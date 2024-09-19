//
//  NonSearchableList.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-06-20.
//

import SwiftUI
import CoreData

struct BasicList<T: NSManagedObject, Content: View>: View where T: Identifiable {
    
    let height: CGFloat
    let containerName: String
    let elementName: String
    @FetchRequest var data: FetchedResults<T>
    let content: (FetchedResults<T>.Element) -> Content
    
    var body: some View {
        if data.isEmpty {
            GroupBox {
                Text("You currently have no \(elementName) saved to \(containerName)...")
                    .font(.subheadline)
                    .fontWeight(.light)
                    .foregroundStyle(.red)
                    .frame(maxWidth: .infinity)
            }
        } else {
            List{
                ForEach(data) { item in
                    content(item)
                }
            }
            .frame(height: height)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    
    let context = PersistenceController.previewViewContext

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
        }
        .padding(.horizontal, 10)
        .environment(\.managedObjectContext, context)
}
