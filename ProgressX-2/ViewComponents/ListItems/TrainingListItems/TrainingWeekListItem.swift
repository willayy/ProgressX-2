//
//  TrainingWeekListItem.swift
//  ProgressX-2
//
//  Created by lucas häyhänen on 2024-07-18.
//

import SwiftUI

struct TrainingWeekListItem: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var navPath: [Int]
    @Binding var selectedTrainingWeek: TrainingWeek?
 
    @ObservedObject var week: TrainingWeek
    
    var body: some View {
        
        HStack {
            VStack(alignment: .leading) {
                
                Text(week.timePeriodName ?? "")
                
                (Text("Sessions: ")
                    .fontWeight(.bold)
                 + Text("\(week.trainingSessions?.count ?? 0)"))
                .lineLimit(1)
                .minimumScaleFactor(0.6)
        
            }
            .frame(width: 135, height: 20)
            .padding(.vertical, 10)
            
            Spacer()
            
            // MARK: Edit button
            Button(action: {
                selectedTrainingWeek = week
                navPath.append(2)
            }) { Image(systemName: "calendar") }
                .frame(width: 20)
                .padding(.horizontal, 10)
                .buttonStyle(BorderlessButtonStyle())
        

        }
    }
}
