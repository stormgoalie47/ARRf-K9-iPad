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
    var name: String
    var resourceDescription: String?
    var url: String?
    var category: String
    var subcategory: String
    var location: String?
    var notes: String?
    
    init(name: String, category: String, subcategory: String, description: String? = nil, url: String? = nil, location: String? = nil, notes: String? = nil) {
        self.timestamp = Date()
        self.name = name
        self.resourceDescription = description
        self.url = url
        self.category = category
        self.subcategory = subcategory
        self.location = location
        self.notes = notes
    }
    
    // Category icon mapping
    var categoryIcon: String {
        switch category {
        case "Links":
            return "link.circle.fill"
        case "Parks":
            return "leaf.fill"
        case "Businesses":
            return "building.2.fill"
        case "Tools":
            return "wrench.and.screwdriver.fill"
        default:
            return "questionmark.circle.fill"
        }
    }
    
    // Check if category should show location field
    var shouldShowLocation: Bool {
        return category == "Businesses" || category == "Parks"
    }
}
