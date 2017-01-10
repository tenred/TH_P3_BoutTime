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

//**************************************************
//***************** Protocols
//**************************************************

protocol BoutTimeGameType{

    var totalNoOfRounds: Int {get set}
    var numEventsPerRound: Int {get set}
    var eventDataCollection: [HistoricalEvent: HistoricalEventItem] {get set}
    var eventDataCurrentRound: [[HistoricalEvent: HistoricalEventItem]] {get set}
    var eventDataGameHistory: [HistoricalEvent] {get set}

    func getHistoricalEventsForRound() -> Array<[HistoricalEvent: HistoricalEventItem]>
    func moveDataSet(dataSet: Array<[HistoricalEvent: HistoricalEventItem]>, eventLabel:  EventLabel, move: MoveDirection) -> Array<[HistoricalEvent: HistoricalEventItem]>
    func getUniqueEvent() -> [HistoricalEvent : HistoricalEventItem]
    func checkSubmittedAnswer(userOrder: Array<[HistoricalEvent: HistoricalEventItem]>) -> (isRoundCorrect: Bool, wrongAnswers: [Int])
}

protocol HistoricalEventType{
    
    var description: String {get}
    var URL: String {get}
    var date: NSDate {get}
    var seqNo: Int {get}
    
}

protocol TimerType {
    
    var totalTimeInSecs: Int {get set}
    var currentTimeInSec: Int {get set}

    func isTimerFinished() -> Bool
    func displayString() -> String
}

protocol UpDownButtonAttributes{
    
    var direction: MoveDirection! {get set}
    var size: ButtonSize! {get set}
    var associatedLabel: EventLabel! {get set}
    
    func btnDirection(tag: Int)throws -> MoveDirection
    func btnSize(tag: Int) -> ButtonSize
    func associatedLabel(tag: Int)throws -> EventLabel
    func stateImage(btnDirection: MoveDirection, btnPressState: ButtonState, btnSize: ButtonSize) -> UIImage

}

//Error Type Protocols

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

enum URLError: Error{
    case noValidURL
    
}

    
//**************************************************
//***************** Enums
//**************************************************

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
    case endGame
}

//**************************************************
//***************** Structs
//**************************************************

struct HistoricalEventItem: HistoricalEventType {
    
    // Struct used to model the attributes associated to a Historical Event.
    // Historical Event Data is pulled from  HistoricalEventData.pList
    
    var description: String
    var URL: String
    var date: NSDate
    var seqNo: Int
}


struct buttonAttributes: UpDownButtonAttributes {
    
    //This struct is used to model the buttons associated to moving Historicial Event in order by user.
    //Button can be idenfied through button.tagNo as which contains an Int value.
    
    var direction: MoveDirection!
    var size: ButtonSize!
    var associatedLabel: EventLabel!
    
    init(tagNo: Int){
        //button tagNo is retreived to determin which button on the UI has been pressed.
        
        do{
            self.direction = try btnDirection(tag: tagNo)
            self.size = btnSize(tag: tagNo)
            self.associatedLabel = try associatedLabel(tag: tagNo)
            
        } catch GameError.moveDirectionError{
            print("Error gathering Button Info")
        }catch  {
            fatalError("BOOM")
        }
    }
    
    internal func btnDirection(tag: Int)throws -> MoveDirection{
        //tagNo mapping to determin whether the button is an up or down type.

        switch tag{
        case 0,2,4:
            return MoveDirection.down
        case 1,3,5:
            return MoveDirection.up
        default:
            throw GameError.moveDirectionError
        }
    }
    
    internal func btnSize(tag: Int) -> ButtonSize{
        //tagNo mapping to determin whether the button is a full or half length.
        //identifiying this will determine which image is used.

      
        switch tag{
        case 0,5:
            return ButtonSize.full
        default:
            return ButtonSize.half
        }
    }
    
