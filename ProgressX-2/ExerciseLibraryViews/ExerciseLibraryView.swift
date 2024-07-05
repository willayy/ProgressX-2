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
        SideBarView(content: {
            ExerciseLibraryNavigationController(content: {
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
                        SearchableList(
                            containerName: "Exercise Library",
                            elementName: "Exercises",
                            allData: _allExercises,
                            searchedData: _searchedExercises
                        ) { exercise in
                            ExerciseListItem(
                                navPath: $navPath,
                                selectedExercise: $selectedExercise,
                                exercise: exercise
                            )
                            .environment(\.managedObjectContext, viewContext)
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
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            SideBarButton(showMenu: $showMenu)
                                .environmentObject(viewRouter)
                        }
                    }
                }
            },navPath: $navPath,
            selectedExercise: $selectedExercise,
            editingPr: $editingPr,
            newPrType: $newPrType)
        }, showMenu: $showMenu)
        .environmentObject(viewRouter)
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    
    return ExerciseLibraryView()
        .environmentObject(ViewRouter())
        .environment(\.managedObjectContext, context)
}
