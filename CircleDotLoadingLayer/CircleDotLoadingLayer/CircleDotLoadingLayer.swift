//
//  CircleDotLoadingLayer.swift
//  CircleDotLoadingLayer
//
//  Created by GilNam Park on 10/09/2019.
//  Copyright © 2019 GilNam Park. All rights reserved.
//

import UIKit

class CircleDotLoadingLayer: CALayer, CAAnimationDelegate {
    
    let textLayer = CATextLayer()
    
    var circleLayers: [CAShapeLayer] = []
    
    var text: String = "" {
        didSet {
            textLayer.string = self.text
        }
    }
    
    var startText: String = ""
    var endText: String = ""
    
    private var isShow: Bool = false
    
    override init() {
        super.init()
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }
    
    init(frame: CGRect) {
        
        super.init()
        
        initLayer(frame: frame)
    }
    
    private func initLayer(frame: CGRect) {
        self.frame = frame
        self.backgroundColor = #colorLiteral(red: 0.137254902, green: 0.137254902, blue: 0.137254902, alpha: 0.8) // 35, 35, 35, 80
        
        setTextLayer()
        
        setCircleLayer()
    }
    
    func showLayer() {
            
        isShow = true
        
        text = startText
        
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = 0
        opacityAnimation.toValue = 1
        opacityAnimation.duration = 0.3
        
        self.add(opacityAnimation, forKey: "opacityAnimation")
        
        startCircleLayerAnimation()
    }
    
    private func animationStart(frame: CGRect) {
        
        startCircleLayerAnimation()
    }
    
    func hideLayer(isSuccess: Bool) {
        
        if isShow == false {
            return
        }
        
        isShow = false
        
        if isSuccess {
            animationStop()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            
            self.opacity = 0
            
            let opacityAnimation = CABasicAnimation(keyPath: "opacity")
            opacityAnimation.fromValue = 1
            opacityAnimation.toValue = 0
            opacityAnimation.duration = 0.5
            opacityAnimation.delegate = self
            
            self.add(opacityAnimation, forKey: "opacityAnimation")
        }
    }
    
    private func animationStop() {
        
        for circleLayer in circleLayers {
            circleLayer.removeAllAnimations()
            circleLayer.opacity = 0
        }
        
        text = endText
    }
    
    
    private func setTextLayer() {
        
        textLayer.frame = CGRect(x: self.frame.midX - 65, y: self.frame.midY - 10, width: 130, height: 20)
        textLayer.contentsScale = UIScreen.main.scale
        textLayer.alignmentMode = .center
        textLayer.font = UIFont.boldSystemFont(ofSize: 14)
        textLayer.fontSize = 14
        
        self.addSublayer(textLayer)
    }
    
    private func setCircleLayer() {
        
        var x = self.frame.midX - 17
        let y = self.frame.midY - 26
        
        for _ in 0..<3 {
            
            let circleLayer = CAShapeLayer()
            circleLayer.frame = CGRect(x: x, y: y, width: 8, height: 8)
            circleLayer.fillColor = UIColor.white.cgColor
            circleLayer.path = getCirclePath().cgPath
            
            circleLayers.append(circleLayer)
            
            self.addSublayer(circleLayer)
            
            x += 13
        }
    }
    
    private func getCirclePath() -> UIBezierPath {
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 4, y: 4))
        path.addArc(withCenter: CGPoint(x: 4, y: 4), radius: 4, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        
        return path
    }
    
    private func startCircleLayerAnimation() {
        
        for i in 0..<circleLayers.count {
            
            var values: [CGFloat] = []
            
            for j in 0..<5 {
                
                values.append((i == j - 1) ? 1.5 : 1)
            }
            
            let circleAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
            circleAnimation.values = values
            circleAnimation.duration = 1.2
            circleAnimation.repeatCount = .infinity
            circleAnimation.fillMode = .forwards
            
            circleLayers[i].add(circleAnimation, forKey: "circleAnimation\(i)")
        }
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        
        textLayer.removeFromSuperlayer()
        self.removeFromSuperlayer()
    }
}


