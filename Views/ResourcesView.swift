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

    var body: some View {
        NavigationStack {
            Text("Resources")
                .font(.largeTitle)
            List {
                ForEach(resources) { resource in
                    NavigationLink {
                        Text("Resource at \(resource.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
                    } label: {
                        Text(resource.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
                    }
                }
                .onDelete(perform: deleteResource)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addResource) {
                        Label("Add Resource", systemImage: "plus")
                    }
                }
            }
        }
    }

    private func addResource() {
        withAnimation {
            let newResource = Resource(timestamp: Date())
            modelContext.insert(newResource)
        }
    }

    private func deleteResource(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(resources[index])
            }
        }
    }
}
