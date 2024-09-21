//
//  SetExerciseSelectionList.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-01.
//

import SwiftUI
import CoreData

struct SetExerciseSelectionList: View {
    
    @FetchRequest(
        
        entity: Exercise.entity(),
        
        sortDescriptors: [NSSortDescriptor(keyPath: \Exercise.exerciseName, ascending: false)]
        
    ) private var exercises: FetchedResults<Exercise>
    
    @Binding var selectedExercise: Exercise?
    
    @Binding var searchWord: String
    
    var body: some View {
        
        // Computed variable that returns a subset matching the searchword
        var searchedCollection: [Exercise] {
            
            if searchWord.isEmpty {
                
                return exercises.filter { Exercise in true }
                
            } else {
                
                return exercises.filter { $0.exerciseName!.localizedCaseInsensitiveContains(searchWord) }
                
            }
            
        }
        
        VStack {
            
            GroupBox {
                
                VStack {
                    
                    TextField("Search...", text: $searchWord)
                    
                    Rectangle()
                        .foregroundStyle(.gray)
                        .cornerRadius(20)
                        .frame(height: 2)
                    
                }
                
                DisclosureGroup(selectedExercise?.exerciseName ?? "Not selected") {
                    
                    ScrollView {
                        
                        ForEach(searchedCollection) { exercise in
                            
                            Button {
                                
                                selectedExercise = exercise
                                
                            } label: {
                                
                                Text(exercise.exerciseName!)
                                    .frame(width: 250)
                                
                            }
                            .padding(2)
                        }
                    }
                    .frame(maxHeight: 300)
                }
            }
        }
    }
}

#Preview {
    
    let context = PersistenceController.previewViewContext
    @State var selectedExercise: Exercise? = nil
    @State var searchWord: String = ""
    
    return SetExerciseSelectionList(
        selectedExercise: $selectedExercise,
        searchWord: $searchWord
    )
    .environment(\.managedObjectContext, context)
}
