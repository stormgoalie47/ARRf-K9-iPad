//
//  AddResourceView.swift
//  ARRf K9 iPad
//
//  Created by Addison Reed on 7/26/25.
//

import SwiftUI
import SwiftData

struct AddResourceView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    let resource: Resource?
    
    @State private var name = ""
    @State private var description = ""
    @State private var url = ""
    @State private var location = ""
    @State private var notes = ""
    @State private var selectedCategory = "Links"
    @State private var selectedSubcategory = "ARRf K9"
    
    // Define categories and subcategories
    private let categories = [
        ("Links", ["ARRf K9", "Client Handouts", "Reviews"]),
        ("Parks", []),
        ("Businesses", ["The Best!", "Rescues", "Pet Supplies", "Grooming", "Others"]),
        ("Tools", ["Collars", "E-Collars", "Leashes", "Enrichment", "Exercise", "Apparel", "Other"])
    ]
    
    private var availableSubcategories: [String] {
        return categories.first { $0.0 == selectedCategory }?.1 ?? []
    }
    
    private var isFormValid: Bool {
        let hasValidName = !name.trimmingCharacters(in: .whitespaces).isEmpty
        let hasValidCategory = !selectedCategory.isEmpty
        
        // For categories with subcategories, require subcategory selection
        // For categories without subcategories (like Parks), subcategory can be empty
        let hasValidSubcategory = availableSubcategories.isEmpty || !selectedSubcategory.isEmpty
        
        return hasValidName && hasValidCategory && hasValidSubcategory
    }
    
    init(resource: Resource? = nil) {
        self.resource = resource
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section("Resource Information") {
                    TextField("Resource Name", text: $name)
                    
                    TextField("Description (Optional)", text: $description, axis: .vertical)
                        .lineLimit(3...6)
                    
                    TextField("URL (Optional)", text: $url)
                        .keyboardType(.URL)
                        .autocapitalization(.none)
                    
                    if selectedCategory == "Businesses" || selectedCategory == "Parks" {
                        TextField("Location (Optional)", text: $location)
                    }
                }
                
                Section("Category") {
                    Picker("Category", selection: $selectedCategory) {
                        ForEach(categories, id: \.0) { category, _ in
                            Text(category).tag(category)
                        }
                    }
                    .onChange(of: selectedCategory) { _, newValue in
                        // Reset subcategory when category changes
                        if let firstSubcategory = categories.first(where: { $0.0 == newValue })?.1.first {
                            selectedSubcategory = firstSubcategory
                        } else {
                            selectedSubcategory = ""
                        }
                    }
                    
                    if !availableSubcategories.isEmpty {
                        Picker("Subcategory", selection: $selectedSubcategory) {
                            ForEach(availableSubcategories, id: \.self) { subcategory in
                                Text(subcategory).tag(subcategory)
                            }
                        }
                    }
                }
                
                Section("Additional Information") {
                    TextField("Notes (Optional)", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                }
            }
            .navigationTitle(resource == nil ? "Add Resource" : "Edit Resource")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveResource()
                    }
                    .disabled(!isFormValid)
                }
            }
            .onAppear {
                if let resource = resource {
                    // Edit mode - populate fields
                    name = resource.name
                    description = resource.resourceDescription ?? ""
                    url = resource.url ?? ""
                    location = resource.location ?? ""
                    notes = resource.notes ?? ""
                    selectedCategory = resource.category
                    selectedSubcategory = resource.subcategory
                }
            }
        }
    }
    
    private func saveResource() {
        let trimmedName = name.trimmingCharacters(in: .whitespaces)
        let trimmedDescription = description.trimmingCharacters(in: .whitespaces).isEmpty ? nil : description.trimmingCharacters(in: .whitespaces)
        let trimmedUrl = url.trimmingCharacters(in: .whitespaces).isEmpty ? nil : url.trimmingCharacters(in: .whitespaces)
        let trimmedLocation = location.trimmingCharacters(in: .whitespaces).isEmpty ? nil : location.trimmingCharacters(in: .whitespaces)
        let trimmedNotes = notes.trimmingCharacters(in: .whitespaces).isEmpty ? nil : notes.trimmingCharacters(in: .whitespaces)
        
        // Handle subcategory for categories without subcategories
        let finalSubcategory = availableSubcategories.isEmpty ? "" : selectedSubcategory
        
        if let existingResource = resource {
            // Update existing resource
            existingResource.name = trimmedName
            existingResource.resourceDescription = trimmedDescription
            existingResource.url = trimmedUrl
            existingResource.location = trimmedLocation
            existingResource.notes = trimmedNotes
            existingResource.category = selectedCategory
            existingResource.subcategory = finalSubcategory
        } else {
            // Create new resource
            let newResource = Resource(
                name: trimmedName,
                category: selectedCategory,
                subcategory: finalSubcategory,
                description: trimmedDescription,
                url: trimmedUrl,
                location: trimmedLocation,
                notes: trimmedNotes
            )
            modelContext.insert(newResource)
        }
        
        dismiss()
    }
}

#Preview {
    AddResourceView()
        .modelContainer(for: Resource.self, inMemory: true)
} 