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
    
    @StateObject private var viewModel = ChooseWeekViewModel()
    @Binding var navPath: [Int]
    @Binding var selectedRoutine: Routine?
    @Binding var selectedTrainingCycle: TrainingCycle?
    @Binding var selectedTrainingWeek: TrainingWeek?
    
    
    var body: some View {
        
        @FetchRequest(
            entity: TrainingWeek.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \TrainingWeek.positionIndex, ascending: true)],
            predicate: NSPredicate(format: "trainingCycle == %@", selectedTrainingCycle!)
        ) var TrainingWeeks: FetchedResults<TrainingWeek>
        
        ScrollView{
            VStack(alignment: .center){
                BoldTitle(text: "Weeks")
                LightSubHeadline(text: "Here you can choose a spesific week you would like to start on").padding(.bottom)
            BasicList(
                height: 400,
                containerName: "this Routine",
                elementName: "week",
                data: _TrainingWeeks
            ) { week in
                TrainingWeekListItem(
                    navPath: $navPath,
                    selectedTrainingWeek: $selectedTrainingWeek,
                    week: week
                )
                .environment(\.managedObjectContext, viewContext)
            }.padding(.horizontal, 20)
                VStack{
                    HStack{
                        BoldSubHeadline(text: "Choose a specific Week:")
                        Image(systemName: "calendar")
                    }                }
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
    @State var selectedTrainingWeek: TrainingWeek? = nil
    
    return ChooseWeekView(
        navPath: $navPath,
        selectedRoutine: $selectedRoutine,
        selectedTrainingCycle: $selectedTrainingCycle, 
        selectedTrainingWeek: $selectedTrainingWeek
    )
    .environment(\.managedObjectContext, context)
}

