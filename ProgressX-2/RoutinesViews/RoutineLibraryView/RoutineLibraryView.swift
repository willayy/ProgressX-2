//
//  RoutineLibraryView.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-06-19.
//

import SwiftUI

struct RoutineLibraryView: View {
    
    @StateObject private var viewModel = RoutineLibraryViewModel()
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        entity: Routine.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Routine.timePeriodName, ascending: false)]
    ) var allRoutines: FetchedResults<Routine>
    
    @FetchRequest(
        entity: Routine.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Routine.timePeriodName, ascending: false)]
    ) var searchedRoutines: FetchedResults<Routine>
    
    var body: some View {
        
            RoutineLibraryNavigationController(
                navPath: $viewModel.navPath,
                selectedRoutine: $viewModel.selectedRoutine,
                selectedTemplateCycle: $viewModel.selectedTemplateCycle,
                selectedTemplateWeek: $viewModel.selectedTemplateWeek,
                selectedTemplateSession: $viewModel.selectedTemplateSession,
                selectedTemplateSet: $viewModel.selectedTemplateSet,
                selectedThreshold: $viewModel.selectedThreshold,
            content: {
            ScrollView {
                VStack(alignment: .center) {
                    
                    //MARK: View header text
                    BoldTitle(text: "Routine library")
                        .padding(.horizontal, 20)
                    
                    HiddenLightSubHeadline(
                        title: "What is a Routine?",
                        text: "The routine is your training program, a routine consists of 1 or more Weeks. This gives you both the possibility of doing the same training sessions every week and having an alternating week schedule."
                    )
                    .padding(.horizontal, 20)
                    
                    // MARK: Search bar
                    SearchBar(
                        searchAttribute: "timePeriodName",
                        searchText: $viewModel.searchText,
                        fetchRequest: _searchedRoutines
                    )
                    .padding(.top, 20)
                    .padding(.horizontal, 20)
                    
                    // MARK: List
                    SearchableList(
                        containerName: "Routine Library",
                        elementName: "Routines",
                        allData: _allRoutines,
                        searchedData: _searchedRoutines
                    ) { routine in
                        RoutineListItem(
                            navPath: $viewModel.navPath,
                            selectedRoutine: $viewModel.selectedRoutine,
                            selectedTemplateCycle: $viewModel.selectedTemplateCycle,
                            routine: routine
                        )
                        .environment(\.managedObjectContext, viewContext)
                    }
                    .padding(.horizontal, 20)
                    
                    // MARK: Add new Routine button
                    Button {
                        viewModel.navPath.append(1)
                    } label: {
                        Text("Add new Routine")
                            .frame(height: 40)
                            .foregroundColor(Color("buttonTextColor"))
                        Image(systemName: "plus")
                            .foregroundColor(Color("buttonTextColor"))
                    }
                    .buttonStyle(BorderedProminentButtonStyle())
                    .padding(.top, 20)
                    .padding(.bottom, 10)
                    
                }
            }
        })
        .environment(\.managedObjectContext, viewContext)
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    
    return RoutineLibraryView()
        .environment(\.managedObjectContext, context)
}
