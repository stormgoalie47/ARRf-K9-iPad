//
//  Untitled.swift
//  ARRf K9 iPad
//
//  Created by Addison Reed on 7/26/25.
//

import SwiftUI
import SwiftData

struct ResourcesView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var resources: [Resource]
    
    @State private var selectedCategory: String?
    @State private var selectedSubcategory: String?
    @State private var showingAddResource = false
    @State private var navigationPath = NavigationPath()
    
    // Define categories and subcategories
    private let categories = [
        ("Links", ["ARRf K9", "Client Handouts", "Reviews"]),
        ("Parks", []),
        ("Businesses", ["The Best!", "Rescues", "Pet Supplies", "Grooming", "Others"]),
        ("Tools", ["Collars", "E-Collars", "Leashes", "Enrichment", "Exercise", "Apparel", "Other"])
    ]
    
    private var filteredResources: [Resource] {
        var filtered = resources
        
        if let selectedCategory = selectedCategory {
            filtered = filtered.filter { $0.category == selectedCategory }
            
            if let selectedSubcategory = selectedSubcategory {
                filtered = filtered.filter { $0.subcategory == selectedSubcategory }
            }
        }
        
        return filtered
    }
    
    private func resourcesForCategory(_ category: String) -> [Resource] {
        return resources.filter { $0.category == category }
    }
    
    private func resourcesForSubcategory(_ category: String, _ subcategory: String) -> [Resource] {
        return resources.filter { $0.category == category && $0.subcategory == subcategory }
    }
    
    private func getCategoryIcon(for category: String) -> String {
        switch category {
        case "Links":
            return "link.circle.fill"
        case "Parks":
            return "leaf.fill"
        case "Businesses":
            return "building.2.fill"
        case "Tools":
            return "wrench.and.screwdriver.fill"
        default:
            return "questionmark.circle.fill"
        }
    }

    var body: some View {
        NavigationStack(path: $navigationPath) {
            VStack(spacing: 0) {
                // Fixed Filter Section
                VStack(spacing: 16) {
                    // Category Filter
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 16) {
                            Spacer()
                            CategoryStatCard(
                                title: "All",
                                iconName: "square.grid.2x2.fill",
                                isSelected: selectedCategory == nil
                            ) {
                                selectedCategory = nil
                                selectedSubcategory = nil
                            }
                            
                            ForEach(categories, id: \.0) { category, _ in
                                CategoryStatCard(
                                    title: category,
                                    iconName: getCategoryIcon(for: category),
                                    isSelected: selectedCategory == category
                                ) {
                                    selectedCategory = category
                                    // Auto-select first subcategory if available
                                    if let firstSubcategory = categories.first(where: { $0.0 == category })?.1.first {
                                        selectedSubcategory = firstSubcategory
                                    } else {
                                        selectedSubcategory = nil
                                    }
                                }
                            }
                            Spacer()
                        }
                        .padding(.horizontal)
                    }
                    
                    // Subcategory Filter (only show if category is selected)
                    if let selectedCategory = selectedCategory {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Spacer()
                                HStack(spacing: 16) {
                                    ForEach(categories.first { $0.0 == selectedCategory }?.1 ?? [], id: \.self) { subcategory in
                                        StatCard(
                                            title: subcategory,
                                            isSelected: selectedSubcategory == subcategory
                                        ) {
                                            selectedSubcategory = subcategory
                                        }
                                    }
                                }
                                Spacer()
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                .padding(.vertical)
                .background(Color(.systemBackground))
                
                // Scrollable Results Section
                ScrollView {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("\(filteredResources.count) resource(s)")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        if filteredResources.isEmpty {
                            VStack {
                                Spacer()
                                Text("No resources found")
                                    .foregroundColor(.secondary)
                                    .italic()
                                Spacer()
                            }
                            .frame(maxHeight: 200)
                        } else {
                            LazyVStack(spacing: 12) {
                                ForEach(filteredResources, id: \.timestamp) { resource in
                                    ResourceRowView(resource: resource)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.vertical)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add Resource") {
                        showingAddResource = true
                    }
                }
            }
            .sheet(isPresented: $showingAddResource) {
                AddResourceView()
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("ResetNavigation"))) { notification in
            if let userInfo = notification.userInfo,
               let tab = userInfo["tab"] as? Int,
               tab == 4 { // Resources tab
                navigationPath = NavigationPath()
            }
        }
    }
}

