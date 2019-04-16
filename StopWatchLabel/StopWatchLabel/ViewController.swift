//
//  ViewController.swift
//  StopWatchLabel
//
//  Created by Park GilNam on 16/04/2019.
//  Copyright © 2019 swieeft. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var stopWatchLabel: StopWatchLabel!
    @IBOutlet weak var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startButton.layer.masksToBounds = true
        startButton.layer.cornerRadius = startButton.frame.height / 2
        
        stopWatchLabel.delegate = self
    }
    
    @IBAction func startAction(_ sender: Any) {
        if stopWatchLabel.isStart {
            stopWatchLabel.stopStopWatch()
            startButton.setTitle("시작", for: .normal)
        } else {
            stopWatchLabel.startStopWatch(counter: 10.0)
            startButton.setTitle("정지", for: .normal)
        }
    }
}

extension ViewController: StopWatchLabelDelegate {
    func stopTimer() {
        let alertController = UIAlertController(title: "알림", message: "스탑워치 시간 종료!", preferredStyle: .alert)
        
        
        let okAction = UIAlertAction(title: "확인", style: .default) { (_) in
            self.startButton.setTitle("시작", for: .normal)
        }
        
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
