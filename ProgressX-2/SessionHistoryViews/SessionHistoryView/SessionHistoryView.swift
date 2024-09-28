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
    @Binding var selectedTrainingSet: TrainingSet?
    
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
            
            LightSubHeadline(text: ("This is a list of all the sets in your completed session with their name, exercise, order preformed in session and status of their completion."))
                .padding(.bottom, 10)
                .padding(.horizontal, 20)
            
            BasicList(
                height: 400,
                containerName: "",
                elementName: "Sets",
                data: _allTrainingSets)
            { set in
                SetHistoryListItem(
                    navPath: $navPath, selectedTrainingSet: $selectedTrainingSet, set: set)
            
                }.padding(.horizontal, 20)
                .padding(.bottom, 20)
            
            BoldSubHeadline(text: "Targeted muscles")
            
            LightSubHeadline(text: ("This dummy displays what muscle groups your workout targeted"))
                .padding(.bottom, 10)
                .padding(.horizontal, 20)
            
            DisplayMusclesDummy(selectedMuscles: $viewModel.selectedCategories , categories: _categories)

        }.onAppear(perform: {
            fillSett()
            exercisecategorys()
        })
    }
    
    
    public func fillSett() -> Void{
        viewModel.selectedTrainingSets = selectedTrainingSession?.trainingSets?.allObjects as! [TrainingSet]
    }
    
    public func exercisecategorys() -> Void {
        var displayset: Set<ExerciseCategory> = Set()
        for set in viewModel.selectedTrainingSets{
                var categories = set.exercise?.categories?.allObjects as! [ExerciseCategory]
                for category in categories{
                    displayset.insert(category)
                }
            }
        viewModel.selectedCategories = displayset
        }
    
    
    }

    public func SetsForChart(sets: [TrainingSet]) -> [String:Int]{
        var colection:[String:Int] = ["Completed full set":0, "Completed with less reps": 0, "Skipped set": 0]
        for trainingset in sets{
            if trainingset.quantityDone < trainingset.quantityTodo && trainingset.quantityDone > 0{
                colection["Completed with less reps"]! += 1
            } else if trainingset.quantityDone == trainingset.quantityTodo {
                colection["Completed full set"]! += 1
            } else {
                colection["Skipped set"]! += 1
            }
        }
        
        return colection
    }


