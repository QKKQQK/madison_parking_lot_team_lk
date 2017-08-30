//
//  PakingInfo.swift
//  mapApp
//
//  Created by Lijie Zhao on 8/29/17.
//  Copyright © 2017 team_lk. All rights reserved.
//

import Foundation

public struct PakingInfo: Codable, CustomStringConvertible {
    var name: String
    var id: Int
    var vacant_stalls: Int
    var url: URL
    
    public var description: String {
        return "\(name) \n \(id) \n \(vacant_stalls) \n \(url) \n"
    }
}
