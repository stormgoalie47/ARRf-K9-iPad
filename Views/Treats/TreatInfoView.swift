//
//  TreatInfoView.swift
//  ARRf K9 iPad
//
//  Created by Addison Reed on 7/26/25.
//

import SwiftUI
import SwiftData

struct TreatInfoView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var allParents: [Parent]
    @Query private var allDogs: [Dog]
    @State private var showingEditTreat = false
    @State private var showingAddLessonDate = false
    @State private var newLessonDate = Date()
    @State private var showingRemoveDateAlert = false
    @State private var dateToRemove: Date?
    
    let treat: Treat
    
    // Helper functions to get parent and dog information from reverse relationships
    private var displayParents: [Parent] {
        if !treat.parents.isEmpty {
            return treat.parents
        } else {
            // Find parents that have this treat in their treats array
            return allParents.filter { $0.treats.contains(treat) }
        }
    }
    
    private var displayDogs: [Dog] {
        if !treat.dogs.isEmpty {
            return treat.dogs
        } else {
            // Find dogs that have this treat in their packages array
            return allDogs.filter { $0.packages.contains(treat) }
        }
    }
    
    private var lessonProgress: (completed: Int, total: Int) {
        let completed = treat.lessonDates.filter { $0 <= Date() }.count
        return (completed, treat.numberLessons)
    }
    
    private var nextLessonDate: Date? {
        treat.lessonDates.filter { $0 > Date() }.min()
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                   
                    HStack {
                        Spacer()
                        
                        Text(treat.packageType)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Text("\(treat.numberLessons) lessons")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                        }
                        
                        Spacer()
                        
                        Text(treat.price, format: .currency(code: "USD"))
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Spacer()
                        
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
                
                Divider()
                
                // Dates Section
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Spacer()
                        Text("Timeline")
                            .font(.headline)
                        Spacer()
                    }
                    
                    if let purchaseDate = treat.purchaseDate {
                        HStack {
                            Spacer()
                            Text("Purchase Date:")
                                .fontWeight(.medium)
                            Spacer()
                            Text(purchaseDate, format: .dateTime.day().month().year())
                            Spacer()
                        }
                    }
                    
                    if let completionDate = treat.completionDate {
                        HStack {
                            Spacer()
                            Text("Completion Date:")
                                .fontWeight(.medium)
                            Spacer()
                            Text(completionDate, format: .dateTime.day().month().year())
                            Spacer()
                        }
                    }
                    
                    if treat.purchaseDate == nil && treat.completionDate == nil {
                        Text("No dates set")
                            .foregroundColor(.secondary)
                            .italic()
                    }
                }
                    .padding()
                
                Divider()
                
                // Lesson Dates Section
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Spacer()
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Lesson Dates")
                                .font(.headline)
                        }
                        Spacer()
                        Button("Add Date") {
                            showingAddLessonDate = true
                        }
                        .buttonStyle(.bordered)
                        .controlSize(.small)
                        Spacer()
                    }
                    
                    if treat.lessonDates.isEmpty {
                        Text("No lesson dates scheduled")
                            .foregroundColor(.secondary)
                            .italic()
                    } else {
                        LazyVStack(alignment: .leading, spacing: 4) {
                            ForEach(treat.lessonDates.sorted(), id: \.self) { date in
                                HStack {
                                    Spacer()
                                    Text(date, format: .dateTime.day().month().year())
                                        .font(.body)
                                    Spacer()
                                    Button("Remove") {
                                        dateToRemove = date
                                        showingRemoveDateAlert = true
                                    }
                                    Spacer()
                                    .buttonStyle(.bordered)
                                    .controlSize(.small)
                                    .foregroundColor(.red)
                                }
                                .padding(.vertical, 2)
                            }
                        }
                    }
                    HStack {
                        Spacer()
                        Text("\(lessonProgress.completed)/\(lessonProgress.total) completed")
                            .font(.title3)
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        Text("\(treat.lessonDates.count)/\(lessonProgress.total) scheduled")
                            .font(.title3)
                        Spacer()
                    }
                }
                .padding()
                
                Divider()
                
                HStack {
                    // Parents Section
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Spacer()
                            Text("Parents")
                                .font(.headline)
                            Spacer()
                        }
                        
                        ForEach(displayParents, id: \.id) { parent in
                            NavigationLink {
                                ParentsInfoView(parent: parent)
                            } label: {
                                HStack {
                                    Spacer()
                                    Text(parent.fullName)
                                        .font(.body)
                                        .foregroundColor(.primary)
                                    Spacer()
                                }
                                .padding(.vertical, 2)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding()
                    
                    Divider()
                    
                    // Dogs Section
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Spacer()
                            Text("Dogs")
                                .font(.headline)
                            Spacer()
                        }
                        
                        ForEach(displayDogs, id: \.id) { dog in
                            NavigationLink {
                                DogInfoView(dog: dog, parent: dog.parent ?? treat.parents.first!)
                            } label: {
                                HStack {
                                    Spacer()
                                    VStack(alignment: .leading) {
                                        Text(dog.name)
                                            .font(.body)
                                            .fontWeight(.medium)
                                            .foregroundColor(.primary)
                                    }
                                    Spacer()
                                }
                                .padding(.vertical, 2)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding()
                }
                
                // Notes Section
                if let notes = treat.notes, !notes.isEmpty {
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Spacer()
                            Text("Notes")
                                .font(.headline)
                            Spacer()
                        }
                        HStack {
                            Spacer()
                            Text(notes)
                                .font(.body)
                            Spacer()
                        }
                    }
                    .padding()
                }
                
                Spacer(minLength: 100)
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Edit") {
                    showingEditTreat = true
                }
            }
        }
        .sheet(isPresented: $showingEditTreat) {
            AddTreatView(treat: treat)
        }
        .sheet(isPresented: $showingAddLessonDate) {
            NavigationView {
                VStack(spacing: 20) {
                    Text("Add Lesson Date")
                        .font(.headline)
                    
                    DatePicker("Lesson Date", selection: $newLessonDate, displayedComponents: .date)
                        .datePickerStyle(.graphical)
                    
                    HStack {
                        Button("Cancel") {
                            showingAddLessonDate = false
                        }
                        .buttonStyle(.bordered)
                        
                        Spacer()
                        
                        Button("Add") {
                            addLessonDate()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
                .padding()
                .navigationTitle("Add Lesson Date")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
        .alert("Remove Lesson Date", isPresented: $showingRemoveDateAlert) {
            Button("Cancel", role: .cancel) {
                dateToRemove = nil
            }
            Button("Remove", role: .destructive) {
                if let date = dateToRemove {
                    removeLessonDate(date)
                }
                dateToRemove = nil
            }
        } message: {
            if let date = dateToRemove {
                Text("Are you sure you want to remove the lesson date on \(date, style: .date)?")
            }
        }
    }
    
    private func addLessonDate() {
        // Strip time from date to store only the date
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: newLessonDate)
        if let dateOnly = calendar.date(from: components) {
            treat.lessonDates.append(dateOnly)
            treat.lastUpdated = Date()
        }
        showingAddLessonDate = false
        newLessonDate = Date() // Reset for next use
    }
    
    private func removeLessonDate(_ date: Date) {
        treat.lessonDates.removeAll { $0 == date }
        treat.lastUpdated = Date()
    }
}

#Preview {
    NavigationView {
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
    }
    .modelContainer(for: Treat.self, inMemory: true)
} 
