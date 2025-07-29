//
//  TreatRowMinimalView.swift
//  ARRf K9 iPad
//
//  Created by Addison Reed on 7/29/25.
//

//
//  TreatRowView.swift
//  ARRf K9 iPad
//
//  Created by Addison Reed on 7/26/25.
//

import SwiftUI
import SwiftData

struct TreatRowMinimalView: View {
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
            HStack() {
                Spacer()
                // Package Type Icon
                Image(systemName: packageTypeIcon)
                    .font(.title2)
                    .foregroundColor(.blue)
                    .frame(width: 30)
                
                Spacer()
                // Dog Name
                if !displayDogs.isEmpty {
                    Text(displayDogs.map { $0.name }.joined(separator: ", "))
                        .font(.title)
                } else {
                    Text("No Dogs")
                        .font(.title)
                }
                
                Spacer()
                // Lessons Remaining
                Text("\(remainingLessons)/\(treat.numberLessons)")
                    .font(.title)
                
                Spacer()
                // Status Badge
                Text(treat.completed ? "Completed" : "Active")
                    .font(.title)
                    .background(treat.completed ? Color.green : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(4)
                Spacer()
            }
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
