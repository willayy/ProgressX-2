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
    @State private var showMagnifiedView: Bool = false
    @ObservedObject var exercise: Exercise
    
    var body: some View {
        VStack(alignment: .leading, content: {
            
            VStack(alignment: .leading, content: {
                
                Text(exercise.exerciseName ?? "")
                    .font(.title2)
                
                (Text("Type: ")
                    .fontWeight(.bold)
                + Text("\(exercise.exerciseType ?? "")"))
                .minimumScaleFactor(0.6)
                
                (Text("Categories: ")
                    .fontWeight(.bold)
                 + Text(exercise.formattedCategories ?? "No categories"))
                .minimumScaleFactor(0.6)
                
            })
            .sheet(isPresented: $showMagnifiedView) {
                MagnifiedExerciseView(exercise: exercise)
                    .presentationDetents([.fraction(0.3)])
            }
            .padding(.horizontal, 30)
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity, maxHeight: 60, alignment: .leading)
            
            Spacer()
            
            HStack {
                
                // MARK: Magnify button
                Button(action: {
                    showMagnifiedView = true
                }) { Image(systemName: "plus.magnifyingglass") }
                    .frame(width: 20)
                    .buttonStyle(BorderlessButtonStyle())
                    .padding(.horizontal, 20)
                
                Spacer()
                
                // MARK: Edit button
                Button(action: {
                    selectedExercise = exercise
                    navPath.append(2)
                }) { Image(systemName: "pencil") }
                    .frame(width: 20)
                    .buttonStyle(BorderlessButtonStyle())
                    .padding(.horizontal, 20)
            
                Spacer()
                
                // MARK: Statistics button
                Button(action: {
                    selectedExercise = exercise
                    navPath.append(3)
                }) { Image(systemName: "chart.xyaxis.line") }
                    .frame(width: 20)
                    .buttonStyle(BorderlessButtonStyle())
                    .padding(.horizontal, 20)

                Spacer()
                
                // MARK: Delete button
                Button(action: {
                    showDeleteAlert = true
                }) { Image(systemName: "trash") }
                    .frame(width: 20)
                    .buttonStyle(BorderlessButtonStyle())
                    .padding(.horizontal, 20)
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
            .padding(.horizontal, 10)
            .padding(.vertical, 10)
            .frame(maxWidth: .infinity, maxHeight: .infinity)

        })
        .frame(width: 300, height: 100)
    }
}

