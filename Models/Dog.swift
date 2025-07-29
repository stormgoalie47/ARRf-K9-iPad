//
//  Dog.swift
//  ARRf K9 iPad
//
//  Created by Addison Reed on 7/26/25.
//

import Foundation
import SwiftData

@Model
final class Dog {
    var timestamp: Date
    var name: String
    var breed: String
    var parent: Parent?
    var dob: Date
    var color: String?
    var feeding: String?
    var medications: String?
    var trainingNotes: String?
    var notes: String?
    var packages: [Treat]
    var dateAdded: Date
    var lastUpdated: Date?
    
    init(name: String, breed: String, dob: Date, parent: Parent? = nil, color: String? = nil, feeding: String? = nil, medications: String? = nil, trainingNotes: String? = nil, notes: String? = nil) {
        self.timestamp = Date()
        self.name = name
        self.breed = breed
        self.parent = parent
        self.dob = dob
        self.color = color
        self.feeding = feeding
        self.medications = medications
        self.trainingNotes = trainingNotes
        self.notes = notes
        self.packages = []
        self.dateAdded = Date()
        self.lastUpdated = nil
    }
}
