//
//  TapeMeasureView.swift
//  TapeMeasureView
//
//  Created by Park GilNam on 23/03/2019.
//  Copyright © 2019 swieeft. All rights reserved.
//

import UIKit

protocol TapeMeasureViewProtocol {
    func setData(id: String?, data: String)
}

class TapeMeasureView: UIView, UIScrollViewDelegate {
    
    var delegate: TapeMeasureViewProtocol?
    
    let barWidth: CGFloat = 1
    
    let sideEmptyDataCount: CGFloat = 11
    
    var space: CGFloat = 15.0
    
    var minData: CGFloat = 10.0
    var maxData: CGFloat = 150.0
    var startData: CGFloat = 60.0
    
    /** 1단위 마다의 나누는 간격 */
    var intervalSplit: CGFloat = 10
    
    var unit: String = "kg"
    
    private let mainLayer: CALayer = CALayer()
    private let scrollView: UIScrollView = UIScrollView()
    
    private var barOffets: [CGFloat] = []
    private var values: [String] = []
    
    private var selectData: String = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        scrollView.delegate = self
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.layer.addSublayer(mainLayer)
        
        self.backgroundColor = UIColor(red: 249/255, green: 249/255, blue: 249/255, alpha: 1)
        self.addSubview(scrollView)
    }
    
    override func layoutSubviews() {
        scrollView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
    }
    
    func setTapeMeasure() {
        mainLayer.sublayers?.forEach({$0.removeFromSuperlayer()})
        
        self.space = (scrollView.bounds.width / (sideEmptyDataCount * 2)) - barWidth
        
        let count = ((Int(maxData - minData) + 1) * Int(intervalSplit)) - 9
        scrollView.contentSize = CGSize(width: ((barWidth + space) * (CGFloat(count) + (sideEmptyDataCount * 2))) + space, height: self.frame.size.height)
        mainLayer.frame = CGRect(x: 0, y: 0, width: scrollView.contentSize.width, height: scrollView.contentSize.height)
        
        drawHorizontalLines()
        drawCenterMarker()
        
        var index = 0
        
        
        for _ in 0..<Int(sideEmptyDataCount) {
            showEntry(index: index, height: 0, value: "")
            index += 1
        }
        
        for i in 0..<count {
            let value = String(format: "%.1f", minData + (CGFloat(i) / intervalSplit))
            
            if (i % 10) == 0 {
                showEntry(index: index, height: 30, value: value)
            } else if (i % 5) == 0 {
                showEntry(index: index, height: 20, value: value)
            } else {
                showEntry(index: index, height: 10,value: value)
            }
            index += 1
        }
        
        for _ in 0..<Int(sideEmptyDataCount) {
            showEntry(index: index, height: 0, value: "")
            index += 1
        }
        
        let offset = barOffets[Int(((startData - minData) * intervalSplit) + 1)]
        scrollView.contentOffset.x = offset
    }
    
    private func drawHorizontalLines() {
        self.layer.sublayers?.forEach({
            if $0 is CAShapeLayer {
                $0.removeFromSuperlayer()
            }
        })
        
        let horizontalLineInfos: [Float] = [0, 1]
        
        for lineInfo in horizontalLineInfos {
            let xPos = CGFloat(0.0)
            let yPos = translateHeightValueToYPosition(value: lineInfo)
            
            let path = UIBezierPath()
            path.move(to: CGPoint(x: xPos, y: yPos))
            path.addLine(to: CGPoint(x: scrollView.frame.size.width, y: yPos))
            
            let lineLayer = CAShapeLayer()
            lineLayer.path = path.cgPath
            lineLayer.lineWidth = 1
            
            lineLayer.strokeColor = UIColor(red: 191, green: 191, blue: 191, alpha: 1).cgColor
            self.layer.insertSublayer(lineLayer, at: 0)
        }
    }
    
    private func drawCenterMarker() {
        let linePath = UIBezierPath()
        linePath.move(to: CGPoint(x: scrollView.bounds.maxX / 2, y: 0))
        linePath.addLine(to: CGPoint(x: scrollView.bounds.maxX / 2, y: 30))
        
        let lineLayer = CAShapeLayer()
        lineLayer.path = linePath.cgPath
        lineLayer.lineWidth = 2
        lineLayer.strokeColor = UIColor(red: 237/255, green: 85/255, blue: 100/255, alpha: 1).cgColor
        
        self.layer.addSublayer(lineLayer)
        
        let trianglePath = UIBezierPath()
        trianglePath.move(to: CGPoint(x: (scrollView.bounds.maxX / 2) + 5, y: 30))
        trianglePath.addLine(to: CGPoint(x: (scrollView.bounds.maxX / 2) - 5, y: 30))
        trianglePath.addLine(to: CGPoint(x: (scrollView.bounds.maxX / 2), y: 37))
        trianglePath.addLine(to: CGPoint(x: (scrollView.bounds.maxX / 2) + 5, y: 30))
        
        let triangleLayer = CAShapeLayer()
        triangleLayer.path = trianglePath.cgPath
        triangleLayer.fillColor = UIColor(red: 237/255, green: 85/255, blue: 100/255, alpha: 1).cgColor
        
        self.layer.addSublayer(triangleLayer)
    }
    
    private func translateHeightValueToYPosition(value: Float) -> CGFloat {
        let height: CGFloat = CGFloat(value) * mainLayer.frame.height
        return mainLayer.frame.height - height
    }
    
    private func showEntry(index: Int, height: CGFloat, value: String) {
        let xPos: CGFloat = space + CGFloat(index) * (barWidth + space)
        
        drawBar(index: index, xPos: xPos, height: height)
        
        let offsetX = xPos - space
        drawXaxisValue(index: index, xPos: offsetX, value: height == 30 ? value : "")
        
        values.append(value)
        barOffets.append(offsetX)
    }
    
    private func drawBar(index: Int, xPos: CGFloat, height: CGFloat) {
        let barLayer = CALayer()
        barLayer.frame = CGRect(x: xPos, y: 0, width: barWidth, height: height)
        barLayer.backgroundColor = height == 30 ? UIColor(red: 191/255, green: 191/255, blue: 191/255, alpha: 1).cgColor : UIColor(red: 223/255, green: 223/255, blue: 223/255, alpha: 1).cgColor
        
        mainLayer.addSublayer(barLayer)
    }
    
    private func drawXaxisValue(index: Int, xPos: CGFloat, value: String) {
        let textLayer = CATextLayer()
        textLayer.frame = CGRect(x: xPos - 40 + space, y: 40, width: 80, height: 22)
        textLayer.backgroundColor = UIColor.clear.cgColor
        textLayer.alignmentMode = CATextLayerAlignmentMode.center
        textLayer.contentsScale = UIScreen.main.scale
        textLayer.string = value != "" ? "\(value)\(unit)" : ""
        textLayer.foregroundColor = UIColor(red: 102/255, green: 102/255, blue: 102/255, alpha: 1).cgColor
        textLayer.font = UIFont.systemFont(ofSize: 18)
        textLayer.fontSize = 18
        
        mainLayer.addSublayer(textLayer)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var index = round((scrollView.contentOffset.x + (scrollView.bounds.width / 2)) / (barWidth + space)) - sideEmptyDataCount
        
        if index <= 0 {
            index = 1
        } else if index > CGFloat(barOffets.count - Int(sideEmptyDataCount * 2)) {
            index = CGFloat(barOffets.count - Int(sideEmptyDataCount * 2))
        }
        
        delegate?.setData(id: self.restorationIdentifier, data: self.values[Int(index) + Int(sideEmptyDataCount) - 1])
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        moveCenterIndex(scrollView)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        moveCenterIndex(scrollView)
    }
    
    private func moveCenterIndex(_ scrollView: UIScrollView) {
        var index = round((scrollView.contentOffset.x + (scrollView.bounds.width / 2)) / (barWidth + space)) - sideEmptyDataCount
        
        if index < 0 || Int(index) >= barOffets.count {
            return
        }
        
        if index <= 0 {
            index = 1
        } else if index > CGFloat(barOffets.count - Int(sideEmptyDataCount * 2)) {
            index = CGFloat(barOffets.count - Int(sideEmptyDataCount * 2))
        }
        
        print("\(index) : \(self.values[Int(index) + Int(sideEmptyDataCount) - 1])")
        
        UIView.animate(withDuration: 0.3) {
            let barOffset = self.barOffets[Int(index)]
            scrollView.contentOffset.x = barOffset
        }
        
        delegate?.setData(id: self.restorationIdentifier, data: self.values[Int(index) + Int(sideEmptyDataCount) - 1])
    }
    
}
