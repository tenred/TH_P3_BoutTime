//
//  GameAudio.swift
//  TrueFalseStarter
//
//  Created by Sherief Wissa on 20/10/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//
// Description: This struct controls the inApp audio based on the different events within the gameplay.
//


import Foundation
import AudioToolbox

struct AudioControl {
    
    private var gameSound: SystemSoundID = 0
    
    private let correctAnswAudioFile = "CorrectDing"
    private let wrongAnswAudioFile = "IncorrectDing"
    
    private mutating func loadAudio(audioFileName: String){
        //Description: initiates the Game Audio
        let pathToSoundFile = Bundle.main.path(forResource: audioFileName, ofType: "wav")
        let soundURL = NSURL(fileURLWithPath: pathToSoundFile!)
        AudioServicesCreateSystemSoundID(soundURL, &gameSound)
        
    }
    
    mutating func correctSound() {
        //Descrition: plays audio when the app is launched.
        loadAudio(audioFileName: correctAnswAudioFile)
        AudioServicesPlaySystemSound(gameSound)
    }
    
    
    mutating func wrongSound(){
        //Descrition: plays audio when the a correct answer is selected.
        loadAudio(audioFileName: wrongAnswAudioFile)
        AudioServicesPlaySystemSound(gameSound)
        
    }
}
