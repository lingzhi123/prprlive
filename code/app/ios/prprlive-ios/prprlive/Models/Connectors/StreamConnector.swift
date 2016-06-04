//
//  StreamConnector.swift
//  Streamini
//
//  Created by Vasily Evreinov on 23/06/15.
//  Copyright (c) 2015 UniProgy s.r.o. All rights reserved.
//

import UIKit

class StreamConnector: Connector {
    
//    func streams(getGlobal: Bool, success: (live: [Stream], recent: [Stream]) -> (), failure: (error: NSError) -> ()) {
//        let path = (getGlobal) ? "stream/global" : "stream/followed"
//        
//        let streamMapping = StreamMappingProvider.streamResponseMapping()
//        let statusCode = RKStatusCodeIndexSetForClass(RKStatusCodeClass.Successful)
//        
//        let liveStreamResponseDescriptor = RKResponseDescriptor(mapping: streamMapping, method: RKRequestMethod.GET, pathPattern: nil, keyPath: "data.live", statusCodes: statusCode)
//        
//        let recentStreamResponseDescriptor = RKResponseDescriptor(mapping: streamMapping, method: RKRequestMethod.GET, pathPattern: nil, keyPath: "data.recent", statusCodes: statusCode)
//        
//        manager.addResponseDescriptor(liveStreamResponseDescriptor)
//        manager.addResponseDescriptor(recentStreamResponseDescriptor)        
//        
//        manager.getObjectsAtPath(path, parameters: self.sessionParams(), success: { (operation, mappingResult) -> Void in
//            // success code
//            let error:Error = self.findErrorObject(mappingResult: mappingResult)!
//            if !error.status {
//                if error.code == Error.kLoginExpiredCode {
//                    self.relogin({ () -> () in
//                        self.streams(getGlobal, success: success, failure: failure)
//                    }, failure: { () -> () in
//                        failure(error: error.toNSError())
//                    })
//                } else {
//                    failure(error: error.toNSError())
//                }
//            } else {
//                var live: [Stream] = []
//                if let l: AnyObject = mappingResult.dictionary()["data.live"] {
//                    live = l as! [Stream]
//                }
//                
//                var recent: [Stream] = []
//                if let r: AnyObject = mappingResult.dictionary()["data.recent"] {
//                    recent = r as! [Stream]
//                }
//
//                success(live: live, recent: recent)
//            }
//        }) { (operation, error) -> Void in
//            // failure code
//            failure(error: error)
//        }
//    }
    
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
//                    }, failure: { () -> () in
//                        failure(error: error.toNSError())
//                    })
//                } else {
//                    failure(error: error.toNSError())
//                }
//            } else {
//                let streams = mappingResult.dictionary()["data.recent"] as! [Stream]                
//                success(streams: streams)
//            }
//            }) { (operation, error) -> Void in
//                // failure code
//                failure(error: error)
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
//                    }, failure: { () -> () in
//                        failure(error: error.toNSError())
//                    })
//                } else {
//                    failure(error: error.toNSError())
//                }
//            } else {
//                let streams = mappingResult.dictionary()["data.streams"] as! [Stream]
//                success(streams: streams)
//            }
//            }) { (operation, error) -> Void in
//                // failure code
//                failure(error: error)
//        }
    }
    
    func create(data: NSDictionary, success: (stream: Stream) -> (), failure: (error: NSError) -> ()) {
        let stream: Stream = Stream()
        stream.name = data["title"] as! String
        stream.channel = "live"
        
        success(stream: stream)
        
//        let path = "stream/create"
//        
//        let requestMapping  = StreamMappingProvider.createStreamRequestMapping()
//        let streamMapping   = StreamMappingProvider.streamResponseMapping()
//        
//        let requestDescriptor = RKRequestDescriptor(mapping: requestMapping, objectClass: NSDictionary.self, rootKeyPath: nil, method: RKRequestMethod.POST)
//        manager.addRequestDescriptor(requestDescriptor)
//
//        let statusCode = RKStatusCodeIndexSetForClass(RKStatusCodeClass.Successful)
//        let streamResponseDescriptor = RKResponseDescriptor(mapping: streamMapping, method: RKRequestMethod.POST, pathPattern: nil, keyPath: "data", statusCodes: statusCode)
//        
//        manager.addResponseDescriptor(streamResponseDescriptor)
//        
//        manager.postObject(data, path: path, parameters: self.sessionParams(), success: { (operation, mappingResult) -> Void in
//            // success code
//            let error:Error = self.findErrorObject(mappingResult: mappingResult)!
//            if !error.status {
//                if error.code == Error.kLoginExpiredCode {
//                    self.relogin({ () -> () in
//                        self.create(data, success: success, failure: failure)
//                    }, failure: { () -> () in
//                        failure(error: error.toNSError())
//                    })
//                } else {
//                    failure(error: error.toNSError())
//                }
//            } else {
//                let stream = mappingResult.dictionary()["data"] as! Stream
//                success(stream: stream)
//            }
//            }) { (operation, error) -> Void in
//                // failure code
//                failure(error: error)
//        }
    }
    
