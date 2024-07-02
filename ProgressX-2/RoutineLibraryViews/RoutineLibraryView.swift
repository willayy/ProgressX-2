//
//  RoutineLibraryView.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-06-19.
//

import SwiftUI

struct RoutineLibraryView: View {
    
    @EnvironmentObject private var viewRouter: ViewRouter
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        entity: Routine.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Routine.timePeriodName, ascending: false)]
    ) var allRoutines: FetchedResults<Routine>
    
    @FetchRequest(
        entity: Routine.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Routine.timePeriodName, ascending: false)]
    ) var searchedRoutines: FetchedResults<Routine>
    
    // TimePeriod selections
    @State private var selectedRoutine: Routine? = nil
    @State private var selectedTemplateCycle: TemplateCycle? = nil
    @State private var selectedTemplateWeek: TemplateWeek? = nil
    @State private var selectedTemplateSession: TemplateSession? = nil
    @State private var selectedTemplateSet: TemplateSet? = nil
    
    @State private var showMenu: Bool = false
    @State private var navPath: [Int] = [Int]()
    @State private var searchText: String = ""
    
    var body: some View {
        
        SideBar(
            rotateWhenExpands: true,
            disableInteractions: true,
            sideMenuWidth: 200,
            cornerRadius: 25,
            showMenu: $showMenu
        ) { safeArea in
            NavigationStack(path: $navPath) {
                ScrollView {
                    VStack(alignment: .center) {
                        //MARK: View header text
                        BoldTitle(text: "Routine library")
                        
                        LightSubHeadline(text: "Here you can browse Routines you have created, view statistics, edit them and create new ones.")
                        
                        // MARK: Search bar
                        SearchBar(
                            searchAttribute: "timePeriodName",
                            searchText: $searchText,
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
                                navPath: $navPath,
                                selectedRoutine: $selectedRoutine,
                                selectedTemplateCycle: $selectedTemplateCycle,
                                routine: routine
                            )
                            .environment(\.managedObjectContext, viewContext)
                        }
                        
                        // MARK: Add new Routine button
                        Button {
                            navPath.append(1)
                        } label: {
                            Text("Add new Routine")
                                .frame(height: 40)
                            Image(systemName: "plus")
                        }
                        .buttonStyle(BorderedProminentButtonStyle())
                        .padding(.top, 10)
                        
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        SideBarButton(showMenu: $showMenu)
                            .environmentObject(viewRouter)
                    }
                }
                //MARK: Handling the navigation through the NavStack
                // This is the root view of this whole view-hierarchy.
                // If you want to add more viewas add to this group of if statements.
                .navigationDestination(for: Int.self) { selection in
                    if selection == 1 {
                        
                        // MARK: Create new routine
                        CreateNewRoutineView(
                            navPath: $navPath,
                            selectedRoutine: $selectedRoutine
                        )
                        .environment(\.managedObjectContext, viewContext)
                        
                    } else if selection == 2 {
                        
                        // MARK: Edit routine
                        EditRoutineView(
                            navPath: $navPath,
                            selectedRoutine: $selectedRoutine,
                            selectedTemplateCycle: $selectedTemplateCycle,
                            selectedTemplateWeek: $selectedTemplateWeek
                        )
                        .environment(\.managedObjectContext, viewContext)
                        
                    } else if selection == 3 {
                        
                        // MARK: Routine statistic
                        RoutineStatisticsView()
                        
                    } else if selection == 4 {
                        
                        // MARK: Edit week
                        EditWeekView(
                            navPath: $navPath,
                            selectedTemplateWeek: $selectedTemplateWeek,
                            selectedTemplateSession: $selectedTemplateSession
                        )
                        .environment(\.managedObjectContext, viewContext)
                        
                    } else if selection == 5 {
                        
                        // MARK: Edit session
                        EditSessionView(
                            navPath: $navPath,
                            selectedTemplateSet: $selectedTemplateSet,
                            selectedTemplateSession: $selectedTemplateSession
                        )
                        .environment(\.managedObjectContext, viewContext)
                        
                    } else if selection == 6 {
                        
                        // MARK: Edit set
                        #warning("TODO: Implemented edit set")
                        
                    } else if selection == 7 {
                        
                        // MARK: Create new set
                        CreateNewTemplateSetView(
                            navPath: $navPath, 
                            selectedTemplateSession: $selectedTemplateSession
                        )
                        .environment(\.managedObjectContext, viewContext)
                        
                    } else if selection == 8 {
                        
                        // MARK: Add Thresholds
                        AddThresholdsView(
                            selectedTemplateSet: $selectedTemplateSet
                        )
                        .environment(\.managedObjectContext, viewContext)
                        
                    }
                }
            }
        } menuView: { safeArea in
            SideBarMenuView(safeArea)
        } Background: {
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
    
    return RoutineLibraryView()
        .environmentObject(ViewRouter())
        .environment(\.managedObjectContext, context)
}
