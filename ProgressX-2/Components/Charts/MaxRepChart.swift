//
//  MaxRepChart.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-05-30.
//

import SwiftUI
import Charts

struct MaxRepChart: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @State var overlayBodyWeight = false
    let exercise: RepBasedExercise
    
    var body: some View {
        
        let prs: [MaxReps] = DataUtility.getMaxRepPrs(exercise: exercise) ?? []
        let bwEntries: [BodyEntry] = DataUtility.getBodyWeightEntriesAsArray()
        let sortedPrs: [MaxReps] = DataUtility.sortPersonralRecordsByDate(prs: prs) as! [MaxReps]
        let sortedBwEntries: [BodyEntry] = DataUtility.sortBwEntriesByDate(bwEntries: bwEntries)
        
        let highestReps = DataUtility.getHighestPrValue(data: prs) ?? 0
        let highestWeight = DataUtility.getHighestBwValue(data: bwEntries)
        let highestLoad = prs.map { $0.load }.max() ?? 0
        let highestOfLoadAndBw = highestWeight! >= highestLoad ? highestWeight! : highestLoad
        
        (Text("AMRAP")
            .font(.subheadline)
            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
         + Text(" chart for ")
            .font(.subheadline)
         + Text(exercise.exerciseName!)
            .font(.subheadline)
            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/))
        .padding(.horizontal, 40)
        .padding(.top, 20)
        
        VStack(alignment: .leading) {
            LightSubHeadline(text: "load at AMRAP set (Blue)")
            LightSubHeadline(text: "reps at AMRAP set (Black)")
            LightSubHeadline(text: "bodyweight (Yellow)")
        }
        
        ZStack {
            
            Rectangle()
                .cornerRadius(10)
                .foregroundStyle(Color(.systemGray6))
                .frame(height: 385)
                .padding(.horizontal, 40)
            
            if prs.isEmpty {
                Text("Cant genereate this chart because there are no AMRAP PR's recorded for exercise: \(exercise.exerciseName!)")
                    .font(.subheadline)
                    .fontWeight(.light)
                    .foregroundColor(.red)
                    .padding(.all, 80)
                    .multilineTextAlignment(.center)
            } else {
                VStack {
                    Chart {
                        ForEach(sortedPrs) {
                            LineMark (
                                x: .value("prDate", $0.achievedOnDate!),
                                y: .value("load", $0.load),
                                series: .value("load", "B")
                            )
                            .foregroundStyle(.blue)
                        }
                        
                        if overlayBodyWeight {
                            ForEach(sortedBwEntries) {
                                LineMark (
                                    x: .value("bwDate", $0.date!),
                                    y: .value("bw", $0.bodyWeight)
                                )
                            }
                        }
                    }
                    .padding(.horizontal, 50)
                    .chartYScale(domain: 0...highestOfLoadAndBw + 20)
                    .frame(height: 150)
                    
                    Chart {
                        ForEach(sortedPrs) {
                            LineMark (
                                x: .value("prDate", $0.achievedOnDate!),
                                y: .value("reps", $0.reps),
                                series: .value("reps", "A")
                            )
                            .foregroundStyle(.black)
                            
                            PointMark (
                                x: .value("prDate", $0.achievedOnDate!),
                                y: .value("reps", $0.reps)
                            )
                            .foregroundStyle(.black)
                        }
                    }
                    .padding(.horizontal, 50)
                    .chartYScale(domain: 0...highestReps + 20)
                    .frame(height: 150)
                    
                    Toggle(isOn: $overlayBodyWeight, label: {
                        Text("Do you want to overlay bodyweight?")
                    })
                    .padding(.horizontal, 50)
                    .padding(.top, 10)
                }
            }
        }
    }
}

#Preview {
        
    let container = PersistenceController.shared.previewContainer
    let exercise = DataUtility.getExercisesAsArray()
        .first(where:{$0.exerciseName == "testing exercise (reps)"}) as! RepBasedExercise
    
    return MaxRepChart(exercise: exercise)
        .environment(\.managedObjectContext, container.viewContext)
}
