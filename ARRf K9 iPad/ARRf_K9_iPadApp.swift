//
//  ARRf_K9_iPadApp.swift
//  ARRf K9 iPad
//
//  Created by Addison Reed on 7/26/25.
//

import SwiftUI
import SwiftData

@main
struct ARRf_K9_iPadApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Parent.self,
            Treat.self,
            PottyBreak.self,
            Resource.self,
            Dog.self
        ])
        let modelConfiguration = ModelConfiguration(
            schema: schema, 
            isStoredInMemoryOnly: true
        )

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    #if DEBUG
                    createSampleData()
                    #endif
                }
        }
        .modelContainer(sharedModelContainer)
    }
    
    private func createSampleData() {
        let context = sharedModelContainer.mainContext
        
        // Check if sample data already exists
        let existingParents = try? context.fetch(FetchDescriptor<Parent>())
        if let existingParents = existingParents, !existingParents.isEmpty {
            return // Sample data already exists
        }
        
        // Create sample parent
        let sampleParent = Parent(
            timestamp: Date(),
            firstName: "John",
            lastName: "Smith",
            notes: "Sample parent for testing purposes"
        )
        
        // Create sample dog
        let sampleDog = Dog(
            name: "Buddy",
            breed: "Golden Retriever",
            dob: Calendar.current.date(byAdding: .year, value: -2, to: Date()) ?? Date(),
            parent: sampleParent,
            color: "Golden",
            feeding: "2 cups twice daily",
            medications: "Heartgard monthly",
            trainingNotes: "Working on basic commands and leash training",
            notes: "Very friendly and energetic dog. Loves playing fetch and going for walks."
        )
        
        // Add dog to parent
        sampleParent.dogs.append(sampleDog)
        
        // Create sample treat/package
        let sampleTreat = Treat(
            parents: [sampleParent],
            dogs: [sampleDog],
            packageType: "Boarding",
            numberLessons: 10,
            purchaseDate: Calendar.current.date(byAdding: .day, value: -30, to: Date()),
            lessonDates: [
                Calendar.current.date(byAdding: .day, value: -25, to: Date()) ?? Date(),
                Calendar.current.date(byAdding: .day, value: -18, to: Date()) ?? Date(),
                Calendar.current.date(byAdding: .day, value: -11, to: Date()) ?? Date(),
                Calendar.current.date(byAdding: .day, value: -4, to: Date()) ?? Date(),
                Calendar.current.date(byAdding: .day, value: 3, to: Date()) ?? Date(),
                Calendar.current.date(byAdding: .day, value: 10, to: Date()) ?? Date()
            ],
            price: 1200.0,
            notes: "Sample training package for demonstration"
        )
        
        // Set up bidirectional relationships
        sampleParent.treats.append(sampleTreat)
        sampleDog.packages.append(sampleTreat)
        
        print("📊 Sample data relationships:")
        print("   Parent: \(sampleParent.fullName) (ID: \(sampleParent.id))")
        print("   Parent treats count: \(sampleParent.treats.count)")
        print("   Dog: \(sampleDog.name) (ID: \(sampleDog.id))")
        print("   Dog packages count: \(sampleDog.packages.count)")
        print("   Treat: \(sampleTreat.packageType) (ID: \(sampleTreat.id))")
        print("   Treat parents count: \(sampleTreat.parents.count)")
        print("   Treat dogs count: \(sampleTreat.dogs.count)")
        
        // Save to context
        context.insert(sampleParent)
        context.insert(sampleDog)
        context.insert(sampleTreat)
        
        do {
            try context.save()
            print("✅ Sample data created successfully!")
            
            // Verify relationships after save
            print("📊 After save verification:")
            print("   Parent treats count: \(sampleParent.treats.count)")
            print("   Dog packages count: \(sampleDog.packages.count)")
            print("   Treat parents count: \(sampleTreat.parents.count)")
            print("   Treat dogs count: \(sampleTreat.dogs.count)")
        } catch {
            print("❌ Failed to create sample data: \(error)")
        }
    }
}
