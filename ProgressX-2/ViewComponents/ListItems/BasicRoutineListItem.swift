//
//  BasicRoutineListItem.swift
//  ProgressX-2
//
//  Created by lucas häyhänen on 2024-07-17.
//

import SwiftUI
import CoreData

struct BasicRoutineListItem: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var navPath: [Int]
    @Binding var selectedRoutine: Routine?
    @Binding var selectedTrainingCycle: TrainingCycle?
    @Binding var selectedTrainingWeek: TrainingWeek?
    @Binding var selectedTrainingSession: TrainingSession?
    
    @State private var showDeleteAlert: Bool = false
    @ObservedObject var routine: Routine
    
    var body: some View {
        
        HStack {
            
            VStack(alignment: .leading) {
                
                Text(routine.timePeriodName ?? "")
                
                (Text("Created: ")
                    .fontWeight(.bold)
                 + Text("\(routine.creationDateString)"))
                .lineLimit(1)
                .minimumScaleFactor(0.6)
                
                (Text("Completed cycles: ")
                    .fontWeight(.bold)
                 + Text("\(routine.completedCycles.count)"))
                .lineLimit(1)
                .minimumScaleFactor(0.6)
                
                (Text("Weeks: ")
                    .fontWeight(.bold)
                 + Text("\(routineWeekAmount1(routine: routine))"))
                .lineLimit(1)
                .minimumScaleFactor(0.6)
                
                Button {
                    
                } label: {
                    Text("Start workout")
                        .foregroundColor(Color("buttonTextColor"))
                }
        
            }
            .frame(width: 135, height: 55)
            .padding(.vertical, 10)
            
            Spacer()
            
            Button(action: {
                selectedRoutine = routine
                selectedTrainingCycle = routineCycle(routine: routine).first
                navPath.append(1)
            }) { Image(systemName: "calendar") }
                .frame(width: 20)
                .padding(.horizontal, 10)
                .buttonStyle(BorderlessButtonStyle())
            
            Button(action: {
                selectedRoutine = routine
                print(selectedRoutine?.timePeriodName)
                selectedTrainingCycle = routineCycle(routine: routine).first
                print(routineCycle(routine: routine).first?.trainingWeeks?.count)
                selectedTrainingWeek = routineWeeks(routine: routine).first
                print(selectedTrainingWeek?.timePeriodName)
                selectedTrainingSession = routineSessions(routine: routine).first
                print(selectedTrainingSession?.timePeriodName)
                
                navPath.append(2)
            }) { Image(systemName: "figure.run" ) }
                .frame(width: 20)
                .padding(.horizontal, 10)
                .buttonStyle(BorderlessButtonStyle())        }
    }
    
    private func routineWeekAmount1(routine: Routine) -> Int {
        let trainingWeeksFetchRequest: NSFetchRequest<TrainingWeek> = TrainingWeek.fetchRequest()
        trainingWeeksFetchRequest.predicate = NSPredicate(format: "trainingCycle.routine == %@", routine)
        let weekResults = PersistenceController.fetch(viewContext, fetchRequest: trainingWeeksFetchRequest)
        return weekResults.count
    }
    
    private func routineCycle(routine: Routine) -> [TrainingCycle] {
        let trainingCycleFetchRequest: NSFetchRequest<TrainingCycle> = TrainingCycle.fetchRequest()
        trainingCycleFetchRequest.predicate = NSPredicate(format: "routine == %@", routine)
        let CycleResults = PersistenceController.fetch(viewContext, fetchRequest: trainingCycleFetchRequest)
        return CycleResults
    }
    
    private func routineWeeks(routine: Routine) -> [TrainingWeek] {
        let trainingWeeksFetchRequest: NSFetchRequest<TrainingWeek> = TrainingWeek.fetchRequest()
        trainingWeeksFetchRequest.predicate = NSPredicate(format: "trainingCycle.routine == %@", routine)
        let weekResults = PersistenceController.fetch(viewContext, fetchRequest: trainingWeeksFetchRequest)
        return weekResults
    }
    
    private func routineSessions(routine: Routine) -> [TrainingSession] {
        let trainingSessionFetchRequest: NSFetchRequest<TrainingSession> = TrainingSession.fetchRequest()
        trainingSessionFetchRequest.predicate = NSPredicate(format: "trainingWeek.trainingCycle.routine == %@", routine)
        let sessionResults = PersistenceController.fetch(viewContext, fetchRequest: trainingSessionFetchRequest)
        return sessionResults
    }
    
    
    
    private func routineWeekAmount2(routine: Routine) -> Int {
        let trainingCycles = routine.trainingCycles!
        var weeks: [TrainingWeek] = []
        
        for cycle in trainingCycles.allObjects as! [TrainingCycle] {
            for week in cycle.trainingWeeks!.allObjects as! [TrainingWeek] {
                weeks.append(week)
            }
        }
        
        return weeks.count
    }
    
}
