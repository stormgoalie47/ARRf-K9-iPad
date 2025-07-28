//
//  DogInfoView.swift
//  ARRf K9 iPad
//
//  Created by Addison Reed on 7/26/25.
//

import SwiftUI
import SwiftData

struct DogInfoView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showingEditDog = false
    
    let dog: Dog
    let parent: Parent
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 16) {
                // Dog Header
                VStack(alignment: .leading, spacing: 8) {
                    Text(dog.Name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text(dog.Breed)
                        .font(.title2)
                        .foregroundColor(.secondary)
                    
                    Text("Date of Birth: \(dog.Dob, format: .dateTime.day().month().year())")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.bottom)
                
                Divider()
                
                // Notes Section
                if !dog.notes.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Notes")
                            .font(.headline)
                        
                        Text(dog.notes)
                            .font(.body)
                    }
                    .padding(.bottom)
                    
                    Divider()
                }
                
                // Associated Treats
                VStack(alignment: .leading, spacing: 8) {
                    Text("Training Packages")
                        .font(.headline)
                    
                    if let treats = getDogTreats() {
                        if treats.isEmpty {
                            Text("No training packages assigned yet...")
                                .foregroundColor(.secondary)
                                .italic()
                        } else {
                            LazyVStack(alignment: .leading, spacing: 8) {
                                ForEach(treats, id: \.timestamp) { treat in
                                    TreatRowView(treat: treat)
                                }
                            }
                        }
                    }
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Dog Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") {
                        dismiss()
                    }
                }
                
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
    }
    
    private func getDogTreats() -> [Treat]? {
        // This would need to be implemented based on your data model
        // For now, returning nil as a placeholder
        return nil
    }
}

#Preview {
    DogInfoView(
        dog: Dog(
            timestamp: Date(),
            Name: "Buddy",
            Breed: "Golden Retriever",
            Dob: Date(),
            notes: "Very friendly and energetic dog"
        ),
        parent: Parent(timestamp: Date(), firstName: "John", lastName: "Doe", notes: "Test parent")
    )
    .modelContainer(for: Dog.self, inMemory: true)
} 