//    func createWithFile(filename: String, fileData: NSData, data: NSDictionary, success: (stream: Stream) -> (), failure: (error: NSError) -> ()) {
//        let path = "stream/create"
//        
//        let requestMapping  = StreamMappingProvider.createStreamRequestMapping()
//        let streamMapping   = StreamMappingProvider.streamResponseMapping()
//        
//        let requestDescriptor = RKRequestDescriptor(mapping: requestMapping, objectClass: NSDictionary.self, rootKeyPath: nil, method: RKRequestMethod.POST)
//        manager.addRequestDescriptor(requestDescriptor)
//        
//        let statusCode = RKStatusCodeIndexSetForClass(RKStatusCodeClass.Successful)
//        let streamResponseDescriptor = RKResponseDescriptor(mapping: streamMapping, method: RKRequestMethod.POST, pathPattern: nil, keyPath: "data", statusCodes: statusCode)
//        
//        manager.addResponseDescriptor(streamResponseDescriptor)
//        
//        let request =
//        manager.multipartFormRequestWithObject(data, method: RKRequestMethod.POST, path: path, parameters: self.sessionParams()) { (formData) -> Void in
//            formData.appendPartWithFileData(fileData, name: "image", fileName: filename, mimeType: "image/jpeg")
//        }
//        
//        let operation = manager.objectRequestOperationWithRequest(request, success: { (operation, mappingResult) -> Void in
//            let error:Error = self.findErrorObject(mappingResult: mappingResult)!
//            if !error.status {
//                if error.code == Error.kLoginExpiredCode {
//                    self.relogin({ () -> () in
//                        self.createWithFile(filename, fileData: fileData, data: data, success: success, failure: failure)
//                    }, failure: { () -> () in
//                        failure(error: error.toNSError())
//                    })
//                } else {
//                    failure(error: error.toNSError())
//                }
//            } else {
//                let stream = mappingResult.dictionary()["data"] as! Stream
//                success(stream: stream)
//            }
//            }) { (operation, error) -> Void in
//                failure(error: error)
//        }
//        
//        manager.enqueueObjectRequestOperation(operation)
//    }
    
//    func close(streamId: UInt, success: () -> (), failure: (error: NSError) -> ()) {
//        let path = "stream/close"
//        
//        var params = self.sessionParams()
//        params!["id"] = streamId
//        
//        manager.postObject(nil, path: path, parameters: params, success: { (operation, mappingResult) -> Void in
//            // success code
//            let error:Error = self.findErrorObject(mappingResult: mappingResult)!
//            if !error.status {
//                if error.code == Error.kLoginExpiredCode {
//                    self.relogin({ () -> () in
//                        self.close(streamId, success: success, failure: failure)
//                    }, failure: { () -> () in
//                        failure(error: error.toNSError())
//                    })
//                } else {
//                    failure(error: error.toNSError())
//                }            } else {
//                success()
//            }
//            }) { (operation, error) -> Void in
//                // failure code
//                failure(error: error)
//        }
//    }
    
//    func join(streamId: UInt, success: () -> (), failure: (error: NSError) -> ()) {
//        let path = "stream/join"
//        
//        var params = self.sessionParams()
//        params!["id"] = streamId
//        
//        manager.postObject(nil, path: path, parameters: params, success: { (operation, mappingResult) -> Void in
//            let error:Error = self.findErrorObject(mappingResult: mappingResult)!
//            if !error.status {
//                if error.code == Error.kLoginExpiredCode {
//                    self.relogin({ () -> () in
//                        self.join(streamId, success: success, failure: failure)
//                    }, failure: { () -> () in
//                        failure(error: error.toNSError())
//                    })
//                } else {
//                    failure(error: error.toNSError())
//                }            } else {
//                success()
//            }
//        }) { (operation, error) -> Void in
//            failure(error: error)
//        }
//    }
    
