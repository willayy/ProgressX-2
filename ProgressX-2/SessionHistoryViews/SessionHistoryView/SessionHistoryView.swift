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
            sortDescriptors: [],
            predicate: NSCompoundPredicate(type: .and, subpredicates: [NSPredicate(format: "trainingSession == %@", selectedTrainingSession!),
                                                                       NSPredicate(format: "trainingSession.isComplete == %@", NSNumber(booleanLiteral: true))])
        ) var allTrainingSets: FetchedResults<TrainingSet>
        
        ScrollView{
            BoldTitle(text: (selectedTrainingSession?.timePeriodName)!)
                .padding(.horizontal, 20)
            
            LightSubHeadline(text: ((selectedTrainingSession?.timePeriodDescription)! + " In routine " + ((selectedTrainingSession?.parent.parent.parent.timePeriodName) ?? "")))
                .padding(.bottom, 20)
                .padding(.horizontal, 20)
            
            let trainingsets = selectedTrainingSession?.trainingSets?.allObjects as! [TrainingSet]
            
            PieChart(data: SetsForChart(sets: trainingsets))
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
                    navPath: $navPath, selectedTrainingSet: $viewModel.selectedTrainingSet, set: set)
            
                }.padding(.horizontal, 20)
            }
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


