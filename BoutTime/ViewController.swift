//
//  ViewController.swift
//  BoutTime
//
//  Created by Sherief Wissa on 14/11/16.
//  Copyright © 2016 10 Red Hacks Pty Ltd. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet var eventLabelCollection: [UILabel]!
    
    var soundToPlay = AudioControl()
    var eventCollection: [HistoricalEvent : HistoricalEventItem]

    required init?(coder aDecoder: NSCoder) {
        
        do{
            let dictionary = try PListConverter.dictionaryFromFile(resource: "HistoricalEventsData", ofFileType: "plist")
            let eventCollectionDict = try HistoricalEventUnArchiver.HistoryEventFromDictionary(dictionary: dictionary)
            self.eventCollection = eventCollectionDict
            
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
        UIStateFirstLoad()
        dateExperiment()

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
    

    func dateExperiment(){
        var dateArr = [NSDate]()
        
        for event in eventCollection{
            dateArr.append(event.value.date)
        }

        print(dateArr.sorted(by: { $0.compare($1 as Date) == .orderedAscending }))
        
    }
    
    func UIStateFirstLoad() {
    // Function loads the default UI state with app is first launched.
        
        for label in eventLabelCollection {
            label.layer.masksToBounds = true
            label.layer.cornerRadius = 5
        }
    }
    
}

