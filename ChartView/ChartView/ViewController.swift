//
//  ViewController.swift
//  ChartView
//
//  Created by Park GilNam on 23/03/2019.
//  Copyright © 2019 swieeft. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var barChartView: ChartView!
    @IBOutlet weak var lineChartView: ChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lineChartView.chartType = .Line
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let values = generateData()
        barChartView.values = values
        lineChartView.values = values
    }
    
    func generateData() -> [ChartView.ChartValue] {
        var result: [ChartView.ChartValue] = []
        
        for i in 0..<20 {
            let value = (arc4random() % 90) + 10
            let height: Float = Float(value) / 100.0
            
            let formatter = DateFormatter()
            formatter.dateFormat = "M월 d일"
            var date = Date()
            date.addTimeInterval(TimeInterval(86400 * i))
            
            let data = ChartView.ChartValue(xAxisValue: formatter.string(from: date), yAxisValue: height)
            result.append(data)
        }
        return result
    }



}

