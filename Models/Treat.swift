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
    var id: UUID
    var timestamp: Date
    var lastUpdated: Date?
    var parents: [Parent]
    var dogs: [Dog]
    var packageType: String
    var numberLessons: Int
    var purchaseDate: Date?
    var completionDate: Date?
    var lessonDates: [Date]
    var price: Double
    var completed: Bool
    var notes: String?
    
    init(id: UUID = UUID(), lastUpdated: Date? = nil, parents: [Parent], dogs: [Dog], packageType: String, numberLessons: Int, purchaseDate: Date? = nil, completionDate: Date? = nil, lessonDates: [Date] = [], price: Double, notes: String? = nil) {
        self.id = id
        self.timestamp = Date()
        self.lastUpdated = Date()
        self.parents = parents
        self.dogs = dogs
        self.packageType = packageType
        self.numberLessons = numberLessons
        self.purchaseDate = purchaseDate
        self.completionDate = completionDate
        self.lessonDates = lessonDates
        self.price = price
        self.completed = false
        self.notes = notes
    }
}
