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

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(parents) { parent in
                    NavigationLink {
                        ParentsInfoView(parent: parent)
                    } label: {
                        Text(parent.fullName)
                    }
                }
                .onDelete(perform: deleteParent)
            }
            .toolbar {
                ToolbarItem {
                    Button(action: { showingAddParent = true }) {
                        Label("Add Parent", systemImage: "plus")
                    }
                }
            }
        } detail: {
            Text("Select a Parent")
        }
        .sheet(isPresented: $showingAddParent) {
            AddParentView()
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
