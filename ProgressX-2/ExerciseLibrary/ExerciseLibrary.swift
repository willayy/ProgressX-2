//
//  CreateNewExercise.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-05-14.
//

import SwiftUI
import CoreData

struct ExerciseLibrary: View {
    
    @EnvironmentObject var viewRouter: ViewRouter
    @Environment(\.managedObjectContext) private var viewContext
    
    // The navPath variable is passed along to all following
    // views in this set of views.
    @State private var allExercises: [Exercise] = DataFetching.getExercisesAsArray()
    @State private var showDeleteAlert = false
    @State private var deletedExerciseName = ""
    @State private var navPath = [Int]()
    @State private var selectedExercise: Exercise? = nil
    @State private var selectedExerciseName: String = ""
    @State private var selectedExerciseDesc: String = ""
    @State private var searchText: String = ""
    
    private func searchedItems() -> [Exercise] {
        return allExercises.filter { searchText.isEmpty ? true : $0.exerciseName!.localizedCaseInsensitiveContains(searchText) }
    }
    
    var body: some View {
        NavigationStack(path: $navPath) {
            ScrollView {
                VStack(alignment: .center, spacing: 10) {
                    
                    BoldTitle(text: "Exercise library")
                    
                    LightSubHeadline(text: "Here you can browse exercises you have stored in your library, you can delete, edit, view statistics or add new ones.")
                    
                    TextField("Search...", text: $searchText)
                                        .padding(10)
                                        .background(Color(.systemGray6))
                                        .cornerRadius(10)
                                        .padding(.horizontal, 20)
                                        .onDisappear(perform: {
                                            searchText = ""
                                        })
                    
                    //MARK: List view displaying all exercise objects
                    VStack(alignment: .center) {
                        if allExercises.isEmpty {
                            LightSubHeadline(text: "You currently have no exercises saved to the exercise library...")
                        } else {
                            List {
                                ForEach(searchedItems()) { exercise in
                                    HStack {
                                        
                                        Text(exercise.exerciseName ?? "Unnamed Exercise")
                                        
                                        Spacer()
                                        
                                        // MARK: Edit button
                                        Button(action: {
                                            selectedExercise = exercise
                                            selectedExerciseName = exercise.exerciseName!
                                            selectedExerciseDesc = exercise.exerciseDesc!
                                            navPath.append(3)
                                        }) { Image(systemName: "pencil") }
                                            .frame(width: 20)
                                            .padding(.horizontal, 10)
                                            .buttonStyle(BorderlessButtonStyle())
                                        
                                        // MARK: Statistics button
                                        Button(action: {
                                            
                                            selectedExercise = exercise
                                            navPath.append(4)
                                        }) { Image(systemName: "note") }
                                            .frame(width: 20)
                                            .padding(.horizontal, 10)
                                            .buttonStyle(BorderlessButtonStyle())
                                        
                                        // MARK: Delete button
                                        Button(action: {
                                            showDeleteAlert = true
                                            deletedExerciseName = exercise.exerciseName!
                                        }) { Image(systemName: "trash") }
                                            .frame(width: 20)
                                            .padding(.horizontal, 10)
                                            .buttonStyle(BorderlessButtonStyle())
                                            .alert(isPresented: $showDeleteAlert, content: {
                                                Alert(
                                                    title: Text("Delete Item"),
                                                    message: Text("Are you sure you want to delete \(deletedExerciseName)?"),
                                                    primaryButton: .destructive(Text("Delete")) {
                                                        allExercises.removeAll(where: { $0 === exercise })
                                                        DataFetching.deleteNSManagedObject(object: exercise)
                                                        DataFetching.save()
                                                    },
                                                    secondaryButton: .cancel()
                                                )
                                            })
                                    }
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
            .navigationDestination(for: Int.self) { selection in
                if selection == 2 {
                    CreateNewExercise(exercises: $allExercises)
                } else if selection == 3 {
                    EditExercise(exercise: $selectedExercise, currName: $selectedExerciseName, currDesc: $selectedExerciseDesc, exercises: $allExercises)
                } else if selection == 4 {
                    StatisticsView(exercise: $selectedExercise)
                }
            }
        }
    }
}

#Preview {
    ExerciseLibrary()
        .environmentObject(ViewRouter())
        .environment(\.managedObjectContext, PersistenceController.shared.previewContainer.viewContext)
}
