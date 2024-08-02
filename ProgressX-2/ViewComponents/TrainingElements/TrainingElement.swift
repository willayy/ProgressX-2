//
//  TrainingElement.swift
//  ProgressX-2
//
//  Created by lucas häyhänen on 2024-07-26.
//

import Foundation
import SwiftUI
import CoreData

struct TrainingElement: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var currentSet: TrainingSet?

    var body: some View {

        VStack{
            Text(currentSet!.timePeriodName!)
                .bold()
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .frame(width: 100)
            Text(currentSet!.timePeriodDescription!)
            
            ZStack{
                Rectangle().foregroundColor(Color(.lightGray))
                    .cornerRadius(8)
                VStack{
                    HStack{
                        Text("Exercise")
                            .bold()
                            .multilineTextAlignment(.leading)
                            .padding(.leading)
                        
                        Spacer()
                        
                        Text(currentSet!.exercise!.exerciseName!)
                            .bold()
                            .multilineTextAlignment(.trailing)
                            .padding(.trailing)
                    }
                    .padding(.bottom, 2.0)
                    
                    HStack{
                        Text("Load todo")
                            .bold()
                            .multilineTextAlignment(.leading)
                            .padding(.leading)
                        Spacer()
                        
                        Text(currentSet!.loadTodoString)
                            .bold()
                            .multilineTextAlignment(.trailing)
                            .padding(.trailing)
                    }
                    .padding(.bottom, 2.0)
                    
                    HStack{
                        Text("Quantity todo")
                            .bold()
                            .multilineTextAlignment(.leading)
                            .padding(.leading)
                        
                        Spacer()
                        
                        Text(currentSet!.quantityTodoString!)
                            .bold()
                            .multilineTextAlignment(.trailing)
                            .padding(.trailing)
                    }
                    .padding(.bottom, 2.0)
                    
                    HStack{
                        Text("One Rep Max")
                            .bold()
                            .multilineTextAlignment(.leading)
                            .padding(.leading)
                        
                        Spacer()
                        
                        Text(currentSet!.exercise!.latestPr?.loadString ?? "")
                            .bold()
                            .multilineTextAlignment(.trailing)
                            .padding(.trailing)
                    }
                    .padding(.bottom, 2.0)
                }
            }
            .padding(.top, 5)
            .padding(.horizontal)
            .frame(height: 160)
            
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
    allTrainingSets.sorted(by: {$0.positionIndex > $1.positionIndex})
    
    @State var currentTrainingSet = allTrainingSets.first
    
    return TrainingElement(currentSet: $currentTrainingSet)
}
