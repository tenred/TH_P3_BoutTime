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
//
//    var totalNoOfRounds: Int {get set}
//    var numEventsPerRound: Int {get set}
//    var eventDataCollection: [HistoricalEvent: HistoricalEventItem] {get set}
//    var eventDataCurrentRound: [[HistoricalEvent: HistoricalEventItem]] {get set}
//    var eventDataGameHistory: [HistoricalEvent] {get set}
//    
////    func getUniqueEvent() -> [HistoricalEvent : HistoricalEventItem]
//    func moveEvent(direction: MoveDirection)
//    
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
    case moveDirectionError
}

enum TimerError: Error{
    case OutOfTime
}


    
//Concrete Types

enum HistoricalEvent:Int{
    case event01 = 1
    case event02, event03, event04, event05, event06, event07, event08, event09, event10
    case event11, event12, event13, event14, event15, event16, event17, event18, event19, event20
    case event21, event22, event23, event24, event25
}

enum EventLabel: Int{
    case label01 = 0
    case label02
    case label03
    case label04
}

enum MoveDirection{
    case up
    case down
}

enum ButtonSize{
    case full
    case half
}

enum ButtonState{
    case normal
    case highlighted
}


enum gameUIState{
    case newRound
    case newGame
    case shakeyShakey
    case answerSubmitted
    case wrongAnswer
    case correctAnswer
    
}


struct HistoricalEventItem: HistoricalEventType {
        
    var description: String
    var URL: NSURL
    var date: NSDate
    var seqNo: Int
}


struct buttonAttributes {
    
    var direction: MoveDirection!
    var size: ButtonSize!
    var associatedLabel: EventLabel!
    //var stateImage: UIImage!
    
    init(tagNo: Int /*, state: ButtonState */){
    
        do{
            self.direction = try btnDirection(tag: tagNo)
            self.size = btnSize(tag: tagNo)
            self.associatedLabel = try associatedLabel(tag: tagNo)
            //self.stateImage = try stateImage(btnDirection: self.direction, btnPressState: state, btnSize: self.size)
            
        } catch {
            print("Error gathering Button Infor")
            fatalError("BOOM")
        }
    }
    
    private func btnDirection(tag: Int)throws -> MoveDirection{
        
        switch tag{
        case 0,2,4:
            return MoveDirection.down
        case 1,3,5:
            return MoveDirection.up
        default:
            throw GameError.moveDirectionError
        }
    }
    
    private func btnSize(tag: Int) -> ButtonSize{
      
        switch tag{
        case 0,5:
            return ButtonSize.full
        default:
            return ButtonSize.half
        }
    }
    
    private func associatedLabel(tag: Int)throws -> EventLabel{
        
        switch tag{
        case 0:
            return EventLabel.label01
            
        case 1,2:
            return EventLabel.label02
            
        case 3,4:
            return EventLabel.label03
            
        case 5:
            return EventLabel.label04
            
        default:
            throw GameError.moveDirectionError
            
        }
    }
    
    
    func stateImage(btnDirection: MoveDirection, btnPressState: ButtonState, btnSize: ButtonSize) -> UIImage{
        
        var buttonImage: UIImage!
        
        let normal_up_full: UIImage = #imageLiteral(resourceName: "up_full.png")
        let normal_up_half: UIImage = #imageLiteral(resourceName: "up_half.png")
        let normal_down_full: UIImage = #imageLiteral(resourceName: "down_full.png")
        let normal_down_half: UIImage = #imageLiteral(resourceName: "down_half.png")
        
        let selected_up_full: UIImage = #imageLiteral(resourceName: "up_full_selected.png")
        let selected_up_half: UIImage = #imageLiteral(resourceName: "up_half_selected.png")
        let selected_down_full: UIImage = #imageLiteral(resourceName: "down_full_selected.png")
        let selected_down_half: UIImage = #imageLiteral(resourceName: "down_half_selected.png")
        
        if btnPressState == ButtonState.normal{
            
            switch (btnDirection, btnSize) {
            
            case (MoveDirection.up, ButtonSize.full):
                buttonImage = normal_up_full
            case (MoveDirection.up, ButtonSize.half):
                buttonImage = normal_up_half
            case (MoveDirection.down, ButtonSize.full):
                buttonImage = normal_down_full
            case (MoveDirection.down, ButtonSize.half):
                buttonImage = normal_down_half
            }
            
        }
        
        if btnPressState == ButtonState.highlighted{
            
            switch (btnDirection, btnSize) {
                
            case (MoveDirection.up, ButtonSize.full):
                buttonImage = selected_up_full
            case (MoveDirection.up, ButtonSize.half):
                buttonImage = selected_up_half
            case (MoveDirection.down, ButtonSize.full):
                buttonImage = selected_down_full
            case (MoveDirection.down, ButtonSize.half):
                buttonImage = selected_down_half
            }
            
        }

    return buttonImage
        
    }
}


    
    
