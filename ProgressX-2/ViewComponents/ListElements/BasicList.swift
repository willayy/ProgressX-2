//
//  NonSearchableList.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-06-20.
//

import SwiftUI
import CoreData

struct BasicList<T: NSManagedObject, Content: View>: View where T: Identifiable {
    
    let height: CGFloat?
    let containerName: String
    let elementName: String
    @FetchRequest var data: FetchedResults<T>
    let content: (FetchedResults<T>.Element) -> Content
    
    var body: some View {
        if data.isEmpty {
            Text("You currently have no \(elementName) saved to \(containerName)...")
                .font(.subheadline)
                .fontWeight(.light)
                .padding(.vertical, 20)
                .padding(.horizontal, 20)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .foregroundStyle(.red)
        } else {
            List{
                ForEach(data) { item in
                    content(item)
                }
            }
            .frame(height: height)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .padding(.horizontal, 20)
        }
    }
}

#Preview {
    
    let context = PersistenceController.preview.container.viewContext
    
    // Does not really work as intended here because @FetchRequest wrapper does not work in Preview context.
    
    @FetchRequest(
        entity: Exercise.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Exercise.exerciseName, ascending: false)]
    ) var allExercises: FetchedResults<Exercise>
    
    @State var navPath: [Int] = [Int]()
    
    @State var selectedExercise: Exercise? = nil
    
    return BasicList(
        height: 400,
        containerName: "Exercise Library",
        elementName: "Exercises",
        data: _allExercises) { exercise in
            ExerciseListItem(
                navPath: $navPath,
                selectedExercise: $selectedExercise,
                exercise: exercise
            )
            .environment(\.managedObjectContext, context)
        }
}
