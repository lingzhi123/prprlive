//
//  StreamDashboardConnector.swift
//  Prprlive-ios
//
//  Created by Apple on 16/5/22.
//  Copyright © 2016年 prprlive.com. All rights reserved.
//

import Foundation
import UIKit

class StreamDashboardConnector: Connector {
    var session: NSURLSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
//    var dashboardManager = RKObjectManager(baseURL: NSURL(string: "http://test.dashboard.ks-cdn.com"))
    
    override init () {
        super.init()
//        RKMIMETypeSerialization.registerClass(RKNSJSONSerialization.self, forMIMEType: RKMIMETypeTextPlain)
//        self.dashboardManager.requestSerializationMIMEType = RKMIMETypeFormURLEncoded
//        self.dashboardManager.setAcceptHeaderWithMIMEType(RKMIMETypeTextPlain)
        
    }
    
    func streams(app: String, channel: String, success: (streams: [Stream]) -> (), failure: (error: NSError) -> ()) {
        
        let task: NSURLSessionTask = session.dataTaskWithURL(NSURL(string: "http://test.dashboard.ks-cdn.com/v1/stat?"+app+"="+channel)!) { (nsdata, respons, error) -> Void in
            if (error != nil) {
                failure(error: error!)
                return
            }
            
//            let str: NSString = NSString(data: nsdata!, encoding: NSUTF8StringEncoding)!
//            print(str)
            success(streams: StreamMappingProvider.streamResponseMapping(nsdata, app: app, channel: channel))
        }
        
        task.resume()
        
    }
    
    func recent(userId: UInt, success: (streams: [Stream]) -> (), failure: (error: NSError) -> ()) {
//        let path = ("stream/recent" as NSString).stringByAppendingPathComponent("\(userId)")
//        
//        let streamMapping = StreamMappingProvider.streamResponseMapping()
//        let statusCode = RKStatusCodeIndexSetForClass(RKStatusCodeClass.Successful)
//        
//        let responseDescriptor = RKResponseDescriptor(mapping: streamMapping, method: RKRequestMethod.GET, pathPattern: nil, keyPath: "data.recent", statusCodes: statusCode)
//        
//        manager.addResponseDescriptor(responseDescriptor)
//        
//        manager.getObjectsAtPath(path, parameters: self.sessionParams(), success: { (operation, mappingResult) -> Void in
//            // success code
//            let error:Error = self.findErrorObject(mappingResult: mappingResult)!
//            if !error.status {
//                if error.code == Error.kLoginExpiredCode {
//                    self.relogin({ () -> () in
//                        self.recent(userId, success: success, failure: failure)
//                        }, failure: { () -> () in
//                            failure(error: error.toNSError())
//                    })
//                } else {
//                    failure(error: error.toNSError())
//                }
//            } else {
//                let streams = mappingResult.dictionary()["data.recent"] as! [Stream]
//                success(streams: streams)
//            }
//        }) { (operation, error) -> Void in
//            // failure code
//            failure(error: error)
//        }
    }
    
    func my(success: (streams: [Stream]) -> (), failure: (error: NSError) -> ()) {
//        let path = "stream/my"
//        
//        let streamMapping = StreamMappingProvider.streamResponseMapping()
//        let statusCode = RKStatusCodeIndexSetForClass(RKStatusCodeClass.Successful)
//        
//        let responseDescriptor = RKResponseDescriptor(mapping: streamMapping, method: RKRequestMethod.GET, pathPattern: nil, keyPath: "data.streams", statusCodes: statusCode)
//        
//        manager.addResponseDescriptor(responseDescriptor)
//        
//        manager.getObjectsAtPath(path, parameters: self.sessionParams(), success: { (operation, mappingResult) -> Void in
//            // success code
//            let error:Error = self.findErrorObject(mappingResult: mappingResult)!
//            if !error.status {
//                if error.code == Error.kLoginExpiredCode {
//                    self.relogin({ () -> () in
//                        self.my(success, failure: failure)
//                        }, failure: { () -> () in
//                            failure(error: error.toNSError())
//                    })
//                } else {
//                    failure(error: error.toNSError())
//                }
//            } else {
//                let streams = mappingResult.dictionary()["data.streams"] as! [Stream]
//                success(streams: streams)
//            }
//        }) { (operation, error) -> Void in
//            // failure code
//            failure(error: error)
//        }
    }
    
