//
//  SessionHistoryView.swift
//  ProgressX-2
//
//  Created by lucas häyhänen on 2024-08-14.
//

import Foundation
import SwiftUI
import CoreData

struct SessionHistoryView: View {
    
    @Binding var navPath: [Int]
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var viewModel = SessionHistoryViewModel()
    @Binding var selectedTrainingSession: TrainingSession?
    
    var body: some View {
        
        @FetchRequest(
            entity: TrainingSet.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \TrainingSet.positionIndex, ascending: true)],
            predicate: NSCompoundPredicate(
                type: .and,
                subpredicates: [
                    NSPredicate(format: "trainingSession == %@", selectedTrainingSession!),
                    NSPredicate(format: "trainingSession.isComplete == %@", NSNumber(booleanLiteral: true))
                ]
            )
        ) var allTrainingSets: FetchedResults<TrainingSet>
        
        ScrollView {
            
            BoldTitle(text: (selectedTrainingSession?.timePeriodName)!)
                .padding(.horizontal, 20)
            
            LightSubHeadline(text: ((selectedTrainingSession?.timePeriodDescription)! + " In routine " + ((selectedTrainingSession?.parent.parent.parent.timePeriodName) ?? "")))
                .padding(.bottom, 20)
                .padding(.horizontal, 20)
            
            PieChart(data: selectedTrainingSession!.setsCompletionData)
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
                .frame(height: 300)
            
            BasicList(
                height: 400,
                containerName: "",
                elementName: "Sets",
                data: _allTrainingSets)
            { set in
                SetHistoryListItem(
                    navPath: $navPath,
                    selectedTrainingSet: $viewModel.selectedTrainingSet,
                    set: set
                )
            }
            .padding(.horizontal, 20)
        }
    }
}

#Preview {
    
    @State var navPath = [Int]()
    
    let context = PersistenceController.previewViewContext
    
    let request: NSFetchRequest<TrainingSession> = TrainingSession.fetchRequest()
    
    let results = CoreDataAccess.fetch(context, fetchRequest: request)
    
    @State var trainingSession = results.first
    
    return SessionHistoryView(
        navPath: $navPath,
        selectedTrainingSession: $trainingSession
    )
    .environment(\.managedObjectContext, context)

    
    
}
