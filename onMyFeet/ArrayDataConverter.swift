//
//  ArrayDataConverter.swift
//  OnMyFeet
//
//  Created by Zhao Xiongbin on 2016-04-03.
//  Copyright © 2016 OnMyFeet Group. All rights reserved.
//

import Foundation

class ArrayDataConverter {
//    static func stringArrayToNSData(_ array: [String]) -> Data {
//        let data = NSMutableData()
//        let terminator = [0]
//        for string in array {
//            if let encodedString = string.data(using: String.Encoding.utf8) {
//                data.append(encodedString)
//                data.append(terminator, length: 1)
//            }
//            else {
//                NSLog("Cannot encode string \"\(string)\"")
//            }
//        }
//        return data as Data
//    }
//    
//    static func nsDataToStringArray(_ data: Data) -> [String] {
//        var decodedStrings = [String]()
//        
//        var stringTerminatorPositions = [Int]()
//        
//        var currentPosition = 0
//        data.enumerateBytes() {
//            buffer, range, stop in
//            
//            let bytes = UnsafePointer<UInt8>(buffer)
//            for i in 0..<range.length {
//                if bytes[i] == 0 {
//                    stringTerminatorPositions.append(currentPosition)
//                }
//                currentPosition += 1
//            }
//        }
//        
//        var stringStartPosition = 0
//        for stringTerminatorPosition in stringTerminatorPositions {
//            let encodedString = data.subdata(in: NSMakeRange(stringStartPosition, stringTerminatorPosition - stringStartPosition))
//            let decodedString =  NSString(data: encodedString, encoding: String.Encoding.utf8) as! String
//            decodedStrings.append(decodedString)
//            stringStartPosition = stringTerminatorPosition + 1
//        }
//        
//        return decodedStrings
//    }
}
