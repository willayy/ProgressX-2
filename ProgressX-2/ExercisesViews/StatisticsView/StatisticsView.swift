//
//  StatisticsView.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-05-19.
//

import SwiftUI
import Charts
import CoreData

struct StatisticsView: View {
    
    @Binding var exercise: Exercise?
    @Binding var navPath: [Int]
    @Binding var editingPr: PersonalRecord?
    @Binding var newPrType: String?
    @State private var displayedPrType = "onerepmax"
    
    private let prSegments: [String : String] = [
        "AMRAP" : "maxreps",
        "1RM" : "onerepmax"
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center) {
                
                BoldTitle(text: "Statistics for")
                    .padding(.horizontal, 20)
                
                Title2(text: "\(String(exercise!.exerciseName!))")
                
                if exercise!.exerciseType == "reps" {
                    BoldSubHeadline(text: "Do you want to view your AMRAP Pr's for this Exercise or your 1RM Pr's?")
                        .padding(.top, 20)
                        .padding(.horizontal, 20)
                    
                    BasicSegPicker(
                        selectedSegment: $displayedPrType,
                        segments: prSegments
                    )
                    .padding(.horizontal, 20)
                }
                
                if exercise!.exerciseType == "reps" {
                    GeneralInfoRepsExercise(
                        exercise: exercise, 
                        selection: displayedPrType
                    )
                    .padding(.horizontal, 20)
                } else if exercise!.exerciseType == "time" {
                    GeneralInfoTimeExercise(
                        exercise: exercise
                    )
                    .padding(.horizontal, 20)
                }
                
                if exercise!.exerciseType == "reps" {
                    
                    if displayedPrType == "onerepmax" {
                        SingleChart(
                            exercise: exercise!,
                            set: "1RM",
                            prType: "onerepmax"
                        )
                        .padding(.horizontal, 20)
                        
                        PrList(
                            height: 500,
                            navPath: $navPath,
                            editingPr: $editingPr,
                            exercise: exercise!,
                            prType: "onerepmax",
                            newPrType: $newPrType
                        )
                        .padding(.horizontal, 20)
                        
                    } else {
                        
                        DoubleChart(
                            exercise: exercise!,
                            set: "AMRAP",
                            prType: "maxreps"
                        )
                        .padding(.horizontal, 20)
                        
                        PrList(
                            height: 500,
                            navPath: $navPath,
                            editingPr: $editingPr,
                            exercise: exercise!,
                            prType: "maxreps",
                            newPrType: $newPrType
                        )
                        .padding(.horizontal, 20)
                    }
                    
                } else if exercise!.exerciseType == "time" {
                    
                    DoubleChart(
                        exercise: exercise!,
                        set: "Time-max",
                        prType: "timemax"
                    )
                    .padding(.horizontal, 20)
                    
                    PrList(
                        height: 500,
                        navPath: $navPath,
                        editingPr: $editingPr,
                        exercise: exercise!,
                        prType: "timemax", 
                        newPrType: $newPrType
                    )
                    .padding(.horizontal, 20)
                }
            }
        }
    }
}

#Preview {
    
    let context = PersistenceController.previewViewContext
    
    let fetchRequest: NSFetchRequest<Exercise> = Exercise.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "exerciseType == %@", "reps")
    
    let exerciseResult: [Exercise] = CoreDataAccess.fetch(context, fetchRequest: fetchRequest)

    @State var exercise: Exercise? = exerciseResult.first!
    
    @State var navPath: [Int] = [Int]()
    
    @State var editingPr: PersonalRecord? = nil
    
    @State var newPrType: String? = nil
    
    return StatisticsView(
        exercise: $exercise,
        navPath: $navPath,
        editingPr: $editingPr, 
        newPrType: $newPrType
    ).environment(\.managedObjectContext, context)
}
