//
//  StreamMappingProvider.swift
//  Streamini
//
//  Created by Vasily Evreinov on 23/06/15.
//  Copyright (c) 2015 UniProgy s.r.o. All rights reserved.
//

import UIKit

class StreamMappingProvider: NSObject {
    
//    class func streamRequestMapping() -> RKObjectMapping {
//        let mapping = RKObjectMapping.requestMapping()
//        
//        mapping.addAttributeMappingsFromDictionary([
//            "id"            : "id",
//            "title"         : "title",
//            "streamHash"    : "hash",
//            "ended"         : "ended",
//            "viewers"       : "viewers",
//            "tviewers"      : "tviewers",
//            "rviewers"      : "rviewers",
//            "city"          : "city",
//            "lon"           : "lon",
//            "lat"           : "lat",
//            "likes"         : "likes",
//            "rlikes"        : "rlikes"
//        ])
//        
//        let userMapping = UserMappingProvider.userRequestMapping()
//        let userRelationshipMapping = RKRelationshipMapping(fromKeyPath: "user", toKeyPath: "user", withMapping: userMapping)
//        mapping.addPropertyMapping(userRelationshipMapping)
//        
//        return mapping
//    }
    
    class func streamResponseMapping(data: NSData?, app: String, channel: String) -> [Stream] {
        var streams = [Stream]()
        if(data == nil) {
            return streams
        }
        
        let dic: NSDictionary? = try!(NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableLeaves)) as! NSDictionary
        
        let streamsDic: NSDictionary? = dic![app]![channel] as? NSDictionary
        
        for key in streamsDic!.allKeys {
            print(key)
            let stream: Stream = Stream()
            stream.name = key as! String
            stream.channel = channel
            stream.address = streamsDic![key as! String]!["address"] as! String
            
            streams.append(stream)
        }
        //            print(dic["app"]!["live"])
//        data
//        
//        mapping.addAttributeMappingsFromDictionary([
//            "address"       : "address"
//        ])
//        
//        return mapping
        return streams
    }
    
    class func viewersResponseMapping() -> RKObjectMapping {
        let mapping = RKObjectMapping(forClass: NSMutableDictionary.self)
        mapping.addAttributeMappingsFromArray(["viewers", "likes"])
        
        let userMapping = UserMappingProvider.userResponseMapping()
        let userRelationshipMapping = RKRelationshipMapping(fromKeyPath: "users", toKeyPath: "users", withMapping: userMapping)
        mapping.addPropertyMapping(userRelationshipMapping)
        
        return mapping
    }
        
    class func createStreamRequestMapping() -> RKObjectMapping {
        let mapping = RKObjectMapping.requestMapping()
        mapping.addAttributeMappingsFromArray(["title", "lon", "lat", "city"])
        return mapping
    }    
}
