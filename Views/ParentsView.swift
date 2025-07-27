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

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(parents) { parent in
                    NavigationLink {
                        Text("Parent: " + parent.fullName)
                        Text("Notes: ")
                        Text(parent.notes)
                        if parent.dogs.isEmpty {
                            Text("No dogs added yet...")
                        }
                    } label: {
                        Text(parent.fullName)
                    }
                }
                .onDelete(perform: deleteParent)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addParent) {
                        Label("Add Parent", systemImage: "plus")
                    }
                }
            }
        } detail: {
            Text("Select a Parent")
        }
    }

    private func addParent() {
        withAnimation {
            let newParent = Parent(timestamp: Date(), firstName: "Test", lastName: "Parent", notes: "Notes Section")
            modelContext.insert(newParent)
        }
    }

    private func deleteParent(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(parents[index])
            }
        }
    }
}

#Preview {
    ParentsView()
}
