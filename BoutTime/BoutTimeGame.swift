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
    var numEventsPerRound: Int {get set}
    var eventDataCollection: [HistoricalEvent: HistoricalEventItem] {get set}
    var eventDataCurrentRound: [[HistoricalEvent: HistoricalEventItem]] {get set}
    var eventDataGameHistory: [HistoricalEvent] {get set}
    
//    func getUniqueEvent() -> [HistoricalEvent : HistoricalEventItem]
    func moveEvent(direction: MoveDirection)
    
}

protocol HistoricalEventType{
    
    var description: String {get}
    var URL: NSURL {get}
    var date: NSDate {get}
    var seqNo: Int {get}
    
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
    case noMoreUniqueEvents
}

enum TimerError: Error{
    case OutOfTime
}




//Helper Classes


    
//Concrete Types

enum HistoricalEvent:Int{
    case event01 = 1
    case event02, event03, event04, event05, event06, event07, event08, event09, event10
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
    var seqNo: Int
}

class BoutTimeGame: BoutTimeGameType{
 
    var totalNoOfRounds: Int
    var numEventsPerRound: Int
    var eventDataCollection: [HistoricalEvent: HistoricalEventItem]
    var eventDataCurrentRound: [[HistoricalEvent : HistoricalEventItem]] = []
    var eventDataGameHistory: [HistoricalEvent] = []
    
    var roundsPlayed = 0
    var correctRounds = 0
    
    init(){
        self.totalNoOfRounds = 0
        self.numEventsPerRound = 0
        self.eventDataCollection = [:]
    }
    
    init(totalNoOfRounds: Int, numEventsPerRound: Int, eventData: Dictionary<HistoricalEvent,HistoricalEventItem>){
        
        self.totalNoOfRounds = totalNoOfRounds
        self.numEventsPerRound = numEventsPerRound
        self.eventDataCollection = eventData
        
        
        print(randomizedInt())
    
    }
    
    func returnEventDataToDisplay(inRound: Int, atEvent: Int) -> Array<String>{
        var displayArr: [String] = []
        var counter: Int = 0
        
        repeat{
            let displayString = getUniqueEvent()
            
            print(displayString)
            
            counter += 1
        } while counter != numEventsPerRound
        
      return displayArr
    }
    
    func getUniqueEvent() -> [HistoricalEventItem]  {
 
        var eventDisplayedBefore: Bool
        var dictionary: [HistoricalEventItem] = []

//        var dictionary: [HistoricalEvent : HistoricalEventItem] = [:]
        
        repeat{
            eventDisplayedBefore = false

            let item = HistoricalEvent(rawValue: randomizedInt())
        
            if let item = item {
        
                do{
                    try eventDisplayedBefore = hasEventBeenUsedBefore(event: item)
                    
                    if eventDisplayedBefore != true{
                        eventDataGameHistory.append(item)
                        dictionary = [eventDataCollection[item]!]
                        
                    }
                    
                } catch GameError.noMoreUniqueEvents{
                    print("Sorry, Fresh out of event random events!")
                    print("Clearing out game history just to be safe!")
                    
                    eventDataGameHistory.removeAll()
        
                } catch {
                    fatalError("Boom")
                }
                
            }
        } while eventDisplayedBefore == true
        loggingPrint(dictionary)
        return dictionary
    }

    
    func randomizedInt() -> Int {
        
        let lowerBound: UInt32 = 1
        let upperBound: UInt32 = UInt32(eventDataCollection.count)
        
        let index = Int(arc4random_uniform(upperBound - lowerBound) + lowerBound)
        
        return index
    }
    
    
    func hasEventBeenUsedBefore(event: HistoricalEvent) throws -> Bool{
        
        var trueOrFalse: Bool = false

        for record in eventDataGameHistory{
            
            if record == event {
                
                trueOrFalse = true
            }
        }
        
        if (eventDataGameHistory.count) == (eventDataCollection.count)-1{
            throw GameError.noMoreUniqueEvents
        }
        
        return trueOrFalse
    }
    

    
    //    func dateExperiment(){
    //        var dateArr = [NSDate]()
    //
    //        for event in eventCollection{
    //            dateArr.append(event.value.date)
    //        }
    //
    //        print(dateArr.sorted(by: { $0.compare($1 as Date) == .orderedAscending }))
    //        
    //    }

    
    
    func moveEvent(direction: MoveDirection){
        
    }
    
    
}





