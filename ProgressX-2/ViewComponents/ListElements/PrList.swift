//
//  PrList.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-05-24.
//

import SwiftUI
import CoreData

struct PrList: View {
    
    @FetchRequest private var personalRecords: FetchedResults<PersonalRecord>
    @Binding private var navPath: [Int]
    @Binding private var editingPr: PersonalRecord?
    private let exercise: Exercise
    private let prType: String
    @Binding private var newPrType: String?
    
    init(navPath: Binding<[Int]>, editingPr: Binding<PersonalRecord?>, exercise: Exercise, prType: String, newPrType: Binding<String?>) {
        self._navPath = navPath
        self.exercise = exercise
        self._editingPr = editingPr
        self.prType = prType
        self._newPrType = newPrType
        self._personalRecords = FetchRequest<PersonalRecord>(
            entity: PersonalRecord.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \PersonalRecord.achievedOnDate, ascending: false)],
            predicate: NSCompoundPredicate(andPredicateWithSubpredicates: [
                NSPredicate(format: "exercise == %@", exercise),
                NSPredicate(format: "prType == %@", prType)
            ])
        
        )
    }
    
    var body: some View {
        
        BoldSubHeadline(text: "List of all \(personalRecords.first?.typeString ?? "") PR's achieved on \(exercise.exerciseName!)")
            .padding(.horizontal, 40)
            .padding(.top, 20)
        
        if personalRecords.isEmpty {
            GroupBox {
                Text("No PR's found for this exercise")
                    .font(.subheadline)
                    .padding(.horizontal, 40)
                    .foregroundStyle(.red)
            }
        }
        
        else {
            List {
                ForEach(personalRecords) { pr in
                    PrListItem(navPath: $navPath,
                               editingPr: $editingPr,
                               pr: pr
                    )
                }
            }
            .frame(height: 300)
            .background(Color(.systemGray6))
            .cornerRadius(10)
        }
        
        Button(action: {
            newPrType = prType
            navPath.append(5)
        }) {
            Text("Add new PR")
                .frame(height: 25)
                .foregroundColor(Color("buttonTextColor"))
            Image(systemName: "plus")
                .foregroundColor(Color("buttonTextColor"))
        }
        .buttonStyle(BorderedProminentButtonStyle())
        .padding(.top, 10)
    }
}

#Preview {
    
    let context = PersistenceController.preview.container.viewContext
    
    let fetchRequest: NSFetchRequest<Exercise> = Exercise.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "exerciseType == %@","time")
    
    let timeBasedExerciseResults: [Exercise] = PersistenceController.fetch(context, fetchRequest: fetchRequest)
    
    let exercise: Exercise? = timeBasedExerciseResults.first
    
    @State var navPath: [Int] = [Int]()
    
    @State var editingPr: PersonalRecord? = nil
    
    @State var newPrType: String? = nil
    
    return PrList(
        navPath: $navPath,
        editingPr: $editingPr,
        exercise: exercise!,
        prType: "timemax",
        newPrType: $newPrType
    ).environment(\.managedObjectContext, context)
}
