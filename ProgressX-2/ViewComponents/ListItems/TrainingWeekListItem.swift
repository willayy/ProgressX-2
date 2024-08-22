//
//  TrainingWeekListItem.swift
//  ProgressX-2
//
//  Created by lucas häyhänen on 2024-07-18.
//

import SwiftUI

struct TrainingWeekListItem: View {
    
    @Binding var navPath: [Int]
    @Binding var selectedTrainingWeek: TrainingWeek?
    @ObservedObject var trainingWeek: TrainingWeek
    
    var body: some View {
        
        HStack {
            VStack(alignment: .leading) {
                
                Text(trainingWeek.timePeriodName ?? "")
                
                (Text("Total sessions: ")
                    .fontWeight(.bold)
                 + Text("\(trainingWeek.trainingSessions?.count ?? 0)"))
                .lineLimit(1)
                .minimumScaleFactor(0.6)
                
                (Text("Next session: ")
                    .fontWeight(.bold)
                 + Text("\(trainingWeek.nextTrainingSession?.timePeriodName! ?? "Finished")"))
                .lineLimit(1)
                .minimumScaleFactor(0.6)
                
                let progress = trainingWeek.progress
                
                ProgressBar(
                    height: 5,
                    progress: progress
                )
        
            }
            .frame(width: 200, height: 35, alignment: .leading)
            .padding(.vertical, 10)
            
            Spacer()
            
            if !trainingWeek.isComplete {
                
                // MARK: Edit button
                Button(action: {
                    selectedTrainingWeek = trainingWeek
                    navPath.append(4)
                }) { Image(systemName: "calendar") }
                    .frame(width: 20)
                    .padding(.horizontal, 10)
                    .buttonStyle(BorderlessButtonStyle())
                
            } else {
                
                Image(systemName: "checkmark.seal.fill")
                    .frame(width: 20)
                    .padding(.horizontal, 10)
                    .foregroundStyle(.green)
                
            }
        }
    }
}
