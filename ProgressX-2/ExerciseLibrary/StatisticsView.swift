//
//  StatisticsView.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-05-19.
//

import SwiftUI
import Charts

struct StatisticsView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @Binding public var exercise: Exercise?
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center) {
                
                BoldTitle(text: "Statistics for \(String(describing: exercise!.exerciseName!))")
                
                LightSubHeadline(text: "Here you can view graphs of your progress and scroll through all your achieved prs, you can edit them by pressing the pencil button.")
            
                GeneralExerciseInformation(exercise: exercise!)
                    .environment(\.managedObjectContext, viewContext)
                
                if exercise is RepBasedExercise {
                    OneRepMaxChart(exercise: exercise as! RepBasedExercise)
                        .environment(\.managedObjectContext, viewContext)
                        
                } else if exercise is TimeBasedExercise {
                    // Chart
                }
            }
        }
    }
}

#Preview {
    let container = PersistenceController.shared.previewContainer
    @State var ex: Exercise? = DataUtility.getExercisesAsArray().first
    return StatisticsView(exercise: $ex)
        .environment(\.managedObjectContext, container.viewContext)
}
