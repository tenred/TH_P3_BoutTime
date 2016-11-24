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
    
    var soundToPlay = AudioControl()
    var eventCollection: [HistoricalEvent : HistoricalEventItem]

    var boutTimeGamePlay = BoutTimeGame()
    var eventDataForRound: [[HistoricalEvent : HistoricalEventItem]] = []

    required init?(coder aDecoder: NSCoder) {
        
        do{
            let dictionary = try PListConverter.dictionaryFromFile(resource: "HistoricalEventsData", ofFileType: "plist")
            let eventCollectionDict = try HistoricalEventUnArchiver.HistoryEventFromDictionary(dictionary: dictionary)
            self.eventCollection = eventCollectionDict

            let boutTimeObj = BoutTimeGame(totalNoOfRounds: 6, numEventsPerRound: 4, eventData: eventCollection)
            self.boutTimeGamePlay = boutTimeObj
            
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
        newRound()

    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        //Override function to respond to shake action.
        
        print("Shakey Shakey")
        soundToPlay.correctSound()
    }
    
    
    //**************************************************
    //***************** Helper Methods
    //**************************************************
  

    
    @IBAction func buttonPressed(_ sender: UIButton) {
        
        let buttonNo: Int = sender.tag
        
        do{
          
            let actionItems = try boutTimeGamePlay.moveInstructions(btnTagNo: buttonNo)
            eventDataForRound = boutTimeGamePlay.reorderDataSet(dataSet: eventDataForRound, eventLabel: actionItems.eventLabel, move: actionItems.move)
            updateLabelsWithEventDescription()
                        
        }catch GameError.moveDirectionError {
            print("Error moving event to next label")
            
        }catch {
            fatalError("BOOM")
        }
    
    }
    
    func newRound(){
        
        eventDataForRound = boutTimeGamePlay.getHistoricalEventsForRound()
        updateLabelsWithEventDescription()
        
    }

    
    func updateLabelsWithEventDescription(){
        
        for lbl in eventLabelCollection{
            let recordForLabel = eventDataForRound[lbl.tag]            
            for item in recordForLabel{
                lbl.text = String(item.value.description)
            }
            
        }
    }
    
    
}