//    private func mapping(btnTagNo: Int)throws -> (eventLabel:EventLabel, move: MoveDirection, size: ButtonSize){
//        
//        var move: MoveDirection!
//        var lbl: EventLabel!
//        var btnSize: ButtonSize!
//        
//        switch btnTagNo {
//            
//        case 0:
//            move = MoveDirection.down
//            lbl = EventLabel.label01
//            btnSize = ButtonSize.full
//            
//        case 1:
//            move = MoveDirection.up
//            lbl = EventLabel.label02
//            btnSize = ButtonSize.half
//            
//        case 2:
//            move = MoveDirection.down
//            lbl = EventLabel.label02
//            btnSize = ButtonSize.half
//            
//        case 3:
//            move = MoveDirection.up
//            lbl = EventLabel.label03
//            btnSize = ButtonSize.half
//            
//        case 4:
//            move = MoveDirection.down
//            lbl = EventLabel.label03
//            btnSize = ButtonSize.half
//            
//        case 5:
//            move = MoveDirection.up
//            lbl = EventLabel.label04
//            btnSize = ButtonSize.full
//            
//        default:
//            throw GameError.moveDirectionError
//        }
//        
//        guard let buttonDirection = move, let eventLabel = lbl, let size = btnSize else{
//            throw GameError.moveDirectionError
//        }
//        
//        return(eventLabel,buttonDirection,size)
//    }

    



class BoutTimeGame: BoutTimeGameType{
 
    //**************************************************
    //***************** Property Decleration
    //**************************************************
    
    var totalNoOfRounds: Int
    var numEventsPerRound: Int
    var eventDataCollection: [HistoricalEvent: HistoricalEventItem]
    var eventDataCurrentRound: [[HistoricalEvent: HistoricalEventItem]] = []
    var eventDataCurrentRoundUserOrdered: [HistoricalEvent] = []
    
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
    }
  
    func getHistoricalEventsForRound() -> Array<[HistoricalEvent: HistoricalEventItem]> {
        
        var roundDataArr: [[HistoricalEvent: HistoricalEventItem]] = []
        
        repeat{
            
            let record = getUniqueEvent()
            
            if roundDataArr.isEmpty != true {
                roundDataArr.append(record)
            } else {
                roundDataArr.insert(record, at: 0)
            }
            
        } while roundDataArr.count != numEventsPerRound
    
        eventDataCurrentRound = roundDataArr
        
        return roundDataArr
        
    }

