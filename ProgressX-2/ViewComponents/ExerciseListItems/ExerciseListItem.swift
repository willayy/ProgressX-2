//
//  ExerciseListItem.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-06-02.
//

import SwiftUI

struct ExerciseListItem: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var selectedExercise: Exercise?
    @Binding var belongsTo: [Exercise]
    @Binding var selectedExerciseName: String
    @Binding var selectedExerciseDesc: String
    @Binding var navPath: [Int]
    let listItemExercise: Exercise
    @State var showDeleteAlert: Bool = false
    @State var deletedExerciseName: String = ""
    
    var body: some View {
        HStack {
            
            Text(listItemExercise.exerciseName ?? "Unnamed Exercise")
            
            Spacer()
            
            // MARK: Edit button
            Button(action: {
                selectedExercise = listItemExercise
                selectedExerciseName = listItemExercise.exerciseName!
                selectedExerciseDesc = listItemExercise.exerciseDesc!
                navPath.append(3)
            }) { Image(systemName: "pencil") }
                .frame(width: 20)
                .padding(.horizontal, 10)
                .buttonStyle(BorderlessButtonStyle())
            
            // MARK: Statistics button
            Button(action: {
                selectedExercise = listItemExercise
                navPath.append(4)
            }) { Image(systemName: "note") }
                .frame(width: 20)
                .padding(.horizontal, 10)
                .buttonStyle(BorderlessButtonStyle())
            
            // MARK: Delete button
            Button(action: {
                showDeleteAlert = true
                deletedExerciseName = listItemExercise.exerciseName!
            }) { Image(systemName: "trash") }
                .frame(width: 20)
                .padding(.horizontal, 10)
                .buttonStyle(BorderlessButtonStyle())
                .alert(isPresented: $showDeleteAlert, content: {
                    Alert(
                        title: Text("Delete Item"),
                        message: Text("Are you sure you want to delete \(deletedExerciseName)?"),
                        primaryButton: .destructive(Text("Delete")) {
                            belongsTo.removeAll(where: { $0 === listItemExercise })
                            DataFetching.deleteNSManagedObject(viewContext, object: listItemExercise)
                            DataFetching.save(viewContext)
                        },
                        secondaryButton: .cancel()
                    )
                })
        }
    }
}

