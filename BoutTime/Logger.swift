//
//  Logger.swift
//  BoutTime
//
//  Created by Sherief Wissa on 22/11/16.
//  Copyright © 2016 10 Red Hacks Pty Ltd. All rights reserved.
//

import Foundation

func loggingPrint<T>(_ closure: @autoclosure () -> T, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
    // Function used for internal logging of attribute values for trouble shooting
    
    #if DEBUG
        let instance = closure()
        let description: String
        
        if let debugStringConvertible = instance as? CustomDebugStringConvertible {
            description = debugStringConvertible.debugDescription
        } else {
            // Will use `CustomStringConvertible` representation if possuble, otherwise
            // it will print the type of the returned instance like `T()`
            description = "\(instance)"
        }
        
        let file = URL(fileURLWithPath: file).lastPathComponent
        let queue = Thread.isMainThread ? "UI" : "BG"
        
        print("<\(queue)> \(file) `\(function)` [\(line)]: \(description)")
    #endif
}
