//
//  Stream.swift
//  Streamini
//
//  Created by Vasily Evreinov on 23/06/15.
//  Copyright (c) 2015 UniProgy s.r.o. All rights reserved.
//

import UIKit

class Stream: NSObject {
    var channel = ""
    var name = ""
    var address = ""
    var bw_real = ""
    var flashver = ""
    var bw_in = ""
    var video: Video = Video()
    var audio: Audio = Audio()
}
