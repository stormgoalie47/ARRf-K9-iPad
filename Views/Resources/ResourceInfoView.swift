//
//  ResourceInfoView.swift
//  ARRf K9 iPad
//
//  Created by Addison Reed on 7/26/25.
//

import SwiftUI
import SwiftData

struct ResourceInfoView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State private var showingEditResource = false
    
    let resource: Resource
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Resource Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text(resource.name)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        HStack {
                            Text("\(resource.category) • \(resource.subcategory)")
                                .font(.title3)
                                .foregroundColor(.secondary)
                            
                            Spacer()
                        }
                    }
                    .padding(.bottom)
                    
                    Divider()
                    
                    // Description Section
                    if let description = resource.resourceDescription {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Description")
                                .font(.headline)
                            
                            Text(description)
                                .font(.body)
                        }
                        .padding(.bottom)
                        
                        Divider()
                    }
                    
                    // URL Section
                    if let url = resource.url {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Link")
                                .font(.headline)
                            
                            HStack {
                                Image(systemName: "link")
                                    .foregroundColor(.blue)
                                
                                Text(url)
                                    .font(.body)
                                    .foregroundColor(.blue)
                                
                                Spacer()
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                if let url = URL(string: url) {
                                    UIApplication.shared.open(url)
                                }
                            }
                        }
                        .padding(.bottom)
                        
                        Divider()
                    }
                    
                    // Location Section (only for Businesses and Parks)
                    if let location = resource.location, !location.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Location")
                                .font(.headline)
                            
                            Text(location)
                                .font(.body)
                        }
                        .padding(.bottom)
                        
                        Divider()
                    }
                    
                    // Notes Section
                    if let notes = resource.notes, !notes.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Notes")
                                .font(.headline)
                            
                            Text(notes)
                                .font(.body)
                        }
                        .padding(.bottom)
                        
                        Divider()
                    }
                    
                    // Metadata Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Details")
                            .font(.headline)
                        
                        HStack {
                            Text("Added:")
                                .fontWeight(.medium)
                            Spacer()
                            Text(resource.timestamp, format: .dateTime.day().month().year())
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Resource Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Edit") {
                        showingEditResource = true
                    }
                }
            }
            .sheet(isPresented: $showingEditResource) {
                AddResourceView(resource: resource)
            }
        }
    }
}

#Preview {
    ResourceInfoView(
        resource: Resource(
            name: "Sample Resource",
            category: "Tools",
            subcategory: "Collars",
            description: "A sample resource description",
            url: "https://example.com",
            notes: "Sample notes"
        )
    )
    .modelContainer(for: Resource.self, inMemory: true)
} 