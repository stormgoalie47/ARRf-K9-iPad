//
//  AddTreatView.swift
//  ARRf K9 iPad
//
//  Created by Addison Reed on 7/26/25.
//

import SwiftUI
import SwiftData

struct AddTreatView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @Query private var allParents: [Parent]
    @Query private var allDogs: [Dog]
    
    private var availableDogs: [Dog] {
        // Get all dogs that belong to the selected parents
        let parentDogs = selectedParents.flatMap { $0.dogs }
        
        // If no dogs found from selected parents, try to get from all parents
        if parentDogs.isEmpty {
            return allDogs
        }
        
        return Array(Set(parentDogs)) // Remove duplicates
    }
    
    @State private var selectedParents: Set<Parent> = []
    @State private var selectedDogs: Set<Dog> = []
    @State private var packageType = "Boarding"
    @State private var numberLessons = 10
    @State private var purchaseDate: Date = Date()
    @State private var completionDate: Date = Date()
    @State private var price = 0.0
    @State private var notes = ""
    @State private var hasPurchaseDate = false
    @State private var hasCompletionDate = false
    @State private var showingDeleteAlert = false
    
    private let treatToEdit: Treat?
    private let isEditing: Bool
    private let isParentLocked: Bool
    
    init(treat: Treat? = nil, defaultParent: Parent? = nil) {
        self.treatToEdit = treat
        self.isEditing = treat != nil
        self.isParentLocked = defaultParent != nil
        
        if let treat = treat {
            // Try to get parents and dogs from forward relationships first
            var initialParents = Set(treat.parents)
            var initialDogs = Set(treat.dogs)
            
            // If forward relationships are empty, try to get from reverse relationships
            if initialParents.isEmpty {
                let reverseParents = allParents.filter { $0.treats.contains(treat) }
                initialParents = Set(reverseParents)
                print("🔧 Using reverse relationships for parents: \(reverseParents.map { $0.fullName })")
            }
            
            if initialDogs.isEmpty {
                let reverseDogs = allDogs.filter { $0.packages.contains(treat) }
                initialDogs = Set(reverseDogs)
                print("🔧 Using reverse relationships for dogs: \(reverseDogs.map { $0.name })")
            }
            
            _selectedParents = State(initialValue: initialParents)
            _selectedDogs = State(initialValue: initialDogs)
            _packageType = State(initialValue: treat.packageType)
            _numberLessons = State(initialValue: treat.numberLessons)
            _price = State(initialValue: treat.price)
            _notes = State(initialValue: treat.notes ?? "")
            
            if let purchaseDate = treat.purchaseDate {
                _purchaseDate = State(initialValue: purchaseDate)
                _hasPurchaseDate = State(initialValue: true)
            }
            if let completionDate = treat.completionDate {
                _completionDate = State(initialValue: completionDate)
                _hasCompletionDate = State(initialValue: true)
            }
            // Note: lessonDates are managed in TreatInfoView, not in AddTreatView
        } else if let defaultParent = defaultParent {
            // Set default parent when creating new treat
            _selectedParents = State(initialValue: [defaultParent])
            
            // Auto-select the newest dog from the default parent
            if let newestDog = defaultParent.dogs.max(by: { $0.timestamp < $1.timestamp }) {
                _selectedDogs = State(initialValue: [newestDog])
            }
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section("Package Information") {
                    Picker("Package Type", selection: $packageType) {
                        Text("Boarding").tag("Boarding")
                        Text("B&T").tag("B&T")
                        Text("Day Camp").tag("Day Camp")
                        Text("House Call").tag("House Call")
                    }
                    .pickerStyle(.menu)
                    
                    HStack {
                        Text("Number of Lessons:")
                        TextField("Lessons", value: $numberLessons, format: .number)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.trailing)
                    }
                    
                    HStack {
                        Text("Price:")
                        TextField("Price", value: $price, format: .currency(code: "USD"))
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                }
                
                Section("Dates") {
                    DatePicker("Purchase Date", selection: $purchaseDate, displayedComponents: .date)
                        .onChange(of: purchaseDate) { _, newValue in
                            hasPurchaseDate = true
                        }
                    
                    DatePicker("Completion Date", selection: $completionDate, displayedComponents: .date)
                        .onChange(of: completionDate) { _, newValue in
                            hasCompletionDate = true
                        }
                }
                
                Section("Parents") {
                    if isParentLocked {
                        // Show locked parent info
                        if let lockedParent = selectedParents.first {
                            HStack {
                                Text(lockedParent.fullName)
                                    .font(.headline)
                                Spacer()
                                Text("(Locked)")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    } else {
                        // Allow parent selection
                        ForEach(allParents) { parent in
                            HStack {
                                Text(parent.fullName)
                                Spacer()
                                if selectedParents.contains(parent) {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.blue)
                                }
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                if selectedParents.contains(parent) {
                                    selectedParents.remove(parent)
                                } else {
                                    selectedParents.insert(parent)
                                }
                            }
                        }
                    }
                }
                
                Section("Dogs") {
                    if availableDogs.isEmpty {
                        Text("No dogs available for selected parent(s)")
                            .foregroundColor(.secondary)
                            .italic()
                    } else {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Select Dogs:")
                                .font(.headline)
                            
                            ForEach(availableDogs) { dog in
                                HStack {
                                    Button(action: {
                                        if selectedDogs.contains(dog) {
                                            selectedDogs.remove(dog)
                                        } else {
                                            selectedDogs.insert(dog)
                                        }
                                    }) {
                                        HStack {
                                            Image(systemName: selectedDogs.contains(dog) ? "checkmark.circle.fill" : "circle")
                                                .foregroundColor(selectedDogs.contains(dog) ? .blue : .gray)
                                            
                                            VStack(alignment: .leading, spacing: 2) {
                                                Text(dog.name)
                                                    .font(.body)
                                                    .fontWeight(.medium)
                                                
                                                Text(dog.breed)
                                                    .font(.caption)
                                                    .foregroundColor(.secondary)
                                            }
                                            
                                            Spacer()
                                        }
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                                .padding(.vertical, 4)
                            }
                        }
                        
                        if !selectedDogs.isEmpty {
                            Text("Selected: \(selectedDogs.map { $0.name }.joined(separator: ", "))")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .padding(.top, 4)
                        }
                    }
                }
                
                Section("Notes") {
                    TextField("Notes", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                }
                
                if isEditing {
                    Section {
                        Button("Delete Package") {
                            showingDeleteAlert = true
                        }
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
            }
            .navigationTitle(isEditing ? "Edit Treat" : "Add Treat")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveTreat()
                    }
                    .disabled((!isParentLocked && selectedParents.isEmpty) || selectedDogs.isEmpty || availableDogs.isEmpty)
                }
            }
            .alert("Delete Package", isPresented: $showingDeleteAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Delete", role: .destructive) {
                    deleteTreat()
                }
            } message: {
                Text("Are you sure you want to delete this \(treatToEdit?.packageType ?? "package")? This action cannot be undone.")
            }
        }
    }
    
    private func saveTreat() {
        // Debug output
        print("💾 Starting saveTreat()")
        print("   Selected parents: \(selectedParents.map { $0.fullName })")
        print("   Selected dogs: \(selectedDogs.map { $0.name })")
        
        // Check existing treats before saving
        if let parent = selectedParents.first {
            print("   📊 Existing treats for \(parent.fullName) before save:")
            for treat in parent.treats {
                print("     - \(treat.packageType) (ID: \(treat.id)): \(treat.parents.count) parents, \(treat.dogs.count) dogs")
                print("       Parents: \(treat.parents.map { $0.fullName })")
                print("       Dogs: \(treat.dogs.map { $0.name })")
            }
        }
        
        if isEditing, let treat = treatToEdit {
            // Update existing treat
            treat.packageType = packageType.trimmingCharacters(in: .whitespaces)
            treat.numberLessons = numberLessons
            treat.price = price
            treat.notes = notes.trimmingCharacters(in: .whitespaces).isEmpty ? nil : notes.trimmingCharacters(in: .whitespaces)
            treat.purchaseDate = hasPurchaseDate ? purchaseDate : nil
            treat.completionDate = hasCompletionDate ? completionDate : nil
            treat.parents = Array(selectedParents)
            treat.dogs = Array(selectedDogs)
            treat.lastUpdated = Date()
            
            print("   🔄 Updated existing treat: \(treat.packageType) (ID: \(treat.id))")
            
            // Update reverse relationships
            for parent in selectedParents {
                if !parent.treats.contains(treat) {
                    parent.treats.append(treat)
                    print("   🔗 Added treat to parent: \(parent.fullName)")
                }
            }
            for dog in selectedDogs {
                if !dog.packages.contains(treat) {
                    dog.packages.append(treat)
                    print("   🔗 Added treat to dog: \(dog.name)")
                }
            }
        } else {
            // Create new treat
            let newTreat = Treat(
                parents: [],  // Start with empty arrays
                dogs: [],
                packageType: packageType.trimmingCharacters(in: .whitespaces),
                numberLessons: numberLessons,
                purchaseDate: hasPurchaseDate ? purchaseDate : nil,
                completionDate: hasCompletionDate ? completionDate : nil,
                price: price,
                notes: notes.trimmingCharacters(in: .whitespaces).isEmpty ? nil : notes.trimmingCharacters(in: .whitespaces)
            )
            
            modelContext.insert(newTreat)
            print("   🆕 Created new treat: \(newTreat.packageType) (ID: \(newTreat.id))")
            
            // Explicitly set both sides of the relationship
            newTreat.parents = Array(selectedParents)
            newTreat.dogs = Array(selectedDogs)
            
            // Update reverse relationships
            for parent in selectedParents {
                parent.treats.append(newTreat)
                print("   🔗 Added treat to parent: \(parent.fullName)")
            }
            for dog in selectedDogs {
                dog.packages.append(newTreat)
                print("   🔗 Added treat to dog: \(dog.name)")
            }
        }
        
        // Explicitly save the context
        do {
            try modelContext.save()
            print("   💾 Context saved successfully")
            
            // Refresh existing treats to ensure their relationships are maintained
            if let parent = selectedParents.first {
                print("   🔄 Refreshing existing treats...")
                for treat in parent.treats {
                    // Re-establish the forward relationships for existing treats
                    if treat.parents.isEmpty && !parent.treats.isEmpty {
                        treat.parents = [parent]
                        print("   🔧 Fixed parent relationship for \(treat.packageType)")
                    }
                    if treat.dogs.isEmpty && !parent.dogs.isEmpty {
                        treat.dogs = parent.dogs
                        print("   🔧 Fixed dog relationships for \(treat.packageType)")
                    }
                }
                
                // Save again after fixing relationships
                try modelContext.save()
                print("   💾 Context saved again after fixing relationships")
            }
            
            // Check existing treats after saving
            if let parent = selectedParents.first {
                print("   📊 Existing treats for \(parent.fullName) after save:")
                for treat in parent.treats {
                    print("     - \(treat.packageType) (ID: \(treat.id)): \(treat.parents.count) parents, \(treat.dogs.count) dogs")
                    print("       Parents: \(treat.parents.map { $0.fullName })")
                    print("       Dogs: \(treat.dogs.map { $0.name })")
                }
            }
        } catch {
            print("   ❌ Error saving context: \(error)")
        }
        
        print("   ✅ saveTreat() completed")
        dismiss()
    }
    
    private func deleteTreat() {
        if let treat = treatToEdit {
            print("🗑️ Deleting treat: \(treat.packageType) (ID: \(treat.id))")
            
            // Remove from all parent's treats arrays
            for parent in treat.parents {
                parent.treats.removeAll { $0.id == treat.id }
                print("   🗑️ Removed from parent: \(parent.fullName)")
            }
            
            // Remove from all dog's packages arrays
            for dog in treat.dogs {
                dog.packages.removeAll { $0.id == treat.id }
                print("   🗑️ Removed from dog: \(dog.name)")
            }
            
            // Delete the treat
            modelContext.delete(treat)
            
            // Save the context
            do {
                try modelContext.save()
                print("   💾 Context saved after deletion")
            } catch {
                print("   ❌ Error saving context after deletion: \(error)")
            }
            
            dismiss()
        }
    }
}

#Preview {
    AddTreatView()
        .modelContainer(for: Treat.self, inMemory: true)
} 