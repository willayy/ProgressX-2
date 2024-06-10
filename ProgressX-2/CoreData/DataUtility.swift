//
//  DataRefining.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-05-24.
//

import Foundation

// This class contains method to sort through data fetched from the CoreData base. This file does not include fetching and inserting, look in Persistance for that.

class DataUtility {
    
    private static let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        return df
    }()
    
    // MARK: Data handling
    // Data handling are functions that uses object, or arrays of objects.
    
    public static func sortBwEntriesByDate(bwEntries: [BodyEntry]) -> [BodyEntry] {
        let sortedBwEntries = bwEntries
            .sorted(by: { $0.date! > $1.date! })
        return sortedBwEntries
    }
    
    /// Performs non-inplace sorting of an array of PersonalRecord objects.
    /// - Parameter prs: An array of PersonalRecord objects
    public static func sortPersonalRecordsByDate(prs: [PersonalRecord]) -> [PersonalRecord] {
        let sortedPrs = prs.sorted(by: { $0.achievedOnDate! > $1.achievedOnDate! })
        return sortedPrs
    }
    
    public static func getHighestPrValue(data: [OneRepMax]) -> Double? {
        let highestValue: Double? = data.map { $0.load }.max() ?? nil
        return highestValue
    }
    
    public static func getHighestPrValue(data: [TimeMax]) -> Double? {
        let highestValue: Double? = data.map { $0.time }.max() ?? nil
        return highestValue
    }
    
    public static func getHighestPrValue(data: [MaxReps]) -> Int? {
        let highestValue: Int? = data.map { Int($0.reps) }.max() ?? nil
        return highestValue
    }
    
    public static func getHighestBwValue(data: [BodyEntry]) -> Double? {
        let highestValue: Double? = data.map { $0.bodyWeight }.max() ?? nil
        return highestValue
    }
    
    public static func getLowestPrValue(data: [OneRepMax]) -> Double? {
        let lowestValue: Double? = data.map { $0.load }.min() ?? nil
        return lowestValue
    }
    
    public static func getLowestPrValue(data: [TimeMax]) -> Double? {
        let lowestValue: Double? = data.map { $0.time }.min() ?? nil
        return lowestValue
    }
    
    public static func getLowestPrValue(data: [MaxReps]) -> Int? {
        let lowestValue: Int? = data.map { Int($0.reps) }.min() ?? nil
        return lowestValue
    }
    
    public static func getLowestBwValue(data: [BodyEntry]) -> Double? {
        let lowestValue: Double? = data.map { $0.bodyWeight }.min() ?? nil
        return lowestValue
    }
    
    public static func get1RmPrs(exercise: RepBasedExercise) -> [OneRepMax]? {
        return exercise.oneRepMaxPrs?.array as? [OneRepMax]
    }
    
    public static func getMaxRepPrs(exercise: RepBasedExercise) -> [MaxReps]? {
        return exercise.maxRepPrs?.array as? [MaxReps]
        
    }
    
    public static func getTimePrs(exercise: TimeBasedExercise) -> [TimeMax]? {
        return exercise.timePrs?.array as? [TimeMax]
    }
    
    public static func getFirstPrDate(prs: [PersonalRecord]) -> String? {
        if prs.isEmpty { return nil }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let date = prs.min(by: { $0.achievedOnDate! < $1.achievedOnDate! })!.achievedOnDate
        let dateString = dateFormatter.string(from: date!)
        return dateString
    }
    
    public static func getLastPrDate(prs: [PersonalRecord]) -> String? {
        if prs.isEmpty { return nil }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        let date = prs.min(by: { $0.achievedOnDate! > $1.achievedOnDate! })!.achievedOnDate
        let dateString = dateFormatter.string(from: date!)
        return dateString
    }
    
    public static func getLatestPrValue(data: [OneRepMax]) -> Double? {
        if let latestInstance = data.max(by: { $0.achievedOnDate! < $1.achievedOnDate! }) {
            return latestInstance.load
        } else {
            return nil
        }
    }
    
    public static func getLatestPrValue(data: [MaxReps]) -> Int? {
        if let latestInstance = data.max(by: { $0.achievedOnDate! < $1.achievedOnDate! }) {
            return Int(latestInstance.reps)
        } else {
            return nil
        }
    }
    
    public static func getLatestPrValue(data: [TimeMax]) -> Double? {
        if let latestInstance = data.max(by: { $0.achievedOnDate! < $1.achievedOnDate! }) {
            return latestInstance.time
        } else {
            return nil
        }
    }
    
    public static func getEarliestValue(data: [OneRepMax]) -> Double? {
        if let earliestInstance = data.min(by: { $0.achievedOnDate! < $1.achievedOnDate! }) {
            return earliestInstance.load
        } else {
            return nil
        }
    }
    
    /// Formats a date according to the pattern "yyyy-MM-dd"
    /// - Parameter date: A date
    /// - Returns: A date string in the format "yyyy-MM-dd"
    public static func formatDate(date: Date) -> String {
        return dateFormatter.string(from: date)
    }
    
}
