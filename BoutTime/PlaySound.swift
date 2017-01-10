//
//  GameAudio.swift
//  TrueFalseStarter
//
//  Created by Sherief Wissa on 20/10/16.
//  Copyright © 2016 Treehouse. All rights reserved.
//
//


import Foundation
import AudioToolbox

struct AudioControl {
    // Description: This struct controls the inApp audio based on the different events within the gameplay.
    
    private var gameSound: SystemSoundID = 0
    
    let correctAnswAudioFile = "CorrectDing"
    let wrongAnswAudioFile = "IncorrectBuzz"
    
        
    private mutating func loadAudio(audioFileName: String){
        //Description: initiates the Game Audio
        let pathToSoundFile = Bundle.main.path(forResource: audioFileName, ofType: "wav")
        let soundURL = NSURL(fileURLWithPath: pathToSoundFile!)
        AudioServicesCreateSystemSoundID(soundURL, &gameSound)
        
    }
    
    mutating func play(isCorrect: Bool) {
        //Descrition: plays audio when the app is launched.
        var soundURL = ""
        
        if isCorrect{
            soundURL = correctAnswAudioFile
        } else {
            soundURL = wrongAnswAudioFile
        }
        
        loadAudio(audioFileName: soundURL)
        AudioServicesPlaySystemSound(gameSound)
    }

}
