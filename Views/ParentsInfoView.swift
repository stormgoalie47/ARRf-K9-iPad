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
    @State var parent: Parent
    @State private var showingEditParent = false
    
    init(parent: Parent) {
        self.parent = parent
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
            
            if parent.dogs.isEmpty {
                Text("No dogs added yet...")
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .navigationTitle("Parent Details")
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
    }
}
