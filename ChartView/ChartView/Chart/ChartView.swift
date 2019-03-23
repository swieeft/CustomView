//
//  ChartView.swift
//  ChartView.swift
//
//  Created by Park GilNam on 23/03/2019.
//  Copyright © 2019 swieeft. All rights reserved.
//

import UIKit

protocol ChartViewProtocol {
    func getSelectIndex(index: Int)
    func dataSetComplete()
    func getNewData()
}

class ChartView: UIView, UIScrollViewDelegate {
    enum ChartType {
        case Bar
        case Line
    }
    
    enum ChartDirection {
        case toRight
        case toLeft
    }
    
    // Chart에 표시할 데이터
    struct ChartValue {
        let xAxisValue: String  // x 축 데이터
        let yAxisValue: Float   // y 축 데이터
    }
    
    // Chart에 들어간 각 Layer 별 데이터
    private struct ChartLayerData {
        var offsetX: CGFloat    // 현재 데이터의 x축 offset 값
        var chartDataLayer: CALayer // Chart의 데이터를 이미지화한 Layer
        var xAxisValueLayer: CATextLayer // x축 데이터 Layer
        var yAxisValueLayer: CATextLayer // y축 데이터 Layer
        
        init() {
            offsetX = 0
            chartDataLayer = CALayer()
            xAxisValueLayer = CATextLayer()
            yAxisValueLayer = CATextLayer()
        }
    }
    
    var delegate: ChartViewProtocol?
    
    var chartType: ChartType = .Bar
    
