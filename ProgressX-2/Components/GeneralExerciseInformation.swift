//
//  GeneralExerciseInformation.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-05-29.
//

import SwiftUI

struct GeneralExerciseInformation: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @State var exercise: Exercise
    let weightUnit = DataUtility.getProfile()!.isMetric ? " kg" : " lbs"
    
    var body: some View {
        
        BoldSubHeadline(text: "General information")
            .padding(.horizontal, 40)
            .padding(.top, 20)
        
        ZStack {
            
            if exercise is TimeBasedExercise {
                
                let timeBasedExercise: TimeBasedExercise = exercise as! TimeBasedExercise
                let timePrs: [TimeMax] = DataUtility.getTimePrs(exercise: timeBasedExercise) ?? []
                
                Rectangle()
                    .cornerRadius(10)
                    .foregroundStyle(Color(.systemGray6))
                    .frame(height: 150)
                    .padding(.horizontal, 40)
                
                VStack(alignment: .leading) {
                    
                    Text("Total time pr's recorded: ")
                        .font(.subheadline)
                        .fontWeight(.light)
                        .foregroundColor(.gray)
                    + Text(String(timePrs.count))
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .foregroundStyle(.black)
                    
                    Text("First entry: ")
                        .font(.subheadline)
                        .fontWeight(.light)
                        .foregroundColor(.gray)
                    + Text(DataUtility.getFirstPrDate(prs: timePrs ) ?? "No pr recorded")
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .foregroundStyle(.black)
                    
                    Text("Last entry: ")
                        .font(.subheadline)
                        .fontWeight(.light)
                        .foregroundColor(.gray)
                    + Text(DataUtility.getFirstPrDate(prs: timePrs) ?? "No pr recorded")
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .foregroundStyle(.black)
                    
                    Text("All time low: ")
                        .font(.subheadline)
                        .fontWeight(.light)
                        .foregroundColor(.gray)
                    + Text(String(DataUtility.getLowestPrValue(data: timePrs) ?? 0) + " s")
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .foregroundStyle(.blue)
                    
                    Text("All time high: ")
                        .font(.subheadline)
                        .fontWeight(.light)
                        .foregroundColor(.gray)
                    + Text(String(DataUtility.getHighestPrValue(data: timePrs) ?? 0) + " s")
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .foregroundStyle(.blue)
                    
                    Text("Last PR: ")
                        .font(.subheadline)
                        .fontWeight(.light)
                        .foregroundColor(.gray)
                    + Text(String(DataUtility.getLatestPrValue(data: timePrs) ?? 0) + " s")
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .foregroundStyle(.blue)
                    
                }
            }
            
            else if exercise is RepBasedExercise {
                
                Rectangle()
                    .cornerRadius(10)
                    .foregroundStyle(Color(.systemGray6))
                    .frame(height: 300)
                    .padding(.horizontal, 40)
                
                VStack(alignment: .leading) {
                    
                    let repBasedexercise = exercise as! RepBasedExercise
                    let oneRepMaxPrs = DataUtility.get1RmPrs(exercise: repBasedexercise) ?? []
                    let maxRepPrs = DataUtility.getMaxRepPrs(exercise: repBasedexercise) ?? []
                    
                    Text("Total 1RM pr's recorded: ")
                        .font(.subheadline)
                        .fontWeight(.light)
                        .foregroundColor(.gray)
                    + Text(String(oneRepMaxPrs.count))
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .foregroundStyle(.black)
                    
                    Text("First entry (1RM): ")
                        .font(.subheadline)
                        .fontWeight(.light)
                        .foregroundColor(.gray)
                    + Text(DataUtility.getFirstPrDate(prs: oneRepMaxPrs) ?? "No pr recorded")
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .foregroundStyle(.black)
                    
                    Text("Last entry (1RM): ")
                        .font(.subheadline)
                        .fontWeight(.light)
                        .foregroundColor(.gray)
                    + Text(DataUtility.getFirstPrDate(prs: oneRepMaxPrs) ?? "No pr recorded")
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .foregroundStyle(.black)
                    
                    Text("All time low (1RM): ")
                        .font(.subheadline)
                        .fontWeight(.light)
                        .foregroundColor(.gray)
                    + Text(String(DataUtility.getLowestPrValue(data: oneRepMaxPrs) ?? 0) + weightUnit)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .foregroundStyle(.blue)
                    
                    Text("All time high (1RM): ")
                        .font(.subheadline)
                        .fontWeight(.light)
                        .foregroundColor(.gray)
                    + Text(String(DataUtility.getHighestPrValue(data: oneRepMaxPrs) ?? 0) + weightUnit)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .foregroundStyle(.blue)
                    
                    Text("Last PR (1RM): ")
                        .font(.subheadline)
                        .fontWeight(.light)
                        .foregroundColor(.gray)
                    + Text(String(DataUtility.getLatestPrValue(data: oneRepMaxPrs) ?? 0) + weightUnit)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .foregroundStyle(.blue)
                    
                    (Text("Total AMRAP pr's recorded: ")
                        .font(.subheadline)
                        .fontWeight(.light)
                        .foregroundColor(.gray)
                     + Text(String(maxRepPrs.count))
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .foregroundStyle(.black))
                    .padding(.top, 5)
                    
                    Text("First entry (AMRAP): ")
                        .font(.subheadline)
                        .fontWeight(.light)
                        .foregroundColor(.gray)
                    + Text(DataUtility.getFirstPrDate(prs: maxRepPrs) ?? "No pr recorded")
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .foregroundStyle(.black)
                    
                    Text("Last entry (AMRAP): ")
                        .font(.subheadline)
                        .fontWeight(.light)
                        .foregroundColor(.gray)
                    + Text(DataUtility.getFirstPrDate(prs: maxRepPrs) ?? "No pr recorded")
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .foregroundStyle(.black)
                    
                    Text("All time low (AMRAP): ")
                        .font(.subheadline)
                        .fontWeight(.light)
                        .foregroundColor(.gray)
                    + Text(String(DataUtility.getLowestPrValue(data: maxRepPrs) ?? 0) + " reps")
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .foregroundStyle(.blue)
                    
                    Text("All time high (AMRAP): ")
                        .font(.subheadline)
                        .fontWeight(.light)
                        .foregroundColor(.gray)
                    + Text(String(DataUtility.getHighestPrValue(data: maxRepPrs) ?? 0) + " reps")
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .foregroundStyle(.blue)
                    
                    Text("Last PR (AMRAP): ")
                        .font(.subheadline)
                        .fontWeight(.light)
                        .foregroundColor(.gray)
                    + Text(String(DataUtility.getLatestPrValue(data: maxRepPrs) ?? 0) + " reps")
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .foregroundStyle(.blue)
                }
            }
        }
    }
}

#Preview {
    let container = PersistenceController.shared.previewContainer
    let exercise: RepBasedExercise = DataUtility.getExercisesAsArray().first! as! RepBasedExercise
    return GeneralExerciseInformation(exercise: exercise)
        .environment(\.managedObjectContext, container.viewContext)
}
