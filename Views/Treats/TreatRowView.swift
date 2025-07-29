//
//  TreatRowView.swift
//  ARRf K9 iPad
//
//  Created by Addison Reed on 7/26/25.
//

import SwiftUI
import SwiftData

struct TreatRowView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var allParents: [Parent]
    @Query private var allDogs: [Dog]
    
    let treat: Treat
    
    // Helper functions to get parent and dog information from reverse relationships
    private var displayParents: [Parent] {
        if !treat.parents.isEmpty {
            return treat.parents
        } else {
            // Find parents that have this treat in their treats array
            return allParents.filter { $0.treats.contains(treat) }
        }
    }
    
    private var displayDogs: [Dog] {
        if !treat.dogs.isEmpty {
            return treat.dogs
        } else {
            // Find dogs that have this treat in their packages array
            return allDogs.filter { $0.packages.contains(treat) }
        }
    }
    
    var body: some View {
        NavigationLink {
            TreatInfoView(treat: treat)
        } label: {
            HStack(spacing: 16) {
                // Package Type Icon
                Image(systemName: packageTypeIcon)
                    .font(.title2)
                    .foregroundColor(.blue)
                    .frame(width: 30)
                
                // Dog Name
                if !displayDogs.isEmpty {
                    Text(displayDogs.map { $0.name }.joined(separator: ", "))
                        .font(.title)
                        .frame(maxWidth: .infinity, alignment: .leading)
                } else {
                    Text("No Dogs")
                        .font(.title)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                // Parent Name
                if !displayParents.isEmpty {
                    Text(displayParents.map { $0.fullName }.joined(separator: ", "))
                        .font(.title)
                        .frame(maxWidth: .infinity, alignment: .leading)
                } else {
                    Text("No Parents")
                        .font(.title)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                // Lessons Remaining
                Text("\(remainingLessons)/\(treat.numberLessons)")
                    .font(.title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                // Status Badge
                Text(treat.completed ? "Completed" : "Active")
                    .font(.title)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(treat.completed ? Color.green : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(4)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    // Helper computed property for package type icon
    private var packageTypeIcon: String {
        switch treat.packageType {
        case "Boarding":
            return "house.fill"
        case "B&T":
            return "person.2.fill"
        case "Day Camp":
            return "sun.max.fill"
        case "House Call":
            return "car.fill"
        default:
            return "shippingbox.fill"
        }
    }
    
    // Helper computed property for remaining lessons
    private var remainingLessons: Int {
        let completedLessons = treat.lessonDates.filter { $0 <= Date() }.count
        return max(0, treat.numberLessons - completedLessons)
    }
}

#Preview {
    TreatRowView(
        treat: Treat(
            parents: [],
            dogs: [],
            packageType: "Boarding",
            numberLessons: 10,
            price: 1000.0,
            notes: "Test treat"
        )
    )
    .modelContainer(for: Treat.self, inMemory: true)
} 
