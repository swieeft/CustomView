//
//  ViewController.swift
//  LoadingActivityIndicator
//
//  Created by Park GilNam on 23/04/2019.
//  Copyright © 2019 swieeft. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var fullView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var middleView: UIView!
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var fullButton: UIButton!
    @IBOutlet weak var topButton: UIButton!
    @IBOutlet weak var middleButton: UIButton!
    @IBOutlet weak var bottomButtom: UIButton!
    
    @IBOutlet weak var indicatorColorButton: UIButton!
    @IBOutlet weak var backgroundColorButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        indicatorColorButton.layer.borderColor = UIColor.lightGray.cgColor
        indicatorColorButton.layer.borderWidth = 0.5
        
        backgroundColorButton.layer.borderColor = UIColor.lightGray.cgColor
        backgroundColorButton.layer.borderWidth = 0.5
    }
    @IBAction func loadingAction(_ sender: UIButton) {
        let indicatorColor = indicatorColorButton.backgroundColor ?? .lightGray
        let backgroundColor = backgroundColorButton.backgroundColor ?? .clear
        
        var targetView: UIView?
        
        switch sender {
        case fullButton:
            targetView = fullView
        case topButton:
            targetView = topView
        case middleButton:
            targetView = middleView
        case bottomButtom:
            targetView = bottomView
        default:
            return
        }
        if let targetView = targetView {
            if sender.isSelected {
                LoadingActivityIndicator.shared.stop(targetView)
            } else {
                LoadingActivityIndicator.shared.start(targetView, indicatorColor: indicatorColor, overlayViewColor: backgroundColor)
            }
        }
        
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func indicatorColorAction(_ sender: UIButton) {
        showColorPicker(sourceView: sender)
    }
    @IBAction func backgroundColorAction(_ sender: UIButton) {
        showColorPicker(sourceView: sender)
    }
    
    func showColorPicker(sourceView: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let vc = storyboard.instantiateViewController(withIdentifier: "ColorPickerViewController") as? ColorPickerViewController else {
            return
        }
        
        // 현재 색상
        if let color = sourceView.backgroundColor {
            vc.currentColor = color
        }
        
        vc.delegate = self
        
        vc.modalPresentationStyle = .popover
        vc.preferredContentSize = CGSize(width: 200, height: 260)
        vc.popoverPresentationController?.sourceView = sourceView
        vc.popoverPresentationController?.sourceRect = sourceView.bounds
        vc.popoverPresentationController?.permittedArrowDirections = .any
        vc.popoverPresentationController?.delegate = self
        
        self.present(vc, animated: true, completion: nil)
    }
}

extension ViewController: UIPopoverPresentationControllerDelegate, ColorPickerDelegate {
    func setColor(color: UIColor, isClear: Bool, sourceView: UIView) {
        switch sourceView {
        case indicatorColorButton:
            indicatorColorButton.backgroundColor = color
            indicatorColorButton.setTitle(isClear ? "/" : nil, for: .normal)
        case backgroundColorButton:
            backgroundColorButton.backgroundColor = color
            backgroundColorButton.setTitle(isClear ? "/" : nil, for: .normal)
        default:
            return
        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}

