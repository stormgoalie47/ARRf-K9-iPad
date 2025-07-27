//
//  Untitled.swift
//  ARRf K9 iPad
//
//  Created by Addison Reed on 7/26/25.
//

import SwiftUI
import SwiftData

struct TreatsView: View {
    @Environment(\.modelContext) private var modelContext
        @Query private var treats: [Treat]

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(treats) { treat in
                    NavigationLink {
                        Text("Treats at \(treat.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
                    } label: {
                        Text(treat.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
                    }
                }
                .onDelete(perform: deleteTreat)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addTreat) {
                        Label("Add Treat", systemImage: "plus")
                    }
                }
            }
        } detail: {
            Text("Select a Treat")
        }
    }

    private func addTreat() {
        withAnimation {
            let newTreat = Treat(timestamp: Date())
            modelContext.insert(newTreat)
        }
    }

    private func deleteTreat(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(treats[index])
            }
        }
    }
}
