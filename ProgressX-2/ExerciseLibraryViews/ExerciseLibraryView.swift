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
    ) private var exercises: FetchedResults<Exercise>
    
    @State private var navPath = [Int]()
    @State private var selectedExercise: Exercise? = nil
    @State private var searchText: String = ""
    @State private var editingPr: PersonalRecord?
    
    var body: some View {
        NavigationStack(path: $navPath) {
            ScrollView {
                VStack(alignment: .center, spacing: 10) {
                    
                    BoldTitle(text: "Exercise library")
                    
                    LightSubHeadline(text: "Here you can browse exercises you have stored in your library, you can delete, edit, view statistics or add new ones.")
                    
                    TextField("Search...",
                              text: $searchText)
                            .padding(10)
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                            .padding(.horizontal, 20)
                            .onDisappear(perform: {
                                searchText = ""
                            })
                            .padding(.top, 20)
                    
                    //MARK: List view displaying all exercise objects
                    VStack(alignment: .center) {
                        if exercises.isEmpty {
                            LightSubHeadline(text: "You currently have no exercises saved to the exercise library...")
                                .padding(.bottom, 20)
                                .padding(.top, 20)
                        } else {
                            List {
                                ForEach(searchedItems()) { exercise in
                                    ExerciseListItem(
                                        navPath: $navPath, 
                                        selectedExercise: $selectedExercise,
                                        exercise: exercise
                                    ).environment(\.managedObjectContext, viewContext)
                                }
                            }
                            .frame(height: 600)
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                            .padding(.horizontal, 20)
                        }
                    }
                    
                    // MARK: Add new exercise button
                    Button {
                        navPath.append(2)
                    } label: {
                        Text("Add new exercise")
                            .frame(height: 40)
                        Image(systemName: "plus")
                    }
                    .buttonStyle(BorderedProminentButtonStyle())
                    
                }
            }
            
            //MARK: Handling the navigation through the NavStack
            .navigationDestination(for: Int.self) { selection in
                if selection == 2 {
                    CreateNewExerciseView()
                        .environment(\.managedObjectContext, viewContext)
                } else if selection == 3 {
                    EditExerciseView(
                        exercise: $selectedExercise
                    ).environment(\.managedObjectContext, viewContext)
                } else if selection == 4 {
                    StatisticsView(
                        exercise: $selectedExercise,
                        navPath: $navPath,
                        editingPr: $editingPr
                    ).environment(\.managedObjectContext, viewContext)
                } else if selection == 5 {
                    EditPrView(
                        editingPr: $editingPr,
                        exercise: $selectedExercise
                    )
                }
            }
        }
    }
    
    /// Returns an array of exercises that has filtered by a seach-word from the CoreData fetch result
    /// - Returns: An array filtered by a search-word
    private func searchedItems() -> [Exercise] {
        return exercises.filter { searchText.isEmpty ? true : $0.exerciseName!.localizedCaseInsensitiveContains(searchText) }
    }
    
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    
    return ExerciseLibraryView()
        .environmentObject(ViewRouter())
        .environment(\.managedObjectContext, context)
}
