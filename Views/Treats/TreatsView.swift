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
    
    private let packageTypes = ["All", "Boarding", "B&T", "Day Camp", "House Call"]
    private let statusOptions = ["All", "Active", "Completed"]
    
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
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Filter Cards - Same Line
                    HStack(spacing: 130) {
                        // Package Type Filter Cards
                        VStack(alignment: .leading, spacing: 12) {
                            HStack(spacing: 12) {
                                ForEach(packageTypes, id: \.self) { type in
                                    StatCard(
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
    }
}
