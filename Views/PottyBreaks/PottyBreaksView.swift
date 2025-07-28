//
//  PottyBreaksView.swift
//  ARRf K9 iPad
//
//  Created by Addison Reed on 7/26/25.
//

import SwiftUI
import SwiftData

struct PottyBreaksView: View {
    @Environment(\.modelContext) private var modelContext
        @Query private var pottybreaks: [PottyBreak]

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(pottybreaks) { pottybreak in
                    NavigationLink {
                        Text("Potty Break at \(pottybreak.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
                    } label: {
                        Text(pottybreak.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
                    }
                }
                .onDelete(perform: deletePottyBreak)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addPottyBreak) {
                        Label("Add Potty Break", systemImage: "plus")
                    }
                }
            }
        } detail: {
            Text("Select a Potty Break")
        }
    }

    private func addPottyBreak() {
        withAnimation {
            let newPottyBreak = PottyBreak(timestamp: Date())
            modelContext.insert(newPottyBreak)
        }
    }

    private func deletePottyBreak(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(pottybreaks[index])
            }
        }
    }
}

#Preview {
    PottyBreaksView()
}
