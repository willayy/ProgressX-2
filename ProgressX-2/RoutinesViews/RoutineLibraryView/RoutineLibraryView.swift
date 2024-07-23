//
//  RoutineLibraryView.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-06-19.
//

import SwiftUI

struct RoutineLibraryView: View {
    
    @EnvironmentObject private var viewRouter: ViewRouter
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
        
        SideBarView(
            showMenu: $viewModel.showMenu,
            content: {
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
                        
                        LightSubHeadline(text: "Here you can browse Routines you have created, view statistics, edit them and create new ones.")
                        
                        // MARK: Search bar
                        SearchBar(
                            searchAttribute: "timePeriodName",
                            searchText: $viewModel.searchText,
                            fetchRequest: _searchedRoutines
                        )
                        .padding(.top, 20)
                        
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
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        SideBarButton(showMenu: $viewModel.showMenu)
                            .environmentObject(viewRouter)
                    }
                }
            })
            .environment(\.managedObjectContext, viewContext)
        })
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    
    return RoutineLibraryView()
        .environmentObject(ViewRouter())
        .environment(\.managedObjectContext, context)
}
