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
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center) {
                
                BoldTitle(text: "Statistics for \(String(exercise!.exerciseName!))")
                
                LightSubHeadline(text: "Here you can view graphs of your progress and scroll through all your achieved prs, you can edit them by pressing the pencil button.")
                
                if exercise is RepBasedExercise {
                    GeneralInfoRepsExercise(
                        exercise: exercise as? RepBasedExercise
                    ).environment(\.managedObjectContext, viewContext)
                } else if exercise is TimeBasedExercise {
                    GeneralInfoTimeExercise(
                        exercise: exercise as? TimeBasedExercise
                    ).environment(\.managedObjectContext, viewContext)
                }
                
                
                if exercise is RepBasedExercise {
                    SingleChart(
                        exercise: exercise as! RepBasedExercise,
                        set: "1RM",
                        entity: OneRepMax.entity()
                    ).environment(\.managedObjectContext, viewContext)
                    
                    PrList(
                        navPath: $navPath,
                        editingPr: $editingPr,
                        exercise: exercise,
                        entity: OneRepMax.entity(),
                        prType: "1RM"
                    ).environment(\.managedObjectContext, viewContext)
                    
                    DoubleChart(
                        exercise: exercise as! RepBasedExercise,
                        set: "AMRAP",
                        entity: MaxReps.entity()
                    ).environment(\.managedObjectContext, viewContext)
                    
                    PrList(
                        navPath: $navPath,
                        editingPr: $editingPr,
                        exercise: exercise,
                        entity: MaxReps.entity(),
                        prType: "AMRAP"
                    ).environment(\.managedObjectContext, viewContext)
                    
                } else if exercise is TimeBasedExercise {
                    DoubleChart(
                        exercise: exercise as! TimeBasedExercise,
                        set: "Time-max",
                        entity: TimeMax.entity()
                    ).environment(\.managedObjectContext, viewContext)
                    
                    PrList(
                        navPath: $navPath,
                        editingPr: $editingPr,
                        exercise: exercise,
                        entity: TimeMax.entity(),
                        prType: "Time-max"
                    ).environment(\.managedObjectContext, viewContext)
                }
            }
        }
    }
}

#Preview {
    
    let context = PersistenceController.preview.container.viewContext
    
    let fetchRequestRepBasedExercise: NSFetchRequest<RepBasedExercise> = RepBasedExercise.fetchRequest()
    
    let exerciseResult: [RepBasedExercise] = PersistenceController.fetch(context, fetchRequest: fetchRequestRepBasedExercise)

    @State var exercise: Exercise? = exerciseResult.first!
    
    @State var navPath: [Int] = [Int]()
    
    @State var editingPr: PersonalRecord? = nil
    
    return StatisticsView(
        exercise: $exercise,
        navPath: $navPath,
        editingPr: $editingPr
    ).environment(\.managedObjectContext, context)
}
