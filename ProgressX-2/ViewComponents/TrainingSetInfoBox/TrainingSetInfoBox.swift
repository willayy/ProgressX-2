//
//  TrainingElement.swift
//  ProgressX-2
//
//  Created by lucas häyhänen on 2024-07-26.
//

import Foundation
import SwiftUI
import CoreData

struct TrainingSetInfoBox: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var currentTrainingSet: TrainingSet?

    var body: some View {

        VStack {
            
            if currentTrainingSet != nil {
                
                BoldTitle(text: currentTrainingSet!.timePeriodName!)
                
                LightSubHeadline(text: currentTrainingSet!.timePeriodDescription!)
                
                GroupBox {
                    
                    VStack(spacing: 5) {
                        
                        HStack {
                            
                            Text("Exercise:")
                                .bold()
                                .multilineTextAlignment(.leading)
                                .padding(.leading)
                            
                            Spacer()
                            
                            Text(currentTrainingSet!.exercise!.exerciseName!)
                                .multilineTextAlignment(.trailing)
                                .padding(.trailing)
                        }
                        
                        HStack{
                            
                            Text("Load todo:")
                                .bold()
                                .multilineTextAlignment(.leading)
                                .padding(.leading)
                            Spacer()
                            
                            let latestBodyEntry = PersistenceController.getLatestBodyEntry(viewContext)!
                            let bodyWeight = latestBodyEntry.bodyWeight
                            if currentTrainingSet!.loadTodo == bodyWeight {
                                Text("Bodyweight")
                                    .multilineTextAlignment(.trailing)
                                    .padding(.trailing)
                            } else {
                                Text(currentTrainingSet!.loadTodoString)
                                    .multilineTextAlignment(.trailing)
                                    .padding(.trailing)
                            }
                        }
                        
                        HStack{
                            
                            Text("Quantity todo:")
                                .bold()
                                .multilineTextAlignment(.leading)
                                .padding(.leading)
                            
                            Spacer()
                            
                            Text(currentTrainingSet!.quantityTodoString!)
                                .multilineTextAlignment(.trailing)
                                .padding(.trailing)
                        }
                        
                        HStack{
                            
                            Text("Latest PR:")
                                .bold()
                                .multilineTextAlignment(.leading)
                                .padding(.leading)
                            
                            Spacer()
                            
                            let pr = currentTrainingSet?.exercise?.latestPr
                            let prType = pr?.prType
                            
                            if prType == "maxreps" {
                                
                                Text("\(pr!.quantityString!) (AMRAP)")
                                    .multilineTextAlignment(.trailing)
                                    .padding(.trailing)
                                
                            } else if prType == "onerepmax" {
                                
                                Text("\(pr!.loadString!) (1RM)")
                                    .multilineTextAlignment(.trailing)
                                    .padding(.trailing)
                                
                            } else if prType == "timemax" {
                                
                                Text("\(pr!.quantityString!) (Time-max)")
                                    .multilineTextAlignment(.trailing)
                                    .padding(.trailing)
                                
                            } else {
                                
                                Text("No PR recorded")
                                    .multilineTextAlignment(.trailing)
                                    .padding(.trailing)
                                
                            }
                            
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    let fetchRequest: NSFetchRequest = Routine.fetchRequest()
    let routines = PersistenceController.fetch(context, fetchRequest: fetchRequest)
    
    let routine = routines.first!
    
    @State var navPath: [Int] = [Int]()
    @State var selectedRoutine: Routine? = routine
    let allTrainingCycles = routine.trainingCycles!.allObjects as! [TrainingCycle]
    @State var selectedTrainingCycle: TrainingCycle? = allTrainingCycles.first!
    
    let allTrainingWeeks = selectedTrainingCycle?.trainingWeeks!.allObjects as! [TrainingWeek]
    @State var selectedTrainingWeek: TrainingWeek? = allTrainingWeeks.first!
    
    let allTrainingSessions = selectedTrainingWeek?.trainingSessions!.allObjects as! [TrainingSession]
    @State var selectedTrainingSession: TrainingSession? = allTrainingSessions.first(where: {$0.timePeriodName == "Session 1"})
    
    @State var allTrainingSets = selectedTrainingSession?.trainingSets!.allObjects as! [TrainingSet]
    
    @State var currentTrainingSet = allTrainingSets.first
    
    return TrainingSetInfoBox(currentTrainingSet: $currentTrainingSet)
}
