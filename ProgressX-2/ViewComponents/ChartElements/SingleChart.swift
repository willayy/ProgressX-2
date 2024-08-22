//
//  PrChart.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-05-24.
//

import SwiftUI
import Charts
import CoreData

struct SingleChart: View {
 
    @Environment(\.managedObjectContext) private var viewContext
    
    // Fetching BodyWeightentries
    @FetchRequest(
        entity: BodyEntry.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \BodyEntry.achievedOnDate, ascending: true)]
    ) private var bodyEntryResults: FetchedResults<BodyEntry>
    
    @FetchRequest private var personalRecordResults: FetchedResults<PersonalRecord>
    
    // State to toggle the bodyweight overlay graph off and on
    @State private var overlayBodyWeight: Bool = false
    
    private let exercise: Exercise
    
    private let set: String
    
    init(exercise: Exercise, set: String, prType: String) {
        
        self.exercise = exercise
        
        self.set = set
        
        // Fetch the correct prs according to the prType and Exercise
        self._personalRecordResults = FetchRequest<PersonalRecord>(
            entity: PersonalRecord.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \PersonalRecord.achievedOnDate, ascending: true)],
            predicate: NSCompoundPredicate(andPredicateWithSubpredicates: [
                NSPredicate(format: "exercise == %@", exercise),
                NSPredicate(format: "prType == %@", prType)
            ])
        )
        
    }
    
    var body: some View {
        
        // Get the weightUnit
        let weightUnit: String = CoreDataAccess.getWeightUnit(viewContext)!
        
        (Text(set)
            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
         + Text(" chart for ")
         + Text(exercise.exerciseName!)
            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/))
        .padding(.horizontal, 10)
        .padding(.top, 20)
        
        VStack(alignment: .leading) {
            LightSubHeadline(text: "load (\(weightUnit)) at \(set) set (Black)")
            LightSubHeadline(text: "bodyweight (\(weightUnit)) (Yellow)")
        }
        
        GroupBox {
            
            if personalRecordResults.isEmpty {
                Text("Cant genereate this chart because there are no 1RM PR's recorded for exercise: \(exercise.exerciseName!)")
                    .font(.subheadline)
                    .fontWeight(.light)
                    .foregroundColor(.red)
                    .padding(.all, 20)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
            } else {
                
                // Get the pr with the highest load recorded on the exercise
                let highestLoad = personalRecordResults.max(by: {$0.weightLoad < $1.weightLoad})?.weightLoad ?? 0
                // Get the highest bodyweight recorded on this profile
                let highestBw = bodyEntryResults.max(by: {$0.bodyWeight < $1.bodyWeight})?.bodyWeight ?? 0
                // Compare and chose the one who has the biggest value, this is later used to scale the y axis correctly
                let highestOfLoadAndBw = highestLoad >= highestBw ? highestLoad : highestBw
                
                VStack {
                    Chart {
                        ForEach(personalRecordResults) {
                            LineMark (
                                x: .value("prDate", $0.achievedOnDate!),
                                y: .value("load", $0.weightLoad),
                                series: .value("load", "A")
                            )
                            .foregroundStyle(.black)
                            
                            PointMark (
                                x: .value("prDate", $0.achievedOnDate!),
                                y: .value("load", $0.weightLoad)
                            )
                            .foregroundStyle(.black)
                        }
                        
                        if overlayBodyWeight {
                            ForEach(bodyEntryResults) {
                                LineMark (
                                    x: .value("bwDate", $0.achievedOnDate!),
                                    y: .value("bodyweight", $0.bodyWeight),
                                    series: .value("bw", "B")
                                )
                                .foregroundStyle(.yellow)
                            }
                        }
                    }
                    .padding(.horizontal, 10)
                    .chartYScale(domain: 0...highestOfLoadAndBw + 20)
                    .frame(height: 150)
                    
                    Toggle(isOn: $overlayBodyWeight, label: {
                        Text("Do you want to overlay bodyweight?")
                    })
                    .minimumScaleFactor(0.75)
                    .padding(.horizontal, 40)
                    .padding(.top, 10)
                }
                .frame(maxWidth: .infinity)
            }
        }
    }
}

#Preview {
        
    let context = PersistenceController.preview.container.viewContext
    
    let fetchRequestExercise: NSFetchRequest<Exercise> = Exercise.fetchRequest()
    fetchRequestExercise.predicate = NSPredicate(format: "exerciseType == %@", "reps")
    
    let exerciseResult: [Exercise] = CoreDataAccess.fetch(context, fetchRequest: fetchRequestExercise)

    let exercise: Exercise = exerciseResult.first!
    
    return SingleChart(exercise: exercise, set: "1RM", prType: "onerepmax")
        .environment(\.managedObjectContext, context)
}
