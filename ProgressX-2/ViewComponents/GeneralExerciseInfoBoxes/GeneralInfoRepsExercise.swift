//
//  GeneralInfoRepsExercise.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-06-04.
//

import SwiftUI
import CoreData

struct GeneralInfoRepsExercise: View {
        
    @FetchRequest private var maxRepPersonalRecords: FetchedResults<PersonalRecord>
    @FetchRequest private var oneRepMaxPersonalRecords: FetchedResults<PersonalRecord>
    private let exercise: Exercise?
    public let selection: String
    
    init(exercise: Exercise?, selection: String) {
        self.exercise = exercise
        self.selection = selection
        self._maxRepPersonalRecords = FetchRequest<PersonalRecord>(
            entity: PersonalRecord.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \PersonalRecord.achievedOnDate, ascending: true)],
            predicate: NSCompoundPredicate(andPredicateWithSubpredicates: [
                NSPredicate(format: "exercise == %@", exercise!),
                NSPredicate(format: "prType == %@", "maxreps")
            ])
        )
        self._oneRepMaxPersonalRecords = FetchRequest<PersonalRecord>(
            entity: PersonalRecord.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \PersonalRecord.achievedOnDate, ascending: true)],
            predicate: NSCompoundPredicate(andPredicateWithSubpredicates: [
                NSPredicate(format: "exercise == %@", exercise!),
                NSPredicate(format: "prType == %@", "onerepmax")
            ])
        )
    }
    
    var body: some View {
        
        // Find the min value or nil if there are no values
        // Construct the all time low from the min (if it exists) and the weight unit
        let fetchedMinValue1RM = oneRepMaxPersonalRecords.min(by: {$0.weightLoad < $1.weightLoad})?.loadString
        let allTimeLow1RM = fetchedMinValue1RM != nil ? (fetchedMinValue1RM!) : nil
        
        // Same thing for the max values
        let fetchedMaxValue1RM = oneRepMaxPersonalRecords.max(by: {$0.weightLoad < $1.weightLoad})?.loadString
        let allTimeHigh1RM = fetchedMaxValue1RM != nil ? (fetchedMaxValue1RM!) : nil
        
        // Find the latest PR weight value or nil if there are no values
        let fetchedLatestValue1RM = oneRepMaxPersonalRecords.last?.loadString
        let latestValue1RM = fetchedLatestValue1RM != nil ? (fetchedLatestValue1RM!) : nil
        
        // Do exactly the same thing but for AMRAP pr's
        let fetchedMinValueMaxReps = maxRepPersonalRecords.min(by: {$0.prQuantity < $1.prQuantity})?.quantityString
        let allTimeLowMaxReps = fetchedMinValueMaxReps != nil ? (fetchedMinValueMaxReps!) : nil
        
        let fetchedMaxValueMaxReps = maxRepPersonalRecords.max(by: {$0.prQuantity < $1.prQuantity})?.quantityString
        let allTimeHighMaxReps = fetchedMaxValueMaxReps != nil ? (fetchedMaxValueMaxReps!) : nil
        
        let fetchedLatestValueMaxReps = maxRepPersonalRecords.last?.quantityString
        let latestValueMaxReps = fetchedLatestValueMaxReps != nil ? (fetchedLatestValueMaxReps!) : nil
        
        BoldSubHeadline(text: "General information")
            .padding(.horizontal, 40)
            .padding(.top, 20)
        
        GroupBox {
            
            VStack(alignment: .leading) {
                
                if selection == "onerepmax" {
                    
                    Text("Total 1RM pr's recorded: ")
                        .font(.subheadline)
                        .fontWeight(.light)
                        .foregroundColor(.gray)
                    + Text(String(oneRepMaxPersonalRecords.count))
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .foregroundStyle(.black)
                    
                    Text("First entry date (1RM): ")
                        .font(.subheadline)
                        .fontWeight(.light)
                        .foregroundColor(.gray)
                    + Text(oneRepMaxPersonalRecords.first?.dateString ?? "No pr recorded")
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .foregroundStyle(.black)
                    
                    Text("Last entry date (1RM): ")
                        .font(.subheadline)
                        .fontWeight(.light)
                        .foregroundColor(.gray)
                    + Text(oneRepMaxPersonalRecords.last?.dateString ?? "No pr recorded")
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
                    
                } else if selection == "maxreps" {
                    
                    (Text("Total AMRAP pr's recorded: ")
                        .font(.subheadline)
                        .fontWeight(.light)
                        .foregroundColor(.gray)
                     + Text(String(maxRepPersonalRecords.count))
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .foregroundStyle(.black))
                    .padding(.top, 5)
                    
                    Text("First entry date (AMRAP): ")
                        .font(.subheadline)
                        .fontWeight(.light)
                        .foregroundColor(.gray)
                    + Text(maxRepPersonalRecords.first?.dateString ?? "No pr recorded")
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .foregroundStyle(.black)
                    
                    Text("Last entry date (AMRAP): ")
                        .font(.subheadline)
                        .fontWeight(.light)
                        .foregroundColor(.gray)
                    + Text(maxRepPersonalRecords.last?.dateString ?? "No pr recorded")
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
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    
    let fetchRequest: NSFetchRequest<Exercise> = Exercise.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "exerciseType == %@", "reps")
    
    let exerciseResult: [Exercise] = PersistenceController.fetch(context, fetchRequest: fetchRequest)

    let exercise: Exercise = exerciseResult.first!
    
    return GeneralInfoRepsExercise(exercise: exercise, selection: "onerepmax")
        .environment(\.managedObjectContext, context)
}
