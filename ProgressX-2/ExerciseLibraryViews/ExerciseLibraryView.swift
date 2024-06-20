//
//  CreateNewExercise.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-05-14.
//

import SwiftUI
import CoreData

struct ExerciseLibraryView: View {
    
    @EnvironmentObject private var viewRouter: ViewRouter
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        entity: Exercise.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Exercise.exerciseName, ascending: false)]
    ) private var allExercises: FetchedResults<Exercise>
    
    @FetchRequest(
        entity: Exercise.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Exercise.exerciseName, ascending: false)]
    ) private var searchedExercises: FetchedResults<Exercise>
    
    @State private var showMenu: Bool = false
    @State private var navPath = [Int]()
    @State private var selectedExercise: Exercise? = nil
    @State private var searchText: String = ""
    @State private var editingPr: PersonalRecord?
    @State private var newPrType: String? = nil
    
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
                    VStack(alignment: .center, spacing: 10) {
                        
                        BoldTitle(text: "Exercise library")
                        
                        LightSubHeadline(text: "Here you can browse exercises you have stored in your library, you can delete, edit, view statistics or add new ones.")
                        
                        SearchBar(
                            searchAttribute: "exerciseName",
                            searchText: $searchText,
                            fetchRequest: _searchedExercises
                        )
                            .padding(.top, 20)
                        
                        //MARK: List view displaying all exercise objects
                        VStack(alignment: .center) {
                            if allExercises.isEmpty {
                                Text("You currently have no exercises saved to the exercise library...")
                                    .font(.subheadline)
                                    .fontWeight(.light)
                                    .padding(.bottom, 20)
                                    .padding(.top, 20)
                                    .foregroundStyle(.red)
                            } else if searchedExercises.isEmpty {
                                LightSubHeadline(text: "No Exercises matched your search...")
                                    .padding(.vertical, 20)
                            } else {
                                List {
                                    ForEach(searchedExercises) { exercise in
                                        ExerciseListItem(
                                            navPath: $navPath,
                                            selectedExercise: $selectedExercise,
                                            exercise: exercise
                                        )
                                        .environment(\.managedObjectContext, viewContext)
                                    }
                                }
                                .frame(height: 400)
                                .background(Color(.systemGray6))
                                .cornerRadius(10)
                                .padding(.horizontal, 20)
                            }
                        }
                        
                        // MARK: Add new exercise button
                        Button {
                            navPath.append(1)
                        } label: {
                            Text("Add new exercise")
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
                        CreateNewExerciseView()
                            .environment(\.managedObjectContext, viewContext)
                    } else if selection == 2 {
                        EditExerciseView(
                            exercise: $selectedExercise
                        ).environment(\.managedObjectContext, viewContext)
                    } else if selection == 3 {
                        StatisticsView(
                            exercise: $selectedExercise,
                            navPath: $navPath,
                            editingPr: $editingPr,
                            newPrType: $newPrType
                        ).environment(\.managedObjectContext, viewContext)
                    } else if selection == 4 {
                        EditPrView(
                            editingPr: $editingPr,
                            exercise: $selectedExercise
                        ).environment(\.managedObjectContext, viewContext)
                    } else if selection == 5 {
                        CreateNewPersonalRecord(
                            prType: $newPrType,
                            exercise: $selectedExercise
                        ).environment(\.managedObjectContext, viewContext)
                    }
                }
            }
        } menuView: { safeArea in
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
    
    return ExerciseLibraryView()
        .environmentObject(ViewRouter())
        .environment(\.managedObjectContext, context)
}
