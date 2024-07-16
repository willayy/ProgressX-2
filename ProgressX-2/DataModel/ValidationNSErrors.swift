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
    case prQuantityIsInvalid = 9997
    
    // Profile
    case profileNameIsInvalid = 9998
    
    // Exercise
    case exerciseNameIsInvalid = 9996
    
    // Completeable
    case completeWithoutCompletionDate = 9995
    
    // Cycle
    case cycleCompleteWithUncompleteWeeks = 9994
    case cycleCompleteWithNoWeeks = 9993
    case cycleInCompleteWithCompleteWeeks = 9976
    
    // Week
    case weekCompleteWithUncompleteSessions = 9992
    case weekCompleteWithNoSessions = 9991
    case weekInCompleteWithCompleteSessions = 9975
    
    // Session
    case sessionCompleteWithUncompleteSets = 9990
    case sessionCompleteWithNoSets = 9989
    case sessionIncompleteWithCompleteSets = 9974
    
    // Set
    case setAndExerciseTypeMismatch = 9987
    case quantityTodoIsInvalid = 9986
    case quantityDoneIsInvalid = 9985
    
    // Orderable
    case positionIndexIsInvalid = 9983
    
    // Routine
    case routineNameIsInvalid = 9982
    case routineHasInvalidAmountOfIncompleteCycles = 9972
    
    // Threshold
    case triggerQuantityIsInvalid = 9981
    case flatLoadAddIsInvalid = 9980
    case flatQuantityAddIsInvalid = 9979
    case prTypeValueIsInvalid = 9978
    case prTypeAndExerciseMismatch = 9977
    
    // ExerciseCategory
    case exerciseCategoryNameIsInvalid = 9973
    
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
            
        case .quantityDoneIsInvalid:
            return [NSLocalizedDescriptionKey: 
                    """
                    Quantity done properties on Training/Template Sets must
                    be a valid Integer if the its exercise is rep based.
                    If the exercise is time based it needs to be Double.
                    """]
            
        case .quantityTodoIsInvalid:
            return [NSLocalizedDescriptionKey: 
                    """
                    Quantity todo properties on Training/Template Sets must
                    be a valid Integer if the its exercise is rep based.
                    If the exercise is time based it needs to be Double.
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
            
        case .prQuantityIsInvalid:
            return [NSLocalizedDescriptionKey:
                    """
                    Quantity property on PersonalRecord cant be set
                    to a double value that isnt a valid integer if the
                    PersonalRecord is of type 'maxreps' or 'onerepmax'.
                    """]
            
        case .prAndExerciseTypeMismatch:
            return [NSLocalizedDescriptionKey:
                    """
                    Pr type string does not match exerice type string.
                    """]
            
        case .positionIndexIsInvalid:
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
                    be a valid integer if exercise is of type 'reps'.
                    If the exercise is of type 'time' it needs to be a
                    valid Double.
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
            
        case .cycleInCompleteWithCompleteWeeks:
            return [NSLocalizedDescriptionKey:
                    """
                    The cycle should not be incomplete when all it's
                    weeks are completed.
                    """]
            
        case .weekInCompleteWithCompleteSessions:
            return [NSLocalizedDescriptionKey:
                    """
                    The week should not be incomplete when all it's
                    sessions are completed.
                    """]
            
        case .sessionIncompleteWithCompleteSets:
            return [NSLocalizedDescriptionKey:
                    """
                    The session should not be incomplete when all it's
                    sets are completed.
                    """]
            
        case .exerciseCategoryNameIsInvalid:
            return [NSLocalizedDescriptionKey:
                    """
                    The name of this exerciseCategory is not unique.
                    """
            ]
            
        case .routineHasInvalidAmountOfIncompleteCycles:
            return [NSLocalizedDescriptionKey:
                    """
                    The cycle must have one and one only cycle that is "inactive"
                    and has isComplete set to false.
                    """
            ]
        }
    }
    
    // Helper function to convert enum case to NSError
    func toNSError() -> NSError {
        return NSError(domain: self.domain, code: self.rawValue, userInfo: self.userInfo)
    }
}
