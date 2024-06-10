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
    @Binding var exercise: Exercise?
    @Binding var navPath: [Int]
    @Binding var editingPr: PersonalRecord?
    @Binding var allPrs: [PersonalRecord]
    @Binding var oneRepMaxPrs: [OneRepMax]
    @Binding var timeMaxPrs: [TimeMax]
    @Binding var maxRepPrs: [MaxReps]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center) {
                
                BoldTitle(text: "Statistics for \(String(exercise!.exerciseName!))")
                
                LightSubHeadline(text: "Here you can view graphs of your progress and scroll through all your achieved prs, you can edit them by pressing the pencil button.")
                
                if exercise is RepBasedExercise {
                    GeneralInfoRepsExercise(
                        exercise: $exercise,
                        oneRepMaxPrs: $oneRepMaxPrs,
                        maxRepsPrs: $maxRepPrs
                    ).environment(\.managedObjectContext, viewContext)
                } else if exercise is TimeBasedExercise {
                    GeneralInfoTimeExercise(
                        exercise: $exercise,
                        timeMaxPrs: $timeMaxPrs
                    ).environment(\.managedObjectContext, viewContext)
                }
                
                PrList(
                    navPath: $navPath,
                    exercise: $exercise,
                    prs: $allPrs,
                    editingPr: $editingPr
                )
                
                if exercise is RepBasedExercise {
                    OneRepMaxChart(
                        oneRepMaxPrs: $oneRepMaxPrs, 
                        exercise: exercise as! RepBasedExercise
                    ).environment(\.managedObjectContext, viewContext)
                    MaxRepChart(
                        maxRepPrs: $maxRepPrs, 
                        exercise: exercise as! RepBasedExercise
                    ).environment(\.managedObjectContext, viewContext)
                } else if exercise is TimeBasedExercise {
                    TimeMaxChart(
                        timeMaxPrs: $timeMaxPrs, 
                        exercise: exercise as! TimeBasedExercise
                    ).environment(\.managedObjectContext, viewContext)
                }
            }
        }
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    @State var exercise: Exercise? = DataFetching.getExercisesAsArray(context)
        .first(where:{$0.exerciseName == "testing exercise (time)"})
    @State var navPath: [Int] = [Int]()
    @State var editingPr: PersonalRecord? = nil
    @State var allPrs: [PersonalRecord] = []
    @State var oneRepMaxPrs: [OneRepMax] = []
    @State var timeMaxPrs: [TimeMax] = []
    @State var maxRepPrs: [MaxReps] = []
    return StatisticsView(
        exercise: $exercise,
        navPath: $navPath,
        editingPr: $editingPr,
        allPrs: $allPrs,
        oneRepMaxPrs: $oneRepMaxPrs,
        timeMaxPrs: $timeMaxPrs,
        maxRepPrs: $maxRepPrs
    ).environment(\.managedObjectContext, context)
}
