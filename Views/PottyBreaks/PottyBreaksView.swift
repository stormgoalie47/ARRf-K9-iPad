//
//  PottyBreaksView.swift
//  ARRf K9 iPad
//
//  Created by Addison Reed on 7/26/25.
//

import SwiftUI
import SwiftData

struct PottyBreaksView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var allTreats: [Treat]
    
    @State private var selectedDate = Date()
    @State private var navigationPath = NavigationPath()
    
    private var allLessonDates: [Date] {
        let allDates = allTreats.flatMap { $0.lessonDates }
        let normalizedDates = allDates.map { stripTimeFromDate($0) }
        return Array(Set(normalizedDates)).sorted() // Remove duplicates and sort
    }
    
    private func stripTimeFromDate(_ date: Date) -> Date {
        return Calendar.current.startOfDay(for: date)
    }
    
    private var datesWithLessons: [Date: [Treat]] {
        var dateMap: [Date: [Treat]] = [:]
        for treat in allTreats {
            for lessonDate in treat.lessonDates {
                let normalizedDate = stripTimeFromDate(lessonDate)
                dateMap[normalizedDate, default: []].append(treat)
            }
        }
        return dateMap
    }
    
    private var futureTreats: [Treat] {
        let today = Calendar.current.startOfDay(for: Date())
        return allTreats.filter { treat in
            treat.lessonDates.contains { lessonDate in
                let lessonDay = Calendar.current.startOfDay(for: lessonDate)
                return lessonDay >= today
            }
        }.sorted { treat1, treat2 in
            let earliestDate1 = treat1.lessonDates.min() ?? Date.distantFuture
            let earliestDate2 = treat2.lessonDates.min() ?? Date.distantFuture
            return earliestDate1 < earliestDate2
        }
    }

    var body: some View {
        NavigationStack(path: $navigationPath) {
            HStack(spacing: 0) {
                // Left Section - Calendar and Events
                VStack(spacing: 0) {
                    // Calendar View
                    CustomCalendarView(
                        selectedDate: $selectedDate,
                        datesWithEvents: allLessonDates
                    )
                    .padding()
                    
                    // Events for Selected Date
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Lessons on \(selectedDate, format: .dateTime.day().month().year())")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        let normalizedSelectedDate = stripTimeFromDate(selectedDate)
                        if let lessonsForDate = datesWithLessons[normalizedSelectedDate] {
                            if lessonsForDate.isEmpty {
                                Text("No lessons scheduled")
                                    .foregroundColor(.secondary)
                                    .italic()
                                    .padding(.horizontal)
                            } else {
                                ScrollView {
                                    LazyVStack(spacing: 8) {
                                        ForEach(lessonsForDate, id: \.timestamp) { treat in
                                            LessonDateCard(treat: treat)
                                        }
                                    }
                                    .padding(.horizontal)
                                }
                            }
                        } else {
                            Text("No lessons scheduled")
                                .foregroundColor(.secondary)
                                .italic()
                                .padding(.horizontal)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(.systemGray6))
                
                // Right Section - Future Events
                VStack(spacing: 0) {
                    if futureTreats.isEmpty {
                        VStack {
                            Spacer()
                            Text("No upcoming training packages")
                                .foregroundColor(.secondary)
                                .italic()
                            Spacer()
                        }
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(futureTreats, id: \.timestamp) { treat in
                                    FutureTreatCard(treat: treat)
                                }
                            }
                            .padding()
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color(.systemGray6))
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Today") {
                        selectedDate = Date()
                    }
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("ResetNavigation"))) { notification in
            if let userInfo = notification.userInfo,
               let tab = userInfo["tab"] as? Int,
               tab == 2 { // PottyBreaks tab
                navigationPath = NavigationPath()
            }
        }
    }
}

#Preview {
    PottyBreaksView()
}