    func viewers(data: NSDictionary, success: (likes: UInt, viewers: UInt, users: [User]) -> (), failure: (error: NSError) -> ()) {
        let streamId = data["streamId"] as! UInt
        let path = ("stream/viewers" as NSString).stringByAppendingPathComponent("\(streamId)")
        
        let streamMapping = StreamMappingProvider.viewersResponseMapping()
        let statusCode = RKStatusCodeIndexSetForClass(RKStatusCodeClass.Successful)
        
        let streamResponseDescriptor = RKResponseDescriptor(mapping: streamMapping, method: RKRequestMethod.GET, pathPattern: nil, keyPath: "data", statusCodes: statusCode)
        
        manager.addResponseDescriptor(streamResponseDescriptor)
        
        var params = self.sessionParams()
        if let page: UInt = (data["p"] as? UInt) {
            params!["p"] = page
        }
        
        manager.getObjectsAtPath(path, parameters: params, success: { (operation, mappingResult) -> Void in
            let error:Error = self.findErrorObject(mappingResult: mappingResult)!
            if !error.status {
                if error.code == Error.kLoginExpiredCode {
                    self.relogin({ () -> () in
                        self.viewers(data, success: success, failure: failure)
                        }, failure: { () -> () in
                            failure(error: error.toNSError())
                    })
                } else {
                    failure(error: error.toNSError())
                }            } else {
                let data = mappingResult.dictionary()["data"] as! NSDictionary
                let likes: UInt     = data["likes"] as! UInt
                let viewers: UInt   = data["viewers"] as! UInt
                let users:[User]    = data["users"] as! [User]
                success(likes: likes, viewers: viewers, users: users)
            }
        }) { (operation, error) -> Void in
            failure(error: error)
        }
    }
    
    func replayViewers(data: NSDictionary, success: (likes: UInt, viewers: UInt, users: [User]) -> (), failure: (error: NSError) -> ()) {
        let streamId = data["streamId"] as! UInt
        let path = ("stream/rviewers" as NSString).stringByAppendingPathComponent("\(streamId)")
        
        let streamMapping = StreamMappingProvider.viewersResponseMapping()
        let statusCode = RKStatusCodeIndexSetForClass(RKStatusCodeClass.Successful)
        
        let streamResponseDescriptor = RKResponseDescriptor(mapping: streamMapping, method: RKRequestMethod.GET, pathPattern: nil, keyPath: "data", statusCodes: statusCode)
        
        manager.addResponseDescriptor(streamResponseDescriptor)
        
        var params = self.sessionParams()
        if let page: UInt = (data["p"] as? UInt) {
            params!["p"] = page
        }
        
        manager.getObjectsAtPath(path, parameters: params, success: { (operation, mappingResult) -> Void in
            let error:Error = self.findErrorObject(mappingResult: mappingResult)!
            if !error.status {
                if error.code == Error.kLoginExpiredCode {
                    self.relogin({ () -> () in
                        self.replayViewers(data, success: success, failure: failure)
                        }, failure: { () -> () in
                            failure(error: error.toNSError())
                    })
                } else {
                    failure(error: error.toNSError())
                }            } else {
                let data = mappingResult.dictionary()["data"] as! NSDictionary
                let likes: UInt     = data["likes"] as! UInt
                let viewers: UInt   = data["viewers"] as! UInt
                let users:[User]    = data["users"] as! [User]
                success(likes: likes, viewers: viewers, users: users)
            }
        }) { (operation, error) -> Void in
            failure(error: error)
        }
    }
}
