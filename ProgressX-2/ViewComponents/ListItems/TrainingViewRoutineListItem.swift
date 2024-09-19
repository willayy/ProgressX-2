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
                
                let routineName = routine.timePeriodName ?? "Not available"
                let routineCreationDate = routine.formattedCreatedOnDate ?? "Not available"
                let completedCycles = String(routine.completedCycles?.count ?? 0)
                let currentCycle = routine.nextTrainingCycle
                let totalNumberOfWeeks = String(currentCycle?.children.count ?? 0)
                let currentWeek = currentCycle?.nextTrainingWeek
                let currentWeekName = currentWeek?.timePeriodName ?? "Not available"
                let currentSession = currentWeek?.nextTrainingSession
                let currentSessionName = currentSession?.timePeriodName ?? "Not available"
                let routineProgress = currentCycle?.progress ?? 0
                
                Text(routineName)
                
                (
                    Text("Created: ")
                    .fontWeight(.bold)
                    + Text(routineCreationDate)
                )
                .lineLimit(1)
                .minimumScaleFactor(0.6)
                
                (
                    Text("Completed cycles: ")
                    .fontWeight(.bold)
                    + Text(completedCycles)
                )
                .lineLimit(1)
                .minimumScaleFactor(0.6)
                
                (
                    Text("Total weeks: ")
                    .fontWeight(.bold)
                    + Text(totalNumberOfWeeks)
                )
                .lineLimit(1)
                .minimumScaleFactor(0.6)
                
                (
                    Text("Current week: ")
                    .fontWeight(.bold)
                    + Text(currentWeekName)
                )
                .lineLimit(1)
                .minimumScaleFactor(0.6)
                
                (
                    Text("Next session: ")
                    .fontWeight(.bold)
                    + Text(currentSessionName)
                )
                .lineLimit(1)
                .minimumScaleFactor(0.6)
                
                ProgressBar(
                    height: 5,
                    progress: routineProgress
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
                let nextCycle = routine.nextTrainingCycle
                let nextWeek = nextCycle?.nextTrainingWeek
                let nextSession = nextWeek?.nextTrainingSession
                let currentSet = nextSession?.nextTrainingSet
                
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
