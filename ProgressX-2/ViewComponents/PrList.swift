//
//  PrList.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-05-24.
//

import SwiftUI
import CoreData

struct PrList: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest private var personalRecordResults: FetchedResults<PersonalRecord>
    @Binding private var navPath: [Int]
    @Binding private var editingPr: PersonalRecord?
    private let exercise: Exercise?
    private let prType: String
    
    init(navPath: Binding<[Int]>, editingPr: Binding<PersonalRecord?>, exercise: Exercise?, entity: NSEntityDescription, prType: String) {
        self._navPath = navPath
        self.exercise = exercise
        self._editingPr = editingPr
        self.prType = prType
        self._personalRecordResults = FetchRequest<PersonalRecord>(
            entity: entity,
            sortDescriptors: [NSSortDescriptor(keyPath: \PersonalRecord.achievedOnDate, ascending: false)],
            predicate: NSPredicate(format: "exercise == %@", exercise!)
        )
    }
    
    var body: some View {
        
        BoldSubHeadline(text: "List of all \(prType) PR's achieved on \(exercise!.exerciseName!)")
            .padding(.horizontal, 40)
            .padding(.top, 20)
        
        if personalRecordResults.isEmpty {
            Text("No PR's found for this exercise")
                .font(.subheadline)
                .padding(.top, 20)
                .foregroundStyle(.red)
        } 
        
        else {
            List {
                ForEach(personalRecordResults) { pr in
                    PrListItem(navPath: $navPath,
                               editingPr: $editingPr,
                               pr: pr)
                }
            }
            .frame(height: 300)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .padding(.horizontal, 40)
        }
    }
}

#Preview {
    
    let context = PersistenceController.preview.container.viewContext
    
    let fetchRequestTimeBasedExercise: NSFetchRequest<TimeBasedExercise> = TimeBasedExercise.fetchRequest()
    
    let timeBasedExercuseResults: [TimeBasedExercise] = PersistenceController.fetch(context, fetchRequest: fetchRequestTimeBasedExercise)
    
    let exercise: TimeBasedExercise? = timeBasedExercuseResults.first
    
    let entity = TimeMax.entity()
    
    @State var navPath: [Int] = [Int]()
    
    @State var editingPr: PersonalRecord? = nil
    
    return PrList(navPath: $navPath, editingPr: $editingPr, exercise: exercise, entity: entity, prType: "Time-max")
        .environment(\.managedObjectContext, context)
}
