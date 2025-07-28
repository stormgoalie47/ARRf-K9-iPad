//
//  Treat.swift
//  ARRf K9 iPad
//
//  Created by Addison Reed on 7/26/25.
//

import Foundation
import SwiftData

@Model
final class Treat {
    var timestamp: Date
    var lastUpdated: Date?
    var parents: [Parent]
    var dogs: [Dog]
    var packageType: String
    var numberLessons: Int
    var dateStarted: Date?
    var dateEnded: Date?
    var price: Double
    var completed: Bool
    var notes: String?
    
    init(lastUpdated: Date? = nil, parents: [Parent], dogs: [Dog], packageType: String, numberLessons: Int, dateStarted: Date? = nil, dateEnded: Date? = nil, price: Double, notes: String? = nil) {
        self.timestamp = Date()
        self.lastUpdated = Date()
        self.parents = parents
        self.dogs = dogs
        self.packageType = packageType
        self.numberLessons = numberLessons
        self.dateStarted = dateStarted
        self.dateEnded = dateEnded
        self.price = price
        self.completed = false
        self.notes = notes
    }
}
