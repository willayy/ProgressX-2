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
        
        // Computed variable
        var searchedCollection: [Exercise] {
            if searchWord.isEmpty {
                exercises.filter { _ in true }
            } else {
                exercises.filter { $0.exerciseName!.localizedCaseInsensitiveContains(searchWord)
                }
            }
        }
        
        VStack {
            ZStack {
                Rectangle()
                    .cornerRadius(10)
                    .foregroundStyle(Color(.systemGray6))
                    .padding(.horizontal, 40)
                    .frame(height: 40)
                
                Text(selectedExercise?.exerciseName! ?? "Not selected")
                    .fontWeight(.light)
            }
            
            GroupBox {
                VStack {
                    TextField("Search...", text: $searchWord)
                    Rectangle()
                        .foregroundStyle(.gray)
                        .cornerRadius(20)
                        .frame(height: 2)
                }
                DisclosureGroup(selectedExercise?.exerciseName ?? "Not selected") {
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
            }
            .padding(.horizontal, 40)
        }
    }
}

#Preview {
    
    @State var selectedExercise: Exercise? = nil
    @State var searchWord: String = ""
    
    return SetExerciseSelectionList(
        selectedExercise: $selectedExercise,
        searchWord: $searchWord
    )
}
