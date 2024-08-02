//
//  CalendarHeaderView.swift
//  MyWorkouts
//
//  Created by Scholar on 8/1/24.
//

import SwiftUI
import SwiftData

struct CalendarHeaderView: View {
    @State private var monthDate = Date.now
    @State private var years: [Int] = []
    @State private var selectedMonth = Date.now.monthInt
    @State private var selectedYear = Date.now.yearInt
    @Query private var workouts: [Workout]
    @Query(sort: \Activity.name) private var activites: [Activity]
    @State private var selectedActivity: Activity?
    let months = Date.fullMonthNames
    var body: some View {
        NavigationStack{
            VStack{
                Picker("", selection: $selectedActivity){
                    Text("All").tag(nil as Activity?)
                    ForEach(activites) { activity in
                        Text(activity.name).tag(activity as Activity?)
                        
                    }
                }
                .buttonStyle(.borderedProminent)
                HStack{
                    Picker("", selection: $selectedYear){
                        ForEach(years, id: \.self) { year in
                            Text(String(year))
                        }
                    }
                    Picker("", selection: $selectedMonth){
                        ForEach(months.indices, id: \.self) { index in
                            Text(months[index]).tag(index + 1)
                        }
                    }
                }
                .buttonStyle(.bordered)
                secondView(date: monthDate, selectedActivity: selectedActivity)
                Spacer()
            }
            .navigationTitle("Calander")
        }
        .onAppear {
            years = Array(Set(workouts.map {$0.date.yearInt}.sorted()))
        }
        .onChange(of: selectedYear) {
            updateData()
        }
        .onChange(of: selectedMonth) {
            updateData()
        }
    }
    
    func updateData() {
        monthDate = Calendar.current.date(from: DateComponents(year: selectedYear, month: selectedMonth, day: 1))!
    }
}

#Preview {
    CalendarHeaderView()
        .modelContainer(Activity.preview)
}
