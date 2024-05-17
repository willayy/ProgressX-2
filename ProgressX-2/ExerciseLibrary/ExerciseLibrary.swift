//
//  CreateNewExercise.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-05-14.
//

import SwiftUI
import CoreData

private let p = PersistenceController.shared

struct ExerciseLibrary: View {
    
    @EnvironmentObject var viewRouter: ViewRouter
    
    // The navPath variable is passed along to all following
    // views in this set of views.
    @State private var exercises: [Exercise] = p.getExercisesAsArray()
    @State private var refreshListView = false // Dont want to add this but since SwiftUI doesnt notice / refresh view when object attribtues changes i have to.
    @State private var showDeleteAlert = false
    @State private var deletedExerciseName = ""
    @State private var navPath = [Int]()
    @State private var listItemClicked = false
    @State private var selectedObject: Exercise? = nil
    @State private var selectedObjectName: String = ""
    @State private var selectedObjectDesc: String = ""
    
    var body: some View {
        NavigationStack(path: $navPath) {
            ScrollView {
                VStack(alignment: .center, spacing: 10) {
                    
                    Text("Exercise library")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .minimumScaleFactor(0.5);
                    
                    Text("Here you can browse exercises you have stored in your library, you can delete, edit or add new ones.")
                        .font(.subheadline)
                        .fontWeight(.light)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                        .minimumScaleFactor(0.5);
                    
                    //MARK: List view displaying all exercise objects
                    VStack(alignment: .center, spacing: 10) {
                        List {
                            
                            // Forcing refresh after exercise has been edited.
                            if refreshListView {}
                            
                            ForEach(exercises, id: \.self) { exercise in
                                HStack {
                                    
                                    Text(exercise.exerciseName ?? "Unnamed Exercise")
                                    
                                    Spacer()
                                    
                                    // MARK: Edit button
                                    Button(action: {
                                        listItemClicked = true
                                        selectedObject = exercise
                                        selectedObjectName = exercise.exerciseName!
                                        selectedObjectDesc = exercise.exerciseDesc!
                                        navPath.append(3)
                                        listItemClicked = false
                                    }) { Image(systemName: "pencil") }
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
                                                exercises.removeAll(where: { $0 === exercise })
                                                p.deleteNSManagedObject(object: exercise)
                                                p.save()
                                            },
                                            secondaryButton: .cancel()
                                        )
                                    })
                                }
                            }
                        }
                        .frame(height: 600)
                        .cornerRadius(10)
                        .padding(.horizontal, 20)
                        .onAppear(perform: {refreshListView = false})
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
                    CreateNewExercise()
                } else if selection == 3 {
                    EditExercise(exercise: $selectedObject, currName: $selectedObjectName, currDesc: $selectedObjectDesc, refreshListView: $refreshListView)
                }
            }
        }
    }
}

#Preview {
    ExerciseLibrary()
        .environmentObject(ViewRouter())
}
