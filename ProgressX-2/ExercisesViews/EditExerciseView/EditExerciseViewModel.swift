//
//  EditExerciseViewModel.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-08.
//

import Foundation
import SwiftUI

class EditExerciseViewModel: ObservableObject {
    
    @Published var exerciseEditedAlert: Bool = false
    @Published var noChangeAlert: Bool = false
    @Published var newName: String = ""
    @Published var newDesc: String = ""
    @Published var newNameIsInvalid: Bool = false
    @Published var newNameIsInvalidMsg: String = ""
    @Published var newDescIsInvalid: Bool = false
    @Published var newDescIsInvalidMsg: String = ""
    
    public func setViewStartValues(selectedExercise: Exercise?) -> Void {
        newName = selectedExercise!.exerciseName ?? ""
        newDesc = selectedExercise!.exerciseDesc ?? ""
    }
    
    public func saveExerciseChanges(selectedExercise: Exercise?) -> Void {
        
        if newName != selectedExercise!.exerciseName {
            selectedExercise!.exerciseName = newName
        }
        
        if newDesc != selectedExercise!.exerciseDesc {
            selectedExercise!.exerciseDesc = newDesc
        }
        
        if selectedExercise!.hasChanges {            
            withAnimation {
                exerciseEditedAlert = true
            }
        } else {
            withAnimation {
                noChangeAlert = true
            }
        }
        
    }
}
