//
//  BasicRoutineListItem.swift
//  ProgressX-2
//
//  Created by lucas häyhänen on 2024-07-17.
//

import SwiftUI
import CoreData

struct TrainingViewRoutineListItem: View {
    
    @Binding var navPath: [Int]
    @Binding var selectedRoutine: Routine?
    @Binding var selectedSession: TrainingSession?
    @Binding var currentTrainingSet: TrainingSet?
    @ObservedObject var routine: Routine
    
    var body: some View {
        
        HStack {
            
            VStack(alignment: .leading) {
                
                Text(routine.timePeriodName ?? "")
                
                (Text("Created: ")
                    .fontWeight(.bold)
                 + Text("\(routine.creationDateString ?? "")"))
                .lineLimit(1)
                .minimumScaleFactor(0.6)
                
                (Text("Completed cycles: ")
                    .fontWeight(.bold)
                 + Text("\(routine.completedCycles!.count)"))
                .lineLimit(1)
                .minimumScaleFactor(0.6)
                
                (Text("Total weeks: ")
                    .fontWeight(.bold)
                 + Text("\(routine.weeksInRoutine.count)"))
                .lineLimit(1)
                .minimumScaleFactor(0.6)
                
                (Text("Current week: ")
                    .fontWeight(.bold)
                 + Text("\(routine.getNextWeek()?.timePeriodName! ?? "")"))
                .lineLimit(1)
                .minimumScaleFactor(0.6)
                
                (Text("Next session: ")
                    .fontWeight(.bold)
                 + Text("\(routine.getNextSession()?.timePeriodName! ?? "")"))
                .lineLimit(1)
                .minimumScaleFactor(0.6)
                
                let progress = routine.getNextTrainingCycle()?.getProgress() ?? 0
                
                ProgressBar(
                    height: 5,
                    progress: progress
                )
                
            }
            .frame(width: 200, height: 90, alignment: .leading)
            .padding(.vertical, 10)
            
            Spacer()
            
            Button(action: {
                selectedRoutine = routine
                navPath.append(1)
            }) { Image(systemName: "calendar") }
                .frame(width: 20)
                .padding(.horizontal, 10)
                .buttonStyle(BorderlessButtonStyle())
            
            Button(action: {
                selectedRoutine = routine
                let nextCycle = routine.getNextTrainingCycle()!
                let nextWeek = nextCycle.getNextTrainingWeek()
                let nextSession = nextWeek?.getNextTrainingSession()
                let currentSet = nextSession?.getNextTrainingSet()
                
                // There exists a next week/session/set
                // This should probably have some feedback for the user as well.
                if currentSet != nil {
                    selectedSession = nextSession
                    currentTrainingSet = currentSet
                    navPath.append(2)
                }
            }) { Image(systemName: "figure.run" ) }
                .frame(width: 20)
                .padding(.horizontal, 10)
                .buttonStyle(BorderlessButtonStyle())}
    }
}
