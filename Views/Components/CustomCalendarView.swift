//
//  CustomCalendarView.swift
//  ARRf K9 iPad
//
//  Created by Addison Reed on 7/26/25.
//

import SwiftUI

struct CustomCalendarView: View {
    @Binding var selectedDate: Date
    let datesWithEvents: [Date]
    
    private let calendar = Calendar.current
    private let dateFormatter = DateFormatter()
    
    @State private var currentMonth = Date()
    
    private var monthDates: [(date: Date, isPadding: Bool)] {
        let startOfMonth = calendar.dateInterval(of: .month, for: currentMonth)?.start ?? currentMonth
        let endOfMonth = calendar.dateInterval(of: .month, for: currentMonth)?.end ?? currentMonth
        
        // Get the first day of the month
        let firstDayOfMonth = startOfMonth
        
        // Get the weekday of the first day (1 = Sunday, 2 = Monday, etc.)
        let firstWeekday = calendar.component(.weekday, from: firstDayOfMonth)
        
        // Calculate how many padding days we need at the start
        // We want the first day to align with its correct weekday column
        let paddingDays = firstWeekday - 1 // Subtract 1 because we want Sunday to be column 0
        
        var dates: [(date: Date, isPadding: Bool)] = []
        
        // Add padding days (empty cells for days before the month starts)
        for _ in 0..<paddingDays {
            dates.append((date: Date(), isPadding: true))
        }
        
        // Add all the days in the month
        var currentDate = firstDayOfMonth
        while currentDate < endOfMonth {
            dates.append((date: currentDate, isPadding: false))
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate) ?? currentDate
        }
        
        return dates
    }
    
    private var weekDays: [String] {
        dateFormatter.shortWeekdaySymbols
    }
    
    private var monthYearString: String {
        dateFormatter.dateFormat = "MMMM yyyy"
        return dateFormatter.string(from: currentMonth)
    }
    
    private func hasEvent(on date: Date) -> Bool {
        let normalizedDate = calendar.startOfDay(for: date)
        return datesWithEvents.contains { eventDate in
            calendar.startOfDay(for: eventDate) == normalizedDate
        }
    }
    
    private func isSelected(_ date: Date) -> Bool {
        calendar.startOfDay(for: date) == calendar.startOfDay(for: selectedDate)
    }
    
    private func isToday(_ date: Date) -> Bool {
        calendar.startOfDay(for: date) == calendar.startOfDay(for: Date())
    }
    
    var body: some View {
        VStack(spacing: 16) {
            // Month/Year Header
            HStack {
                Button(action: previousMonth) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                }
                
                Spacer()
                
                Text(monthYearString)
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button(action: nextMonth) {
                    Image(systemName: "chevron.right")
                        .font(.title2)
                }
            }
            .padding(.horizontal)
            
            // Week Days Header
            HStack {
                ForEach(weekDays, id: \.self) { day in
                    Text(day)
                        .font(.caption)
                        .fontWeight(.medium)
                        .frame(maxWidth: .infinity)
                }
            }
            
            // Calendar Grid
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
                ForEach(Array(monthDates.enumerated()), id: \.offset) { index, dateInfo in
                    if dateInfo.isPadding {
                        // Padding cell - empty space
                        VStack(spacing: 2) {
                            Text("")
                                .font(.body)
                                .frame(width: 32, height: 32)
                            
                            Circle()
                                .fill(Color.clear)
                                .frame(width: 4, height: 4)
                        }
                    } else {
                        // Actual date cell
                        VStack(spacing: 2) {
                            Text("\(calendar.component(.day, from: dateInfo.date))")
                                .font(.body)
                                .fontWeight(isSelected(dateInfo.date) ? .bold : .regular)
                                .foregroundColor(isToday(dateInfo.date) ? .white : .primary)
                                .frame(width: 32, height: 32)
                                .background(
                                    Circle()
                                        .fill(isSelected(dateInfo.date) ? Color.blue : (isToday(dateInfo.date) ? Color.gray : Color.clear))
                                )
                            
                            if hasEvent(on: dateInfo.date) {
                                Circle()
                                    .fill(Color.blue)
                                    .frame(width: 4, height: 4)
                            } else {
                                Circle()
                                    .fill(Color.clear)
                                    .frame(width: 4, height: 4)
                            }
                        }
                        .onTapGesture {
                            selectedDate = dateInfo.date
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical)
    }
    
    private func previousMonth() {
        if let newMonth = calendar.date(byAdding: .month, value: -1, to: currentMonth) {
            currentMonth = newMonth
        }
    }
    
    private func nextMonth() {
        if let newMonth = calendar.date(byAdding: .month, value: 1, to: currentMonth) {
            currentMonth = newMonth
        }
    }
}

#Preview {
    CustomCalendarView(
        selectedDate: .constant(Date()),
        datesWithEvents: [Date(), Calendar.current.date(byAdding: .day, value: 5, to: Date()) ?? Date()]
    )
} 