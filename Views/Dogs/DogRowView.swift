//
//  DogRowView.swift
//  ARRf K9 iPad
//
//  Created by Addison Reed on 7/26/25.
//

import SwiftUI
import SwiftData

struct DogRowView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var showingEditDog = false
    
    let dog: Dog
    let parent: Parent
    
    var body: some View {
        NavigationLink {
            DogInfoView(dog: dog, parent: parent)
        } label: {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Spacer()
                VStack(alignment: .leading, spacing: 2) {
                        Text(dog.name)
                        .font(.headline)
                        .fontWeight(.semibold)
                            .foregroundColor(.primary)
                    
                        HStack {
                            Text(dog.breed)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                            if let color = dog.color, !color.isEmpty {
                                Text("• \(color)")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        Text("DOB: \(dog.dob, format: .dateTime.day().month().year())")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                Spacer()
            }
            
                // Show care info if available
                if hasCareInfo() {
                    HStack {
                        Spacer()
                        if let feeding = dog.feeding, !feeding.isEmpty {
                            Label(feeding, systemImage: "cup.and.saucer")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
                        if let medications = dog.medications, !medications.isEmpty {
                            Label(medications, systemImage: "pills")
                    .font(.caption)
                    .foregroundColor(.secondary)
                        }
                        Spacer()
                    }
                    .padding(.top, 2)
            }
                
                if let notes = dog.notes, !notes.isEmpty {
                    HStack {
                        Spacer()
                        Text(notes)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .padding(.top, 2)
                        Spacer()
                    }
                }
        }
        .padding(.vertical, 4)
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $showingEditDog) {
            AddDogView(parent: parent, dog: dog)
        }
        }
    
    private func hasCareInfo() -> Bool {
        return (dog.feeding != nil && !dog.feeding!.isEmpty) ||
               (dog.medications != nil && !dog.medications!.isEmpty)
    }
}

#Preview {
    DogRowView(
        dog: Dog(
            name: "Buddy",
            breed: "Golden Retriever",
            dob: Date(),
            color: "Golden",
            feeding: "2 cups twice daily",
            medications: "Heartgard monthly",
            notes: "Very friendly dog"
        ),
        parent: Parent(timestamp: Date(), firstName: "John", lastName: "Doe", notes: "Test parent")
    )
    .modelContainer(for: Parent.self, inMemory: true)
} 
