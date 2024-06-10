//
//  TimeMaxChart.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-05-30.
//

import SwiftUI
import Charts

struct TimeMaxChart: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var timeMaxPrs: [TimeMax]
    @State private var overlayBodyWeight = false
    @State private var sortedTimeMaxPrs: [TimeMax] = []
    let exercise: TimeBasedExercise
    
    var body: some View {
        
        let weightUnit: String = DataFetching.getProfile(viewContext)!.isMetric ? "kg's" : "lbs"
        let bwEntries: [BodyEntry] = DataFetching.getBodyWeightEntriesAsArray(viewContext)
        let sortedBwEntries: [BodyEntry] = DataUtility.sortBwEntriesByDate(bwEntries: bwEntries)
        let highestTime: Double = DataUtility.getHighestPrValue(data: timeMaxPrs) ?? 0
        let highestWeight: Double = DataUtility.getHighestBwValue(data: bwEntries) ?? 0
        let highestLoad: Double = timeMaxPrs.map({$0.load}).max() ?? 0
        let highestOfLoadAndBw: Double = highestWeight >= highestLoad ? highestWeight : highestLoad
        
        (
            Text("Time-max")
                .font(.subheadline)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
            + Text(" chart for ")
                .font(.subheadline)
            + Text(exercise.exerciseName!)
                .font(.subheadline)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
        )
        .padding(.horizontal, 40)
        .padding(.top, 20)
        
        VStack(alignment: .leading) {
            LightSubHeadline(text: "load (\(weightUnit)) at timed set (Blue)")
            LightSubHeadline(text: "timed set pr in seconds (Black)")
            LightSubHeadline(text: "bodyweight (\(weightUnit)) (Yellow)")
        }
        
        ZStack {
            
            Rectangle()
                .cornerRadius(10)
                .foregroundStyle(Color(.systemGray6))
                .frame(height: 385)
                .padding(.horizontal, 40)
            
            if timeMaxPrs.isEmpty {
                Text("Cant genereate this chart because there are no Time PR's recorded for exercise: \(exercise.exerciseName!)")
                    .font(.subheadline)
                    .fontWeight(.light)
                    .foregroundColor(.red)
                    .padding(.all, 80)
                    .multilineTextAlignment(.center)
                
            } else {
                VStack {
                    Chart {
                        ForEach(sortedTimeMaxPrs) {
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
                        ForEach(sortedTimeMaxPrs) {
                            LineMark (
                                x: .value("prDate", $0.achievedOnDate!),
                                y: .value("time", $0.time),
                                series: .value("reps", "B")
                            )
                            .foregroundStyle(.black)
                            
                            PointMark (
                                x: .value("prDate", $0.achievedOnDate!),
                                y: .value("time", $0.time)
                            )
                            .foregroundStyle(.black)
                            
                            }
                        }
                        .padding(.horizontal, 50)
                        .chartYScale(domain: 0...highestTime + 20)
                        .frame(height: 150)
                        .onAppear(perform: {
                            sortedTimeMaxPrs = DataUtility.sortPersonalRecordsByDate(prs: timeMaxPrs) as! [TimeMax]
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
    let exercise: TimeBasedExercise = DataFetching.getExercisesAsArray(context)
        .first(where:{$0.exerciseName == "testing exercise (time)"}) as! TimeBasedExercise
    @State var timeMaxPrs : [TimeMax] = exercise.timePrs!.array as! [TimeMax]
    
    return TimeMaxChart(timeMaxPrs: $timeMaxPrs, exercise: exercise)
        .environment(\.managedObjectContext, context)
}
