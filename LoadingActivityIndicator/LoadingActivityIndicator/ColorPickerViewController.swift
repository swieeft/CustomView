//
//  ColorPickerViewController.swift
//  LoadingActivityIndicator
//
//  Created by Park GilNam on 23/04/2019.
//  Copyright © 2019 swieeft. All rights reserved.
//

import UIKit

protocol ColorPickerDelegate {
    func setColor(color:UIColor, isClear: Bool, sourceView: UIView)
}

class ColorPickerViewController: UIViewController {

    @IBOutlet weak var pickerView: UIView!
    
    @IBOutlet weak var redLabel: UILabel!
    @IBOutlet weak var greenLabel: UILabel!
    @IBOutlet weak var blueLabel: UILabel!
    @IBOutlet weak var alphaLabel: UILabel!
    
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    @IBOutlet weak var alphaSlider: UISlider!
    
    var currentColor:UIColor = .clear // 현재 색상
    
    var redColor:Float = 0.0
    var greenColor:Float = 0.0
    var blueColor:Float = 0.0
    var alpha:Float = 0.0
    
    var delegate: ColorPickerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setCurrentColor()
    }
    
    // 현재 색상으로 컨트롤 값을 변경
    func setCurrentColor() {
        var fRed: CGFloat = 0.0
        var fGreen: CGFloat = 0.0
        var fBlue: CGFloat = 0.0
        var fAlpha: CGFloat = 0.0
        
        if self.currentColor.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha) {
            redColor = Float(fRed)
            redSlider.value = Float(fRed)
            
            greenColor = Float(fGreen)
            greenSlider.value = Float(fGreen)
            
            blueColor = Float(fBlue)
            blueSlider.value = Float(fBlue)
            
            alpha = Float(fAlpha)
            alphaSlider.value = Float(fAlpha)
            
            setColor()
        }
    }
    
    @IBAction func onSliderAction(_ sender: UISlider) {
        switch sender {
        case redSlider:
            redColor = sender.value
        case greenSlider:
            greenColor = sender.value
        case blueSlider:
            blueColor = sender.value
        case alphaSlider:
            alpha = sender.value
        default:
            return
        }
        
        setColor()
    }
    
//    @IBAction func onRedSliderAction(_ sender: Any) {
//        redColor = redSlider.value
//        setColor()
//    }
//
//    @IBAction func onGreenSliderAction(_ sender: Any) {
//        greenColor = greenSlider.value
//        setColor()
//    }
//
//    @IBAction func onBlueSliderAction(_ sender: Any) {
//        blueColor = blueSlider.value
//        setColor()
//    }
//
//    @IBAction func onAlphaSliderAction(_ sender: Any) {
//        alpha = alphaSlider.value
//        setColor()
//    }
    
    func setColor() {
        let red = String(format: "%0.0f", self.redColor * 255)
        redLabel.text = "Red : \(red)"
        
        let green = String(format: "%0.0f", self.greenColor * 255)
        greenLabel.text = "Green : \(green)"
        
        let blue = String(format: "%0.0f", self.blueColor * 255)
        blueLabel.text = "Blue : \(blue)"
        
        let alpha = String(format: "%0.0f", self.alpha * 255)
        alphaLabel.text = "Alpha : \(alpha)"
        
        let color = UIColor(red: CGFloat(self.redColor), green: CGFloat(self.greenColor), blue: CGFloat(self.blueColor), alpha: CGFloat(self.alpha))
        currentColor = color
        
        if let sourceView = self.popoverPresentationController?.sourceView {
            self.delegate?.setColor(color: color, isClear: self.alpha == 0 ? true : false, sourceView: sourceView)
        }
    }
}
