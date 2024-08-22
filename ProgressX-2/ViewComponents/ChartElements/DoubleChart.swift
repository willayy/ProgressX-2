//
//  MaxRepChart.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-05-30.
//

import SwiftUI
import Charts
import CoreData

struct DoubleChart: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    // Fetching BodyWeightentries
    @FetchRequest(
        entity: BodyEntry.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \BodyEntry.achievedOnDate, ascending: true)]
    ) private var bodyEntryResults: FetchedResults<BodyEntry>
    
    @FetchRequest private var personalRecordResults: FetchedResults<PersonalRecord>
    
    // State to toggle the bodyweight overlay graph off and on
    @State private var overlayBodyWeight: Bool = false
    
    private var exercise: Exercise
    
    private var set: String
    
    init(exercise: Exercise, set: String, prType: String) {
        
        self.exercise = exercise
        
        self.set = set
        
        // Fetch the prs for the exercise
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
        
        let weightUnit: String = CoreDataAccess.getWeightUnit(viewContext)!
        // Infer the quantity unit from the personal records, if not possible set to unknown.
        let quantityUnit: String = {
            if exercise.exerciseType == "reps" {
                return "reps"
            } else {
                return "seconds"
            }
        }()
        
        (Text(set)
            .font(.subheadline)
            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
         + Text(" chart for ")
            .font(.subheadline)
         + Text(exercise.exerciseName!)
            .font(.subheadline)
            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/))
        .padding(.horizontal, 10)
        .padding(.top, 20)
        
        VStack(alignment: .leading) {
            LightSubHeadline(text: "load (\(weightUnit)) at AMRAP set (Blue)")
            LightSubHeadline(text: "\(quantityUnit) at \(set) set (Black)")
            LightSubHeadline(text: "bodyweight (\(weightUnit)) (Yellow)")
        }
        
        GroupBox {
            
            if personalRecordResults.isEmpty {
                Text("Cant genereate this chart because there are no AMRAP PR's recorded for exercise: \(exercise.exerciseName!)")
                    .font(.subheadline)
                    .fontWeight(.light)
                    .foregroundColor(.red)
                    .padding(.all, 20)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
            } else {
                
                // Get the highest weightload pr recorded on the exercise
                let highestPrByLoad: PersonalRecord? = personalRecordResults.max(by: {$0.weightLoad < $1.weightLoad})
                let highestPrLoad: Double = highestPrByLoad?.weightLoad ?? 0
                
                // Get the highest bodyweight recorded
                let highestBwEntry: BodyEntry? = bodyEntryResults.max(by: {$0.bodyWeight < $1.bodyWeight})
                let highestBw: Double = highestBwEntry?.bodyWeight ?? 0
                
                // Compare and chose the one who has the biggest value, this is later used to scale the y axis correctly
                let loadHigherThanBw: Bool = highestPrLoad >= highestBw
                let highestOfLoadAndBw: Double = loadHigherThanBw ? highestPrLoad : highestBw
                
                // Highest quantity count
                let highestPrByQuantity: PersonalRecord? = personalRecordResults.max(by: {$0.prQuantity < $1.prQuantity})
                let highestPrQuantity: Double = highestPrByQuantity?.prQuantity ?? 0
                
                VStack {
                    
                    loadChart(yscale: highestOfLoadAndBw)
                    
                    quantityChart(yscale: highestPrQuantity)
                    
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
    
    private func loadChart(yscale: Double) -> some View {
        Chart {
            ForEach(personalRecordResults) {
                LineMark (
                    x: .value("prDate", $0.achievedOnDate!),
                    y: .value("load", $0.weightLoad),
                    series: .value("load", "A")
                )
                .foregroundStyle(.blue)
            }
            
            if overlayBodyWeight {
                ForEach(bodyEntryResults) {
                    LineMark (
                        x: .value("bwDate", $0.achievedOnDate!),
                        y: .value("bw", $0.bodyWeight),
                        series: .value("bw", "C")
                    )
                    .foregroundStyle(.yellow)
                }
            }
        }
        .padding(.horizontal, 10)
        .chartYScale(domain: 0...yscale + 20)
        .frame(height: 150)
    }
    
    private func quantityChart(yscale: Double) -> some View {
        Chart {
            ForEach(personalRecordResults) {
                LineMark (
                    x: .value("prDate", $0.achievedOnDate!),
                    y: .value("reps", $0.prQuantity),
                    series: .value("reps", "B")
                )
                .foregroundStyle(.black)
                
                PointMark (
                    x: .value("prDate", $0.achievedOnDate!),
                    y: .value("reps", $0.prQuantity)
                )
                .foregroundStyle(.black)
            }
        }
        .padding(.horizontal, 10)
        .chartYScale(domain: 0...yscale + 20)
        .frame(height: 150)
    }
    
}


#Preview {
    
    let context = PersistenceController.preview.container.viewContext
    
    let fetchRequestExercise: NSFetchRequest<Exercise> = Exercise.fetchRequest()
    fetchRequestExercise.predicate = NSPredicate(format: "exerciseType == %@", "reps")
    
    let exerciseResult: [Exercise] = CoreDataAccess.fetch(context, fetchRequest: fetchRequestExercise)

    let exercise: Exercise = exerciseResult.first!
    
    return DoubleChart(exercise: exercise, set: "AMRAP", prType: "maxreps")
        .environment(\.managedObjectContext, context)
}

