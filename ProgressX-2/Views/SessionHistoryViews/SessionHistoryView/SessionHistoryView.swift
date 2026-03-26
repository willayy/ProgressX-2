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
            
    @StateObject private var viewModel = SessionHistoryViewModel()
    
    @Binding var selectedTrainingSession: TrainingSession?
    
    @FetchRequest(
        entity: ExerciseCategory.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \ExerciseCategory.categoryName, ascending: false)]
    ) private var categories: FetchedResults<ExerciseCategory>
    
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
            
            BoldSubHeadline(text: "Sets in " + (selectedTrainingSession?.timePeriodName ?? ""))
            
            HiddenLightSubHeadline(
                title: "What is shown in this list?",
                text: ("This is a list of all the sets in your completed in this session with their name, exercise, order preformed in session and the status of it's completion.")
            )
                .padding(.bottom, 10)
                .padding(.horizontal, 20)
            
            BasicList(
                height: 400,
                containerName: "",
                elementName: "Sets",
                data: _allTrainingSets
            ) { set in
                SetHistoryListItem(
                    set: set
                )
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
            
            BoldSubHeadline(text: "Targeted muscles")
            
            HiddenLightSubHeadline(title: "What is targeted muscles?", text: "The muscles targeted in this training session are shown on this muscle dummy.")
                .padding(.bottom, 10)
                .padding(.horizontal, 20)
            
            DisplayMusclesDummy(selectedMuscles: $viewModel.selectedCategories , categories: _categories)

        }.onAppear(perform: {
            
            viewModel.assignTrainingSetsFrom(selectedTrainingSession!)
            
            viewModel.assignCategoriesUsedIn(selectedTrainingSession!)
            
        })
    }
}

#Preview {
    
    let context = PersistenceController.previewViewContext
        
    let fetchRequest: NSFetchRequest = TrainingSession.fetchRequest()
    
    let results = CoreDataAccess.fetch(context, fetchRequest: fetchRequest)
    
    @State var selectedTrainingSession: TrainingSession? = results.first
        
    return SessionHistoryView(
        selectedTrainingSession: $selectedTrainingSession
    )
    .environmentObject(ShowMenuController())
    .environment(\.managedObjectContext, context)
    
}
