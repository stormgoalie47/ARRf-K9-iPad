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
    @State private var previousTab = 0
    
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
            // If tapping the same tab, reset navigation
            if newValue == previousTab {
                resetNavigation(for: newValue)
            }
            previousTab = newValue
        }
    }
    
    private func resetNavigation(for tab: Int) {
        // Post notification to reset navigation for the specific tab
        NotificationCenter.default.post(
            name: NSNotification.Name("ResetNavigation"),
            object: nil,
            userInfo: ["tab": tab]
        )
    }
}

#Preview {
    MainTabView()
}
