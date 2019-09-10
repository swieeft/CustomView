//
//  ViewController.swift
//  CircleDotLoadingLayer
//
//  Created by GilNam Park on 10/09/2019.
//  Copyright © 2019 GilNam Park. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var backView: UIView!
    
    var loadingLayer: CircleDotLoadingLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    @IBAction func showButtonAction(_ sender: UIButton) {
        
        if sender.isSelected {
            loadingLayer?.hideLayer()
            
            loadingLayer = nil
            
            sender.isSelected = false
        } else {
            
            loadingLayer = CircleDotLoadingLayer(frame: backView.bounds)
            
            loadingLayer?.startText = "검색 중..."
            loadingLayer?.endText = "검색 완료!"
            
            self.backView.layer.addSublayer(loadingLayer!)
                
            loadingLayer?.showLayer()
            
            sender.isSelected = true
        }
    }
}

