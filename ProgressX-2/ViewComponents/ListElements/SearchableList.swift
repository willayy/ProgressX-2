//
//  RACList.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-06-20.
//

import SwiftUI
import CoreData

// This is a list that takes a randomAccessCollection as an argument
struct SearchableList<T: NSManagedObject, Content: View>: View where T: Identifiable {
    
    let containerName: String
    let elementName: String
    @FetchRequest var allData: FetchedResults<T>
    @FetchRequest var searchedData: FetchedResults<T>
    let content: (FetchedResults<T>.Element) -> Content

    var body: some View {
        if allData.isEmpty {
            Text("You currently have no \(elementName) saved to the \(containerName)...")
                .font(.subheadline)
                .fontWeight(.light)
                .padding(.horizontal, 10)
                .padding(.vertical, 20)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .foregroundStyle(.red)
        } else if searchedData.isEmpty {
            LightSubHeadline(text: "No \(elementName) matched your search...")
                .padding(.vertical, 20)
        } else {
            List{
                ForEach(searchedData) { item in
                    content(item)
                }
            }
            .frame(height: 400)
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
    
    @FetchRequest(
        entity: Exercise.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Exercise.exerciseName, ascending: false)]
    ) var searchedExercises: FetchedResults<Exercise>
    
    @State var navPath: [Int] = [Int]()
    
    @State var selectedExercise: Exercise? = nil
    
    return SearchableList(
        containerName: "Exercise Library",
        elementName: "Exercises",
        allData: _allExercises,
        searchedData: _searchedExercises) { exercise in
            ExerciseListItem(
                navPath: $navPath,
                selectedExercise: $selectedExercise,
                exercise: exercise
            )
            .environment(\.managedObjectContext, context)
        }
}
