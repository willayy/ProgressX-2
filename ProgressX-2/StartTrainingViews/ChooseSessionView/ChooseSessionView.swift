//
//  ChooseSessionView.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-08-05.
//

import SwiftUI
import CoreData

struct ChooseSessionView: View {
    
    @Binding var navPath: [Int]
    @Binding var selectedTrainingWeek: TrainingWeek?
    @Binding var selectedTrainingSession: TrainingSession?
    @Binding var currentTrainingSet: TrainingSet?
    
    var body: some View {
        
        @FetchRequest(
            entity: TrainingSession.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \TrainingSession.positionIndex, ascending: true)],
            predicate: NSPredicate(format: "trainingWeek == %@", selectedTrainingWeek!)
        ) var trainingSessions: FetchedResults<TrainingSession>
        
        ScrollView {
            
            VStack(alignment: .center) {
                
                BoldTitle(text: "Sessions in")
                
                Title2(text: selectedTrainingWeek!.timePeriodName!)
                
                LightSubHeadline(text: "Here you can choose a specific session you would like to start on")
                    .padding(.vertical)
                    .padding(.horizontal)
                
                BasicList(
                    height: 400,
                    containerName: "this week",
                    elementName: "sessions",
                    data: _trainingSessions)
                { session in
                    TrainingSessionListItem(
                        navPath: $navPath,
                        selectedTrainingSession: $selectedTrainingSession,
                        currentTrainingSet: $currentTrainingSet,
                        trainingSession: session
                    )
                }
                .padding(.horizontal,20)
            
            }
        }
    }
}

#Preview {
    
    let context = PersistenceController.previewViewContext
    
    @State var navPath: [Int] = [Int]()
    
    let trainingWeekFetchRequest: NSFetchRequest = TrainingWeek.fetchRequest()
    let trainingWeeks = CoreDataAccess.fetch(context, fetchRequest: trainingWeekFetchRequest)
    @State var selectedTrainingWeek: TrainingWeek? = trainingWeeks.first
    
    let trainingSessionFetchRequest: NSFetchRequest = TrainingSession.fetchRequest()
    let trainingSessions = CoreDataAccess.fetch(context, fetchRequest: trainingSessionFetchRequest)
    @State var selectedTrainingSession: TrainingSession? = trainingSessions.first
    
    @State var currentTrainingSet: TrainingSet? = nil
    
    return ChooseSessionView(
        navPath: $navPath,
        selectedTrainingWeek: $selectedTrainingWeek,
        selectedTrainingSession: $selectedTrainingSession, 
        currentTrainingSet: $currentTrainingSet
    )
}

