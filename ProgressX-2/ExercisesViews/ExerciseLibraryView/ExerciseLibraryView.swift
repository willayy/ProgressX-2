//
//  CreateNewExercise.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-05-14.
//

import SwiftUI
import CoreData

struct ExerciseLibraryView: View {
    
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
        
        ExerciseLibraryNavigationController(
        navPath: $viewModel.navPath,
        selectedExercise: $viewModel.selectedExercise,
        editingPr: $viewModel.editingPr,
        newPrType: $viewModel.newPrType,
        content: {
                    
            ScrollView {
                
                VStackWithSideBarButton {
                    
                    BoldTitle(text: "Exercise library")
                        .padding(.horizontal, 20)
                    
                    LightSubHeadline(text: "Here you can browse exercises you have stored in your library, you can delete, edit, view statistics or add new ones.")
                        .padding(.horizontal, 20)
                    
                    SearchBar(
                        searchAttribute: "exerciseName",
                        searchText: $viewModel.searchText,
                        fetchRequest: _searchedExercises
                    )
                    .padding(.top, 20)
                    .padding(.horizontal, 20)
                    
                    //MARK: List view displaying all exercise objects
                    SearchableList(
                        height: 500,
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
                    }
                    .padding(.horizontal, 20)
                    
                }
            }
                    
            // MARK: Add new exercise button
            Button {
                viewModel.navPath.append(1)
            } label: {
                Text("Add new exercise")
                    .frame(height: 40)
                    .foregroundColor(Color("buttonTextColor"))
                Image(systemName: "plus")
                    .foregroundColor(Color("buttonTextColor"))
            }
            .buttonStyle(BorderedProminentButtonStyle())
            .padding(.vertical, 20)

        })
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    
    return ExerciseLibraryView()
        .environment(\.managedObjectContext, context)
        .environmentObject(ShowMenuController())

}
