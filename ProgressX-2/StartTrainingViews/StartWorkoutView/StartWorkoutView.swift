//
//  StartWorkoutView.swift
//  ProgressX-2
//
//  Created by lucas häyhänen on 2024-07-04.
//

import SwiftUI
import CoreData


struct StartWorkoutView: View {
        
    @StateObject private var viewModel = StartWorkoutViewModel()
        
    @Binding var navPath: [Int]
    
    @Binding var selectedRoutine: Routine?
    
    @Binding var selectedTrainingSession: TrainingSession?
    
    @Binding var currentTrainingSet: TrainingSet?
    
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
                        navPath: $navPath,
                        selectedRoutine: $selectedRoutine,
                        selectedSession: $selectedTrainingSession,
                        currentTrainingSet: $currentTrainingSet,
                        routine: routine
                    )
                }.padding(.horizontal, 20)
                
            }
            
        }
        
    }
    
}
    

#Preview {
    
    let context = PersistenceController.previewViewContext
    
    @State var navPath: [Int] = [Int]()
    @State var selectedRoutine: Routine? = nil
    @State var selectedTrainingSession: TrainingSession? = nil
    @State var currentTrainingSet: TrainingSet? = nil
    
    return StartWorkoutView(
        navPath: $navPath,
        selectedRoutine: $selectedRoutine,
        selectedTrainingSession: $selectedTrainingSession,
        currentTrainingSet: $currentTrainingSet
    )
    .environmentObject(ShowMenuController())
    .environment(\.managedObjectContext, context)
    
}
