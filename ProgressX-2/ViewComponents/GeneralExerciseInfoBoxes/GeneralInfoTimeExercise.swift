//
//  GeneralExerciseInformation.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-05-29.
//

import SwiftUI
import CoreData

struct GeneralInfoTimeExercise: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    // Fetch the Profile to se if its metric or not
    @FetchRequest(
        entity: Profile.entity(),
        sortDescriptors: []
    )private var profileResults: FetchedResults<Profile>
    
    @FetchRequest private var timeMaxResults: FetchedResults<TimeMax>
    
    private let exercise: TimeBasedExercise?
    
    init(exercise: TimeBasedExercise?) {
        self.exercise = exercise
        self._timeMaxResults = FetchRequest<TimeMax>(
            entity: TimeMax.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \TimeMax.achievedOnDate, ascending: true)],
            predicate: NSPredicate(format: "exercise == %@", exercise!)
        )
    }
    
    var body: some View {
        
        // Find the min value or nil if there are no values
        // Construct the all time low from the min (if it exists) and the weight unit
        let timeUnit = "s"
        let fetchedMinValueTime = timeMaxResults.min(by: {$0.weightLoad < $1.weightLoad})?.loadString()
        let allTimeLowTime = fetchedMinValueTime != nil ? (fetchedMinValueTime! + " " + timeUnit) : nil
        
        // Same thing for the max values
        let fetchedMaxValueTime = timeMaxResults.max(by: {$0.weightLoad < $1.weightLoad})?.loadString()
        let allTimeHighTime = fetchedMaxValueTime != nil ? (fetchedMaxValueTime! + " " + timeUnit) : nil
        
        // Find the latest PR weight value or nil if there are no values
        let fetchedLatestValueTime = timeMaxResults.first?.loadString()
        let latestValueTime = fetchedLatestValueTime != nil ? (fetchedLatestValueTime! + " " + timeUnit) : nil
        
        
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
                + Text(String(timeMaxResults.count))
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundStyle(.black)
                
                Text("First entry: ")
                    .font(.subheadline)
                    .fontWeight(.light)
                    .foregroundColor(.gray)
                + Text(timeMaxResults.first?.dateString() ?? "No pr recorded")
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundStyle(.black)
                
                Text("Last entry: ")
                    .font(.subheadline)
                    .fontWeight(.light)
                    .foregroundColor(.gray)
                + Text(timeMaxResults.last?.dateString() ?? "No pr recorded")
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundStyle(.black)
                
                Text("All time low: ")
                    .font(.subheadline)
                    .fontWeight(.light)
                    .foregroundColor(.gray)
                + Text(allTimeLowTime ?? "No pr recorded")
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundStyle(.blue)
                
                Text("All time high: ")
                    .font(.subheadline)
                    .fontWeight(.light)
                    .foregroundColor(.gray)
                + Text(allTimeHighTime ?? "No pr recorded")
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundStyle(.blue)
                
                Text("Last PR: ")
                    .font(.subheadline)
                    .fontWeight(.light)
                    .foregroundColor(.gray)
                + Text(latestValueTime ?? "No pr recorded")
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundStyle(.blue)
            }
        }
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    
    let fetchRequestRepBasedExercise: NSFetchRequest<TimeBasedExercise> = TimeBasedExercise.fetchRequest()
    
    let exerciseResult: [TimeBasedExercise] = PersistenceController.fetch(context, fetchRequest: fetchRequestRepBasedExercise)

    let exercise: TimeBasedExercise = exerciseResult.first!
    
    return GeneralInfoTimeExercise(exercise: exercise)
        .environment(\.managedObjectContext, context)
}
