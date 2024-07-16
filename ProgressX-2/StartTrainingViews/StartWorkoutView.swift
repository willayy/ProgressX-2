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
    
    @FetchRequest(
        entity: Routine.entity(),
        sortDescriptors: []
    ) var routines: FetchedResults<Routine>
    
    
    @State private var showMenu: Bool = false
    @State private var routine: Routine? = nil
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
                        PersistenceController.save(viewContext)
                    }) {
                        Text("Start New Training Cycle")
                    }
                    Button(action: {
                        print(routines)
                    }) {
                        
                        Text("increse load Routine1, Week 1, Session 1, set 1")

                    }
                }
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        SideBarButton(showMenu: $showMenu).environmentObject(viewRouter)
                    }
                }
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
    
    return StartWorkoutView()
        .environmentObject(ViewRouter())
        .environment(\.managedObjectContext, context)
}
