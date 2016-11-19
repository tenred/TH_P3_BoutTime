//
//  pListConverter.swift
//  BoutTime
//
//  Created by Sherief Wissa on 17/11/16.
//  Copyright © 2016 10 Red Hacks Pty Ltd. All rights reserved.
//

import Foundation

enum pListConversionError: Error{
    case InvalidResourceError
    case InvalidData (reason: String)
    case ConversionError
    case SeqNoToIntCoversionError
    case StringToURLConversionError
    case StringToDateConversionError
}


class PListConverter{
    class func dictionaryFromFile(resource: String, ofFileType: String) throws -> [String: AnyObject]{
        guard let path = Bundle.main.path(forResource: resource, ofType: ofFileType) else {
            throw pListConversionError.InvalidResourceError
        }
        
        guard let dictionary = NSDictionary(contentsOfFile: path), let castDictionary = dictionary as? [String: AnyObject] else{
            throw pListConversionError.ConversionError
        }
    
        return castDictionary
    }
}

class HistoricalEventUnArchiver{
    class func HistoryEventFromDictionary(dictionary: [String: AnyObject]) throws -> [HistoricalEvent: HistoricalEventItem] {
        
        var eventCollection: [HistoricalEvent: HistoricalEventItem] = [:]
        var date: NSDate
        var URL: NSURL
        
        func convertStringToDate(str: String) throws -> NSDate {
            
            let delimitedStringArr = str.components(separatedBy: "T")
            let dateStr = delimitedStringArr[0]
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
//            guard let convertedDate = dateFormatter.date(from: str) else {
//                throw pListConversionError.StringToDateConversionError
//            }
            guard let convertedDate = dateFormatter.date(from: dateStr) else {
                throw pListConversionError.StringToDateConversionError
            }

            return convertedDate as NSDate
        }
        
        for (key,value) in dictionary{
            if let itemDict = value as? [String:String], let eventDescription = itemDict["eventDescription"], let dateStr = itemDict["date"], let URLstr = itemDict["URL"]{
                
                print(itemDict)
                
                do{
                    date = try convertStringToDate(str: dateStr)
                    URL = NSURL(fileURLWithPath: URLstr)
                    
                } catch let error{
                    fatalError("\(error)")
                }
                
                let item = HistoricalEventItem(description: eventDescription, URL: URL, date: date)
                
                guard let eventKey = HistoricalEvent(rawValue: key) else{
                    let failReason = "Failed at \(key)"
                    throw HistoryEventDataError.InvalidData(reason: failReason)
                }
                
                eventCollection.updateValue(item, forKey: eventKey)
            } else {
            
            throw pListConversionError.InvalidResourceError
            }
        }
        
        return eventCollection
    }
}
