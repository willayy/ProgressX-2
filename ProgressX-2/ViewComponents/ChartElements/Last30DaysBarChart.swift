//
//  MonthBarChart.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-16.
//

import SwiftUI
import Charts
import CoreData

private struct Last30DaysData: Identifiable {
    var id = UUID()
    var day: String
    var sessions: Int
}

struct Last30DaysBarChart: View {
    
    private let last30DaysData: [Last30DaysData]
    
    init(trainingSessions: [TrainingSession]) {
        
        // A dictionary to keep track of how many days ago a session was completed
        var sessionDictionary: [String : Int] = [:]
        for daysago in 0...30 { sessionDictionary[String(daysago)] = 0 }
        
        for session in trainingSessions {
            sessionDictionary[session.completedDaysAgo!]! += 1
        }
        
        let unsortedMonthDayData = sessionDictionary.map {
            Last30DaysData(day: $0.key, sessions: $0.value)
        }
        
        self.last30DaysData = unsortedMonthDayData.sorted(by: {
            Int($0.day)! > Int($1.day)!

        })
        
    }
    
    var body: some View {
        GroupBox {
            ScrollView(.horizontal) {
                Chart {
                    ForEach(last30DaysData) { data in
                        BarMark(
                            x: .value("Day", data.day),
                            y: .value("Value", data.sessions)
                        )
                        .foregroundStyle(.blue)
                    }
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 20)
                .frame(width: 750)
            }
        }
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    let fetchRequest: NSFetchRequest<Profile> = Profile.fetchRequest()
    let results = PersistenceController.fetch(context, fetchRequest: fetchRequest)
    let profile = results.first!
    let sessions = profile.getSessionsCompletedLast30days
    
    return Last30DaysBarChart(trainingSessions: sessions)
        .padding()
}
