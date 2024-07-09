//
//  CustomNSErrors.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-06-19.
//

import Foundation

enum ValidationNSErrors: Int {
    
    // MARK: Custom errors
    /* -------------------------------------------------------- */
    // PersonalRecord
    case prAndExerciseTypeMismatch = 9999
    case quantityInvalid = 9997
    
    // Profile
    case profileNameIsInvalid = 9998
    
    // Exercise
    case exerciseNameIsInvalid = 9996
    
    // Completeable
    case completeWithoutCompletionDate = 9995
    
    // Cycle
    case cycleCompleteWithUncompleteWeeks = 9994
    case cycleCompleteWithNoWeeks = 9993
    
    // Week
    case weekCompleteWithUncompleteSessions = 9992
    case weekCompleteWithNoSessions = 9991
    
    // Session
    case sessionCompleteWithUncompleteSets = 9990
    case sessionCompleteWithNoSets = 9989
    
    // Set
    case setAndExerciseTypeMismatch = 9987
    case quantityTodoInvalid = 9986
    case quantityDoneInvalid = 9985
    
    // Orderable
    case invalidPositionIndex = 9983
    
    // Routine
    case routineNameIsInvalid = 9982
    
    // Threshold
    case triggerQuantityIsInvalid = 9981
    case flatLoadAddIsInvalid = 9980
    case flatQuantityAddIsInvalid = 9979
    case prTypeValueIsInvalid = 9978
    case prTypeAndExerciseMismatch = 9977
    
    /* -------------------------------------------------------- */
    
    // The Error domain
    private var domain: String {
        return "CoreDataErrorDomain"
    }
    
    // A computed variable that gives a NSError with the correct information
    private var userInfo: [String: Any] {
        switch self {
        case .weekCompleteWithNoSessions:
            return [NSLocalizedDescriptionKey:
                    """
                    Week can't be complete without any sessions.
                    """]
            
        case .weekCompleteWithUncompleteSessions:
            return [NSLocalizedDescriptionKey:
                    """
                    Week can't be complete when its sessions aren't.
                    """]
            
        case .sessionCompleteWithUncompleteSets:
            return [NSLocalizedDescriptionKey:
                    """
                    Session can't be complete when its sets aren't.
                    """]
            
        case .sessionCompleteWithNoSets:
            return [NSLocalizedDescriptionKey: 
                    """
                    Session can't be complete without any sets.
                    """]
            
        case .setAndExerciseTypeMismatch:
            return [NSLocalizedDescriptionKey:
                    """
                    This sets exercise and its thresholds prTypes
                    have mismatching values.
                    """]
            
        case .cycleCompleteWithUncompleteWeeks:
            return [NSLocalizedDescriptionKey: 
                    """
                    Cycle can't be complete when its weeks aren't.
                    """]
            
        case .quantityDoneInvalid:
            return [NSLocalizedDescriptionKey: 
                    """
                    Property .quantityDone on TrainingSet must
                    be a valid integer if the prType is one of
                    'onerepmax' or 'maxreps'.
                    """]
            
        case .quantityTodoInvalid:
            return [NSLocalizedDescriptionKey: 
                    """
                    Property .quantity on TrainingSet must be a valid
                    integer if the quantityType is numerical and the
                    exercise type is reps. If quantityType is percent
                    .quantity must be a valid double.
                    """]
            
        case .completeWithoutCompletionDate:
            return [NSLocalizedDescriptionKey: 
                    """
                    A Completable object can't be complete without
                    a completionDate.
                    """]
            
        case .cycleCompleteWithNoWeeks:
            return [NSLocalizedDescriptionKey:
                    """
                    Cycle cant be complete when it has no weeks.
                    """]
            
        case .quantityInvalid:
            return [NSLocalizedDescriptionKey:
                    """
                    Property .prQuantity on PersonalRecord cant be set
                    to a double value that isnt a valid integer if the
                    PersonalRecord is of type 'maxreps' or 'onerepmax'.
                    """]
            
        case .prAndExerciseTypeMismatch:
            return [NSLocalizedDescriptionKey:
                    """
                    Pr type string does not match .exercise type string.
                    """]
            
        case .invalidPositionIndex:
            return [NSLocalizedDescriptionKey: 
                    """
                    This object contains children with duplicate
                    positionIndexes.
                    """]
            
        case .routineNameIsInvalid:
            return [NSLocalizedDescriptionKey: 
                    """
                    This Routine has a name that is not unique
                    """]
            
        case .profileNameIsInvalid:
            return [NSLocalizedDescriptionKey: 
                    """
                    This Profile has a username that is not unique
                    """]
            
        case .exerciseNameIsInvalid:
            return [NSLocalizedDescriptionKey: 
                    """
                    This Exercise has a name that is not unique
                    """]
            
        case .triggerQuantityIsInvalid:
            return [NSLocalizedDescriptionKey: 
                    """
                    The triggerQuantity of this threshold has to
                    be a valid integer if exercise is of type
                    """]
            
        case .flatLoadAddIsInvalid:
            return [NSLocalizedDescriptionKey: 
                    """
                    If the set this threshold is attached to is
                    not Numerical flatLoadAdd must be nil
                    """]
            
        case .flatQuantityAddIsInvalid:
            return [NSLocalizedDescriptionKey: 
                    """
                    If the set this threshold is attached to is
                    not Numerical flatLoadQuantity must be nil
                    """]
            
        case .prTypeValueIsInvalid:
            return [NSLocalizedDescriptionKey: 
                    """
                    If the threshold has generatePr set false
                    prType should be nil
                    """]
            
        case .prTypeAndExerciseMismatch:
            return [NSLocalizedDescriptionKey: 
                    """
                    The prType in the threshold does not match
                    the exercise on the thresholds set
                    """]
        }
    }
    
    // Helper function to convert enum case to NSError
    func toNSError() -> NSError {
        return NSError(domain: self.domain, code: self.rawValue, userInfo: self.userInfo)
    }
}
