//
//  ParentsInfoView.swift
//  ARRf K9 iPad
//
//  Created by Addison Reed on 7/27/25.
//

import SwiftUI
import SwiftData

struct ParentsInfoView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var parents: [Parent]
    @Query private var allTreats: [Treat]
    let parent: Parent
    @State private var showingEditParent = false
    @State private var showingAddDog = false
    @State private var showingAddTreat = false
    
    init(parent: Parent) {
        self.parent = parent
    }
    
    private var parentTreats: [Treat] {
        allTreats.filter { treat in
            treat.parents.contains(parent)
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Parent: " + parent.fullName)
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Notes: ")
                .font(.headline)
            Text(parent.notes)
                .font(.body)
            
            Divider()
            
            HStack {
                Text("Dogs")
                    .font(.headline)
                Spacer()
                Button("Add Dog") {
                    showingAddDog = true
                }
                .buttonStyle(.borderedProminent)
            }
            
            if parent.dogs.isEmpty {
                Text("No dogs added yet...")
                    .foregroundColor(.secondary)
                    .padding(.vertical)
            } else {
                LazyVStack(alignment: .leading, spacing: 8) {
                    ForEach(parent.dogs, id: \.timestamp) { dog in
                        DogRowView(dog: dog, parent: parent)
                    }
                }
            }
            
            Divider()
            
            HStack {
                Text("Treats")
                    .font(.headline)
                Spacer()
                Text("\(parentTreats.count) package(s)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                Button("Add Treat") {
                    showingAddTreat = true
                }
                .buttonStyle(.borderedProminent)
            }
            
            if parentTreats.isEmpty {
                Text("No treats assigned to this parent...")
                    .foregroundColor(.secondary)
                    .padding(.vertical)
            } else {
                LazyVStack(alignment: .leading, spacing: 8) {
                    ForEach(parentTreats, id: \.timestamp) { treat in
                        TreatRowView(treat: treat)
                    }
                }
            }
        }
        .padding()
        .navigationTitle("Parent Details")
        .id(parent.timestamp) // Force refresh when parent changes
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Edit") {
                    showingEditParent = true
                }
            }
        }
        .sheet(isPresented: $showingEditParent) {
            AddParentView(parent: parent)
        }
        .sheet(isPresented: $showingAddDog) {
            AddDogView(parent: parent)
        }
        .sheet(isPresented: $showingAddTreat) {
            AddTreatView(defaultParent: parent)
        }
    }
}
