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
                // Package Header
                VStack(alignment: .leading, spacing: 8) {
                    Text(treat.packageType)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("\(treat.numberLessons) lessons")
                                .font(.title2)
                                .foregroundColor(.secondary)
                            
                            Text("\(lessonProgress.completed)/\(lessonProgress.total) completed")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text("\(treat.lessonDates.count)/\(lessonProgress.total) scheduled")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        
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
                    
                    if let purchaseDate = treat.purchaseDate {
                        HStack {
                            Text("Purchase Date:")
                                .fontWeight(.medium)
                            Spacer()
                            Text(purchaseDate, format: .dateTime.day().month().year())
                        }
                    }
                    
                    if let completionDate = treat.completionDate {
                        HStack {
                            Text("Completion Date:")
                                .fontWeight(.medium)
                            Spacer()
                            Text(completionDate, format: .dateTime.day().month().year())
                        }
                    }
                    
                    if treat.purchaseDate == nil && treat.completionDate == nil {
                        Text("No dates set")
                            .foregroundColor(.secondary)
                            .italic()
                    }
                }
                .padding(.bottom)
                
                Divider()
                
                // Lesson Dates Section
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text("Lesson Dates")
                                .font(.headline)
                            Text("\(lessonProgress.completed)/\(lessonProgress.total) completed")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            Text("\(treat.lessonDates.count)/\(lessonProgress.total) scheduled")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        Spacer()
                        Button("Add Date") {
                            showingAddLessonDate = true
                        }
                        .buttonStyle(.bordered)
                        .controlSize(.small)
                    }
                    
                    if treat.lessonDates.isEmpty {
                        Text("No lesson dates scheduled")
                            .foregroundColor(.secondary)
                            .italic()
                    } else {
                        LazyVStack(alignment: .leading, spacing: 4) {
                            ForEach(treat.lessonDates.sorted(), id: \.self) { date in
                                HStack {
                                    Text(date, format: .dateTime.day().month().year())
                                        .font(.body)
                                    Spacer()
                                    Button("Remove") {
                                        dateToRemove = date
                                        showingRemoveDateAlert = true
                                    }
                                    .buttonStyle(.bordered)
                                    .controlSize(.small)
                                    .foregroundColor(.red)
                                }
                                .padding(.vertical, 2)
                            }
                        }
                    }
                }
                .padding(.bottom)
                
                Divider()
                
                // Parents Section
                VStack(alignment: .leading, spacing: 8) {
                    Text("Parents")
                        .font(.headline)
                    
                    ForEach(displayParents, id: \.id) { parent in
                        NavigationLink {
                            ParentsInfoView(parent: parent)
                        } label: {
                            HStack {
                                Text(parent.fullName)
                                    .font(.body)
                                    .foregroundColor(.primary)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.vertical, 2)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.bottom)
                
                Divider()
                
                // Dogs Section
                VStack(alignment: .leading, spacing: 8) {
                    Text("Dogs")
                        .font(.headline)
                    
                    ForEach(displayDogs, id: \.id) { dog in
                        NavigationLink {
                            DogInfoView(dog: dog, parent: dog.parent ?? treat.parents.first!)
                        } label: {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(dog.name)
                                        .font(.body)
                                        .fontWeight(.medium)
                                        .foregroundColor(.primary)
                                    Text(dog.breed)
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.vertical, 2)
                        }
                        .buttonStyle(PlainButtonStyle())
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
                
                Spacer(minLength: 100)
            }
            .padding()
        }
        .navigationTitle("Package Details")
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