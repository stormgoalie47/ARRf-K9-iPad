//
//  Pawview.swift
//  ARRf K9 iPad
//
//  Created by Addison Reed on 7/26/25.
//

import SwiftUI
import SwiftData

struct ParentsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var parents: [Parent]
    @State private var showingAddParent = false
    @State private var searchText = ""
    @State private var sortBy: SortOption = .firstName
    
    enum SortOption: String, CaseIterable {
        case firstName = "First Name"
        case lastName = "Last Name"
        
        var sortKey: KeyPath<Parent, String> {
            switch self {
            case .firstName:
                return \.firstName
            case .lastName:
                return \.lastName
            }
        }
    }
    
    private var filteredAndSortedParents: [Parent] {
        let filtered = parents.filter { parent in
            if searchText.isEmpty {
                return true
            }
            
            // Search by parent name
            let parentNameMatch = parent.fullName.localizedCaseInsensitiveContains(searchText)
            
            // Search by dog names
            let dogNameMatch = parent.dogs.contains { dog in
                dog.name.localizedCaseInsensitiveContains(searchText)
            }
            
            return parentNameMatch || dogNameMatch
        }
        
        return filtered.sorted { parent1, parent2 in
            parent1[keyPath: sortBy.sortKey].localizedCaseInsensitiveCompare(parent2[keyPath: sortBy.sortKey]) == .orderedAscending
        }
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search and Sort Controls
                VStack(spacing: 12) {
                    // Search Bar
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.secondary)
                        
                        TextField("Search parents or dogs...", text: $searchText)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                    .padding(.horizontal)
                    
                    // Sort Picker
                    HStack {
                        Text("Sort by:")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Picker("Sort by", selection: $sortBy) {
                            ForEach(SortOption.allCases, id: \.self) { option in
                                Text(option.rawValue).tag(option)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .frame(maxWidth: 200)
                        
                        Spacer()
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 8)
                .background(Color(.systemGroupedBackground))
                
                // Parents List
                List {
                    ForEach(filteredAndSortedParents) { parent in
                        NavigationLink {
                            ParentsInfoView(parent: parent)
                        } label: {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(parent.fullName)
                                    .font(.headline)
                                
                                if !parent.dogs.isEmpty {
                                    Text("Dogs: \(parent.dogs.map { $0.name }.joined(separator: ", "))")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                        }
                    }
                }
                .listStyle(PlainListStyle())
            }
            .toolbar {
                ToolbarItem {
                    Button(action: { showingAddParent = true }) {
                        Label("Add Parent", systemImage: "plus")
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddParent) {
            AddParentView()
        }
    }

    private func deleteParent(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                let parentToDelete = filteredAndSortedParents[index]
                modelContext.delete(parentToDelete)
            }
        }
    }
}

#Preview {
    ParentsView()
        .modelContainer(for: Parent.self, inMemory: true)
}