    // 선택된 Value 색상
    var selectedValueColor = UIColor(red: 234/255, green: 130/255, blue: 43/255, alpha: 1)
    // 기본 Value 색상
    var defultValueColor = UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1)
    // 데이터 기준 선 색상
    var horizontalLineColor = UIColor(red: 109/255, green: 110/255, blue: 113/255, alpha: 1)
    
    // 데이터 기준 선 위치
    var horizontalLinePositions: [Float] = [0.5, 1]
    
    // Chart 스크롤 방향
    var chartDirection: ChartDirection = .toRight
    
    // ChartData Layer 넓이
    var chartDataLayerWidth: CGFloat = 15.0
    
    // Chart Data 사이 간격
    var space: CGFloat = 20.0
    
    // 상단 여백
    var topSpace: CGFloat = 40.0
    
    // 하단 여백
    var bottomSpace: CGFloat = 50.0
    
    // 데이터가 표시될 메인 Layer
    private let mainLayer: CALayer = CALayer()
    
    private let scrollView: UIScrollView = UIScrollView()
    
    // 데이터 Layer Array
    private var chartLayerDataArr: [Int: ChartLayerData] = [:]
    
    // 화면에 표시될 데이터 개수
    var viewChartLayerDatas = 9
    
    // 좌우에 빈 값의 개수
    var emptyDataCount = 3
    
    var values: [ChartValue]? = nil {
        didSet {
            mainLayer.sublayers?.forEach({$0.removeFromSuperlayer()})
            
            self.drawingChart()
        }
    }
    
    // MARK: - Init View
    
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
        
        if chartDirection == .toLeft {
            scrollView.transform = CGAffineTransform(scaleX: -1, y: 1)
        }
        scrollView.layer.addSublayer(mainLayer)
        
        self.addSubview(scrollView)
    }
    
    // MARK: - Method
    
    private func drawingChart() {
        let emptyData = ChartValue(xAxisValue: "", yAxisValue: 0)
        
        if let values = values {
            self.chartLayerDataArr.removeAll()
            
            self.space = (self.scrollView.bounds.width / CGFloat((self.viewChartLayerDatas - 1))) - self.chartDataLayerWidth
            
            let contentSizeWidth = ((self.chartDataLayerWidth + self.space) * (CGFloat(values.count) + CGFloat(self.emptyDataCount * 2))) + self.space
            let contentSizeHeight = self.frame.size.height
            self.scrollView.contentSize = CGSize(width: contentSizeWidth, height: contentSizeHeight)
            
            self.mainLayer.frame = CGRect(x: 0, y: 0, width: self.scrollView.contentSize.width, height: self.scrollView.contentSize.height)
            
            self.drawHorizontalLines()
            self.drawYaxisBasedData()
            
            var index = 0
            
            for _ in 0..<self.emptyDataCount {
                showEntry(index: index, value: emptyData, next: nil)
                index += 1
            }
            
            for i in 0..<values.count {
                let next = (i + 1) >= values.count ? nil : values[i + 1]
                showEntry(index: index, value: values[i], next: next)
                index += 1
            }
            
            for _ in 0..<self.emptyDataCount {
                showEntry(index: index, value: emptyData, next: nil)
                index += 1
            }
            
            if scrollView.contentOffset.x == 0 {
                moveCenterIndex(index: self.emptyDataCount)
                
                setSelectData(index: self.emptyDataCount, isSelect: true)
            }
        }
    }
    
    override func layoutSubviews() {
        scrollView.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
    }
    
    private func drawHorizontalLines() {
        self.layer.sublayers?.forEach({
            if $0 is CAShapeLayer {
                $0.removeFromSuperlayer()
            }
        })
        
        for lineInfo in self.horizontalLinePositions {
            let xPos = CGFloat(0.0)
            let yPos = self.translateHeightValueToYPosition(yAxisValue: lineInfo)
            
            let path = UIBezierPath()
            path.move(to: CGPoint(x: xPos, y: yPos))
            path.addLine(to: CGPoint(x: self.scrollView.frame.size.width - 40, y: yPos))
            
            let lineLayer = CAShapeLayer()
            lineLayer.path = path.cgPath
            lineLayer.lineWidth = 1
            lineLayer.lineDashPattern = [4, 4]
            
            lineLayer.strokeColor = self.horizontalLineColor.cgColor
            
            self.layer.insertSublayer(lineLayer, at: 0)
        }
    }
    
    private func drawYaxisBasedData() {
        
        let width: CGFloat = 30
        let height: CGFloat = 18
        
        for baseData in self.horizontalLinePositions {
            let yPos = translateHeightValueToYPosition(yAxisValue: baseData) - CGFloat((height / 2))
            
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: height))
            label.frame = CGRect(x: CGFloat(self.scrollView.frame.width - 40), y: yPos, width: width, height: height)
            label.text = String(format: "%.0f", baseData * 100.0)
            label.backgroundColor = self.horizontalLineColor
            label.textColor = UIColor.white
            label.font = UIFont.systemFont(ofSize: 9)
            label.layer.masksToBounds = true
            label.layer.cornerRadius = 5
            label.textAlignment = .center
            
            self.addSubview(label)
            self.layoutIfNeeded()
        }
    }
    
    private func showEntry(index: Int, value: ChartValue, next: ChartValue?) {
        chartLayerDataArr[index] = ChartLayerData()
        
        let xPos: CGFloat = space + CGFloat(index) * (chartDataLayerWidth + space)
        let yPos: CGFloat = translateHeightValueToYPosition(yAxisValue: value.yAxisValue)
        
        if chartType == .Line {
            drawChartDataCircleLayer(index: index, xPos: xPos, yPos: yPos, xAxisValue: value.xAxisValue, next: next)
        } else {
            drawChartDataBarLayer(index: index, xPos: xPos, yPos: yPos)
        }
        
        let offsetX = xPos - space / 2
        
        chartLayerDataArr[index]?.offsetX = offsetX
        
        if value.yAxisValue == 0.0 && value.xAxisValue == "" {
            return
        }
        
        drawXaxisValue(index: index, xPos: offsetX, yPos: mainLayer.frame.height - bottomSpace + 10, value: value.xAxisValue)
        
        drawYaxisValue(index: index, xPos: offsetX, yPos: yPos - 20, value: value.yAxisValue)
    }
    
    private func drawChartDataBarLayer(index: Int, xPos: CGFloat, yPos: CGFloat) {
        let chartDataLayer = CALayer()
        
        chartDataLayer.frame = CGRect(x: xPos, y: yPos, width: chartDataLayerWidth, height: mainLayer.frame.height - bottomSpace - yPos)
        chartDataLayer.backgroundColor = self.defultValueColor.cgColor
        
        self.mainLayer.addSublayer(chartDataLayer)
        
        chartLayerDataArr[index]?.chartDataLayer = chartDataLayer
    }
    
    private func drawChartDataCircleLayer(index: Int, xPos: CGFloat, yPos: CGFloat, xAxisValue: String, next: ChartValue?) {
        if xAxisValue == "" {
            return
        }
        
        if next != nil {
            let nextXPos: CGFloat = space + CGFloat(index + 1) * (chartDataLayerWidth + space)
            let nextYPos: CGFloat = translateHeightValueToYPosition(yAxisValue: next!.yAxisValue)
            
            let path = UIBezierPath()
            path.move(to: CGPoint(x: xPos + (chartDataLayerWidth / 2), y: yPos))
            path.addLine(to: CGPoint(x: nextXPos + (chartDataLayerWidth / 2), y: nextYPos))
            
            let lineLayer = CAShapeLayer()
            lineLayer.path = path.cgPath
            lineLayer.lineWidth = 1
            lineLayer.strokeColor = self.defultValueColor.cgColor
            
            self.mainLayer.addSublayer(lineLayer)
        }
        
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: xPos + (chartDataLayerWidth / 2), y: yPos), radius: 5, startAngle: 0, endAngle: .pi * 2, clockwise: true)
        
        let circleLayer = CAShapeLayer()
        circleLayer.path = circlePath.cgPath
        circleLayer.strokeColor = self.defultValueColor.cgColor
        circleLayer.lineWidth = 2
        circleLayer.fillColor = UIColor.white.cgColor
        
        self.mainLayer.addSublayer(circleLayer)
        
        chartLayerDataArr[index]?.chartDataLayer = circleLayer
    }
    
    private func drawXaxisValue(index: Int, xPos: CGFloat, yPos: CGFloat, value: String) {
        let textLayer = initTextLayer(xPos: xPos, yPos: yPos, text: value, fontSize: 14)
        
        self.mainLayer.addSublayer(textLayer)
        
        chartLayerDataArr[index]?.xAxisValueLayer = textLayer
    }
    
    private func drawYaxisValue(index: Int, xPos: CGFloat, yPos: CGFloat, value: Float) {
        let valueStr = String(format: "%.0f", value * 100.0)
        
        let textLayer = self.initTextLayer(xPos: xPos, yPos: yPos, text: valueStr, fontSize: 10)
        self.mainLayer.addSublayer(textLayer)
        
        chartLayerDataArr[index]?.yAxisValueLayer = textLayer
    }
    
    private func initTextLayer(xPos: CGFloat, yPos: CGFloat, text: String, fontSize: CGFloat) -> CATextLayer {
        let textLayer = CATextLayer()
        textLayer.frame = CGRect(x: xPos, y: yPos, width: chartDataLayerWidth + space, height: 22)
        textLayer.backgroundColor = UIColor.clear.cgColor
        textLayer.alignmentMode = CATextLayerAlignmentMode.center
        textLayer.contentsScale = UIScreen.main.scale
        textLayer.string = text
        
        if chartDirection == .toLeft {
            textLayer.transform = CATransform3DMakeRotation(.pi, 0, 1, 0)
        }
        
        setTextLayerFont(layer: textLayer, fontSize: fontSize, isSelect: false)
        
        return textLayer
    }
    
    private func setTextLayerFont(layer: CATextLayer, fontSize: CGFloat, isSelect: Bool) {
        if isSelect {
            layer.foregroundColor = self.selectedValueColor.cgColor
            layer.font = UIFont.boldSystemFont(ofSize: fontSize)
        } else {
            layer.foregroundColor = self.defultValueColor.cgColor
            layer.font = UIFont.systemFont(ofSize: fontSize, weight: UIFont.Weight.medium)
        }
        
        layer.fontSize = fontSize
    }
    
    private func translateHeightValueToYPosition(yAxisValue: Float) -> CGFloat {
        let height: CGFloat = CGFloat(yAxisValue) * (mainLayer.frame.height - bottomSpace - topSpace)
        return mainLayer.frame.height - bottomSpace - height
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let index = getIndex(scrollView) else {
            return
        }
        
        for i in 0..<chartLayerDataArr.count {
            setSelectData(index: i, isSelect: (Int(index) - 1) == i ? true : false)
        }
        
        let check = (scrollView.contentSize.width - scrollView.bounds.width) - ((scrollView.contentSize.width - scrollView.bounds.width) / 10)
        
        if scrollView.contentOffset.x >= check {
            delegate?.getNewData()
        }
    }
    
    func setSelectData(index: Int, isSelect: Bool) {
        guard let data = chartLayerDataArr[index] else {
            return
        }
        
        if chartType == .Line {
            guard let shapeLayer = data.chartDataLayer as? CAShapeLayer else {
                return
            }
            
            shapeLayer.strokeColor = isSelect ? self.selectedValueColor.cgColor : self.defultValueColor.cgColor
            shapeLayer.lineWidth = isSelect ? 3 : 2
        } else {
            data.chartDataLayer.backgroundColor = isSelect ? self.selectedValueColor.cgColor : self.defultValueColor.cgColor
        }
        self.setTextLayerFont(layer: data.xAxisValueLayer, fontSize: 10, isSelect: isSelect)
        self.setTextLayerFont(layer: data.yAxisValueLayer, fontSize: 10, isSelect: isSelect)
        
        let index = round((self.scrollView.contentOffset.x + (self.scrollView.bounds.width / 2)) / (self.chartDataLayerWidth + self.space))
        
        if index == CGFloat.infinity || index == -1 * CGFloat.infinity {
            return
        }
        
        let dataIndex = Int(index) - 4
        self.delegate?.getSelectIndex(index: dataIndex)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard let index = getIndex(scrollView) else {
            return
        }
        moveCenterIndex(index: Int(index) - 1)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard let index = getIndex(scrollView) else {
            return
        }
        moveCenterIndex(index: Int(index) - 1)
    }
    
    private func getIndex(_ scrollView: UIScrollView) -> CGFloat? {
        let index = round((scrollView.contentOffset.x + (scrollView.bounds.width / 2)) / (chartDataLayerWidth + space))
        
        if index == CGFloat.infinity || index == -1 * CGFloat.infinity {
            return nil
        }
        
        return index
    }
    
    private func moveCenterIndex(index: Int) {
        let barOffset = self.chartLayerDataArr[index]?.offsetX ?? 0
        
        let center = (((CGFloat(self.emptyDataCount) * 2) + 1) / 2)
        
        UIView.animate(withDuration: 0.3) {
            self.scrollView.contentOffset.x = barOffset - ((self.chartDataLayerWidth + self.space) * center)
        }
    }
}

