//
//  ExerciseLibraryViewModel.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-08.
//

import Foundation

class ExerciseLibraryViewModel: ObservableObject {
    
    @Published var navPath = [Int]()
    @Published var selectedExercise: Exercise? = nil
    @Published var searchText: String = ""
    @Published var editingPr: PersonalRecord?
    @Published var newPrType: String? = nil
    
}
