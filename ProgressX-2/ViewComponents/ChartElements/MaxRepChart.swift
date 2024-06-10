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
    @Binding var maxRepPrs: [MaxReps]
    @State private var overlayBodyWeight = false
    @State private var sortedMaxRepPrs: [MaxReps] = []
    let exercise: RepBasedExercise
    
    var body: some View {
        
        let weightUnit: String = DataFetching.getProfile(viewContext)!.isMetric ? "kg's" : "lbs"
        let bwEntries: [BodyEntry] = DataFetching.getBodyWeightEntriesAsArray(viewContext)
        let sortedBwEntries: [BodyEntry] = DataUtility.sortBwEntriesByDate(bwEntries: bwEntries)
        let highestReps = DataUtility.getHighestPrValue(data: maxRepPrs) ?? 0
        let highestWeight = DataUtility.getHighestBwValue(data: bwEntries)
        let highestLoad = maxRepPrs.map { $0.load }.max() ?? 0
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
            LightSubHeadline(text: "load (\(weightUnit)) at AMRAP set (Blue)")
            LightSubHeadline(text: "reps at AMRAP set (Black)")
            LightSubHeadline(text: "bodyweight (\(weightUnit)) (Yellow)")
        }
        
        ZStack {
            
            Rectangle()
                .cornerRadius(10)
                .foregroundStyle(Color(.systemGray6))
                .frame(height: 385)
                .padding(.horizontal, 40)
            
            if maxRepPrs.isEmpty {
                Text("Cant genereate this chart because there are no AMRAP PR's recorded for exercise: \(exercise.exerciseName!)")
                    .font(.subheadline)
                    .fontWeight(.light)
                    .foregroundColor(.red)
                    .padding(.all, 80)
                    .multilineTextAlignment(.center)
            } else {
                VStack {
                    Chart {
                        ForEach(maxRepPrs) {
                            LineMark (
                                x: .value("prDate", $0.achievedOnDate!),
                                y: .value("load", $0.load),
                                series: .value("load", "A")
                            )
                            .foregroundStyle(.blue)
                        }
                        
                        if overlayBodyWeight {
                            ForEach(sortedBwEntries) {
                                LineMark (
                                    x: .value("bwDate", $0.date!),
                                    y: .value("bw", $0.bodyWeight),
                                    series: .value("bw", "C")
                                )
                                .foregroundStyle(.yellow)
                            }
                        }
                    }
                    .padding(.horizontal, 50)
                    .chartYScale(domain: 0...highestOfLoadAndBw + 20)
                    .frame(height: 150)
                    
                    Chart {
                        ForEach(sortedMaxRepPrs) {
                            LineMark (
                                x: .value("prDate", $0.achievedOnDate!),
                                y: .value("reps", $0.reps),
                                series: .value("reps", "B")
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
                    .onAppear(perform: {
                        sortedMaxRepPrs = DataUtility.sortPersonalRecordsByDate(prs: maxRepPrs) as! [MaxReps]
                    })
                    
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
        
    let context = PersistenceController.preview.container.viewContext
    let exercise = DataFetching.getExercisesAsArray(context)
        .first(where:{$0.exerciseName == "testing exercise (reps)"}) as! RepBasedExercise
    @State var maxRepPrs: [MaxReps] = (exercise).maxRepPrs!.array as! [MaxReps]
    
    return MaxRepChart(maxRepPrs: $maxRepPrs, exercise: exercise)
        .environment(\.managedObjectContext, context)
}
