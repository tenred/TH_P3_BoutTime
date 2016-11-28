//
//  ViewController.swift
//  BoutTime
//
//  Created by Sherief Wissa on 14/11/16.
//  Copyright © 2016 10 Red Hacks Pty Ltd. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {

    //**************************************************
    //***************** <UI Objects>
    //**************************************************
    
    @IBOutlet weak var eventLabel1: UILabel!
    @IBOutlet weak var eventLabel2: UILabel!
    @IBOutlet weak var eventLabel3: UILabel!
    @IBOutlet weak var eventLabel4: UILabel!
    @IBOutlet var eventLabelCollection: [UILabel]!
    
    @IBOutlet var eventButtonCollection: [UIButton]!
    
    @IBOutlet weak var nextRoundButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    
    var soundToPlay = AudioControl()
    var eventCollection: [HistoricalEvent : HistoricalEventItem]

    var boutTime = BoutTimeGame()
    var eventDataForRound: [[HistoricalEvent : HistoricalEventItem]] = []

    required init?(coder aDecoder: NSCoder) {
        
        do{
            let dictionary = try PListConverter.dictionaryFromFile(resource: "HistoricalEventsData", ofFileType: "plist")
            let eventCollectionDict = try HistoricalEventUnArchiver.HistoryEventFromDictionary(dictionary: dictionary)
            self.eventCollection = eventCollectionDict

            let boutTimeObj = BoutTimeGame(totalNoOfRounds: 6, numEventsPerRound: 4, eventData: eventCollection)
            self.boutTime = boutTimeObj
            
        } catch let error {
            fatalError("\(error)")
        }
        
        super.init(coder: aDecoder)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // ViewController to become first responder to shake event.
        self.becomeFirstResponder()
        changeUIState(gameState: .newGame, isRoundCorrect: nil)
        newRound()

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        //Override function to respond to shake action.
        
        print("Shakey Shakey")
        
        if boutTime.isGameOver(){
            gameOver()
        } else {
            checkAnswer()
        }
        
        soundToPlay.correctSound()
        
    }
    
    
    //**************************************************
    //***************** Helper Methods
    //**************************************************
  
    
    @IBAction func buttonSelected(sender: UIButton) {
    
        //let button = buttonAttributes(tagNo: sender.tag, state: ButtonState.selected)
        
        //sender.setImage(button.stateImage, for: .selected)
        
        
//        let moveDirection: MoveDirection
//        let buttonSize: ButtonSize
//        
//        do{
//            
//            let buttonState = try boutTime.getButtonLabelInfo(btnTagNo: sender.tag)
//            
//            moveDirection = buttonState.move
//            buttonSize = buttonState.size
//            
//        } catch GameError.moveDirectionError {
//            print("Error moving event to next label")
//
//        }catch {
//            fatalError("BOOM")
//        }
//        
//        
    }

    
    @IBAction func buttonPressed(_ sender: UIButton) {
        
        //do{
          
            let buttonInfo = buttonAttributes(tagNo: sender.tag)
            //let actionItems = try boutTime.getButtonLabelInfo(btnTagNo: sender.tag)
            //eventDataForRound = boutTime.moveDataSet(dataSet: eventDataForRound, eventLabel: actionItems.eventLabel, move: actionItems.move)
            
            eventDataForRound = boutTime.moveDataSet(dataSet: eventDataForRound, eventLabel: buttonInfo.associatedLabel, move: buttonInfo.direction)

            updateLabelsWithEventDescription()
//                        
//        }catch GameError.moveDirectionError {
//            print("Error moving event to next label")
//            
//        }catch {
//            fatalError("BOOM")
//        }
    
    }
    
    func checkAnswer(){
        
        let checkUserAnswer = boutTime.checkSubmittedAnswer(userOrder: eventDataForRound)
        let isRoundCorrect = checkUserAnswer.isRoundCorrect
        let wrongAnswers: [Int]? = checkUserAnswer.wrongAnswers
        
        changeUIState(gameState: .answerSubmitted, isRoundCorrect: isRoundCorrect)
        
    }
    
    
    @IBAction func newRound(){
        boutTime.incrementRoundCount()
        eventDataForRound = boutTime.getHistoricalEventsForRound()
        updateLabelsWithEventDescription()
        changeUIState(gameState: .newRound, isRoundCorrect: nil)
    }
    
    func gameOver(){
        
    }

    
    func updateLabelsWithEventDescription(){
        
        for lbl in eventLabelCollection{
            let recordForLabel = eventDataForRound[lbl.tag]            
            for item in recordForLabel{
                lbl.text = String(item.value.description)
            }
            
        }
    }
    
    func changeUIState(gameState: gameUIState, isRoundCorrect: Bool?){
        
        switch gameState {
            
        case .newGame:
        setButtonSelectImage()
        
        case .newRound:
            nextRoundButton.isHidden = true
            timerLabel.isHidden = false
            
        case .answerSubmitted:
            if let isRoundCorrect = isRoundCorrect{
                nextRoundButton.setImage(nextRoundButtonBGImage(isRoundCorrect: isRoundCorrect), for: .normal)
            }
            
            nextRoundButton.isHidden = false
            timerLabel.isHidden = true
            

        default:
            break
        }
    }
    

    func setButtonSelectImage(){

        for button in eventButtonCollection{
            let buttonAttribs = buttonAttributes(tagNo: button.tag)
            let move: MoveDirection = buttonAttribs.direction
            let size: ButtonSize = buttonAttribs.size
            
            let buttonSelectImage = buttonAttribs.stateImage(btnDirection: move, btnPressState: .highlighted, btnSize: size)
            button.setImage(buttonSelectImage, for: .highlighted)
        }
    }
    
    func nextRoundButtonBGImage(isRoundCorrect: Bool) -> UIImage{
        
        let success: UIImage = #imageLiteral(resourceName: "next_round_success.png")
        let fail: UIImage = #imageLiteral(resourceName: "next_round_fail.png")
    
        if isRoundCorrect{
            return success
        } else {
            return fail
        }
    }


}
