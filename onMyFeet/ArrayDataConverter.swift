//
//  ArrayDataConverter.swift
//  OnMyFeet
//
//  Created by Zhao Xiongbin on 2016-04-03.
//  Copyright © 2016 OnMyFeet Group. All rights reserved.
//

import Foundation

class ArrayDataConverter {
    static func stringArrayToNSData(array: [String]) -> NSData {
        let data = NSMutableData()
        let terminator = [0]
        for string in array {
            if let encodedString = string.dataUsingEncoding(NSUTF8StringEncoding) {
                data.appendData(encodedString)
                data.appendBytes(terminator, length: 1)
            }
            else {
                NSLog("Cannot encode string \"\(string)\"")
            }
        }
        return data
    }
    
    static func nsDataToStringArray(data: NSData) -> [String] {
        var decodedStrings = [String]()
        
        var stringTerminatorPositions = [Int]()
        
        var currentPosition = 0
        data.enumerateByteRangesUsingBlock() {
            buffer, range, stop in
            
            let bytes = UnsafePointer<UInt8>(buffer)
            for i in 0..<range.length {
                if bytes[i] == 0 {
                    stringTerminatorPositions.append(currentPosition)
                }
                currentPosition += 1
            }
        }
        
        var stringStartPosition = 0
        for stringTerminatorPosition in stringTerminatorPositions {
            let encodedString = data.subdataWithRange(NSMakeRange(stringStartPosition, stringTerminatorPosition - stringStartPosition))
            let decodedString =  NSString(data: encodedString, encoding: NSUTF8StringEncoding) as! String
            decodedStrings.append(decodedString)
            stringStartPosition = stringTerminatorPosition + 1
        }
        
        return decodedStrings
    }
}