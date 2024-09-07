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
        
    StartWorkoutNavigationController(
        navPath: $viewModel.navPath,
        selectedRoutine: $viewModel.selectedRoutine,
        selectedTrainingWeek: $viewModel.selectedTrainingWeek,
        selectedTrainingSession: $viewModel.selectedTrainingSession,
        currentTrainingSet: $viewModel.currentTrainingSet,
        content: {
            
            ScrollView {
                
                VStackWithSideBarButton {
                    
                    BoldTitle(text: "Routines")
                    
                    
                    HiddenLightSubHeadline(
                        title: "How do i start training?",
                        text: "By pressing the icon of a running man you will automatically start the next session in the order of the routine. If you want more control you can click the calender icon and select precisely which session you want to do.",
                        alignment: .leading
                    )
                    .padding(.horizontal, 20)
                    .padding(.bottom)
                    
                    // MARK: Search bar
                    SearchBar(
                        searchAttribute: "timePeriodName",
                        searchText: $viewModel.searchText,
                        fetchRequest: _searchedRoutines
                    )
                    .padding(.horizontal, 20)
                    
                    // MARK: List
                    SearchableList(
                        height: 500,
                        containerName: "Routine Library",
                        elementName: "Routines",
                        allData: _allRoutines,
                        searchedData: _searchedRoutines
                    ) { routine in
                        TrainingViewRoutineListItem(
                            navPath: $viewModel.navPath,
                            selectedRoutine: $viewModel.selectedRoutine,
                            selectedSession: $viewModel.selectedTrainingSession,
                            currentTrainingSet: $viewModel.currentTrainingSet,
                            routine: routine
                        )
                    }.padding(.horizontal, 20)
                    
                }
            }
        })
    }
}
    

#Preview {
    
    let context = PersistenceController.previewViewContext
    
    return StartWorkoutView()
        .environmentObject(ShowMenuController())
        .environment(\.managedObjectContext, context)
}
