//
//  DataModelEnums.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-06-21.
//

import Foundation

enum ExerciseType: String {
    case Reps = "reps"
    case Time = "time"
}

enum PersonalRecordType: String {
    case OneRepMax = "onerepmax"
    case TimeMax = "timemax"
    case MaxReps = "maxreps"
}

enum LoadType: String {
    case maxPercentage = "maxperc"
    case bodyWeightPercentage = "bwperc"
    case numerical = "numerical"
}

enum QuantityType: String {
    case maxPercentage = "maxperc"
    case numerical = "numerical"
}
