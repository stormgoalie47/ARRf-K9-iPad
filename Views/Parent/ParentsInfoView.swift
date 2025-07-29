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
    let parent: Parent
    @State private var showingEditParent = false
    @State private var showingAddDog = false
    @State private var showingAddTreat = false
    
    init(parent: Parent) {
        self.parent = parent
    }
    
    private var parentTreats: [Treat] {
        let treats = parent.treats.sorted { $0.timestamp > $1.timestamp }
        print("📋 ParentsInfoView - Parent: \(parent.fullName)")
        print("   Total treats in parent.treats: \(parent.treats.count)")
        print("   Treats: \(treats.map { "\($0.packageType) (ID: \($0.id))" })")
        return treats
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Parent Information
                VStack(alignment: .leading, spacing: 8) {
                    Text("Parent: " + parent.fullName)
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    if !parent.notes.isEmpty {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Notes:")
                                .font(.headline)
                            Text(parent.notes)
                                .font(.body)
                        }
                    }
                }
                .padding(.bottom)
                
                Divider()
                
                // Dogs Section
                VStack(alignment: .leading, spacing: 12) {
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
                            ForEach(parent.dogs, id: \.id) { dog in
                                DogRowView(dog: dog, parent: parent)
                            }
                        }
                    }
                }
                .padding(.bottom)
                
                Divider()
                
                // Treats Section
                VStack(alignment: .leading, spacing: 12) {
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
                            ForEach(parentTreats, id: \.id) { treat in
                                TreatRowView(treat: treat)
                            }
                        }
                    }
                }
                
                Spacer(minLength: 100)
            }
            .padding()
        }
        .navigationTitle("Parent Details")
        .navigationBarTitleDisplayMode(.large)
        .id(parent.id) // Force refresh when parent changes
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

#Preview {
    NavigationView {
        ParentsInfoView(
            parent: Parent(timestamp: Date(), firstName: "John", lastName: "Doe", notes: "Test parent")
        )
    }
    .modelContainer(for: Parent.self, inMemory: true)
}
