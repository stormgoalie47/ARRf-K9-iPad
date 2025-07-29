//
//  TreatRowView.swift
//  ARRf K9 iPad
//
//  Created by Addison Reed on 7/26/25.
//

import SwiftUI
import SwiftData

struct TreatRowView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var showingEditTreat = false
    @State private var showingTreatInfo = false
    
    let treat: Treat
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(treat.packageType)
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    HStack {
                        Text("\(treat.numberLessons) lessons")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Text("•")
                            .foregroundColor(.secondary)
                        
                        Text(treat.price, format: .currency(code: "USD"))
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    if let startDate = treat.purchaseDate {
                        Text("Started: \(startDate, format: .dateTime.day().month().year())")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    
                    if let endDate = treat.completionDate {
                        Text("Ended: \(endDate, format: .dateTime.day().month().year())")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 2) {
                    if treat.completed {
                        Text("Completed")
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(4)
                    } else {
                        Text("Active")
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(4)
                    }
                    
                    Button("Edit") {
                        showingEditTreat = true
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.small)
                }
            }
            
            if let notes = treat.notes, !notes.isEmpty {
                Text(notes)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.top, 2)
            }
            
            if !treat.dogs.isEmpty {
                Text("Dogs: \(treat.dogs.map { $0.Name }.joined(separator: ", "))")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.top, 2)
            }
        }
        .padding(.vertical, 4)
        .contentShape(Rectangle())
        .onTapGesture {
            showingTreatInfo = true
        }
        .sheet(isPresented: $showingEditTreat) {
            AddTreatView(treat: treat)
        }
        .sheet(isPresented: $showingTreatInfo) {
            TreatInfoView(treat: treat)
        }
    }
}

#Preview {
    TreatRowView(
        treat: Treat(
            parents: [],
            dogs: [],
            packageType: "Boarding",
            numberLessons: 10,
            price: 1000.0,
            notes: "Test treat"
        )
    )
    .modelContainer(for: Treat.self, inMemory: true)
} 
