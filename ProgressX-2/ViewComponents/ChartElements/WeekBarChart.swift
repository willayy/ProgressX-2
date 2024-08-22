//
//  BarChart.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-16.
//

import SwiftUI
import Charts
import CoreData

private struct WeekDayData: Identifiable {
    var id = UUID()
    var day: String
    var sessions: Int
}

struct WeekBarChart: View {
    
    private var weekDayData: [WeekDayData]
    
    init(trainingSessions: [TrainingSession]) {
        
        // Order of the weekdays
        let customOrder = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
        
        // A dictionary to keep track of the count
        var sessionDictionary: [String : Int] = [:]
        for day in customOrder { sessionDictionary[day] = 0 }
        
        // Count all the sessions
        for session in trainingSessions {
            sessionDictionary[session.completedOnDayString!]! += 1
        }
        
        // Make them into weekdays
        let unsortedWeekDayData = sessionDictionary.map {
            WeekDayData(day: $0.key, sessions: $0.value)
        }
        
        // Sort and assign the data
        self.weekDayData = unsortedWeekDayData.sorted(by: {
            customOrder.firstIndex(of: $0.day)! < customOrder.firstIndex(of: $1.day)!
        })
    }
    
    var body: some View {
        GroupBox {
            Chart {
                ForEach(weekDayData) { data in
                    BarMark(
                        x: .value("Day", data.day),
                        y: .value("Value", data.sessions)
                    )
                    .foregroundStyle(.green)
                }
            }
        }
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    let sessions = CoreDataAccess.getAllSessionsDoneThisWeek(context)
    
    return WeekBarChart(trainingSessions: sessions)
        .padding()
}
