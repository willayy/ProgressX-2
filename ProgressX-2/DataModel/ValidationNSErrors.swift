//
//  CustomNSErrors.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-06-19.
//

import Foundation

enum ValidationNSErrors: Int {
    
    case prAndExerciseTypeMismatch = 9999
    case prExerciseIsNil = 9998
    case quantityInvalid = 9997
    case bodyEntryProfileIsNil = 9996
    case completeWithoutCompletionDate = 9995
    case cycleCompleteWithUncompleteWeeks = 9994
    case cycleCompleteWithNoWeeks = 9993
    case weekCompleteWithUncompleteSessions = 9992
    case weekCompleteWithNoSessions = 9991
    case sessionCompleteWithUncompleteSets = 9990
    case sessionCompleteWithNoSets = 9989
    case setExerciseIsNil = 9988
    case setAndExerciseTypeMismatch = 9987
    case quantityTodoInvalid = 9986
    case quantityDoneInvalid = 9985
    case routineHasMultipleIncompleteCycles = 9984
    case invalidPostionIndex = 9983
    case routineNameIsInvalid = 9982
    case routineHasInvalidTemplateCycleAmount = 9981
    
    var domain: String {
        return "CoreDataErrorDomain"
    }
    
    var userInfo: [String: Any] {
        switch self {
        case .weekCompleteWithNoSessions:
            return [NSLocalizedDescriptionKey: "Week can't be complete without any sessions."]
            
        case .weekCompleteWithUncompleteSessions:
            return [NSLocalizedDescriptionKey: "Week can't be complete when its sessions aren't."]
            
        case .sessionCompleteWithUncompleteSets:
            return [NSLocalizedDescriptionKey: "Session can't be complete when its sets aren't."]
            
        case .sessionCompleteWithNoSets:
            return [NSLocalizedDescriptionKey: "Session can't be complete without any sets."]
            
        case .setExerciseIsNil:
            return [NSLocalizedDescriptionKey: "Set cant have relationship .exercise set to nil."]
            
        case .setAndExerciseTypeMismatch:
            return [NSLocalizedDescriptionKey: "Set.exercise.exerciseType and set.prType have mismatching values."]
            
        case .cycleCompleteWithUncompleteWeeks:
            return [NSLocalizedDescriptionKey: "Cycle can't be complete when its weeks aren't."]
            
        case .quantityDoneInvalid:
            return [NSLocalizedDescriptionKey: "Property .quantityDone on TrainingSet must be a valid integer if the prType is one of 'onerepmax' or 'maxreps'."]
            
        case .quantityTodoInvalid:
            return [NSLocalizedDescriptionKey: "Property .quantityTodo on TrainingSet must be a valid integer if the prType is one of 'onerepmax' or 'maxreps'."]
            
        case .completeWithoutCompletionDate:
            return [NSLocalizedDescriptionKey: "A Completable object can't be complete without a completionDate."]
            
        case .cycleCompleteWithNoWeeks:
            return [NSLocalizedDescriptionKey: "Cycle cant be complete when it has no weeks."]
            
        case .bodyEntryProfileIsNil:
            return [NSLocalizedDescriptionKey: "BodyEntry cant have relationship .profile set to nil."]
            
        case .quantityInvalid:
            return [NSLocalizedDescriptionKey: "Property .prQuantity on PersonalRecord cant be set to a double value that isnt a valid integer."]
            
        case .prExerciseIsNil:
            return [NSLocalizedDescriptionKey: "Pr cant have relationship .exercise set to nil."]
            
        case .prAndExerciseTypeMismatch:
            return [NSLocalizedDescriptionKey: "Pr type string does not match .exercise type string."]
            
        case .routineHasMultipleIncompleteCycles:
            return [NSLocalizedDescriptionKey: "Routine has multiple incomplete cycles."]
            
        case .invalidPostionIndex:
            return [NSLocalizedDescriptionKey: "This Completable object contains a positionIndex which is not unique among the children of its parent."]
            
        case .routineNameIsInvalid:
            return [NSLocalizedDescriptionKey: "This routine has a non unique name."]
            
        case .routineHasInvalidTemplateCycleAmount:
            return [NSLocalizedDescriptionKey: "This routine has an invalid amount of template cycles, it needs to have only one."]
        }
    }
    
    // Helper function to convert enum case to NSError
    func toNSError() -> NSError {
        return NSError(domain: self.domain, code: self.rawValue, userInfo: self.userInfo)
    }
}
