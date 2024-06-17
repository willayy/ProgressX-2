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
    
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var exercise: Exercise?
    @Binding var navPath: [Int]
    @Binding var editingPr: PersonalRecord?
    @Binding var newPrType: String?
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center) {
                
                BoldTitle(text: "Statistics for \(String(exercise!.exerciseName!))")
                
                LightSubHeadline(text: "Here you can view graphs of your progress and scroll through all your achieved prs, you can edit them by pressing the pencil button.")
                
                if exercise!.exerciseType == "reps" {
                    GeneralInfoRepsExercise(
                        exercise: exercise
                    ).environment(\.managedObjectContext, viewContext)
                } else if exercise!.exerciseType == "time" {
                    GeneralInfoTimeExercise(
                        exercise: exercise
                    ).environment(\.managedObjectContext, viewContext)
                }
                
                
                if exercise!.exerciseType == "reps" {
                    SingleChart(
                        exercise: exercise!,
                        set: "1RM",
                        prType: "onerepmax"
                    ).environment(\.managedObjectContext, viewContext)
                    
                    PrList(
                        navPath: $navPath,
                        editingPr: $editingPr,
                        exercise: exercise!,
                        prType: "onerepmax", 
                        newPrType: $newPrType
                    ).environment(\.managedObjectContext, viewContext)
                        
                    DoubleChart(
                        exercise: exercise!,
                        set: "AMRAP",
                        prType: "maxreps"
                    ).environment(\.managedObjectContext, viewContext)
                    
                    PrList(
                        navPath: $navPath,
                        editingPr: $editingPr,
                        exercise: exercise!,
                        prType: "maxreps", 
                        newPrType: $newPrType
                    ).environment(\.managedObjectContext, viewContext)
                    
                } else if exercise!.exerciseType == "time" {
                    DoubleChart(
                        exercise: exercise!,
                        set: "Time-max",
                        prType: "timemax"
                    ).environment(\.managedObjectContext, viewContext)
                    
                    PrList(
                        navPath: $navPath,
                        editingPr: $editingPr,
                        exercise: exercise!,
                        prType: "timemax", 
                        newPrType: $newPrType
                    ).environment(\.managedObjectContext, viewContext)
                }
            }
        }
    }
}

#Preview {
    
    let context = PersistenceController.preview.container.viewContext
    
    let fetchRequest: NSFetchRequest<Exercise> = Exercise.fetchRequest()
    
    let exerciseResult: [Exercise] = PersistenceController.fetch(context, fetchRequest: fetchRequest)

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
