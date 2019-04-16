//
//  StopWatchLabel.swift
//  StopWatchLabel
//
//  Created by Park GilNam on 16/04/2019.
//  Copyright © 2019 swieeft. All rights reserved.
//

import UIKit

protocol StopWatchLabelDelegate {
    func stopTimer()
}

class StopWatchLabel: UILabel {
    
    private var timer = Timer()
    
    // 스탑워치 남은 시간
    private var counter:TimeInterval = 0.0
    
    // 라벨에 표시 될 시간 텍스트
    private var counterStr:String = ""
    
    // 타이머 동작 시간
    private let timerInterval: TimeInterval = 1
    
    var isStart: Bool = false
    
    var delegate: StopWatchLabelDelegate?
    
    // 스탑워치 시작
    func startStopWatch(counter: TimeInterval) {
        if isStart {
            stopTimer(timeOver: false)
        }
        
        self.counter = counter
        self.text = toStringTimeStopWatchFormatter()
        
        startTimer(selector: #selector(updateTimerLabel))
    }
    
    // 스탑워치 종료
    func stopStopWatch() {
        stopTimer(timeOver: false)
    }
    
    // 타이머 설정 후 시작
    private func startTimer(selector:Selector) {
        self.timer = Timer.scheduledTimer(timeInterval: timerInterval, target: self, selector: selector, userInfo: nil, repeats: true)
        isStart = true
    }
    
    // 타이머 종료
    private func stopTimer(timeOver: Bool) {
        self.timer.invalidate()
        self.counterStr = ""
        
        isStart = false
        
        if timeOver {
            delegate?.stopTimer()
        }
    }
    
    // 녹화 시간 화면 표시
    @objc private func updateTimerLabel() {
        counter = counter - timerInterval
        let timeStr = toStringTimeStopWatchFormatter()
        
        if counter <= 0 {
            stopTimer(timeOver: true)
        }
        
        updateText(timeStr: timeStr)
    }
    
    // Label에 시간 표시
    private func updateText(timeStr:String) {
        DispatchQueue.main.async {
            self.text = timeStr
        }
    }
    
    private func toStringTimeStopWatchFormatter() -> String {
        let time = Int(counter)
        
        let seconds = time % 60
        let minutes = (time / 60) % 60
        
        let timeStr = String(format: "%0.2d:%0.2d", minutes, seconds)
        return timeStr
    }
}
