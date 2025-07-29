//
//  CategoryStatCard.swift
//  ARRf K9 iPad
//
//  Created by Addison Reed on 7/26/25.
//

import SwiftUI

struct CategoryStatCard: View {
    let title: String
    let iconName: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: iconName)
                    .font(.system(size: 32))
                    .foregroundColor(isSelected ? .white : .primary)
            }
            .frame(width: 80, height: 80)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Color.blue : Color(.systemBackground))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.blue : Color(.systemGray4), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    HStack(spacing: 16) {
        CategoryStatCard(
            title: "Links",
            iconName: "link.circle.fill",
            isSelected: true
        ) {}
        
        CategoryStatCard(
            title: "Tools",
            iconName: "wrench.and.screwdriver.fill",
            isSelected: false
        ) {}
    }
    .padding()
} 
