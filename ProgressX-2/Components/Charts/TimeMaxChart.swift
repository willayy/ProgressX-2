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
    
    @State var overlayBodyWeight = false
    let exercise: TimeBasedExercise
    
    var body: some View {
        
        let prs: [TimeMax] = DataUtility.getTimePrs(exercise: exercise) ?? []
        let bwEntries: [BodyEntry] = DataUtility.getBodyWeightEntriesAsArray()
        let sortedPrs: [TimeMax] = DataUtility.sortPersonralRecordsByDate(prs: prs) as! [TimeMax]
        let sortedBwEntries: [BodyEntry] = DataUtility.sortBwEntriesByDate(bwEntries: bwEntries)
        let highestTime: Double = DataUtility.getHighestPrValue(data: prs) ?? 0
        
        let highestWeight: Double = DataUtility.getHighestBwValue(data: bwEntries) ?? 0
        let highestLoad: Double = prs.map({$0.load}).max() ?? 0
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
            LightSubHeadline(text: "load at timed set (Blue)")
            LightSubHeadline(text: "time at timed set (Black)")
            LightSubHeadline(text: "bodyweight (Yellow)")
        }
        
        ZStack {
            
            Rectangle()
                .cornerRadius(10)
                .foregroundStyle(Color(.systemGray6))
                .frame(height: 385)
                .padding(.horizontal, 40)
            
            if prs.isEmpty {
                Text("Cant genereate this chart because there are no Time PR's recorded for exercise: \(exercise.exerciseName!)")
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
                                series: .value("load", "A")
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
    let exercise: TimeBasedExercise = DataUtility.getExercisesAsArray()
        .first(where:{$0.exerciseName == "testing exercise (time)"}) as! TimeBasedExercise
    
    return TimeMaxChart(exercise: exercise)
        .environment(\.managedObjectContext, container.viewContext)
}
