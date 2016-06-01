//
//  ZXAPIManager.swift
//  OnMyFeet
//
//  Created by Jack Zhao on 2016-06-01.
//  Copyright © 2016 OnMyFeet Group. All rights reserved.
//

import Foundation
import Alamofire

typealias ZXAPICompletionBlock = (request:NSURLRequest?, response:NSHTTPURLResponse?, data:NSData?, error:NSError?) -> Void

let classes: [String: ()->ZXResponseSerializerProtocol] = ["TestData":{return TestData()}]

class ZXAPIManager: NSObject {
    var defaultParameters: [String: AnyObject]?
    var backgroundQueue: dispatch_queue_t!
    var baseURL: NSURL?

    static var sharedManager = ZXAPIManager.init()
    
    override init() {
        backgroundQueue = dispatch_queue_create("com.jackzhao.tool.bgqueue", nil)
        let URLCache = NSURLCache(memoryCapacity: 4 * 1024 * 1024,
                                  diskCapacity: 20 * 1024 * 1025 ,
                                  diskPath: nil)
        NSURLCache.setSharedURLCache(URLCache)
        super.init()
    }
    
    class func setBaseURL(baseURL:NSURL?) {
        var url = baseURL
        if let baseURL = baseURL {
            if (baseURL.path!.characters.count)>0 && !baseURL.absoluteString.hasSuffix("/") {
                url = baseURL.URLByAppendingPathComponent("")
            }
        }
        
        self.sharedManager.baseURL = url
    }
    
    func startRequestWithRelativeURL(relativeURL:String,
                          method:String,
                          params:[String: AnyObject]?,
                          headers:[String:String]?,
                          cacheLength:NSTimeInterval?,
                          serializerClassName:String?,
                          requestInfo:[String:AnyObject]?,
                          completion:ZXAPICompletionBlock?)
    {
        var requestHash: String?
        
        let URLString = NSURL(string: relativeURL, relativeToURL: self.baseURL)!.absoluteString
        
        var fullDictionary = self.defaultParameters
        if fullDictionary != nil {
            if let params = params {
                fullDictionary! += params
            }
        } else {
            fullDictionary = params
        }
        
        if let responseObject = self.retrieveCacheFor(URLString, params: fullDictionary) {
            self.processResponseCache(cacheLength,
                                      requestHash: requestHash,
                                      serializerClassName: serializerClassName,
                                      responseObject: responseObject,
                                      request: nil,
                                      response: nil,
                                      requestUserInfo: requestInfo,
                                      completion: completion)
        } else {
            
            
            Alamofire.request(Method(rawValue:method)!,
                URLString, parameters: fullDictionary,
                encoding: .URLEncodedInURL,
                headers: headers).response(completionHandler: {[unowned self](request, response, data, error) in
                    self.processResponseCache(cacheLength,
                        requestHash:requestHash,
                        serializerClassName: serializerClassName,
                        responseObject: data,
                        request: request,
                        response: response,
                        requestUserInfo: requestInfo,
                        completion: completion)
                })
            }
            
    }
    
    func retrieveCacheFor(urlString:String, params:NSDictionary?) -> NSData? {
        //Do Something To Retrieve Cache
        return nil
    }
    
    func processResponseCache(cacheLength:NSTimeInterval?, requestHash:String?, serializerClassName:String?, responseObject:NSData?, request:NSURLRequest?, response:NSHTTPURLResponse?, requestUserInfo:NSDictionary?, completion:ZXAPICompletionBlock?) {
        
        dispatch_async(backgroundQueue) {
            if serializerClassName != nil {
                let serializerInstance = classes[serializerClassName!]!()
                serializerInstance.serializeResponseObjectToModel(responseObject, requestUserInfo: nil)
                
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                if let completion = completion {
                    completion(request: request, response: response, data: responseObject, error: nil)
                }
            }
        }
    }
   
}


