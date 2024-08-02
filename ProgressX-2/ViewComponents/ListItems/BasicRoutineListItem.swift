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
    @Binding var AllTrainingSets: [TrainingSet]
    @Binding var currentTrainingSet: TrainingSet?
    @Binding var exercise: Exercise?
    
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
                 + Text("\(routine.completedCycles!.count)"))
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
                selectedTrainingCycle = routineCycle(routine: routine).first
                selectedTrainingWeek = routineWeeks(routine: routine).first
                selectedTrainingSession = routineSessions(routine: routine).first
                AllTrainingSets = routineSet(Session: selectedTrainingSession!)
                currentTrainingSet = AllTrainingSets.first(where: {!$0.isComplete})
                exercise = currentTrainingSet?.exercise
                
                navPath.append(2)
            }) { Image(systemName: "figure.run" ) }
                .frame(width: 20)
                .padding(.horizontal, 10)
                .buttonStyle(BorderlessButtonStyle())}
    }
    
    private func routineWeekAmount1(routine: Routine) -> Int {
        let trainingWeeksFetchRequest: NSFetchRequest<TrainingWeek> = TrainingWeek.fetchRequest()
        trainingWeeksFetchRequest.predicate = NSPredicate(format: "trainingCycle.routine == %@", routine)
        let weekResults = PersistenceController.fetch(viewContext, fetchRequest: trainingWeeksFetchRequest)
        return weekResults.count
    }
    
    private func routineCycle(routine: Routine) -> [TrainingCycle] {
        let trainingCycleFetchRequest: NSFetchRequest<TrainingCycle> = TrainingCycle.fetchRequest()
        let compound1 = NSCompoundPredicate(type: .and, subpredicates: [NSPredicate(format: "routine == %@", routine), NSPredicate(format: "isComplete == %@", NSNumber(value: false))])
        trainingCycleFetchRequest.predicate = compound1
        let CycleResults = PersistenceController.fetch(viewContext, fetchRequest: trainingCycleFetchRequest)
        return CycleResults
    }
    
    private func routineWeeks(routine: Routine) -> [TrainingWeek] {
        let trainingWeeksFetchRequest: NSFetchRequest<TrainingWeek> = TrainingWeek.fetchRequest()
        let compound1 = NSCompoundPredicate(type: .and, subpredicates: [NSPredicate(format: "trainingCycle.routine == %@", routine),NSPredicate(format: "isComplete == %@", NSNumber(value: false))])
        trainingWeeksFetchRequest.predicate = compound1
        let weekResults = PersistenceController.fetch(viewContext, fetchRequest: trainingWeeksFetchRequest)
        return weekResults
    }
    
    private func routineSessions(routine: Routine) -> [TrainingSession] {
        let trainingSessionFetchRequest: NSFetchRequest<TrainingSession> = TrainingSession.fetchRequest()
        let compound1 = NSCompoundPredicate(type: .and, subpredicates: [NSPredicate(format: "trainingWeek.trainingCycle.routine == %@", routine),NSPredicate(format: "isComplete == %@", NSNumber(value: false))])
        trainingSessionFetchRequest.predicate = compound1
        let sessionResults = PersistenceController.fetch(viewContext, fetchRequest: trainingSessionFetchRequest)
        return sessionResults
    }
    
    private func routineSet(Session: TrainingSession) -> [TrainingSet] {
        let trainingSetFetchRequest: NSFetchRequest<TrainingSet> = TrainingSet.fetchRequest()
        let compound1 = NSCompoundPredicate(type: .and, subpredicates: [NSPredicate(format: "trainingSession == %@", Session),NSPredicate(format: "isComplete == %@", NSNumber(value: false))])
        trainingSetFetchRequest.predicate = compound1
        let SetResults = PersistenceController.fetch(viewContext, fetchRequest: trainingSetFetchRequest)
        return SetResults
    }
    
}
