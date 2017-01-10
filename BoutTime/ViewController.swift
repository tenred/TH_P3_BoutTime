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
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var shakeTextLabel: UILabel!
    @IBOutlet weak var earliestTextLabel: UILabel!
    @IBOutlet weak var latestTextLabel: UILabel!

    @IBOutlet var eventButtonCollection: [UIButton]!
    @IBOutlet weak var nextRoundButton: UIButton!
    
    @IBOutlet weak var yourScoreLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var playAgainButton: UIButton!
    
    
    var soundToPlay = AudioControl()
    
    var timerInterval: Timer!
    var roundTimer = CountdownTimer(totalTimeInSecs: 60)

    var boutTime = BoutTimeGame()

    var eventCollection: [HistoricalEvent : HistoricalEventItem]
    var eventDataForRound: [[HistoricalEvent : HistoricalEventItem]] = []
    var infoURL: String?

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
        NewGame()
 
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        //Override function to respond to shake action.
        
        print("Shakey Shakey")
     
        stopTimer()
        checkAnswer()
        
    }
    
    
    
    //**************************************************
    //***************** Helper Methods
    //**************************************************
  
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        
            let buttonInfo = buttonAttributes(tagNo: sender.tag)
            eventDataForRound = boutTime.moveDataSet(dataSet: eventDataForRound, eventLabel: buttonInfo.associatedLabel, move: buttonInfo.direction)
            updateLabelsWithEventDescription()
    
    }
    
    func makeLabelsInteractive(pressable: Bool){
        
            for label in eventLabelCollection{
                
                let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.labelPressed))
                
                if pressable {
                    print("Adding Label Gestures")
                    label.addGestureRecognizer(gestureRecognizer)
                } else{
                    print("Removing Label Gestures")
                    label.gestureRecognizers?.removeAll()
                }
            }
    }
    
    func labelPressed(sender: UIGestureRecognizer){
        
        if let labelNo = sender.view?.tag {
            GetTheEventURL(labelNo: labelNo)
        }
        
        performSegue(withIdentifier: "eventURLSegue", sender: nil)
    }
    
    
    func GetTheEventURL(labelNo: Int){
        
        let event = eventDataForRound[labelNo]
        for item in event{
            infoURL = item.value.URL
        }
    }
    
    
    
    func checkAnswer(){
        
        let checkUserAnswer = boutTime.checkSubmittedAnswer(userOrder: eventDataForRound)
        let isRoundCorrect = checkUserAnswer.isRoundCorrect
        let wrongAnswers: [Int]? = checkUserAnswer.wrongAnswers
        
        changeUIState(gameState: .answerSubmitted, isRoundCorrect: isRoundCorrect)
        makeLabelsInteractive(pressable: true)

        if let wrongAnswers = wrongAnswers{
            highlightWrongEvents(wrongAnswers: wrongAnswers)
        }
        
            soundToPlay.play(isCorrect: isRoundCorrect)
        
    }
    

    @IBAction func newRound(){
        
        if boutTime.isGameOver(){
            gameOver()
            
        } else {
            
            boutTime.incrementRoundCount()
            eventDataForRound = boutTime.getHistoricalEventsForRound()
            updateLabelsWithEventDescription()
            changeUIState(gameState: .newRound, isRoundCorrect: nil)
            timerInterval = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(displayTimer), userInfo: nil, repeats: true)
            makeLabelsInteractive(pressable: false)

        }
     }
    
    
    
    func displayTimer(){
        
        if roundTimer.isTimerFinished(){
            stopTimer()
            checkAnswer()

        }else {
            roundTimer.increment()
            timerLabel.text = roundTimer.displayString()
        }
    }
    
    func stopTimer(){
        roundTimer.ResetTimer()
        timerLabel.text = roundTimer.displayString()
        timerInterval.invalidate()
    }

    
    @IBAction func NewGame(){

        changeUIState(gameState: .newGame, isRoundCorrect: nil)
        boutTime.resetGame()
        newRound()

    }
    
    func gameOver(){
        
        stopTimer()
        changeUIState(gameState: .endGame, isRoundCorrect: nil)
        scoreLabel.text = "\(boutTime.correctRounds)/\(boutTime.totalNoOfRounds)"
        //performSegue(withIdentifier: "FinalScoreView", sender: self)
    }


    
    func changeUIState(gameState: gameUIState, isRoundCorrect: Bool?){
        
        switch gameState {
            
        case .newGame:
            hideUnhideUI(state: .newGame)
            setButtonSelectImage()
        
        case .newRound:
            nextRoundButton.isHidden = true
            timerLabel.isHidden = false
            shakeTextLabel.text = "Shake to complete"

            
        case .answerSubmitted:
            if let isRoundCorrect = isRoundCorrect{
                nextRoundButton.setImage(nextRoundButtonBGImage(isRoundCorrect: isRoundCorrect), for: .normal)
            }
            
            nextRoundButton.isHidden = false
            timerLabel.isHidden = true
            shakeTextLabel.text = "Tap events to learn more"
            
        case .endGame:
            hideUnhideUI(state: .endGame)
        
        default:
            break
        }
    }
    

    
    func updateLabelsWithEventDescription(){
        
        for lbl in eventLabelCollection{
            let recordForLabel = eventDataForRound[lbl.tag]
            for item in recordForLabel{
                lbl.text = String(item.value.description)
                lbl.textColor = UIColor(red: 0/255, green: 64/255, blue: 128/255, alpha: 1.0)
            }
            
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
    
    func highlightWrongEvents(wrongAnswers: Array<Int>){
        
        var labelCount = 0
        
        for event in eventDataForRound{
            for item in event{
                let seqNo = item.value.seqNo
                
                for answer in wrongAnswers{
                    
                    if answer == seqNo{
                        eventLabelCollection[labelCount].textColor = UIColor.red
                    }
                }
                
            }
         labelCount += 1
        }
    }
    
    func hideUnhideUI(state: gameUIState){
        
        var hideGameScreen: Bool!
        var hideScoreScreen: Bool!
        
        
        switch state {
        case .newGame:
            hideGameScreen = false
            hideScoreScreen = true
        case .endGame:
            hideGameScreen = true
            hideScoreScreen = false
        default:
            break
        }

        
        //Game Screen UI Objects
        
        for label in eventLabelCollection{
        label.isHidden = hideGameScreen
        }
        
        for button in eventButtonCollection{
        button.isHidden = hideGameScreen
        }
        
        nextRoundButton.isHidden = hideGameScreen
        timerLabel.isHidden = hideGameScreen
        shakeTextLabel.isHidden = hideGameScreen
        earliestTextLabel.isHidden = hideGameScreen
        latestTextLabel.isHidden = hideGameScreen
        

        //Final Score Screen UI Objects

        yourScoreLabel.isHidden = hideScoreScreen
        playAgainButton.isHidden = hideScoreScreen
        scoreLabel.isHidden = hideScoreScreen
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "eventURLSegue") {
            let svc = segue.destination as! EventInfoVC
            
            if let URLStr = infoURL {
                svc.eventURL = URLStr
            }
            
        }
    }


    

}


