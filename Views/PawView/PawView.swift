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
    @State private var navigationPath = NavigationPath()

    var body: some View {
        NavigationStack(path: $navigationPath) {
            logoSection
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("ResetNavigation"))) { notification in
            if let userInfo = notification.userInfo,
               let tab = userInfo["tab"] as? Int,
               tab == 0 { // PawView tab
                navigationPath = NavigationPath()
            }
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
