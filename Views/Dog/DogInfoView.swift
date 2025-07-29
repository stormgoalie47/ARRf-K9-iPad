//
//  DogInfoView.swift
//  ARRf K9 iPad
//
//  Created by Addison Reed on 7/26/25.
//

import SwiftUI
import SwiftData

struct DogInfoView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var allTreats: [Treat]
    @State private var showingEditDog = false
    
    let dog: Dog
    let parent: Parent
    
    private var dogTreats: [Treat] {
        allTreats.filter { treat in
            treat.dogs.contains(dog)
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Dog Header
                VStack(alignment: .leading, spacing: 8) {
                    Text(dog.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text(dog.breed)
                        .font(.title2)
                        .foregroundColor(.secondary)
                    
                    HStack {
                        Text("Date of Birth: \(dog.dob, format: .dateTime.day().month().year())")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        if let color = dog.color, !color.isEmpty {
                            Text("Color: \(color)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .padding(.bottom)
                
                Divider()
                
                // Care Information
                if hasCareInfo() {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Care Information")
                            .font(.headline)
                        
                        if let feeding = dog.feeding, !feeding.isEmpty {
                            InfoRow(title: "Feeding Schedule", content: feeding)
                        }
                        
                        if let medications = dog.medications, !medications.isEmpty {
                            InfoRow(title: "Medications", content: medications)
                        }
                    }
                    .padding(.bottom)
                    
                    Divider()
                }
                
                // Training Notes
                if let trainingNotes = dog.trainingNotes, !trainingNotes.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Training Notes")
                            .font(.headline)
                        
                        Text(trainingNotes)
                            .font(.body)
                    }
                    .padding(.bottom)
                    
                    Divider()
                }
                
                // General Notes
                if let notes = dog.notes, !notes.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Notes")
                            .font(.headline)
                        
                        Text(notes)
                            .font(.body)
                    }
                    .padding(.bottom)
                    
                    Divider()
                }
                
                // Associated Treats
                VStack(alignment: .leading, spacing: 8) {
                    Text("Training Packages")
                        .font(.headline)
                    
                    if dogTreats.isEmpty {
                        Text("No training packages assigned yet...")
                            .foregroundColor(.secondary)
                            .italic()
                    } else {
                        LazyVStack(alignment: .leading, spacing: 8) {
                            ForEach(dogTreats, id: \.timestamp) { treat in
                                TreatRowView(treat: treat)
                            }
                        }
                    }
                }
                
                // Metadata
                VStack(alignment: .leading, spacing: 4) {
                    Text("Added: \(dog.dateAdded, format: .dateTime.day().month().year())")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    if let lastUpdated = dog.lastUpdated {
                        Text("Last Updated: \(lastUpdated, format: .dateTime.day().month().year())")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.top)
                
                Spacer(minLength: 100)
            }
            .padding()
        }
        .navigationTitle("Dog Details")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Edit") {
                    showingEditDog = true
                }
            }
        }
        .sheet(isPresented: $showingEditDog) {
            AddDogView(parent: parent, dog: dog)
        }
    }
    
    private func hasCareInfo() -> Bool {
        return (dog.feeding != nil && !dog.feeding!.isEmpty) ||
               (dog.medications != nil && !dog.medications!.isEmpty)
    }
}

struct InfoRow: View {
    let title: String
    let content: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
            
            Text(content)
                .font(.body)
        }
    }
}

#Preview {
    NavigationView {
        DogInfoView(
            dog: Dog(
                name: "Buddy",
                breed: "Golden Retriever",
                dob: Date(),
                color: "Golden",
                feeding: "2 cups twice daily",
                medications: "Heartgard monthly",
                trainingNotes: "Working on basic commands",
                notes: "Very friendly and energetic dog"
            ),
            parent: Parent(timestamp: Date(), firstName: "John", lastName: "Doe", notes: "Test parent")
        )
    }
    .modelContainer(for: Dog.self, inMemory: true)
} 