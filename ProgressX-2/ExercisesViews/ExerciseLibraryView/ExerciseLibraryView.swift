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
    
    @StateObject private var viewModel = ExerciseLibraryViewModel()
    
    var body: some View {
        SideBarView(content: {
            ExerciseLibraryNavigationController(content: {
                ScrollView {
                    VStack(alignment: .center, spacing: 10) {
                        
                        BoldTitle(text: "Exercise library")
                        
                        LightSubHeadline(text: "Here you can browse exercises you have stored in your library, you can delete, edit, view statistics or add new ones.")
                        
                        SearchBar(
                            searchAttribute: "exerciseName",
                            searchText: $viewModel.searchText,
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
                                navPath: $viewModel.navPath,
                                selectedExercise: $viewModel.selectedExercise,
                                exercise: exercise
                            )
                            .environment(\.managedObjectContext, viewContext)
                        }
                        .padding(.horizontal, 20)
                        
                        // MARK: Add new exercise button
                        Button {
                            viewModel.navPath.append(1)
                        } label: {
                            Text("Add new exercise")
                                .frame(height: 40)
                            Image(systemName: "plus")
                        }
                        .buttonStyle(BorderedProminentButtonStyle())
                        .padding(.top, 20)
                        .padding(.bottom, 10)
                        
                    }
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            SideBarButton(showMenu: $viewModel.showMenu)
                                .environmentObject(viewRouter)
                        }
                    }
                }
            },  navPath: $viewModel.navPath,
                selectedExercise: $viewModel.selectedExercise,
                editingPr: $viewModel.editingPr,
                newPrType: $viewModel.newPrType)
        }, showMenu: $viewModel.showMenu)
        .environmentObject(viewRouter)
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    
    return ExerciseLibraryView()
        .environmentObject(ViewRouter())
        .environment(\.managedObjectContext, context)
}
