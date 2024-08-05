//
//  StartWorkoutViewModel.swift
//  ProgressX-2
//
//  Created by lucas häyhänen on 2024-07-18.
//

import Foundation
import CoreData

class TrainingViewModel: SavingViewModel{
    
    @Published var selectedRoutine: Routine? = nil
    @Published var navPath: [Int] = [Int]()
    @Published var selectedTrainingCycle: TrainingCycle? = nil
    @Published var selectedTrainingWeek: TrainingWeek? = nil
    @Published var selectedTrainingSession: TrainingSession? = nil
    @Published var AllTrainingSets: [TrainingSet] = []
    @Published public var searchText: String = ""
    
    typealias T = TrainingSet
    
    public func saveEdits(entity: TrainingSet, viewContext: NSManagedObjectContext) -> Void {
        entity.skip()
        self.safeSave(viewContext: viewContext)
    }
    
}


