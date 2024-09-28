//
//  Getters.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-08-01.
//

import Foundation
import CoreData

/// Extensions that has getter functions for things that are often accessed from the CoreData model and warrant a shortcut.
extension CoreDataAccess {
    
    /// Gets an exercise that has the matching exerciseName
    /// - Parameters:
    ///   - context: NSManagedObjectContext
    ///   - name: A string name that should match the exercises .exerciseName property.
    /// - Returns: Returns a matching exercise or nil (if no matches are found)
    public static func getExercise(_ context: NSManagedObjectContext, name: String) -> Exercise? {
        let fetchRequest: NSFetchRequest = Exercise.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "exerciseName == %@", name)
        let results = fetch(context, fetchRequest: fetchRequest)
        return results.first ?? nil
    }
    
    /// Gets the Profile if one is created.
    /// - Parameter context: A NSManagedObjectContext from a peristent container.
    /// - Returns: A Profile object if one has been created, else nil.
    public static func getProfile(_ context: NSManagedObjectContext) -> Profile? {
        let fetchRequest: NSFetchRequest<Profile> = Profile.fetchRequest()
        let fetchResult = fetch(context, fetchRequest: fetchRequest)
        return fetchResult.first
    }
    
    /// Gets the weightUnit set on the Profile
    /// - Parameter context: A NSManagedObjectContext from a peristent container.
    /// - Returns: kg's or lbs if Profile has been created nil otherwise.
    public static func getWeightUnit(_ context: NSManagedObjectContext) -> String? {
        let fetchRequest: NSFetchRequest<Profile> = Profile.fetchRequest()
        let fetchResult = fetch(context, fetchRequest: fetchRequest)
        let profile: Profile? = fetchResult.first
        if profile == nil {return nil}
        else {return profile!.isMetric ? "kg's" : "lbs"}
    }
    
    /// Gets the lengthUnit set on the Profile
    /// - Parameter context: A NSManagedObjectContext from a peristent container.
    /// - Returns: kg's or lbs if Profile has been created nil otherwise.
    public static func getLengthUnit(_ context: NSManagedObjectContext) -> String? {
        let fetchRequest: NSFetchRequest<Profile> = Profile.fetchRequest()
        let fetchResult = fetch(context, fetchRequest: fetchRequest)
        let profile: Profile? = fetchResult.first
        if profile == nil {return nil}
        else {return profile!.isMetric ? "cm" : "ft"}
    }
    
    /// Gets the latest PersonalRecord achieved on some exercise..
    /// - Parameters:
    ///   - context: A NSManagedObjectContext from a peristent container.
    ///   - exercise: An NSManagedObject subclass Exercise object.
    ///   - prType: The type of the PR, this can be "onerepmax" or "maxreps" for a rep based exercise. For a time based exercise it can only be "timemax"
    /// - Returns: The latest achieved PR of an Exercise.
    public static func getLatestPersonalRecord(_ context: NSManagedObjectContext, exercise: Exercise, prType: String) -> PersonalRecord? {
        let fetchRequest: NSFetchRequest<PersonalRecord> = PersonalRecord.fetchRequest()
        fetchRequest.predicate = NSCompoundPredicate(
            andPredicateWithSubpredicates: [
                NSPredicate(format: "exercise == %@", exercise),
                NSPredicate(format: "prType == %@", prType)
            ]
        )
        let fetchResult = fetch(context, fetchRequest: fetchRequest)
        let latest = fetchResult.max(by: { $0.achievedOnDate! < $1.achievedOnDate! })
        return latest
    }
    
    /// Gets the latest BodyEntry.
    /// - Parameter context: A NSManagedObjectContext from a peristent container.
    /// - Returns: The latest achieved BodyEntry
    public static func getLatestBodyEntry(_ context: NSManagedObjectContext) -> BodyEntry? {
        let fetchRequest: NSFetchRequest<BodyEntry> = BodyEntry.fetchRequest()
        let fetchResult = fetch(context, fetchRequest: fetchRequest)
        let latest = fetchResult.max(by: { $0.achievedOnDate! < $1.achievedOnDate! })
        return latest
    }
    
    /// Gets all TrainingSessions in a routine.
    /// - Parameters:
    ///   - context: The NSManagedObjectContext.
    ///   - routine: The routine containing TrainingSessions.
    /// - Returns: An array of TrainingSessions.
    public static func getAllTrainingSessionsIn(routine: Routine, _ context: NSManagedObjectContext) -> [TrainingSession] {
        let fetchRequest: NSFetchRequest<TrainingSession> = TrainingSession.fetchRequest()
        let predicate = NSPredicate(format: "trainingWeek.trainingCycle.routine == %@", routine)
        fetchRequest.predicate = predicate
        let results = fetch(context, fetchRequest: fetchRequest)
        return results
    }
    
    /// Gets all templateSets in the routine, returns empty array if none.
    /// - Parameters:
    ///  - context: The NSManagedObjectContext.
    ///  - routine: The routine containing TemplateSets.
    /// - Returns: An array of TemplateSets.
    public static func getAllTemplateSetsIn(routine: Routine, _ context: NSManagedObjectContext) -> [TemplateSet] {
        let fetchRequest: NSFetchRequest<TemplateSet> = TemplateSet.fetchRequest()
        let predicate = NSPredicate(format: "templateSession.templateWeek.templateCycle.routine == %@", routine)
        fetchRequest.predicate = predicate
        let results = fetch(context, fetchRequest: fetchRequest)
        return results
    }
    
    /// Gets all exercises of the routine.
    public static func getAllExercisesIn(routine: Routine, _ context: NSManagedObjectContext) -> [Exercise] {
        let allTemplateSets: [TemplateSet] = getAllTemplateSetsIn(routine: routine, context)
        let allExercises = allTemplateSets.map { $0.exercise! }
        return allExercises
    }
        
    /// Gets the last session done, returns nil if no sessions done.
    public static func getLastSessionDoneIn(routine: Routine, _ context: NSManagedObjectContext) -> TrainingSession? {
        let allSessions: [TrainingSession] = getAllTrainingSessionsIn(routine: routine, context)
        let completedSessions: [TrainingSession] = allSessions.filter { $0.isComplete }
        let orderedSessions = completedSessions.sorted(by: {$0.completedOnDate! > $1.completedOnDate!})
        return orderedSessions.first
    }
    
    /// Gets all sessions completed within 30 days of today, returns empty array if none.
    public static func getSessionsDoneLast30DaysIn(routine: Routine, _ context: NSManagedObjectContext) -> [TrainingSession] {
        let allSessions: [TrainingSession] = getAllTrainingSessionsIn(routine: routine, context)
        let completedSessions: [TrainingSession] = allSessions.filter { $0.isComplete }
        let today = Date()
        let thirtyDaysAgo = Calendar.current.date(byAdding: .day, value: -30, to: today)!
        let sessionsCompletedWithin30Days = completedSessions.filter { $0.completedOnDate! >= thirtyDaysAgo && $0.completedOnDate! <= today }
        return sessionsCompletedWithin30Days
    }
    
    /// Gets all sessions completed within 7 days of today, returns empty array if none.
    public static func getSessionsDoneLast7DaysIn(routine: Routine, _ context: NSManagedObjectContext) -> [TrainingSession] {
        let allSessions: [TrainingSession] = getAllTrainingSessionsIn(routine: routine, context)
        let completedSessions: [TrainingSession] = allSessions.filter { $0.isComplete }
        let today = Date()
        let sevenDaysAgo = Calendar.current.date(byAdding: .day, value: -7, to: today)!
        let sessionsCompletedWithin7Days = completedSessions.filter { $0.completedOnDate! >= sevenDaysAgo && $0.completedOnDate! <= today }
        return sessionsCompletedWithin7Days
    }
    
    /// Gets all the exercises in the routine as a dictionary where the keys are the exercises and the values the frequency.
    public static func getAllExercisesIn(routine: Routine, _ context: NSManagedObjectContext) -> KeyValueList<String, Int> {
        
        let allExercises: [Exercise] = getAllExercisesIn(routine: routine, context)
        
        // Turn into dictionary
        let exerciseDictionary = Dictionary(grouping: allExercises) { $0.exerciseName! }
            .mapValues { $0.count }
        
        // Make a sorted list of tuples
        let listOfTuples = exerciseDictionary
            .map { ($0.key, $0.value) }
            .sorted { $0.0 < $1.0 }
        
        // Turn into KVList by mapping dictionary into a list of tuples,
        let kvList = KeyValueList(listOfTuples)
            
        return kvList
    }
    
    /// Gets all the categories in the routine as a dictionary where the keys are the exercise-categories and the values the frequency.
    public static func getCategoriesIn(routine: Routine, _ context: NSManagedObjectContext) -> KeyValueList<String, Int> {
        
        let allExercises: [Exercise] = getAllExercisesIn(routine: routine, context)
        
        // Flatten into list of categories
        let allCategories = allExercises.flatMap { $0.categories! }
        
        // Turn into dict
        let categoryDictionary = Dictionary(grouping: (allCategories as! [ExerciseCategory])) { $0.categoryName! }
            .mapValues { $0.count }
        
        // Make a sorted list of tuples
        let listOfTuples = categoryDictionary
            .map { ($0.key, $0.value) }
            .sorted { $0.0 < $1.0 }
        
        // Turn into KVList by mapping dictionary into a list of tuples
        let kvList = KeyValueList(listOfTuples)
        
        return kvList
    }
    
    /// Gets all trainingSessions, completed or not, in the for the whole profile, returns empty array if there are none.
    private static func getAllTrainingSessions(_ context: NSManagedObjectContext) -> [TrainingSession] {
        let fetchRequest: NSFetchRequest<TrainingSession> = TrainingSession.fetchRequest()
        let results = CoreDataAccess.fetch(context, fetchRequest: fetchRequest)
        return results
    }
    
    /// Gets all sessions completed within 30 days of today for all routines, returns empty array if none.
    public static func getAllSessionsDoneLast30days(_ context: NSManagedObjectContext) -> [TrainingSession] {
        let allSessions: [TrainingSession] = getAllTrainingSessions(context)
        // Filter out all the incomplete sessions.
        let completedSessions: [TrainingSession] = allSessions.filter { $0.isComplete }
        let today = Date()
        let thirtyDaysAgo = Calendar.current.date(byAdding: .day, value: -30, to: today)!
        // unsafely unwrapping .completedOnDate because sessions are filtered.
        let sessionsCompletedWithin30Days = completedSessions.filter {
            $0.completedOnDate! >= thirtyDaysAgo && $0.completedOnDate! <= today
        }
        return sessionsCompletedWithin30Days
    }
    
    /// Gets all sessions completed within 7 days of today for all routines, returns empty array if none.
    public static func getAllSessionsDoneThisWeek(_ context: NSManagedObjectContext) -> [TrainingSession] {
        let allSessions: [TrainingSession] = getAllTrainingSessions(context)
        // Filter out all the incomplete sessions
        let completedSessions: [TrainingSession] = allSessions.filter { $0.isComplete }
        let calendar = Calendar.current
        let today = Date()
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today))!
        let endOfWeek = calendar.date(byAdding: .day, value: 6, to: startOfWeek)
        // unsafely unwrapping .completedOnDate because sessions are filtered.
        let sessionCompletedThisWeek = completedSessions.filter {
            $0.completedOnDate! > startOfWeek && $0.completedOnDate! <= endOfWeek!
        }
        return sessionCompletedThisWeek
    }
    
    /// Gets the last completed session for any routine done. Returns nil if no sessions are completed.
    public static func getLastSessionDone(_ context: NSManagedObjectContext) -> TrainingSession? {
        let allSessions: [TrainingSession] = getAllTrainingSessions(context)
        let completedSessions: [TrainingSession] = allSessions.filter { $0.isComplete }
        // Pick the session with the smallest completion date.
        let lastCompleteSession = completedSessions.min(by: { $0.completedOnDate! > $1.completedOnDate! })
        return lastCompleteSession
    }
    
    /// Gets the routine of the last completed session. Returns nil of no sessions are completed.
    public static func getLastRoutineUsed(_ context: NSManagedObjectContext) -> Routine? {
        // If no sessions has been completed return nil
        guard let lastCompletedSession: TrainingSession = getLastSessionDone(context) else {
            return nil
        }
        
        // Get the week, then the cycle, then the routine...
        let week: TrainingWeek = lastCompletedSession.trainingWeek!
        let cycle: TrainingCycle = week.trainingCycle!
        let routine: Routine = cycle.routine!
        return routine
    }
    
    /// Gets all TrainingSessions in this cycle
    public static func getAllTrainingSessionsIn(trainingCycle: TrainingCycle, _ context: NSManagedObjectContext) -> [TrainingSession] {
        let fetchRequest: NSFetchRequest = TrainingSession.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "trainingWeek.trainingCycle == %@", trainingCycle)
        let sessions = CoreDataAccess.fetch(context, fetchRequest: fetchRequest)
        return sessions
    }
    
    /// All TrainingSessions in this TrainingWeek
    public static func getAllTrainingSessionsIn(trainingWeek: TrainingWeek, _ context: NSManagedObjectContext) -> [TrainingSession] {
        let fetchRequest: NSFetchRequest = TrainingSession.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "trainingWeek == %@", trainingWeek)
        let context = context
        let sessions = CoreDataAccess.fetch(context, fetchRequest: fetchRequest)
        return sessions
    }
    
    /// The progress of the trainingweek as a double fraction
    public static func getProgressOf(trainingWeek: TrainingWeek, _ context: NSManagedObjectContext) -> Double {
        let allsession = getAllTrainingSessionsIn(trainingWeek: trainingWeek, context)
        let completedSession = allsession.filter({ $0.isComplete })
        let numberOfSessions = Double(allsession.count)
        let numberOfCompletedSessions = Double(completedSession.count)
        if numberOfSessions == 0 { return 0 }
        else { return (numberOfCompletedSessions / numberOfSessions) }
    }
    
    /// Gets the completion status of this cycle
    public static func getProgressOf(trainingCycle: TrainingCycle, _ context: NSManagedObjectContext) -> Double {
        let allsession = getAllTrainingSessionsIn(trainingCycle: trainingCycle, context)
        let completedSession = allsession.filter({ $0.isComplete })
        let numberOfSessions = Double(allsession.count)
        let numberOfCompletedSessions = Double(completedSession.count)
        if numberOfSessions == 0 { return 0 }
        else { return (numberOfCompletedSessions / numberOfSessions) }
    }
    
}
