//
//  Resource.swift
//  ARRf K9 iPad
//
//  Created by Addison Reed on 7/26/25.
//


import Foundation
import SwiftData

@Model
final class Resource {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
