//
//  StatCard.swift
//  ARRf K9 iPad
//
//  Created by Addison Reed on 7/26/25.
//

import SwiftUI

struct StatCard: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(isSelected ? .white : .primary)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? Color.blue : Color(.systemGray5))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    VStack(spacing: 20) {
        HStack(spacing: 12) {
            StatCard(title: "All", isSelected: true, action: {})
            StatCard(title: "Boarding", isSelected: false, action: {})
            StatCard(title: "B&T", isSelected: false, action: {})
        }
        
        HStack(spacing: 12) {
            StatCard(title: "All", isSelected: false, action: {})
            StatCard(title: "Active", isSelected: true, action: {})
            StatCard(title: "Completed", isSelected: false, action: {})
        }
    }
    .padding()
} 