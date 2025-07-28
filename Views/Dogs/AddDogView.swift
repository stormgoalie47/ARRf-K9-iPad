//
//  AddDogView.swift
//  ARRf K9 iPad
//
//  Created by Addison Reed on 7/26/25.
//

import SwiftUI
import SwiftData

struct AddDogView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var name = ""
    @State private var breed = ""
    @State private var dateOfBirth = Date()
    @State private var notes = ""
    
    private let parent: Parent
    private let dogToEdit: Dog?
    private let isEditing: Bool
    
    init(parent: Parent, dog: Dog? = nil) {
        self.parent = parent
        self.dogToEdit = dog
        self.isEditing = dog != nil
        
        if let dog = dog {
            _name = State(initialValue: dog.Name)
            _breed = State(initialValue: dog.Breed)
            _dateOfBirth = State(initialValue: dog.Dob)
            _notes = State(initialValue: dog.notes)
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section("Dog Information") {
                    TextField("Name", text: $name)
                    TextField("Breed", text: $breed)
                    DatePicker("Date of Birth", selection: $dateOfBirth, displayedComponents: .date)
                }
                
                Section("Notes") {
                    TextField("Notes", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                }
            }
            .navigationTitle(isEditing ? "Edit Dog" : "Add Dog")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveDog()
                    }
                    .disabled(name.isEmpty || breed.isEmpty)
                }
            }
        }
    }
    
    private func saveDog() {
        if isEditing, let dog = dogToEdit {
            // Update existing dog
            dog.Name = name.trimmingCharacters(in: .whitespaces)
            dog.Breed = breed.trimmingCharacters(in: .whitespaces)
            dog.Dob = dateOfBirth
            dog.notes = notes.trimmingCharacters(in: .whitespaces)
        } else {
            // Create new dog
            let newDog = Dog(
                timestamp: Date(),
                Name: name.trimmingCharacters(in: .whitespaces),
                Breed: breed.trimmingCharacters(in: .whitespaces),
                Dob: dateOfBirth,
                notes: notes.trimmingCharacters(in: .whitespaces)
            )
            
            // Add dog to parent
            parent.dogs.append(newDog)
        }
        
        dismiss()
    }
}

#Preview {
    AddDogView(parent: Parent(timestamp: Date(), firstName: "Test", lastName: "Parent", notes: "Test"))
        .modelContainer(for: Parent.self, inMemory: true)
} 