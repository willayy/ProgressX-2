//
//  GeneralExerciseInformation.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-05-29.
//

import SwiftUI
import CoreData

struct GeneralInfoTimeExercise: View {
    
    @FetchRequest private var timeMaxResults: FetchedResults<PersonalRecord>
    private let exercise: Exercise?
    
    init(exercise: Exercise?) {
        self.exercise = exercise
        self._timeMaxResults = FetchRequest<PersonalRecord>(
            entity: PersonalRecord.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \PersonalRecord.achievedOnDate, ascending: true)],
            predicate: NSCompoundPredicate(andPredicateWithSubpredicates: [
                NSPredicate(format: "exercise == %@", exercise!),
                NSPredicate(format: "prType == %@", "timemax")
            ])
        )
    }
    
    var body: some View {
        
        // Find the min value or nil if there are no values
        // Construct the all time low from the min (if it exists) and the weight unit
        let fetchedMinValueTime = timeMaxResults.min(by: {$0.prQuantity < $1.prQuantity})?.quantityString
        let allTimeLowTime = fetchedMinValueTime != nil ? (fetchedMinValueTime!) : nil
        
        // Same thing for the max values
        let fetchedMaxValueTime = timeMaxResults.max(by: {$0.prQuantity < $1.prQuantity})?.quantityString
        let allTimeHighTime = fetchedMaxValueTime != nil ? (fetchedMaxValueTime!) : nil
        
        // Find the latest PR weight value or nil if there are no values
        let fetchedLatestValueTime = timeMaxResults.last?.quantityString
        let latestValueTime = fetchedLatestValueTime != nil ? (fetchedLatestValueTime!) : nil
        
        
        BoldSubHeadline(text: "General information")
            .padding(.horizontal, 40)
            .padding(.top, 20)
        
        GroupBox {
            
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
                + Text(timeMaxResults.first?.dateString ?? "No pr recorded")
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .foregroundStyle(.black)
                
                Text("Last entry: ")
                    .font(.subheadline)
                    .fontWeight(.light)
                    .foregroundColor(.gray)
                + Text(timeMaxResults.last?.dateString ?? "No pr recorded")
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
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    
    let fetchRequestExercise: NSFetchRequest<Exercise> = Exercise.fetchRequest()
    fetchRequestExercise.predicate = NSPredicate(format: "exerciseType == %@", "time")
    
    let exerciseResult: [Exercise] = PersistenceController.fetch(context, fetchRequest: fetchRequestExercise)

    let exercise: Exercise = exerciseResult.first!
    
    return GeneralInfoTimeExercise(exercise: exercise)
        .environment(\.managedObjectContext, context)
}
