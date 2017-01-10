//
//  EventInfoVC.swift
//  BoutTime
//
//  Created by Sherief Wissa on 1/12/16.
//  Copyright © 2016 10 Red Hacks Pty Ltd. All rights reserved.
//
//

import UIKit

class EventInfoVC: UIViewController {
    // This Class controlles the VC used to display URL of selected event when a users selects a particular event.


    @IBOutlet weak var dismissButton: UIBarButtonItem!
    @IBOutlet weak var eventURLWebview: UIWebView!
    
    var eventURL: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadURL()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func closeWebView(_ sender: Any) {
        // Dismisses the VC when the "X" button is selected.
        
        self.dismiss(animated: true, completion: nil)

    }
   
    func loadURL(){
        // Loads the URL from the pList associated to the selected event.
        
        if let strURL = eventURL{
            
            let URLAddress = URL(string: strURL)!
        
            loggingPrint(UIApplication.shared.canOpenURL(URLAddress))
            if UIApplication.shared.canOpenURL(URLAddress){
                print("Yep")
                let requestObj = URLRequest(url: URLAddress)
                eventURLWebview.loadRequest(requestObj)
                
            } else {
                showAlert()
            }
        } else {
        }

    }
    
    func showAlert(){
        let alertController = UIAlertController(title: "URL Error", message: "Sorry, Issues displaying the webpage!", preferredStyle: UIAlertControllerStyle.alert)
        self.present(alertController, animated: true, completion: nil)
        
        
        //alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default , handler: nil))
        //self.present(alertController, animated: true, completion: nil)
    }
    
}
