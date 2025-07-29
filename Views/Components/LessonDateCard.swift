//
//  LessonDateCard.swift
//  ARRf K9 iPad
//
//  Created by Addison Reed on 7/26/25.
//

import SwiftUI
import SwiftData

struct LessonDateCard: View {
    let treat: Treat
    @State private var showingTreatInfo = false
    
    private var lessonProgress: (completed: Int, total: Int) {
        let today = Calendar.current.startOfDay(for: Date())
        let passedLessons = treat.lessonDates.filter { lessonDate in
            let lessonDay = Calendar.current.startOfDay(for: lessonDate)
            return lessonDay < today
        }.count
        return (passedLessons, treat.numberLessons)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(treat.packageType)
                        .font(.headline)
                        .fontWeight(.semibold)
                    
                    Text("\(treat.numberLessons) lessons • \(treat.price, format: .currency(code: "USD"))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("\(lessonProgress.completed)/\(lessonProgress.total) completed • \(treat.lessonDates.count)/\(lessonProgress.total) scheduled")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                if treat.completed {
                    Text("Completed")
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(6)
                } else {
                    Text("Active")
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(6)
                }
            }
            
            // Parents and Dogs
            VStack(alignment: .leading, spacing: 4) {
                if !treat.parents.isEmpty {
                    HStack {
                        Text("Parents: ")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        ForEach(treat.parents, id: \.timestamp) { parent in
                            NavigationLink {
                                ParentsInfoView(parent: parent)
                            } label: {
                                Text(parent.fullName)
                                    .font(.caption)
                                    .foregroundColor(.blue)
                                    .underline()
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            if parent != treat.parents.last {
                                Text(", ")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
                
                if !treat.dogs.isEmpty {
                    HStack {
                        Text("Dogs: ")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        
                        ForEach(treat.dogs, id: \.timestamp) { dog in
                            NavigationLink {
                                DogInfoView(dog: dog, parent: dog.parent ?? treat.parents.first!)
                            } label: {
                                Text(dog.name)
                                    .font(.caption)
                                    .foregroundColor(.blue)
                                    .underline()
                            }
                            .buttonStyle(PlainButtonStyle())
                            
                            if dog != treat.dogs.last {
                                Text(", ")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
        .contentShape(Rectangle())
        .onTapGesture {
            showingTreatInfo = true
        }
        .sheet(isPresented: $showingTreatInfo) {
            NavigationView {
                TreatInfoView(treat: treat)
            }
        }
    }
}

#Preview {
    LessonDateCard(
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