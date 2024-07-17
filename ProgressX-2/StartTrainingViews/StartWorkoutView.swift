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
    
    @StateObject private var viewModel = StartWorkoutViewModel()
    
    @State private var showMenu: Bool = false
    @Binding var routine: Routine?
    
    @FetchRequest(
        entity: Routine.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Routine.timePeriodName, ascending: false)]
    ) var allRoutines: FetchedResults<Routine>
    
    @FetchRequest(
        entity: Routine.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Routine.timePeriodName, ascending: false)]
    ) var searchedRoutines: FetchedResults<Routine>
    
    
    var body: some View {
        SideBar(
            rotateWhenExpands: true, // true
            disableInteractions: true, // true
            sideMenuWidth: 200,
            cornerRadius: 25, // 25
            showMenu: $showMenu
        ) { safeArea in
            NavigationStack{
                VStack{
                    BoldTitle(text: "Routines")
                    
                    LightSubHeadline(text: "Pick the routine that you want to start/continue on")
                    SearchableList(
                        containerName: "Routine Library",
                        elementName: "Routines",
                        allData: _allRoutines,
                        searchedData: _searchedRoutines
                    ) { routine in 
                    BasicRoutineListItem(navPath: $viewModel.navPath, selectedRoutine: $viewModel.selectedRoutine, selectedTrainingCycle: $viewModel.selectedTrainingCycle, routine: routine)
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        SideBarButton(showMenu: $showMenu).environmentObject(viewRouter)
                    }
                    ToolbarItem(placement: .topBarTrailing){
                        Button(action: {
                            copyRoutineTemplate(context: viewContext)
                            print(routine)
                        }) {
                            Text("Start New Training Cycle")
                            
                        }
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
    
    let fetchRequest: NSFetchRequest<Routine> = Routine.fetchRequest()
    let results = PersistenceController.fetch(context, fetchRequest: fetchRequest)
    @State var routine = results.first
    
    return StartWorkoutView(routine: $routine)
        .environmentObject(ViewRouter())
        .environment(\.managedObjectContext, context)
}
