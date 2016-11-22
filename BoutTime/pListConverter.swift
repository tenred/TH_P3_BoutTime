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
//Class Retreives the pList data file and returns it as a castDictionary
    
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
        var seqNo: Int
        
//**************************************************
//***************** Helper Methods
//**************************************************

        func convertStringToDate(str: String) throws -> NSDate {
        //Function takes a string date value and returns an NSDate value
        //Function throws an error if string value cannot be converted.
 
            let delimitedStringArr = str.components(separatedBy: "T")
            let dateStr = delimitedStringArr[0]
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            guard let convertedDate = dateFormatter.date(from: dateStr) else {
                throw pListConversionError.StringToDateConversionError
            }

            return convertedDate as NSDate
        }
        
        
        func convertSeqToInt(str: String) throws -> Int{
        //Function takes a string value and returns an Int value
        //Function throws an error if string value cannot be converted.
            
            
            guard let convertedInt = Int(str) else {
                throw pListConversionError.SeqNoToIntCoversionError
            }
            
            return convertedInt
            
        }
        
//**************************************************
//***************** End of Helper Methods
//**************************************************
        
        for (key,value) in dictionary{
            if let itemDict = value as? [String:String], let eventDescription = itemDict["eventDescription"], let dateStr = itemDict["date"], let URLstr = itemDict["URL"], let seqNoStr = itemDict["seqNo"]{
                
                do{
                    date = try convertStringToDate(str: dateStr)
                    seqNo = try convertSeqToInt(str: seqNoStr)
                    URL = NSURL(fileURLWithPath: URLstr)
                    
                } catch let error{
                    fatalError("\(error)")
                }
                
                let item = HistoricalEventItem(description: eventDescription, URL: URL, date: date, seqNo: seqNo)
                
                guard let eventKey = HistoricalEvent(rawValue: seqNo) else{

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
