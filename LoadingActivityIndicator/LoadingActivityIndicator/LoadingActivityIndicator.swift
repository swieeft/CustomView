//
//  LoadingActivityIndicator.swift
//  LoadingActivityIndicator
//
//  Created by Park GilNam on 23/04/2019.
//  Copyright © 2019 swieeft. All rights reserved.
//

import UIKit

class LoadingActivityIndicator {
//    private var overlayViewStack : [UIView]  = []
//    private var indicatorStack : [UIActivityIndicatorView] = []
    
    private var indicators: [UIView: (view: UIView, indicator: UIActivityIndicatorView)] = [:]
    
    class var shared: LoadingActivityIndicator {
        struct Static {
            static let instance: LoadingActivityIndicator = LoadingActivityIndicator()
        }
        
        return Static.instance
    }
    
    func start(_ view: UIView, indicatorColor: UIColor = .lightGray, overlayViewColor: UIColor = .clear) {
        let overlayView = UIView(frame: view.bounds)
        overlayView.backgroundColor = overlayViewColor
        
        let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)
        activityIndicator.color = indicatorColor
        activityIndicator.center = overlayView.center
        
        overlayView.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
        
        overlayView.alpha = 0
        
        view.addSubview(overlayView)
        
        UIView.animate(withDuration: 0.3, animations: {
            overlayView.alpha = 1
        }, completion: nil)
        
        indicators[view] = (overlayView, activityIndicator)
//        overlayViewStack.append(overlayView)
//        indicatorStack.append(activityIndicator)
    }
    
    func stop(_ view: UIView) {
        indicators.forEach { (key, value) in
            if key == view {
                if value.indicator.isAnimating {
                    value.indicator.stopAnimating()
                }
                
                UIView.animate(withDuration: 0.3, animations: {
                    value.view.alpha = 0
                }, completion: { (_) in
                    value.view.removeFromSuperview()
                })
                return
            }
        }
//        if let indicator = indicatorStack.last, indicator.isAnimating {
//            indicator.stopAnimating()
//        }
//
//        if let view = overlayViewStack.last {
//            UIView.animate(withDuration: 0.3, animations: {
//                view.alpha = 0
//            }, completion: { (_) in
//                view.removeFromSuperview()
//            })
//        }
    }
    
    func stopAll() {
//        indicatorStack.forEach { (indicator) in
//            if indicator.isAnimating {
//                indicator.stopAnimating()
//            }
//        }
//
//        overlayViewStack.forEach { (view) in
//            UIView.animate(withDuration: 0.3, animations: {
//                view.alpha = 0
//            }, completion: { (_) in
//                view.removeFromSuperview()
//            })
//        }
//
//        indicatorStack.removeAll()
//        overlayViewStack.removeAll()
        indicators.forEach { (key, value) in
            if value.indicator.isAnimating {
                value.indicator.stopAnimating()
            }
            
            UIView.animate(withDuration: 0.3, animations: {
                value.view.alpha = 0
            }, completion: { (_) in
                value.view.removeFromSuperview()
            })
        }
        
        indicators.removeAll()
    }
}