//    func getButtonLabelInfo(btnTagNo: Int)throws -> (eventLabel:EventLabel, move: MoveDirection, size: ButtonSize){
//            
//        var move: MoveDirection!
//        var lbl: EventLabel!
//        var btnSize: ButtonSize!
//    
//        switch btnTagNo {
//        
//        case 0:
//            move = MoveDirection.down
//            lbl = EventLabel.label01
//            btnSize = ButtonSize.full
//            
//        case 1:
//            move = MoveDirection.up
//            lbl = EventLabel.label02
//            btnSize = ButtonSize.half
//
//        case 2:
//            move = MoveDirection.down
//            lbl = EventLabel.label02
//            btnSize = ButtonSize.half
//
//        case 3:
//            move = MoveDirection.up
//            lbl = EventLabel.label03
//            btnSize = ButtonSize.half
//
//        case 4:
//            move = MoveDirection.down
//            lbl = EventLabel.label03
//            btnSize = ButtonSize.half
//
//        case 5:
//            move = MoveDirection.up
//            lbl = EventLabel.label04
//            btnSize = ButtonSize.full
//
//        default:
//            throw GameError.moveDirectionError
//        }
//        
//        guard let buttonDirection = move, let eventLabel = lbl, let size = btnSize else{
//            throw GameError.moveDirectionError
//        }
//        
//        return(eventLabel,buttonDirection,size)
//    }
    
    
    func moveDataSet(dataSet: Array<[HistoricalEvent: HistoricalEventItem]>, eventLabel:  EventLabel, move: MoveDirection) -> Array<[HistoricalEvent: HistoricalEventItem]>{
     
        var reOrdered: [[HistoricalEvent: HistoricalEventItem]] = dataSet
        let targetedEvent = dataSet[eventLabel.rawValue]
        var newEventPosition: Int!
        
        switch move {
        case .down:
            newEventPosition  = eventLabel.rawValue + 1
            reOrdered.remove(at: eventLabel.rawValue)
            reOrdered.insert(targetedEvent, at: newEventPosition)
            
        case .up:
            newEventPosition  = eventLabel.rawValue - 1
            reOrdered.remove(at: eventLabel.rawValue)
            reOrdered.insert(targetedEvent, at: newEventPosition)
        }
        
        return reOrdered
    }
    
    func isGameOver() -> Bool{
        
        var trueOrFalse: Bool = false
        
        if totalNoOfRounds == roundsPlayed {
            trueOrFalse = true
        }
        
        return trueOrFalse
    }
    
    func checkSubmittedAnswer(userOrder: Array<[HistoricalEvent: HistoricalEventItem]>) -> (isRoundCorrect: Bool, wrongAnswers: [Int]) {
        
        let answerArr = getRoundAnswerInDateOrder()
        var isCorrect = true
        var wrongAnswer: [Int] = []
        
        var count = 0
        
        for event in userOrder{
            
            for item in event{
                
                if answerArr[count] != item.value.seqNo{
                    isCorrect = false
                    wrongAnswer.append(item.value.seqNo)
                } else {
                    correctRounds += 1
                }

            }
            count += 1
        }
        
        loggingPrint(isCorrect)
        loggingPrint(wrongAnswer)
        
        return (isCorrect, wrongAnswer)
    }
    
    //**************************************************
    //***************** Helper Methodss
    //**************************************************
    
    func incrementRoundCount(){
        
        roundsPlayed += 1
        
    }
    
    private func getRoundAnswerInDateOrder() -> Array<Int> {

        var SeqDateDict: [NSDate:Int] = [:]
        var answerKey: [Int] = []
        for event in eventDataCurrentRound{
            
            for item in event{
                let seqNo = item.value.seqNo
                let date = item.value.date
                
                SeqDateDict.updateValue(seqNo, forKey: date)
            }
            
        }
        
        
        let SeqDateDictSorted = SeqDateDict.sorted{ $0.0.compare($1.0 as Date) == .orderedAscending}
            
            for item in SeqDateDictSorted{
                answerKey.append(item.value)
            }
            
        return answerKey

    }
    

        
    
    private func getUniqueEvent() -> [HistoricalEvent: HistoricalEventItem]  {
        //// Method returns a single unique HistoricalEventItem for the current game
        //// Method calls randomizedInt() to generate a randome HistoricalEventItem.
        //// This is checked against hasEventBeenUsedBefore() to determin if HistoricalEventItem has been displayed in any round.
        
        var eventDisplayedBefore: Bool
        var dictionary: [HistoricalEvent: HistoricalEventItem] = [:]
        
        repeat{
            eventDisplayedBefore = false

            let item = HistoricalEvent(rawValue: randomizedInt())
        
            if let item = item {
        
                do{
                    try eventDisplayedBefore = hasEventBeenUsedBefore(event: item)
                    
                    if eventDisplayedBefore != true{
                        eventDataGameHistory.append(item)
                        //dictionary = [eventDataCollection[item]!]
                        dictionary.updateValue(eventDataCollection[item]!, forKey: item)
                    }
                    
                } catch GameError.noMoreUniqueEvents{
                    print("Sorry, Fresh out of event random events!")
                    print("Clearing out game history just to be safe!")
                    
                    eventDataGameHistory.removeAll()
        
                } catch {
                    fatalError("BOOM")
                }
                
            }
        } while eventDisplayedBefore == true
       
        return dictionary
    }
    
    private func randomizedInt() -> Int {
        
        let lowerBound: UInt32 = 1
        let upperBound: UInt32 = UInt32(eventDataCollection.count)
        
        let index = Int(arc4random_uniform(upperBound - lowerBound) + lowerBound)
        
        return index
    }
    
    
    private func hasEventBeenUsedBefore(event: HistoricalEvent) throws -> Bool{
        
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
    
}





