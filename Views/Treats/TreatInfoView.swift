//
//  TreatInfoView.swift
//  ARRf K9 iPad
//
//  Created by Addison Reed on 7/26/25.
//

import SwiftUI
import SwiftData

struct TreatInfoView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showingEditTreat = false
    
    let treat: Treat
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    // Package Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text(treat.packageType)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        HStack {
                            Text("\(treat.numberLessons) lessons")
                                .font(.title2)
                                .foregroundColor(.secondary)
                            
                            Spacer()
                            
                            Text(treat.price, format: .currency(code: "USD"))
                                .font(.title2)
                                .fontWeight(.semibold)
                        }
                        
                        // Status Badge
                        HStack {
                            if treat.completed {
                                Text("Completed")
                                    .font(.caption)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color.green)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            } else {
                                Text("Active")
                                    .font(.caption)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                            
                            Spacer()
                        }
                    }
                    .padding(.bottom)
                    
                    Divider()
                    
                    // Dates Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Timeline")
                            .font(.headline)
                        
                        if let startDate = treat.dateStarted {
                            HStack {
                                Text("Start Date:")
                                    .fontWeight(.medium)
                                Spacer()
                                Text(startDate, format: .dateTime.day().month().year())
                            }
                        }
                        
                        if let endDate = treat.dateEnded {
                            HStack {
                                Text("End Date:")
                                    .fontWeight(.medium)
                                Spacer()
                                Text(endDate, format: .dateTime.day().month().year())
                            }
                        }
                        
                        if treat.dateStarted == nil && treat.dateEnded == nil {
                            Text("No dates set")
                                .foregroundColor(.secondary)
                                .italic()
                        }
                    }
                    .padding(.bottom)
                    
                    Divider()
                    
                    // Parents Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Parents")
                            .font(.headline)
                        
                        ForEach(treat.parents, id: \.timestamp) { parent in
                            HStack {
                                Text(parent.fullName)
                                    .font(.body)
                                Spacer()
                            }
                            .padding(.vertical, 2)
                        }
                    }
                    .padding(.bottom)
                    
                    Divider()
                    
                    // Dogs Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Dogs")
                            .font(.headline)
                        
                        ForEach(treat.dogs, id: \.timestamp) { dog in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(dog.Name)
                                        .font(.body)
                                        .fontWeight(.medium)
                                    Text(dog.Breed)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                            }
                            .padding(.vertical, 2)
                        }
                    }
                    .padding(.bottom)
                    
                    // Notes Section
                    if let notes = treat.notes, !notes.isEmpty {
                        Divider()
                        
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Notes")
                                .font(.headline)
                            
                            Text(notes)
                                .font(.body)
                        }
                        .padding(.bottom)
                    }
                }
                .padding()
            }
            .navigationTitle("Package Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Done") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Edit") {
                        showingEditTreat = true
                    }
                }
            }
            .sheet(isPresented: $showingEditTreat) {
                AddTreatView(treat: treat)
            }
        }
    }
}

#Preview {
    TreatInfoView(
        treat: Treat(
            parents: [],
            dogs: [],
            packageType: "Boarding",
            numberLessons: 10,
            price: 1000.0,
            notes: "Test package"
        )
    )
    .modelContainer(for: Treat.self, inMemory: true)
} 