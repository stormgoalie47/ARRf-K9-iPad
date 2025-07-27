//
//  Item.swift
//  ARRf K9 iPad
//
//  Created by Addison Reed on 7/26/25.
//

import Foundation
import SwiftData

@Model
final class Parent {
    var timestamp: Date
    var firstName: String
    var lastName: String
    var notes: String
    var dogs: [Dog]

    init(timestamp: Date, firstName: String, lastName: String, notes: String) {
        self.timestamp = timestamp
        self.firstName = firstName
        self.lastName = lastName
        self.notes = notes
        self.dogs = []
    }
    
    var fullName: String {
        "\(firstName) \(lastName)".trimmingCharacters(in: .whitespaces)
    }
}
