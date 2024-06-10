//
//  GeneralInfoRepsExercise.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-06-04.
//

import SwiftUI

struct GeneralInfoRepsExercise: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var exercise: Exercise?
    @Binding var oneRepMaxPrs: [OneRepMax]
    @Binding var maxRepsPrs: [MaxReps]
    @State var weightUnit = ""
    
    var body: some View {
        
        BoldSubHeadline(text: "General information")
            .padding(.horizontal, 40)
            .padding(.top, 20)
        
        ZStack {
            
            Rectangle()
                .cornerRadius(10)
                .foregroundStyle(Color(.systemGray6))
                .frame(height: 300)
                .padding(.horizontal, 40)
            
            VStack(alignment: .leading) {
                
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
                + Text(DataUtility.getLastPrDate(prs: oneRepMaxPrs) ?? "No pr recorded")
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
                 + Text(String(maxRepsPrs.count))
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundStyle(.black))
                .padding(.top, 5)
                
                Text("First entry (AMRAP): ")
                    .font(.subheadline)
                    .fontWeight(.light)
                    .foregroundColor(.gray)
                + Text(DataUtility.getFirstPrDate(prs: maxRepsPrs) ?? "No pr recorded")
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundStyle(.black)
                
                Text("Last entry (AMRAP): ")
                    .font(.subheadline)
                    .fontWeight(.light)
                    .foregroundColor(.gray)
                + Text(DataUtility.getFirstPrDate(prs: maxRepsPrs) ?? "No pr recorded")
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundStyle(.black)
                
                Text("All time low (AMRAP): ")
                    .font(.subheadline)
                    .fontWeight(.light)
                    .foregroundColor(.gray)
                + Text(String(DataUtility.getLowestPrValue(data: maxRepsPrs) ?? 0) + " reps")
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundStyle(.blue)
                
                Text("All time high (AMRAP): ")
                    .font(.subheadline)
                    .fontWeight(.light)
                    .foregroundColor(.gray)
                + Text(String(DataUtility.getHighestPrValue(data: maxRepsPrs) ?? 0) + " reps")
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundStyle(.blue)
                
                Text("Last PR (AMRAP): ")
                    .font(.subheadline)
                    .fontWeight(.light)
                    .foregroundColor(.gray)
                + Text(String(DataUtility.getLatestPrValue(data: maxRepsPrs) ?? 0) + " reps")
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundStyle(.blue)
            }
        }.onAppear {
            weightUnit = DataFetching.getProfile(viewContext)!.isMetric ? " kg" : " lbs"
        }
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    @State var exercise: Exercise? = DataFetching.getExercisesAsArray(context)
        .first(where:{$0.exerciseName == "testing exercise (reps)"})
    @State var oneRepMaxPrs: [OneRepMax] = (exercise as! RepBasedExercise).oneRepMaxPrs!.array as! [OneRepMax]
    @State var maxRepPrs: [MaxReps] = (exercise as! RepBasedExercise).maxRepPrs!.array as! [MaxReps]
    return GeneralInfoRepsExercise(exercise: $exercise,
                                   oneRepMaxPrs: $oneRepMaxPrs,
                                   maxRepsPrs: $maxRepPrs)
        .environment(\.managedObjectContext, context)
}
