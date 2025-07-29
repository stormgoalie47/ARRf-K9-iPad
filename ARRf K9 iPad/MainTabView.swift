//
//  TabView.swift
//  ARRf K9 iPad
//
//  Created by Addison Reed on 7/26/25.
//

import SwiftUI
import SwiftData

struct MainTabView: View {
    @State private var selectedTab = 0
    @State private var tabTapCounts: [Int: Int] = [0: 0, 1: 0, 2: 0, 3: 0, 4: 0]
    
    var body: some View {
        TabView(selection: $selectedTab) {
            PawView()
                .tabItem {
                    Image(systemName: "pawprint")
                    Text("PawView")
                }
                .tag(0)
            
            TreatsView()
                .tabItem {
                    Image(systemName: "shippingbox.fill")
                    Text("Treats")
                }
                .tag(1)
            
            PottyBreaksView()
                .tabItem {
                    Image(systemName: "calendar")
                    Text("Potty Breaks")
                }
                .tag(2)
            
            ParentsView()
                .tabItem {
                    Image(systemName: "dog")
                    Text("Parents")
                }
                .tag(3)
            
            ResourcesView()
                .tabItem {
                    Image(systemName: "books.vertical")
                    Text("Resources")
                }
                .tag(4)
        }
        .onChange(of: selectedTab) { oldValue, newValue in
            // Increment tap count for the selected tab
            tabTapCounts[newValue, default: 0] += 1
            
            // If tapping the same tab, trigger reset
            if newValue == oldValue {
                // Post notification with tab index and tap count
                NotificationCenter.default.post(
                    name: NSNotification.Name("ResetNavigation"),
                    object: nil,
                    userInfo: ["tab": newValue, "tapCount": tabTapCounts[newValue] ?? 0]
                )
            }
        }
    }
}

#Preview {
    MainTabView()
}
