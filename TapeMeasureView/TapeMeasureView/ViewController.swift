//
//  ViewController.swift
//  TapeMeasureView
//
//  Created by Park GilNam on 23/03/2019.
//  Copyright © 2019 swieeft. All rights reserved.
//

import UIKit

class ViewController: UIViewController, TapeMeasureViewProtocol {
    
    @IBOutlet weak var weightMeasureView: TapeMeasureView!
    @IBOutlet weak var weightLabel: UILabel!
    
    @IBOutlet weak var heightMeasureView: TapeMeasureView!
    @IBOutlet weak var heightLabel: UILabel!
    
    @IBOutlet weak var temperaturesMeasureView: TapeMeasureView!
    @IBOutlet weak var temperaturesLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        setWeightMeasureView()
        setHeightMeasureView()
        setTemperaturesMeasureView()
    }
    
    func setWeightMeasureView() {
        weightMeasureView.minData = 0.0
        weightMeasureView.maxData = 300.0
        weightMeasureView.startData = 60.0
        weightMeasureView.unit = "kg"
        weightMeasureView.delegate = self
        
        weightMeasureView.setTapeMeasure()
    }
    
    func setHeightMeasureView() {
        heightMeasureView.minData = 0.0
        heightMeasureView.maxData = 250.0
        heightMeasureView.startData = 170.0
        heightMeasureView.unit = "cm"
        heightMeasureView.delegate = self
        
        heightMeasureView.setTapeMeasure()
    }
    
    func setTemperaturesMeasureView() {
        temperaturesMeasureView.minData = -50.0
        temperaturesMeasureView.maxData = 50.0
        temperaturesMeasureView.startData = 36.5
        temperaturesMeasureView.unit = "℃"
        temperaturesMeasureView.delegate = self
        
        temperaturesMeasureView.setTapeMeasure()
    }
    
    func setData(id: String?, data: String) {
        guard let id = id else {
            return
        }
        
        switch id {
        case "weight":
            weightLabel.text = data
        case "height":
            heightLabel.text = data
        case "Temperatures":
            temperaturesLabel.text = data
        default:
            break
        }
    }
}

