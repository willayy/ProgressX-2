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
    @State private var selectedThreshold: SetThreshold? = nil
    
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
            RoutineLibraryNavigationController(content: {
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
            },
           navPath: $navPath,
           selectedRoutine: $selectedRoutine,
           selectedTemplateCycle: $selectedTemplateCycle,
           selectedTemplateWeek: $selectedTemplateWeek,
           selectedTemplateSession: $selectedTemplateSession,
           selectedTemplateSet: $selectedTemplateSet,
           selectedThreshold: $selectedThreshold)
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
