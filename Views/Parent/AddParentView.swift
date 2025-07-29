//
//  AddParentView.swift
//  ARRf K9 iPad
//
//  Created by Addison Reed on 7/26/25.
//

import SwiftUI
import SwiftData

struct AddParentView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var notes = ""
    @State private var showingDeleteAlert = false
    
    private let parentToEdit: Parent?
    private let isEditing: Bool
    
    init(parent: Parent? = nil) {
        self.parentToEdit = parent
        self.isEditing = parent != nil
        
        if let parent = parent {
            _firstName = State(initialValue: parent.firstName)
            _lastName = State(initialValue: parent.lastName)
            _notes = State(initialValue: parent.notes)
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section("Parent Information") {
                    TextField("First Name", text: $firstName)
                    TextField("Last Name", text: $lastName)
                }
                
                Section("Notes") {
                    TextField("Notes", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                }
                
                if isEditing {
                    Section {
                        Button("Delete Parent") {
                            showingDeleteAlert = true
                        }
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
            }
            .navigationTitle(isEditing ? "Edit Parent" : "Add Parent")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveParent()
                    }
                    .disabled(firstName.isEmpty || lastName.isEmpty)
                }
            }
            .alert("Delete Parent", isPresented: $showingDeleteAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    deleteParent()
                }
            } message: {
                Text("Are you sure you want to delete \(parentToEdit?.fullName ?? "this parent")? This will also delete all associated dogs and packages. This action cannot be undone.")
            }
        }
    }
    
    private func saveParent() {
        if isEditing, let parent = parentToEdit {
            // Update existing parent
            parent.firstName = firstName.trimmingCharacters(in: .whitespaces)
            parent.lastName = lastName.trimmingCharacters(in: .whitespaces)
            parent.notes = notes.trimmingCharacters(in: .whitespaces)
        } else {
            // Create new parent
            let newParent = Parent(
                timestamp: Date(),
                firstName: firstName.trimmingCharacters(in: .whitespaces),
                lastName: lastName.trimmingCharacters(in: .whitespaces),
                notes: notes.trimmingCharacters(in: .whitespaces)
            )
            modelContext.insert(newParent)
        }
        
        dismiss()
    }
    
    private func deleteParent() {
        if let parent = parentToEdit {
            modelContext.delete(parent)
            dismiss()
        }
    }
}

#Preview {
    AddParentView()
        .modelContainer(for: Parent.self, inMemory: true)
} 