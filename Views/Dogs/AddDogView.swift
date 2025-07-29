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
    @State private var color = ""
    @State private var feeding = ""
    @State private var medications = ""
    @State private var trainingNotes = ""
    @State private var notes = ""
    @State private var showingDeleteAlert = false
    
    private let parent: Parent
    private let dogToEdit: Dog?
    private let isEditing: Bool
    
    init(parent: Parent, dog: Dog? = nil) {
        self.parent = parent
        self.dogToEdit = dog
        self.isEditing = dog != nil
        
        if let dog = dog {
            _name = State(initialValue: dog.name)
            _breed = State(initialValue: dog.breed)
            _dateOfBirth = State(initialValue: dog.dob)
            _color = State(initialValue: dog.color ?? "")
            _feeding = State(initialValue: dog.feeding ?? "")
            _medications = State(initialValue: dog.medications ?? "")
            _trainingNotes = State(initialValue: dog.trainingNotes ?? "")
            _notes = State(initialValue: dog.notes ?? "")
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section("Basic Information") {
                    TextField("Name", text: $name)
                    TextField("Breed", text: $breed)
                    DatePicker("Date of Birth", selection: $dateOfBirth, displayedComponents: .date)
                    TextField("Color", text: $color)
                }
                
                Section("Care Information") {
                    TextField("Feeding Schedule", text: $feeding, axis: .vertical)
                        .lineLimit(2...4)
                    TextField("Medications", text: $medications, axis: .vertical)
                        .lineLimit(2...4)
                }
                
                Section("Training & Notes") {
                    TextField("Training Notes", text: $trainingNotes, axis: .vertical)
                        .lineLimit(3...6)
                    TextField("General Notes", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                }
                
                if isEditing {
                    Section {
                        Button("Delete Dog") {
                            showingDeleteAlert = true
                        }
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
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
            .alert("Delete Dog", isPresented: $showingDeleteAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    deleteDog()
                }
            } message: {
                Text("Are you sure you want to delete \(dogToEdit?.name ?? "this dog")? This action cannot be undone.")
            }
        }
    }
    
    private func saveDog() {
        if isEditing, let dog = dogToEdit {
            // Update existing dog
            dog.name = name.trimmingCharacters(in: .whitespaces)
            dog.breed = breed.trimmingCharacters(in: .whitespaces)
            dog.dob = dateOfBirth
            dog.color = color.trimmingCharacters(in: .whitespaces).isEmpty ? nil : color.trimmingCharacters(in: .whitespaces)
            dog.feeding = feeding.trimmingCharacters(in: .whitespaces).isEmpty ? nil : feeding.trimmingCharacters(in: .whitespaces)
            dog.medications = medications.trimmingCharacters(in: .whitespaces).isEmpty ? nil : medications.trimmingCharacters(in: .whitespaces)
            dog.trainingNotes = trainingNotes.trimmingCharacters(in: .whitespaces).isEmpty ? nil : trainingNotes.trimmingCharacters(in: .whitespaces)
            dog.notes = notes.trimmingCharacters(in: .whitespaces).isEmpty ? nil : notes.trimmingCharacters(in: .whitespaces)
            dog.lastUpdated = Date()
        } else {
            // Create new dog
            let newDog = Dog(
                name: name.trimmingCharacters(in: .whitespaces),
                breed: breed.trimmingCharacters(in: .whitespaces),
                dob: dateOfBirth,
                parent: parent,
                color: color.trimmingCharacters(in: .whitespaces).isEmpty ? nil : color.trimmingCharacters(in: .whitespaces),
                feeding: feeding.trimmingCharacters(in: .whitespaces).isEmpty ? nil : feeding.trimmingCharacters(in: .whitespaces),
                medications: medications.trimmingCharacters(in: .whitespaces).isEmpty ? nil : medications.trimmingCharacters(in: .whitespaces),
                trainingNotes: trainingNotes.trimmingCharacters(in: .whitespaces).isEmpty ? nil : trainingNotes.trimmingCharacters(in: .whitespaces),
                notes: notes.trimmingCharacters(in: .whitespaces).isEmpty ? nil : notes.trimmingCharacters(in: .whitespaces)
            )
            
            // Add dog to parent
            parent.dogs.append(newDog)
        }
        
        dismiss()
    }
    
    private func deleteDog() {
        if let dog = dogToEdit {
            modelContext.delete(dog)
            dismiss()
        }
    }
}

#Preview {
    AddDogView(parent: Parent(timestamp: Date(), firstName: "Test", lastName: "Parent", notes: "Test"))
        .modelContainer(for: Parent.self, inMemory: true)
} 