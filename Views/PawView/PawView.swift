//
//  PawView.swift
//  ARRf K9 iPad
//
//  Created by Addison Reed on 7/26/25.
//

import SwiftUI
import SwiftData

struct PawView: View {
    @Environment(\.modelContext) private var modelContext
        @Query private var parents: [Parent]

    var body: some View {
        NavigationStack {
            logoSection
        }
            
    }
    
    private var logoSection: some View {
        VStack(spacing: 16) {
            Image("Banner")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(.top)
        }
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarLeading) {
                leadingToolbar
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                trailingToolbar
            }
        }
        .navigationDestination(for: String.self) { destination in
            switch destination {
            case "analytics":
                AnalyticsView()
            case "settings":
                SettingsView()
            default:
                EmptyView()
            }
        }
    }
    
    private var leadingToolbar: some View {
        Group {
            NavigationLink(value: "analytics") {
                Image(systemName: "chart.bar.fill")
                    .font(.title2)
                    .foregroundColor(.blue)
            }
        }
    }
    
    private var trailingToolbar: some View {
        HStack(spacing: 12) {
            NavigationLink(value: "settings") {
                Image(systemName: "gear")
                    .font(.title2)
                    .foregroundColor(.blue)
            }
        }
    }
}

#Preview {
    PawView()
}
