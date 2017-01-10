//
//  Timer.swift
//  BoutTime
//
//  Created by Sherief Wissa on 29/11/16.
//  Copyright © 2016 10 Red Hacks Pty Ltd. All rights reserved.
//

import Foundation

class CountdownTimer: TimerType{
    // Class is used to control the behaviour of the game count down timer.
    
    var totalTimeInSecs: Int
    var currentTimeInSec: Int
    
    init(totalTimeInSecs: Int){
        self.totalTimeInSecs = totalTimeInSecs
        self.currentTimeInSec = totalTimeInSecs
    }
    
    func increment(){
        currentTimeInSec -= 1
    }
    
    func isTimerFinished() -> Bool{
        var timerOn: Bool
        
        if currentTimeInSec <= 0{
            timerOn = true
        } else{
            timerOn = false
        }
        
        return timerOn
    }
    
    func displayString() -> String {
        
        let minutes = currentTimeInSec / 60 % 60
        let seconds = currentTimeInSec % 60
        return String(format:"%02i:%02i", minutes, seconds)
    }
    
    func ResetTimer(){
        currentTimeInSec = totalTimeInSecs
    }

}
