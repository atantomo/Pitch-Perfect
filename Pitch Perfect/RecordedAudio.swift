//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Tantomo, Andrew | Andrew | ISDOD on 1/13/16.
//  Copyright © 2016 Rakuten. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject{
    var filePathUrl: NSURL!
    var title: String!
    
    init(fromUrl url: NSURL) {
        filePathUrl = url
        title = url.lastPathComponent

    }
    
}