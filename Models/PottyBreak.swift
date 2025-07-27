//
//  PottyBreak.swift
//  ARRf K9 iPad
//
//  Created by Addison Reed on 7/26/25.
//

import Foundation
import SwiftData

@Model
final class PottyBreak {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
