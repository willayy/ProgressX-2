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
    @StateObject private var viewModel = StartWorkoutViewModel()
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        entity: Routine.entity(),
        sortDescriptors: []
    ) var routine: FetchedResults<Routine>
    
    @FetchRequest(
        entity: Routine.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Routine.timePeriodName, ascending: false)]
    ) var allRoutines: FetchedResults<Routine>
    
    @FetchRequest(
        entity: Routine.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Routine.timePeriodName, ascending: false)]
    ) var searchedRoutines: FetchedResults<Routine>
    
    @State private var showMenu: Bool = false
    
    var body: some View {
        SideBarView(content: {
            StartWorkoutNavigationController(content: {
                ScrollView {
                    VStack(alignment: .center){
                        BoldTitle(text: "Routines")
                        
                        LightSubHeadline(text: "Select the routine that you want to start/continue on")
                        
                        // MARK: Search bar
                        SearchBar(
                            searchAttribute: "timePeriodName",
                            searchText: $viewModel.searchText,
                            fetchRequest: _searchedRoutines
                        )
                        .padding(.horizontal, 20)
                        
                        // MARK: List
                        SearchableList(
                            containerName: "Routine Library",
                            elementName: "Routines",
                            allData: _allRoutines,
                            searchedData: _searchedRoutines
                        ) { routine in
                            BasicRoutineListItem(navPath: $viewModel.navPath, 
                                selectedRoutine: $viewModel.selectedRoutine,
                                selectedTrainingCycle: $viewModel.selectedTrainingCycle,
                                selectedTrainingWeek: $viewModel.selectedTrainingWeek,
                                selectedTrainingSession: $viewModel.selectedTrainingSession,
                                AllTrainingSets: $viewModel.AllTrainingSets,
                                currentTrainingSet: $viewModel.currentTrainingSet,
                                exercise: $viewModel.exercise,
                                routine: routine)
                            
                        }.padding(.horizontal, 20)
                        
                        // MARK: Explination for buttons
                        VStack{
                            HStack{
                                BoldSubHeadline(text: "Choose a specific session:")
                                Image(systemName: "calendar")
                            }
                            HStack{
                                BoldSubHeadline(text: "Continue on your previous routine:")
                                Image(systemName: "figure.run")
                            }
                        }
                    }
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            SideBarButton().environmentObject(viewRouter)
                        }
                    }
                }
            }, navPath: $viewModel.navPath,
               selectedRoutine: $viewModel.selectedRoutine,
               selectedTrainingCycle: $viewModel.selectedTrainingCycle,
               selectedTrainingWeek: $viewModel.selectedTrainingWeek,
               selectedTrainingSession: $viewModel.selectedTrainingSession,
               AllTrainingSets: $viewModel.AllTrainingSets,
                                             currentTrainingSet: $viewModel.currentTrainingSet, exercise: $viewModel.exercise)
               .environment(\.managedObjectContext, viewContext)
            
            })
        }
    }
    

#Preview {
    
    let context = PersistenceController.preview.container.viewContext
    
    return StartWorkoutView()
        .environmentObject(ViewRouter())
        .environment(\.managedObjectContext, context)
}
