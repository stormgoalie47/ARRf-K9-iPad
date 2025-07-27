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
    var Name: String
    var Breed: String
    var Dob: Date
    var notes: String

    init(timestamp: Date, Name: String, Breed: String, Dob: Date, notes: String) {
        self.timestamp = timestamp
        self.Name = Name
        self.Breed = Breed
        self.Dob = Dob
        self.notes = notes
    }
}
