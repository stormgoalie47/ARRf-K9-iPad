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
        return Array(Set(parentDogs)) // Remove duplicates
    }
    
    @State private var selectedParents: Set<Parent> = []
    @State private var selectedDogs: Set<Dog> = []
    @State private var packageType = "Boarding"
    @State private var numberLessons = 10
    @State private var dateStarted: Date = Date()
    @State private var dateEnded: Date = Date()
    @State private var price = 0.0
    @State private var notes = ""
    @State private var hasStartDate = false
    @State private var hasEndDate = false
    
    private let treatToEdit: Treat?
    private let isEditing: Bool
    private let isParentLocked: Bool
    
    init(treat: Treat? = nil, defaultParent: Parent? = nil) {
        self.treatToEdit = treat
        self.isEditing = treat != nil
        self.isParentLocked = defaultParent != nil
        
        if let treat = treat {
            _selectedParents = State(initialValue: Set(treat.parents))
            _selectedDogs = State(initialValue: Set(treat.dogs))
            _packageType = State(initialValue: treat.packageType)
            _numberLessons = State(initialValue: treat.numberLessons)
            _price = State(initialValue: treat.price)
            _notes = State(initialValue: treat.notes ?? "")
            
            if let startDate = treat.dateStarted {
                _dateStarted = State(initialValue: startDate)
                _hasStartDate = State(initialValue: true)
            }
            if let endDate = treat.dateEnded {
                _dateEnded = State(initialValue: endDate)
                _hasEndDate = State(initialValue: true)
            }
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
                    DatePicker("Start Date", selection: $dateStarted, displayedComponents: .date)
                        .onChange(of: dateStarted) { _, newValue in
                            hasStartDate = true
                        }
                    
                    DatePicker("End Date", selection: $dateEnded, displayedComponents: .date)
                        .onChange(of: dateEnded) { _, newValue in
                            hasEndDate = true
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
                        Picker("Select Dogs", selection: $selectedDogs) {
                            Text("Select Dogs").tag(Set<Dog>())
                            ForEach(availableDogs) { dog in
                                Text("\(dog.Name) (\(dog.Breed))").tag(Set([dog]))
                            }
                        }
                        .pickerStyle(.menu)
                        
                        if !selectedDogs.isEmpty {
                            Text("Selected: \(selectedDogs.map { $0.Name }.joined(separator: ", "))")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                Section("Notes") {
                    TextField("Notes", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
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
        }
    }
    
    private func saveTreat() {
        if isEditing, let treat = treatToEdit {
            // Update existing treat
            treat.packageType = packageType.trimmingCharacters(in: .whitespaces)
            treat.numberLessons = numberLessons
            treat.price = price
            treat.notes = notes.trimmingCharacters(in: .whitespaces).isEmpty ? nil : notes.trimmingCharacters(in: .whitespaces)
            treat.dateStarted = hasStartDate ? dateStarted : nil
            treat.dateEnded = hasEndDate ? dateEnded : nil
            treat.parents = Array(selectedParents)
            treat.dogs = Array(selectedDogs)
            treat.lastUpdated = Date()
        } else {
            // Create new treat
            let newTreat = Treat(
                parents: Array(selectedParents),
                dogs: Array(selectedDogs),
                packageType: packageType.trimmingCharacters(in: .whitespaces),
                numberLessons: numberLessons,
                dateStarted: hasStartDate ? dateStarted : nil,
                dateEnded: hasEndDate ? dateEnded : nil,
                price: price,
                notes: notes.trimmingCharacters(in: .whitespaces).isEmpty ? nil : notes.trimmingCharacters(in: .whitespaces)
            )
            
            modelContext.insert(newTreat)
        }
        
        dismiss()
    }
}

#Preview {
    AddTreatView()
        .modelContainer(for: Treat.self, inMemory: true)
} 