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
    var id: UUID
    var timestamp: Date
    var firstName: String
    var lastName: String
    var notes: String
    var dogs: [Dog]
    var treats: [Treat]

    init(id: UUID = UUID(), timestamp: Date, firstName: String, lastName: String, notes: String) {
        self.id = id
        self.timestamp = timestamp
        self.firstName = firstName
        self.lastName = lastName
        self.notes = notes
        self.dogs = []
        self.treats = []
    }
    
    var fullName: String {
        "\(firstName) \(lastName)".trimmingCharacters(in: .whitespaces)
    }
}
