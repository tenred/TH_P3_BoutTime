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
        updateLabelsWithNewEvents()
        

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
  

//    func updateLabelText(eventArr: Array<String>){
//        
//        for lbl in eventLabelCollection{
//            lbl.text = "\(eventArr[lbl.tag])"
//        }
//    }
    
    func updateLabelsWithNewEvents(){
        
        for lbl in eventLabelCollection{
            let event =  boutTimeGamePlay.getUniqueEvent()
            lbl.text = event[0].description       }
    }
    
    @IBAction func test(_ sender: Any) {
            print(boutTimeGamePlay.getUniqueEvent())
    }
    
    
}

