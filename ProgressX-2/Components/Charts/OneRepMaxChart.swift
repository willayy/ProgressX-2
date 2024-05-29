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
    
    @State var overlayBodyWeight = false
    let exercise: RepBasedExercise
    
    private func getYscale() -> Double {
        let bwData = getBwData()
        let prData = getPrData()
        let highestWeight = DataUtility.getHighestBwValue(data: bwData)
        let highest1RM = DataUtility.getHighestPrValue(data: prData)
        let highestTotal = highestWeight! >= highest1RM ?? 0 ? highestWeight : highest1RM
        return highestTotal! + 10
    }
    
    private func getBwData() -> [BodyEntry] {
        let bwEntries = DataUtility.getBodyWeightEntriesAsArray()
            .sorted(by: { $0.date! < $1.date! })
        return bwEntries
    }
    
    private func getPrData() -> [OneRepMax] {
        var prData = exercise.oneRepMaxPrs?.array as! [OneRepMax]
        prData = prData.sorted(by: { $0.achievedOnDate! < $1.achievedOnDate! })
        return prData
    }
    
    private func getExerciseName() -> String {
        return exercise.exerciseName!
    }
    
    var body: some View {
        
        (Text("1RM")
            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
         + Text(" chart for ")
         + Text(getExerciseName())
            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/))
        .padding(.horizontal, 40)
        .padding(.top, 20)
        
        ZStack {
            
            Rectangle()
                .cornerRadius(10)
                .foregroundStyle(Color(.systemGray6))
                .frame(height: 375)
                .padding(.horizontal, 40)
            
            if getPrData().isEmpty {
                Text("Cant genereate chart because there are no PR's recorded for exercise: \(getExerciseName())")
                    .font(.subheadline)
                    .fontWeight(.light)
                    .foregroundColor(.red)
                    .padding(.all, 80)
                    .multilineTextAlignment(.center)
            } else {
                VStack {
                    Chart {
                        
                        ForEach(getPrData()) {
                            LineMark (
                                x: .value("prDate", $0.achievedOnDate!),
                                y: .value("PR", $0.load),
                                series: .value("PR", "A")
                            )
                            .foregroundStyle(.black)
                            
                            PointMark (
                                x: .value("prDate", $0.achievedOnDate!),
                                y: .value("PR", $0.load)
                            )
                            .foregroundStyle(.black)
                        }
                        
                        if overlayBodyWeight {
                            ForEach(getBwData()) {
                                LineMark (
                                    x: .value("bwDate", $0.date!),
                                    y: .value("Bodyweight", $0.bodyWeight),
                                    series: .value("BodyWeight", "B")
                                )
                                .foregroundStyle(.yellow)
                            }
                        }
                        
                    }
                    .padding(.horizontal, 50)
                    .chartYScale(domain: 0...getYscale())
                    .frame(height: 300)
                    
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
    let exercise: RepBasedExercise = DataUtility.getExercisesAsArray().first! as! RepBasedExercise
    
    return OneRepMaxChart(exercise: exercise)
        .environment(\.managedObjectContext, container.viewContext)
}
