//
//  GeneralExerciseInformation.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-05-29.
//

import SwiftUI

struct GeneralInfoTimeExercise: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var exercise: Exercise?
    @Binding var timeMaxPrs: [TimeMax]
    
    var body: some View {
        
        BoldSubHeadline(text: "General information")
            .padding(.horizontal, 40)
            .padding(.top, 20)
        
        ZStack {
            Rectangle()
                .cornerRadius(10)
                .foregroundStyle(Color(.systemGray6))
                .frame(height: 150)
                .padding(.horizontal, 40)
            
            VStack(alignment: .leading) {
                
                Text("Total time-max pr's recorded: ")
                    .font(.subheadline)
                    .fontWeight(.light)
                    .foregroundColor(.gray)
                + Text(String(timeMaxPrs.count))
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundStyle(.black)
                
                Text("First entry: ")
                    .font(.subheadline)
                    .fontWeight(.light)
                    .foregroundColor(.gray)
                + Text(DataUtility.getFirstPrDate(prs: timeMaxPrs ) ?? "No pr recorded")
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundStyle(.black)
                
                Text("Last entry: ")
                    .font(.subheadline)
                    .fontWeight(.light)
                    .foregroundColor(.gray)
                + Text(DataUtility.getLastPrDate(prs: timeMaxPrs) ?? "No pr recorded")
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundStyle(.black)
                
                Text("All time low: ")
                    .font(.subheadline)
                    .fontWeight(.light)
                    .foregroundColor(.gray)
                + Text(String(DataUtility.getLowestPrValue(data: timeMaxPrs) ?? 0) + " s")
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundStyle(.blue)
                
                Text("All time high: ")
                    .font(.subheadline)
                    .fontWeight(.light)
                    .foregroundColor(.gray)
                + Text(String(DataUtility.getHighestPrValue(data: timeMaxPrs) ?? 0) + " s")
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundStyle(.blue)
                
                Text("Last PR: ")
                    .font(.subheadline)
                    .fontWeight(.light)
                    .foregroundColor(.gray)
                + Text(String(DataUtility.getLatestPrValue(data: timeMaxPrs) ?? 0) + " s")
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundStyle(.blue)
            }
        }
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    @State var exercise: Exercise? = DataFetching.getExercisesAsArray(context)
        .first(where:{$0.exerciseName == "testing exercise (time)"}) as! TimeBasedExercise
    @State var prs: [TimeMax] = (exercise as! TimeBasedExercise).timePrs!.array as! [TimeMax]
    return GeneralInfoTimeExercise(exercise: $exercise, timeMaxPrs: $prs)
        .environment(\.managedObjectContext, context)
}
