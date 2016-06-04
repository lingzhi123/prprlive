//
//  StreamExtension.swift
//  Streamini
//
//  Created by Evghenii Todorov on 10/29/15.
//  Copyright © 2015 UniProgy s.r.o. All rights reserved.
//

import Foundation

extension Stream {
    
    func urlToStreamImage() -> NSURL {
        let (accessKeyId, _, _, imagesBucket) = Config.shared.amazon()
        let site = Config.shared.site()
        let string = accessKeyId == ""
            ? "\(site)/uploads/\(self.name)-screenshot.jpg"
            : "https://\(imagesBucket).s3.amazonaws.com/\(self.name)-screenshot.jpg"
        return NSURL(string: string)!
    }
    
}