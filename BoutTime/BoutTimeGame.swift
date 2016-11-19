//
//  BoutTimeGame.swift
//  BoutTime
//
//  Created by Sherief Wissa on 15/11/16.
//  Copyright © 2016 10 Red Hacks Pty Ltd. All rights reserved.
//

import UIKit
import Foundation
import AudioToolbox

//Protocols
protocol BoutTimeGameType{

    var totalNoOfRounds: Int {get set}
    var questionsPerRound: Int {get set}
    var historicalEventData: String {get set}

    func randomizeEventData()
    func moveEvent(direction: MoveDirection)
    
}

protocol HistoricalEventType{
    
    var description: String {get}
    var URL: NSURL {get}
    var date: NSDate {get}
    
}

protocol TimerType {
    
    var totalTime: Int {get set}
    
    init(totalTime: Int)
    func startTimer()
    func stopTimer()
    func ResetTimer()
}

//Error Types

enum HistoryEventDataError: Error{
    case InvalidResourceError
    case InvalidData (reason: String)
    case ConversionError
    case SeqNoToIntCoversionError
    case StringToURLConversionError
}

enum GameError: Error{
    case incorrectSequence
}

enum TimerError: Error{
    case OutOfTime
}




//Helper Classes


    
//Concrete Types

enum HistoricalEvent:String{
    case event01, event02, event03, event04, event05, event06, event07, event08, event09, event10
    case event11, event12, event13, event14, event15, event16, event17, event18, event19, event20
    case event21, event22, event23, event24, event25
    
}

enum MoveDirection{
    case up
    case down
}


struct HistoricalEventItem: HistoricalEventType {
        
    var description: String
    var URL: NSURL
    var date: NSDate
}

class BoutTimeGame{

}


class logger{
    
    class func display(x: AnyObject) -> String{
        let printLine: String
        
        printLine = "Variable Name: \(x.self) | Value: \(x)"
        return printLine
    }
}
