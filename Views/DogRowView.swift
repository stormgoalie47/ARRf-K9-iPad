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
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(dog.Name)
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text(dog.Breed)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Text("DOB: \(dog.Dob, format: .dateTime.day().month().year())")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Button("Edit") {
                    showingEditDog = true
                }
                .buttonStyle(.bordered)
                .controlSize(.small)
            }
            
            if !dog.notes.isEmpty {
                Text(dog.notes)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.top, 2)
            }
        }
        .padding(.vertical, 4)
        .sheet(isPresented: $showingEditDog) {
            AddDogView(parent: parent, dog: dog)
        }
    }
}

#Preview {
    DogRowView(
        dog: Dog(
            timestamp: Date(),
            Name: "Buddy",
            Breed: "Golden Retriever",
            Dob: Date(),
            notes: "Very friendly dog"
        ),
        parent: Parent(timestamp: Date(), firstName: "John", lastName: "Doe", notes: "Test parent")
    )
    .modelContainer(for: Parent.self, inMemory: true)
} 