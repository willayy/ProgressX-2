//
//  ChooseWeekView.swift
//  ProgressX-2
//
//  Created by lucas häyhänen on 2024-07-18.
//

import SwiftUI
import CoreData

struct ChooseWeekView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @Binding var navPath: [Int]
    @Binding var selectedRoutine: Routine?
    @Binding var selectedTrainingWeek: TrainingWeek?
    
    var body: some View {
        
        let currentCycle = selectedRoutine!.nextTrainingCycle!
        
        @FetchRequest(
            entity: TrainingWeek.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \TrainingWeek.positionIndex, ascending: true)],
            predicate: NSPredicate(format: "trainingCycle == %@", currentCycle)
        ) var trainingWeeks: FetchedResults<TrainingWeek>
    
        ScrollView{
            
            VStack(alignment: .center) {
                
                BoldTitle(text: "Weeks in")
                
                Title2(text: selectedRoutine!.timePeriodName!)
                
                LightSubHeadline(text: "Here you can choose a specific week you would like to start on")
                    .padding(.vertical)
                    .padding(.horizontal)
                
                BasicList(
                    height: 400,
                    containerName: "this Routine",
                    elementName: "week",
                    data: _trainingWeeks
                ) { week in
                    TrainingWeekListItem(
                        navPath: $navPath,
                        selectedTrainingWeek: $selectedTrainingWeek,
                        trainingWeek: week
                    )
                }
                .padding(.horizontal, 20)
            }
        }
    }
}

#Preview {
    
    let context = PersistenceController.previewViewContext
    let fetchRequest: NSFetchRequest = Routine.fetchRequest()
    let routines = CoreDataAccess.fetch(context, fetchRequest: fetchRequest)
    
    let routine = routines.first!
    
    @State var navPath: [Int] = [Int]()
    @State var selectedRoutine: Routine? = routine
    @State var selectedTrainingWeek: TrainingWeek? = nil
    
    return ChooseWeekView(
        navPath: $navPath,
        selectedRoutine: $selectedRoutine,
        selectedTrainingWeek: $selectedTrainingWeek
    )
    .environment(\.managedObjectContext, context)
}

