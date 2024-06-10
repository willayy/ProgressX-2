//
//  PrChart.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-05-24.
//

import SwiftUI
import Charts

struct OneRepMaxChart: View {
 
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var oneRepMaxPrs: [OneRepMax]
    @State private var overlayBodyWeight = false
    @State private var sortedOneRepMaxPrs: [OneRepMax] = []
    let exercise: RepBasedExercise
    
    var body: some View {
        
        let weightUnit: String = DataFetching.getProfile(viewContext)!.isMetric ? "kg's" : "lbs"
        let bwEntries: [BodyEntry] = DataFetching.getBodyWeightEntriesAsArray(viewContext)
        let sortedBwEntries: [BodyEntry] = DataUtility.sortBwEntriesByDate(bwEntries: bwEntries)
        let highest1RM = DataUtility.getHighestPrValue(data: oneRepMaxPrs) ?? 0
        let highestBw = DataUtility.getHighestBwValue(data: bwEntries) ?? 0
        let highestOf1RmAndBw = highest1RM >= highestBw ? highest1RM : highestBw
        
        (Text("1RM")
            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
         + Text(" chart for ")
         + Text(exercise.exerciseName!)
            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/))
        .padding(.horizontal, 40)
        .padding(.top, 20)
        
        VStack(alignment: .leading) {
            LightSubHeadline(text: "load (\(weightUnit)) at AMRAP set (Black)")
            LightSubHeadline(text: "bodyweight (\(weightUnit)) (Yellow)")
        }
        
        ZStack {
            
            Rectangle()
                .cornerRadius(10)
                .foregroundStyle(Color(.systemGray6))
                .frame(height: 225)
                .padding(.horizontal, 40)
            
            if oneRepMaxPrs.isEmpty {
                Text("Cant genereate this chart because there are no 1RM PR's recorded for exercise: \(exercise.exerciseName!)")
                    .font(.subheadline)
                    .fontWeight(.light)
                    .foregroundColor(.red)
                    .padding(.all, 80)
                    .multilineTextAlignment(.center)
            } else {
                VStack {
                    Chart {
                        ForEach(sortedOneRepMaxPrs) {
                            LineMark (
                                x: .value("prDate", $0.achievedOnDate!),
                                y: .value("load", $0.load),
                                series: .value("load", "A")
                            )
                            .foregroundStyle(.black)
                            
                            PointMark (
                                x: .value("prDate", $0.achievedOnDate!),
                                y: .value("load", $0.load)
                            )
                            .foregroundStyle(.black)
                        }
                        
                        if overlayBodyWeight {
                            ForEach(sortedBwEntries) {
                                LineMark (
                                    x: .value("bwDate", $0.date!),
                                    y: .value("bodyweight", $0.bodyWeight),
                                    series: .value("bw", "B")
                                )
                                .foregroundStyle(.yellow)
                            }
                        }
                    }
                    .padding(.horizontal, 50)
                    .chartYScale(domain: 0...highestOf1RmAndBw + 20)
                    .frame(height: 150)
                    .onAppear(perform: {
                        sortedOneRepMaxPrs = DataUtility.sortPersonalRecordsByDate(prs: oneRepMaxPrs) as! [OneRepMax]
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
    @State var oneRepMaxPrs: [OneRepMax] = exercise.oneRepMaxPrs!.array as! [OneRepMax]
    
    return OneRepMaxChart(oneRepMaxPrs: $oneRepMaxPrs, exercise: exercise)
        .environment(\.managedObjectContext, context)
}
