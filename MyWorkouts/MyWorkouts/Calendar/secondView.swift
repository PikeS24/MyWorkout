//
//  secondView.swift
//  ProTasker
//
//  Created by Scholar on 7/31/24.
//

import SwiftUI
import SwiftData

struct secondView: View {
    let date: Date
    let daysOfWeek = Date.capitalizedFirstLettersOfWeekdays
    let columns = Array(repeating: GridItem(.flexible()), count: 7)
    @State private var days: [Date] = []
    let selectedActivity: Activity?
    @Query private var workouts: [Workout]
    @State private var counts = [Int : Int]()
    
    init(date: Date, selectedActivity: Activity?){
        self.date = date
        self.selectedActivity = selectedActivity
        let endOfMonthAdjustment = Calendar.current.date(byAdding: .day, value: -1, to: date.endOfMonth)!
        let predicate = #Predicate<Workout> {$0.date >= date.startOfMonth && $0.date <= endOfMonthAdjustment}
        _workouts = Query(filter: predicate, sort: \Workout.date)
    }
    var body: some View {
        let color = selectedActivity == nil ? .blue : Color(hex: selectedActivity!.hexColor)!
        VStack {
            HStack {
                ForEach(daysOfWeek.indices, id: \.self) { index in
                Text(daysOfWeek[index])
                        .fontWeight(.black)
                        .frame(maxWidth: .infinity)
                }
            }
            LazyVGrid(columns: columns) {
                ForEach(days, id: \.self) { day in
                    if day.monthInt != date.monthInt {
                        Text("")
                    } else {
                        Text(day.formatted(.dateTime.day()))
                            .fontWeight(.bold)
                            .foregroundStyle(.secondary)
                            .frame(maxWidth: .infinity, minHeight: 40)
                            .background(
                                Circle()
                                    .foregroundStyle(
                                        Date.now.startOfDay == day.startOfDay
                                        ? .red.opacity(counts[day.dayInt] != nil ? 0.8 : 0.3)
                                        : .blue.opacity(counts[day.dayInt] != nil ? 0.8 : 0.3)
                                    )
                            )
                            .overlay(alignment: .bottomTrailing){
                                if let count = counts[day.dayInt] {
                                    Image(systemName: count <= 50 ? "\(count).circle.fill" : "plus.circle.fill")
                                        .foregroundColor(.secondary)
                                        .imageScale(/*@START_MENU_TOKEN@*/.medium/*@END_MENU_TOKEN@*/)
                                        .background(
                                            Color(.systemBackground)
                                                .clipShape(.circle)
                                        )
                                        .offset(x: 5, y: 5)
                                }
                            }
                    }
                }
            }
        }
        .padding()
        .onAppear {
            days = date.calendarDisplayDays
            setupCounts()
        }
        .onChange(of: date) {
            days = date.calendarDisplayDays
            setupCounts()
        }
        .onChange(of: selectedActivity) {
            setupCounts()
        }
    }
    func setupCounts() {
        var filteredWorkouts = workouts
        if let selectedActivity {
            filteredWorkouts = workouts.filter {$0.activity == selectedActivity}
        }
        let mappedItems = filteredWorkouts.map{($0.date.dayInt, 1)}
        counts = Dictionary(mappedItems, uniquingKeysWith: +)
    }
    
}

#Preview {
    secondView(date: Date.now, selectedActivity: nil)
        .modelContainer(Activity.preview)
}