//    func leave(streamId: String, likes: UInt, success: () -> (), failure: (error: NSError) -> ()) {
//        let path = "stream/leave"
//        
//        var params = self.sessionParams()
//        params!["id"] = streamId
//        params!["likes"] = likes
//        
//        manager.postObject(nil, path: path, parameters: params, success: { (operation, mappingResult) -> Void in
//            let error:Error = self.findErrorObject(mappingResult: mappingResult)!
//            if !error.status {
//                if error.code == Error.kLoginExpiredCode {
//                    self.relogin({ () -> () in
//                        self.leave(streamId, likes: likes, success: success, failure: failure)
//                    }, failure: { () -> () in
//                        failure(error: error.toNSError())
//                    })
//                } else {
//                    failure(error: error.toNSError())
//                }            } else {
//                success()
//            }
//            }) { (operation, error) -> Void in
//                failure(error: error)
//        }
//    }
    
    func viewers(data: NSDictionary, success: (likes: UInt, viewers: UInt, users: [User]) -> (), failure: (error: NSError) -> ()) {
//        let streamId = data["streamId"] as! UInt
//        let path = ("stream/viewers" as NSString).stringByAppendingPathComponent("\(streamId)")
//        
//        let streamMapping = StreamMappingProvider.viewersResponseMapping()
//        let statusCode = RKStatusCodeIndexSetForClass(RKStatusCodeClass.Successful)
//        
//        let streamResponseDescriptor = RKResponseDescriptor(mapping: streamMapping, method: RKRequestMethod.GET, pathPattern: nil, keyPath: "data", statusCodes: statusCode)
//        
//        manager.addResponseDescriptor(streamResponseDescriptor)
//        
//        var params = self.sessionParams()
//        if let page: UInt = (data["p"] as? UInt) {
//            params!["p"] = page
//        }
//        
//        manager.getObjectsAtPath(path, parameters: params, success: { (operation, mappingResult) -> Void in
//            let error:Error = self.findErrorObject(mappingResult: mappingResult)!
//            if !error.status {
//                if error.code == Error.kLoginExpiredCode {
//                    self.relogin({ () -> () in
//                        self.viewers(data, success: success, failure: failure)
//                    }, failure: { () -> () in
//                        failure(error: error.toNSError())
//                    })
//                } else {
//                    failure(error: error.toNSError())
//                }            } else {
//                let data = mappingResult.dictionary()["data"] as! NSDictionary
//                let likes: UInt     = data["likes"] as! UInt
//                let viewers: UInt   = data["viewers"] as! UInt
//                let users:[User]    = data["users"] as! [User]
//                success(likes: likes, viewers: viewers, users: users)
//            }
//        }) { (operation, error) -> Void in
//            failure(error: error)
//        }
    }
    
    func replayViewers(data: NSDictionary, success: (likes: UInt, viewers: UInt, users: [User]) -> (), failure: (error: NSError) -> ()) {
//        let streamId = data["streamId"] as! UInt
//        let path = ("stream/rviewers" as NSString).stringByAppendingPathComponent("\(streamId)")
//        
//        let streamMapping = StreamMappingProvider.viewersResponseMapping()
//        let statusCode = RKStatusCodeIndexSetForClass(RKStatusCodeClass.Successful)
//        
//        let streamResponseDescriptor = RKResponseDescriptor(mapping: streamMapping, method: RKRequestMethod.GET, pathPattern: nil, keyPath: "data", statusCodes: statusCode)
//        
//        manager.addResponseDescriptor(streamResponseDescriptor)
//        
//        var params = self.sessionParams()
//        if let page: UInt = (data["p"] as? UInt) {
//            params!["p"] = page
//        }
//        
//        manager.getObjectsAtPath(path, parameters: params, success: { (operation, mappingResult) -> Void in
//            let error:Error = self.findErrorObject(mappingResult: mappingResult)!
//            if !error.status {
//                if error.code == Error.kLoginExpiredCode {
//                    self.relogin({ () -> () in
//                        self.replayViewers(data, success: success, failure: failure)
//                    }, failure: { () -> () in
//                        failure(error: error.toNSError())
//                    })
//                } else {
//                    failure(error: error.toNSError())
//                }            } else {
//                let data = mappingResult.dictionary()["data"] as! NSDictionary
//                let likes: UInt     = data["likes"] as! UInt
//                let viewers: UInt   = data["viewers"] as! UInt
//                let users:[User]    = data["users"] as! [User]
//                success(likes: likes, viewers: viewers, users: users)
//            }
//            }) { (operation, error) -> Void in
//                failure(error: error)
//        }
    }
    
    func get(streamId: UInt, success: (stream: Stream) -> (), failure: (error: NSError) -> ()) {
//        let path = ("stream" as NSString).stringByAppendingPathComponent("\(streamId)")
//        
//        let streamMapping = StreamMappingProvider.streamResponseMapping()
//        let statusCode = RKStatusCodeIndexSetForClass(RKStatusCodeClass.Successful)
//        
//        let streamResponseDescriptor = RKResponseDescriptor(mapping: streamMapping, method: RKRequestMethod.GET, pathPattern: nil, keyPath: "data", statusCodes: statusCode)
//        
//        manager.addResponseDescriptor(streamResponseDescriptor)
//        
//        manager.getObjectsAtPath(path, parameters: self.sessionParams(), success: { (operation, mappingResult) -> Void in
//            let error:Error = self.findErrorObject(mappingResult: mappingResult)!
//            if !error.status {
//                if error.code == Error.kLoginExpiredCode {
//                    self.relogin({ () -> () in
//                        self.get(streamId, success: success, failure: failure)
//                    }, failure: { () -> () in
//                        failure(error: error.toNSError())
//                    })
//                } else {
//                    failure(error: error.toNSError())
//                }            } else {
//                let stream = mappingResult.dictionary()["data"] as! Stream
//                success(stream: stream)
//            }
//            }) { (operation, error) -> Void in
//                failure(error: error)
//        }
    }
    
    func report(streamId: UInt, success: () -> (), failure: (error: NSError) -> ()) {
//        let path = "stream/report"
//        
//        var params = self.sessionParams()
//        params!["id"] = streamId
//        
//        manager.postObject(nil, path: path, parameters: params, success: { (operation, mappingResult) -> Void in
//            let error:Error = self.findErrorObject(mappingResult: mappingResult)!
//            if !error.status {
//                if error.code == Error.kLoginExpiredCode {
//                    self.relogin({ () -> () in
//                        self.report(streamId, success: success, failure: failure)
//                    }, failure: { () -> () in
//                        failure(error: error.toNSError())
//                    })
//                } else {
//                    failure(error: error.toNSError())
//                }            } else {
//                success()
//            }
//            }) { (operation, error) -> Void in
//                failure(error: error)
//        }
    }
    
    func share(streamId: UInt, usersId: [UInt]?, success: () -> (), failure: (error: NSError) -> ()) {
//        let path = "stream/share"
//        
//        var params = self.sessionParams()
//        params!["id"] = streamId
//        
//        if let users = usersId {
//            params!["users"] = users
//        }
//        
//        manager.postObject(nil, path: path, parameters: params, success: { (operation, mappingResult) -> Void in
//            let error:Error = self.findErrorObject(mappingResult: mappingResult)!
//            if !error.status {
//                if error.code == Error.kLoginExpiredCode {
//                    self.relogin({ () -> () in
//                        self.share(streamId, usersId: usersId, success: success, failure: failure)
//                    }, failure: { () -> () in
//                        failure(error: error.toNSError())
//                    })
//                } else {
//                    failure(error: error.toNSError())
//                }
//            } else {
//                success()
//            }
//            }) { (operation, error) -> Void in
//                failure(error: error)
//        }
    }
    
    func ping(streamId: UInt, success: () -> (), failure: (error: NSError) -> ()) {
//        let path = "stream/ping"
//        
//        var params = self.sessionParams()
//        params!["id"] = streamId
//        
//        manager.postObject(nil, path: path, parameters: params, success: { (operation, mappingResult) -> Void in
//            let error:Error = self.findErrorObject(mappingResult: mappingResult)!
//            if !error.status {
//                if error.code == Error.kLoginExpiredCode {
//                    self.relogin({ () -> () in
//                        self.ping(streamId, success: success, failure: failure)
//                    }, failure: { () -> () in
//                        failure(error: error.toNSError())
//                    })
//                } else {
//                    failure(error: error.toNSError())
//                }
//            } else {
//                success()
//            }
//            }) { (operation, error) -> Void in
//                failure(error: error)
//        }
        
        
    }
}
