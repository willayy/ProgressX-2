//
//  StartWorkoutView.swift
//  ProgressX-2
//
//  Created by lucas häyhänen on 2024-07-04.
//

import SwiftUI
import CoreData


struct StartWorkoutView: View {

    
    @EnvironmentObject var viewRouter: ViewRouter
    @Environment(\.managedObjectContext) private var viewContext
    
    let fetchRequestRoutine: NSFetchRequest<Routine> = Routine.fetchRequest()
    let fetchRequestCycle: NSFetchRequest<TrainingCycle> =  TrainingCycle.fetchRequest()
    
    @State private var showMenu: Bool = false
    @Binding var routine: Routine?
    @State private var trainingCycle: TrainingCycle? = nil
    
    var body: some View {

        @FetchRequest(
            entity: TrainingCycle.entity(),
            sortDescriptors: [],
            predicate: NSPredicate(format: "routine == %@", routine ?? [])
        ) var trainingCycles: FetchedResults<TrainingCycle>
        
        @FetchRequest(
            entity: TrainingWeek.entity(),
            sortDescriptors: [],
            predicate: NSPredicate(format: "trainingCycle == %@", trainingCycle ?? [])
        ) var trainingWeeks: FetchedResults<TrainingWeek>
        
        SideBar(
            rotateWhenExpands: true, // true
            disableInteractions: true, // true
            sideMenuWidth: 200,
            cornerRadius: 25, // 25
            showMenu: $showMenu
        ) { safeArea in
            NavigationStack{
                VStack{
                    Button(action: {
                        copyRoutineTemplate(context: viewContext)
                    }) {
                        Text("Start New Training Cycle")
                    }
                    Button(action: {
                        print(routine?.trainingCycles?.count)
                    }) {
                        Text("increse load Routine1, Week 1, Session 1, set 1")
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        SideBarButton(showMenu: $showMenu).environmentObject(viewRouter)
                    }
                }
                
                Text(String(routine?.trainingCycles?.count ?? 0))
                
            }
        }menuView: { safeArea in
            SideBarMenuView(safeArea)
        } Background: {
            // propperty of the background in side menu
            Rectangle()
        }
    }
    
    @ViewBuilder
    func SideBarMenuView(_ safeArea: UIEdgeInsets) -> some View {
        SideBarBuilder(safeArea: safeArea, showMenu: $showMenu)
            .environmentObject(viewRouter)
    }
}

#Preview {
    
    let context = PersistenceController.preview.container.viewContext
    
    let fetchRequest: NSFetchRequest<Routine> = Routine.fetchRequest()
    let results = PersistenceController.fetch(context, fetchRequest: fetchRequest)
    @State var routine = results.first
    
    return StartWorkoutView(routine: $routine)
        .environmentObject(ViewRouter())
        .environment(\.managedObjectContext, context)
}
