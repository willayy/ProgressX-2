//
//  CreateNewExercise.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-05-14.
//

import SwiftUI
import CoreData

struct ExerciseLibraryView: View {
    
    @EnvironmentObject var viewRouter: ViewRouter
    @Environment(\.managedObjectContext) private var viewContext
    
    // The navPath variable is passed along to all following
    // views in this set of views.
    @State private var allExercises: [Exercise] = []
    @State private var allPrs: [PersonalRecord] = []
    @State private var oneRepMaxPrs: [OneRepMax] = []
    @State private var timeMaxPrs: [TimeMax] = []
    @State private var maxRepPrs: [MaxReps] = []
    @State private var navPath = [Int]()
    @State private var selectedExercise: Exercise? = nil
    @State private var selectedExerciseName: String = ""
    @State private var selectedExerciseDesc: String = ""
    @State private var searchText: String = ""
    @State private var editingPr: PersonalRecord? = nil
    
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
                                    ExerciseListItem(
                                        selectedExercise: $selectedExercise, 
                                        belongsTo: $allExercises,
                                        selectedExerciseName: $selectedExerciseName,
                                        selectedExerciseDesc: $selectedExerciseDesc,
                                        navPath: $navPath,
                                        listItemExercise: exercise
                                    )
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
            }.onChange(of: selectedExercise, initial: true) {
                
                allExercises = DataFetching.getExercisesAsArray(viewContext)
    
                if selectedExercise is RepBasedExercise {
                    allPrs = []
                    let repBasedExercise: RepBasedExercise = selectedExercise as! RepBasedExercise
                    let oneRepMaxPrs: [OneRepMax] = DataUtility.get1RmPrs(exercise: repBasedExercise) ?? []
                    let maxRepPrs: [MaxReps] = DataUtility.getMaxRepPrs(exercise: repBasedExercise) ?? []
                    self.oneRepMaxPrs = oneRepMaxPrs
                    self.maxRepPrs = maxRepPrs
                    self.allPrs.append(contentsOf: oneRepMaxPrs)
                    self.allPrs.append(contentsOf: maxRepPrs)
                }
            
                else if selectedExercise is TimeBasedExercise {
                    allPrs = []
                    let timeBasedExercise: TimeBasedExercise = selectedExercise as! TimeBasedExercise
                    let timeMaxPrs = DataUtility.getTimePrs(exercise: timeBasedExercise) ?? []
                    self.timeMaxPrs = timeMaxPrs
                    self.allPrs.append(contentsOf: timeMaxPrs)
                }
            }
            .navigationDestination(for: Int.self) { selection in
                if selection == 2 {
                    CreateNewExerciseView(exercises: $allExercises)
                        .environment(\.managedObjectContext, viewContext)
                } else if selection == 3 {
                    EditExerciseView(
                        exercise: $selectedExercise,
                        currName: $selectedExerciseName,
                        currDesc: $selectedExerciseDesc,
                        allExercises: $allExercises
                    ).environment(\.managedObjectContext, viewContext)
                } else if selection == 4 {
                    StatisticsView(
                        exercise: $selectedExercise,
                        navPath: $navPath,
                        editingPr: $editingPr,
                        allPrs: $allPrs,
                        oneRepMaxPrs: $oneRepMaxPrs,
                        timeMaxPrs: $timeMaxPrs,
                        maxRepPrs: $maxRepPrs
                    ).environment(\.managedObjectContext, viewContext)
                } else if selection == 5 {
                    EditPrView(
                        editingPr: $editingPr,
                        exercise: $selectedExercise, 
                        allPrs: $allPrs
                    )
                }
            }
        }
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    return ExerciseLibraryView()
        .environmentObject(ViewRouter())
        .environment(\.managedObjectContext, context)
}
