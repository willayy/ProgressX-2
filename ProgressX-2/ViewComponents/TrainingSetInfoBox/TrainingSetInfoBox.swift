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
                            
                            let latestBodyEntry = CoreDataAccess.getLatestBodyEntry(viewContext)!
                            
                            let bodyWeight = latestBodyEntry.bodyWeight
                            
                            if currentTrainingSet!.loadTodo == bodyWeight {
                                
                                Text("Bodyweight (\(currentTrainingSet!.formattedLoadTodo))")
                                    .multilineTextAlignment(.trailing)
                                    .padding(.trailing)
                                
                            } else {
                                
                                Text(currentTrainingSet!.formattedLoadTodo)
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
                            
                            Text(currentTrainingSet!.formattedQuantityTodo!)
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
                            
                            if prType == PersonalRecordType.MaxReps.rawValue {
                                
                                Text("\(pr!.quantityString!) (AMRAP)")
                                    .multilineTextAlignment(.trailing)
                                    .padding(.trailing)
                                
                            } else if prType == PersonalRecordType.OneRepMax.rawValue {
                                
                                Text("\(pr!.loadString!) (1RM)")
                                    .multilineTextAlignment(.trailing)
                                    .padding(.trailing)
                                
                            } else if prType == PersonalRecordType.TimeMax.rawValue {
                                
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
    
    let context = PersistenceController.previewViewContext
    
    let fetchRequest: NSFetchRequest = TrainingSet.fetchRequest()
    
    let results = CoreDataAccess.fetch(context, fetchRequest: fetchRequest)
    
    @State var currentTrainingSet = results.first
    
    return TrainingSetInfoBox(currentTrainingSet: $currentTrainingSet)
        .environment(\.managedObjectContext, context)
}
