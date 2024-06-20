//
//  ExerciseListItem.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-06-02.
//

import SwiftUI

// Exercise list item inteded to be used combined with a search bar and a list
struct ExerciseListItem: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var navPath: [Int]
    @Binding var selectedExercise: Exercise?
    @State var showDeleteAlert: Bool = false
    @ObservedObject var exercise: Exercise
    
    var body: some View {
        HStack {
            
            Text(exercise.exerciseName ?? "")
            
            Spacer()
            
            // MARK: Edit button
            Button(action: {
                selectedExercise = exercise
                navPath.append(2)
            }) { Image(systemName: "pencil") }
                .frame(width: 20)
                .padding(.horizontal, 10)
                .buttonStyle(BorderlessButtonStyle())
            
            // MARK: Statistics button
            Button(action: {
                selectedExercise = exercise
                navPath.append(3)
            }) { Image(systemName: "chart.xyaxis.line") }
                .frame(width: 20)
                .padding(.horizontal, 10)
                .buttonStyle(BorderlessButtonStyle())
            
            // MARK: Delete button
            Button(action: {
                showDeleteAlert = true
            }) { Image(systemName: "trash") }
                .frame(width: 20)
                .padding(.horizontal, 10)
                .buttonStyle(BorderlessButtonStyle())
                // Shows an alert box
                .alert(isPresented: $showDeleteAlert, content: {
                    Alert(
                        title: Text("Delete Item"),
                        message: Text("Are you sure you want to delete \(exercise.exerciseName!)?"),
                        primaryButton: .destructive(Text("Delete")) {
                            PersistenceController.delete(viewContext, object: exercise)
                            PersistenceController.save(viewContext)
                        },
                        secondaryButton: .cancel()
                    )
                })
        }
    }
}

