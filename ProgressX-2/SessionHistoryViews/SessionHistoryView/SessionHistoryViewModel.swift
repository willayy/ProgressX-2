//
//  SessionHistoryViewModel.swift
//  ProgressX-2
//
//  Created by lucas häyhänen on 2024-08-14.
//

import Foundation

class SessionHistoryViewModel: ObservableObject{
    
   
    @Published public var selectedCategories: Set<ExerciseCategory> = Set()
    @Published public var selectedTrainingSets: [TrainingSet] = []
    
    /// Assign all trainingsets from the trainingSession to the viewmodel.
    public func assignTrainingSetsFrom(_ session: TrainingSession ) -> Void{
        
        self.selectedTrainingSets = session.children
        
    }
    
    /// Assign alll categories on the trainingSession to displayed set of categories.
    public func assignCategoriesUsedIn(_ session: TrainingSession) -> Void {
        
        var displayset: Set<ExerciseCategory> = Set()
        
        for set in self.selectedTrainingSets {
            
            let exercise = set.exercise!
            
            let categories = exercise.categories?.allObjects as! [ExerciseCategory]
            
            for category in categories{
                
                displayset.insert(category)
                
            }
            
        }
        
        self.selectedCategories = displayset
        
    }
    
}




