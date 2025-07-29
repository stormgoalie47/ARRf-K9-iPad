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
    
    @State private var selectedPackageType: String = "All"
    @State private var selectedStatus: String = "All"
    @State private var navigationPath = NavigationPath()
    
    private let packageTypes = ["All", "Boarding", "B&T", "Day Camp", "House Call"]
    private let statusOptions = ["All", "Active", "Completed"]
    
    // Helper function to get icon for package type
    private func getPackageTypeIcon(for type: String) -> String {
        switch type {
        case "All":
            return "square.grid.2x2.fill"
        case "Boarding":
            return "house.fill"
        case "B&T":
            return "person.2.fill"
        case "Day Camp":
            return "sun.max.fill"
        case "House Call":
            return "car.fill"
        default:
            return "shippingbox.fill"
        }
    }
    
    private var filteredTreats: [Treat] {
        var filtered = treats
        
        // Filter by package type
        if selectedPackageType != "All" {
            filtered = filtered.filter { $0.packageType == selectedPackageType }
        }
        
        // Filter by status
        if selectedStatus != "All" {
            let isCompleted = selectedStatus == "Completed"
            filtered = filtered.filter { $0.completed == isCompleted }
        }
        
        return filtered
    }
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            ScrollView {
                VStack(spacing: 20) {
                    // Filter Cards - Same Line
                    HStack(spacing: 130) {
                        // Package Type Filter Cards
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(spacing: 12) {
                                ForEach(packageTypes, id: \.self) { type in
                                    IconStatCard(
                                        iconName: getPackageTypeIcon(for: type),
                                        title: type,
                                        isSelected: selectedPackageType == type,
                                        action: { selectedPackageType = type }
                                    )
                                }
                            }
                        }
                        
                        // Status Filter Cards
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(spacing: 12) {
                                ForEach(statusOptions, id: \.self) { status in
                                    StatCard(
                                        title: status,
                                        isSelected: selectedStatus == status,
                                        action: { selectedStatus = status }
                                    )
                                }
                            }
                        }
                    }
                    
                    // Results Count
                    .padding(.horizontal)
                    
                    // Treats List
                    LazyVStack(spacing: 12) {
                        ForEach(filteredTreats) { treat in
                            NavigationLink {
                                TreatInfoView(treat: treat)
                            } label: {
                                TreatRowView(treat: treat)
                                    .padding()
                                    .background(Color(.systemBackground))
                                    .cornerRadius(12)
                                    .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("ResetNavigation"))) { notification in
            if let userInfo = notification.userInfo,
               let tab = userInfo["tab"] as? Int,
               tab == 1 { // Treats tab
                navigationPath = NavigationPath()
            }
        }
    }
}