    internal func associatedLabel(tag: Int)throws -> EventLabel{
        //tagNo mapping will determin which label (and therefore which historical event) the selected button is associated to.
        
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
        //Function determins which image is to be used when the buttons are displayed.

        
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



//**************************************************
//***************** Classes
//**************************************************

class BoutTimeGame: BoutTimeGameType{
    

    
    var totalNoOfRounds: Int
    var numEventsPerRound: Int
    var eventDataCollection: [HistoricalEvent: HistoricalEventItem]
    var eventDataCurrentRound: [[HistoricalEvent: HistoricalEventItem]] = []
    var eventDataCurrentRoundUserOrdered: [HistoricalEvent] = []
    
    var eventDataGameHistory: [HistoricalEvent] = []
    
    var roundsPlayed = 0
    var correctRounds = 0
    
    init(){
        //This init method is called when the app first loads.
        //Required to establish a game object without any initial values.
        
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
        //Method is used to generate a array of unique Historical events to be displayed on the commencement of a new round.
        //Return Array is not is historical event order. This is subject to change by the user.
        
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
        
        loggingPrint(roundDataArr)
        return roundDataArr
        
    }
    
    
    func moveDataSet(dataSet: Array<[HistoricalEvent: HistoricalEventItem]>, eventLabel:  EventLabel, move: MoveDirection) -> Array<[HistoricalEvent: HistoricalEventItem]>{
        //Method is called to reorder the current Array  of historical events.
        //This method is called everytime a users presses a direction button.
        //An Array collection is returned with the re-ordered values determined by the user.
     
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
        
        loggingPrint(reOrdered)
        return reOrdered
    }
    

    func checkSubmittedAnswer(userOrder: Array<[HistoricalEvent: HistoricalEventItem]>) -> (isRoundCorrect: Bool, wrongAnswers: [Int]) {
        //Method is called to check if the user submitted array is in correct sequential order.
        //getRoundAnswerInDateOrder() is called to retreive the correct answer which is then cross checked against user submitted answer.
        //If answer is incorrect, Method will return the individual wrongAnswers.

        let answerArr = getRoundAnswerInDateOrder()
        var answerUserSubmitted: [Int] = []
        var isCorrect = true
        var wrongAnswer: [Int] = []
        
        var count = 0
        
        for event in userOrder{
            
            for item in event{
                answerUserSubmitted.append(item.value.seqNo)
                
                if answerArr[count] != item.value.seqNo{
                    isCorrect = false
                    wrongAnswer.append(item.value.seqNo)
                }
            }
            count += 1
        }
        
        if isCorrect{
            correctRounds += 1
        }
        
        print("Round \(roundsPlayed)")
        print("Submitted Answer SeqNo's: \(answerUserSubmitted)")
        print("Correct Answer SeqNo's: \(answerArr)")
        print("Player Score \(correctRounds) of \(roundsPlayed)")

        return (isCorrect, wrongAnswer)
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
    

    func getUniqueEvent() -> [HistoricalEvent: HistoricalEventItem]  {
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

    //**************************************************
    //***************** Helper Methodss
    //**************************************************
    
    func isGameOver() -> Bool{
        //Method return true/false is confirm if the game is in progress.
        
        var trueOrFalse: Bool = false
        
        if totalNoOfRounds == roundsPlayed {
            trueOrFalse = true
        }
        
        return trueOrFalse
    }
    
    func incrementRoundCount(){
        //Method is used to count the rounds played.
        
        roundsPlayed += 1
        
    }
    
    
    private func randomizedInt() -> Int {
        //Method generates a random int.
        
        let lowerBound: UInt32 = 1
        let upperBound: UInt32 = UInt32(eventDataCollection.count)
        
        let index = Int(arc4random_uniform(upperBound - lowerBound) + lowerBound)
        
        return index
    }
    
    
    private func hasEventBeenUsedBefore(event: HistoricalEvent) throws -> Bool{
        //Method check the historical events used within the game and returns true/false is the historical event has been used before.
        
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
    
    func resetGame(){
        //Method resets variables for a new game.
        
        roundsPlayed = 0
        correctRounds = 0
        eventDataCurrentRound.removeAll()
        eventDataCurrentRoundUserOrdered.removeAll()
        eventDataGameHistory.removeAll()
        
    }
    
}





