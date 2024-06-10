//
//  PrList.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-05-24.
//

import SwiftUI

struct PrList: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var navPath: [Int]
    @Binding var exercise: Exercise?
    @Binding var prs: [PersonalRecord]
    @Binding var editingPr: PersonalRecord?
    @State private var sortedPrs: [PersonalRecord] = []
    
    var body: some View {
        
        BoldSubHeadline(text: "List of all PR's achieved on \(exercise!.exerciseName!)")
            .padding(.horizontal, 40)
            .padding(.top, 20)
        
        if prs.isEmpty {
            Text("No PR's found for this exercise")
                .font(.subheadline)
                .padding(.top, 20)
                .foregroundStyle(.red)
        } 
        
        else {
            List {
                ForEach(sortedPrs) { pr in
                    
                    if pr is OneRepMax {
                        OneRepMaxListItem(
                            belongsTo: $prs,
                            navPath: $navPath,
                            editingPr: $editingPr,
                            pr: pr
                        ).environment(\.managedObjectContext, viewContext)
                    } else if pr is MaxReps {
                        MaxRepListItem(
                            belongsTo: $prs,
                            navPath: $navPath,
                            editingPr: $editingPr,
                            pr: pr
                        ).environment(\.managedObjectContext, viewContext)
                    } else if pr is TimeMax {
                        TimeMaxListItem(
                            belongsTo: $prs,
                            navPath: $navPath,
                            editingPr: $editingPr,
                            pr: pr
                        ).environment(\.managedObjectContext, viewContext)
                    }
                    
                }
            }
            .frame(height: 300)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .padding(.horizontal, 40)
            .onAppear(perform: {
                sortedPrs = DataUtility.sortPersonalRecordsByDate(prs: prs)
            })
        }
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    @State var exercise: Exercise? = DataFetching.getExercisesAsArray(context)
        .first(where:{$0.exerciseName == "testing exercise (reps)"})!
    @State var prs: [PersonalRecord] = DataUtility.get1RmPrs(exercise: exercise as! RepBasedExercise) ?? []
    @State var navPath: [Int] = [Int]()
    @State var editingPr: PersonalRecord? = nil
    return PrList(navPath: $navPath, exercise: $exercise, prs: $prs, editingPr: $editingPr)
        .environment(\.managedObjectContext, context)
}
