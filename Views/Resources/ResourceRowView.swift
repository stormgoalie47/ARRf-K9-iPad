//
//  ResourceRowView.swift
//  ARRf K9 iPad
//
//  Created by Addison Reed on 7/26/25.
//

import SwiftUI
import SwiftData

struct ResourceRowView: View {
    let resource: Resource
    @State private var showingResourceInfo = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(resource.name)
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text("\(resource.category) • \(resource.subcategory)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    if let location = resource.location, !location.isEmpty {
                        Text(location)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    if let description = resource.resourceDescription {
                        Text(description)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .lineLimit(2)
                    }
                }
                
                Spacer()
                
                if resource.url != nil {
                    Image(systemName: "link")
                        .foregroundColor(.blue)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
        .contentShape(Rectangle())
        .onTapGesture {
            showingResourceInfo = true
        }
        .sheet(isPresented: $showingResourceInfo) {
            NavigationView {
                ResourceInfoView(resource: resource)
            }
        }
    }
}

#Preview {
    ResourceRowView(
        resource: Resource(
            name: "Sample Resource",
            category: "Tools",
            subcategory: "Collars",
            description: "A sample resource description",
            url: "https://example.com"
        )
    )
    .modelContainer(for: Resource.self, inMemory: true)
} 