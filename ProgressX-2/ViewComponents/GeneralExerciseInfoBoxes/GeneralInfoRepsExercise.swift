//
//  GeneralInfoRepsExercise.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-06-04.
//

import SwiftUI
import CoreData

struct GeneralInfoRepsExercise: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    // Fetch the Profile to se if its metric or not
    @FetchRequest(
        entity: Profile.entity(),
        sortDescriptors: []
    ) private var profileResults: FetchedResults<Profile>
    
    @FetchRequest private var maxRepResults: FetchedResults<MaxReps>
    
    @FetchRequest private var oneRepMaxResults: FetchedResults<OneRepMax>
    
    private let exercise: RepBasedExercise?
    
    init(exercise: RepBasedExercise?) {
        self.exercise = exercise
        self._maxRepResults = FetchRequest<MaxReps>(
            entity: MaxReps.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \MaxReps.achievedOnDate, ascending: true)],
            predicate: NSPredicate(format: "exercise == %@", exercise!)
        )
        self._oneRepMaxResults = FetchRequest<OneRepMax>(
            entity: OneRepMax.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \OneRepMax.achievedOnDate, ascending: true)],
            predicate: NSPredicate(format: "exercise == %@", exercise!)
        )
    }
    
    var body: some View {
        
        // Find the min value or nil if there are no values
        // Construct the all time low from the min (if it exists) and the weight unit
        let weightUnit = profileResults.first!.isMetric ? "kg's" : "lbs"
        let fetchedMinValue1RM = oneRepMaxResults.min(by: {$0.weightLoad < $1.weightLoad})?.loadString()
        let allTimeLow1RM = fetchedMinValue1RM != nil ? (fetchedMinValue1RM! + " " + weightUnit) : nil
        
        // Same thing for the max values
        let fetchedMaxValue1RM = oneRepMaxResults.max(by: {$0.weightLoad < $1.weightLoad})?.loadString()
        let allTimeHigh1RM = fetchedMaxValue1RM != nil ? (fetchedMaxValue1RM! + " " + weightUnit) : nil
        
        // Find the latest PR weight value or nil if there are no values
        let fetchedLatestValue1RM = oneRepMaxResults.first?.loadString()
        let latestValue1RM = fetchedLatestValue1RM != nil ? (fetchedLatestValue1RM! + " " + weightUnit) : nil
        
        // Do exactly the same thing but for AMRAP pr's
        let fetchedMinValueMaxReps = maxRepResults.min(by: {$0.weightLoad < $1.weightLoad})?.loadString()
        let allTimeLowMaxReps = fetchedMinValueMaxReps != nil ? (fetchedMinValueMaxReps! + " " + "reps") : nil
        
        let fetchedMaxValueMaxReps = maxRepResults.max(by: {$0.weightLoad < $1.weightLoad})?.loadString()
        let allTimeHighMaxReps = fetchedMaxValueMaxReps != nil ? (fetchedMaxValueMaxReps! + " " + "reps") : nil
        
        let fetchedLatestValueMaxReps = maxRepResults.first?.loadString()
        let latestValueMaxReps = fetchedLatestValueMaxReps != nil ? (fetchedLatestValueMaxReps! + " " + "reps") : nil
        
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
                + Text(String(oneRepMaxResults.count))
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundStyle(.black)
                
                Text("First entry date (1RM): ")
                    .font(.subheadline)
                    .fontWeight(.light)
                    .foregroundColor(.gray)
                + Text(oneRepMaxResults.first?.dateString() ?? "No pr recorded")
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundStyle(.black)
                
                Text("Last entry date (1RM): ")
                    .font(.subheadline)
                    .fontWeight(.light)
                    .foregroundColor(.gray)
                + Text(oneRepMaxResults.last?.dateString() ?? "No pr recorded")
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundStyle(.black)
                
                Text("All time low (1RM): ")
                    .font(.subheadline)
                    .fontWeight(.light)
                    .foregroundColor(.gray)
                + Text(allTimeLow1RM ?? "No pr recorded")
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundStyle(.blue)
                
                Text("All time high (1RM): ")
                    .font(.subheadline)
                    .fontWeight(.light)
                    .foregroundColor(.gray)
                + Text(allTimeHigh1RM ?? "No pr recorded")
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundStyle(.blue)
                
                Text("Last PR (1RM): ")
                    .font(.subheadline)
                    .fontWeight(.light)
                    .foregroundColor(.gray)
                + Text(latestValue1RM ?? "No pr recorded")
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundStyle(.blue)
                
                (Text("Total AMRAP pr's recorded: ")
                    .font(.subheadline)
                    .fontWeight(.light)
                    .foregroundColor(.gray)
                 + Text(String(maxRepResults.count))
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundStyle(.black))
                .padding(.top, 5)
                
                Text("First entry date (AMRAP): ")
                    .font(.subheadline)
                    .fontWeight(.light)
                    .foregroundColor(.gray)
                + Text(maxRepResults.first?.dateString() ?? "No pr recorded")
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundStyle(.black)
                
                Text("Last entry date (AMRAP): ")
                    .font(.subheadline)
                    .fontWeight(.light)
                    .foregroundColor(.gray)
                + Text(maxRepResults.last?.dateString() ?? "No pr recorded")
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundStyle(.black)
                
                Text("All time low (AMRAP): ")
                    .font(.subheadline)
                    .fontWeight(.light)
                    .foregroundColor(.gray)
                + Text(allTimeLowMaxReps ?? "No pr recorded")
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundStyle(.blue)
                
                Text("All time high (AMRAP): ")
                    .font(.subheadline)
                    .fontWeight(.light)
                    .foregroundColor(.gray)
                + Text(allTimeHighMaxReps ?? "No pr recorded")
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundStyle(.blue)
                
                Text("Last PR (AMRAP): ")
                    .font(.subheadline)
                    .fontWeight(.light)
                    .foregroundColor(.gray)
                + Text(latestValueMaxReps ?? "No pr recorded")
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundStyle(.blue)
            }
        }
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    
    let fetchRequestRepBasedExercise: NSFetchRequest<RepBasedExercise> = RepBasedExercise.fetchRequest()
    
    let exerciseResult: [RepBasedExercise] = PersistenceController.fetch(context, fetchRequest: fetchRequestRepBasedExercise)

    let exercise: RepBasedExercise = exerciseResult.first!
    
    return GeneralInfoRepsExercise(exercise: exercise)
        .environment(\.managedObjectContext, context)
}
