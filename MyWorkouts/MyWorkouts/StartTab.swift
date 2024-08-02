//
//  StartTab.swift
//  MyWorkouts
//
//  Created by Scholar on 8/1/24.
//

import SwiftUI
import SwiftData

struct StartTab: View {
    var body: some View {
        TabView {
            ActivityListView()
                .tabItem {
                    Label ("Classes", systemImage: "pencil")
                }
            CalendarHeaderView()
                .tabItem {
                    Label("Calendar", systemImage: "calendar")
                }
        }
    }
}

#Preview {
    StartTab()
        .modelContainer(Activity.preview)
}
