//
//  ProgressX_2Tests.swift
//  ProgressX-2Tests
//
//  Created by William Norland on 2024-04-12.
//

import XCTest
@testable import ProgressX_2
import CoreData

// These functions are now in the DataUtility file but since they still deal with persistance their tests are in this file.

final class DataModelTests: XCTestCase {
    
    var container: NSPersistentContainer?
    var context: NSManagedObjectContext?
    var exercise: Exercise?
    
    // MARK: SETUP
    override func setUpWithError() throws {
        container = PersistenceController.preview.container
        context = container!.viewContext
        let fetchRequest = Exercise.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "exerciseName == %@", "testing exercise (reps)")
        exercise = PersistenceController.fetch(context!, fetchRequest: fetchRequest).first
        PersistenceController.save(context!)
    }

    // MARK: TEAR DOWN
    override func tearDownWithError() throws {
        context!.rollback()
    }
    
    // MARK: TESTS
    func testCreatePersonalRecordWithMismatchingTypes() {
        // Creating a Personal record with the wrong type for the exercise its using.
        _ = PersistenceController.createPersonalRecord(
            context!,
            exercise: exercise!,
            wl: 100,
            q: 100,
            date: Date(),
            type: "timemax"
        )
        
        XCTAssertThrowsError(try PersistenceController.save_throws(context!))
    }
    
    func testCreatePersonalRecordWithNoExercise() {
        // Create a PersonalRecord with no exercise set.
        let pr = PersonalRecord(context: context!)
        pr.exercise = nil
        pr.prType = "onerepmax"
        pr.prQuantity = 100
        pr.weightLoad = 100
        pr.achievedOnDate = Date()
        
        XCTAssertThrowsError(try PersistenceController.save_throws(context!))
    }
    
    func testCreatePersonalRecordWithInvalidType() {
        // Create a PersonalRecord with a type that is not valid.
        _ = PersistenceController.createPersonalRecord(
            context!,
            exercise: exercise!,
            wl: 100,
            q: 100,
            date: Date(),
            type: "This type is not even close to being valid"
        )
        
        XCTAssertThrowsError(try PersistenceController.save_throws(context!))
    }
    
    func testCreatePersonalRecordWithInvalidQuantity1() {
        // Create a PersonalRecord with a quantity that is too low.
        _ = PersistenceController.createPersonalRecord(
            context!,
            exercise: exercise!,
            wl: 100,
            q: -100,
            date: Date(),
            type: "onerepmax"
        )
        
        XCTAssertThrowsError(try PersistenceController.save_throws(context!))
    }
    
    func testCreatePersonalRecordWithInvalidWeightLoad1() {
        // Create a PersonalRecord with a weightLoad that is too low.
        _ = PersistenceController.createPersonalRecord(
            context!,
            exercise: exercise!,
            wl: -100,
            q: 100,
            date: Date(),
            type: "onerepmax"
        )
        
        XCTAssertThrowsError(try PersistenceController.save_throws(context!))
    }
    
    func testCreatePersonalRecordWithInvalidQuantity2() {
        // Create a PersonalRecord with a quantity that is too high.
        _ = PersistenceController.createPersonalRecord(
            context!,
            exercise: exercise!,
            wl: 100,
            q: 100000000,
            date: Date(),
            type: "onerepmax"
        )
        
        XCTAssertThrowsError(try PersistenceController.save_throws(context!))
    }
    
    func testCreatePersonalRecordWithInvalidWeightLoad2() {
        // Create a PersonalRecord with a weightLoad that is too high.
        _ = PersistenceController.createPersonalRecord(
            context!,
            exercise: exercise!,
            wl: 100000000,
            q: 100,
            date: Date(),
            type: "onerepmax"
        )
        
        XCTAssertThrowsError(try PersistenceController.save_throws(context!))
    }
    
    func testCreateExerciseWithInvalidType() {
        // Create an Exercise with an invalid type string
        _ = PersistenceController.createExercise(
            context!,
            name: "some name",
            desc: "some description",
            type: "This type is not even close to being valid"
        )
        
        XCTAssertThrowsError(try PersistenceController.save_throws(context!))
    }
    
    func testCreateExerciseWithInvalidName() {
        // Create an exercise name that is too long
        let invalidExerciseName: String = String(repeating: "a", count: 51)
        
        // Put invalid name into Exercise
        _ = PersistenceController.createExercise(
            context!,
            name: invalidExerciseName,
            desc: "some description",
            type: "reps"
        )
        
        XCTAssertThrowsError(try PersistenceController.save_throws(context!))
    }
    
    func testCreateExerciseWithInvalidDesc() {
        // Create an exercise desc that is too long
        let invalidExerciseDesc: String = String(repeating: "a", count: 501)
        
        // Put invalid desc into Exercise
        _ = PersistenceController.createExercise(
            context!,
            name: "some name",
            desc: invalidExerciseDesc,
            type: "reps"
        )
        
        XCTAssertThrowsError(try PersistenceController.save_throws(context!))
    }
    
    func testCreateExerciseWithNonUniqueName() {
        // Create an exercise with a name that is already taken
        _ = PersistenceController.createExercise(
            context!,
            name: "testing exercise (reps)",
            desc: "some desc",
            type: "reps"
        )
        
        XCTAssertThrowsError(try PersistenceController.save_throws(context!))
    }
    
    func testCreateProfileWithInvalidGender() {
        // Create a profile with a gender string that is not valid against constraints
        let profile = Profile(context: context!)
        profile.profileUserName = "some username"
        profile.birthDay = Date()
        profile.height = 180
        profile.gender = "This is not a valid gender"
        
        XCTAssertThrowsError(try PersistenceController.save_throws(context!))
    }
    
    func testCreateBodyEntryWithNoProfile() {
        // Try to create a BodyEntry with no profile
        let bodyEntry = BodyEntry(context: context!)
        bodyEntry.bodyWeight = 100
        bodyEntry.achievedOnDate = Date()
        bodyEntry.profile = nil
        
        XCTAssertThrowsError(try PersistenceController.save_throws(context!))
    }
    
    func testCompleteSessionWithIncoompleteSets() {
        let routine = Routine(context: context!)
        let cycle = Cycle(context: context!)
        let week = TrainingWeek(context: context!)
        let session = Session(context: context!)
        let set = TrainingSet(context: context!)
        
        // one-to-many relationships
        routine.addToCycles(cycle)
        cycle.addToWeeks(week)
        week.addToSessions(session)
        session.addToSets(set)
        
        // one-to-one relationship
        cycle.routine = routine
        week.cycle = cycle
        session.trainingWeek = week
        set.trainingSession = session
        
        set.exercise = exercise
        set.isComplete = false
        set.prType = "onerepmax"
        
        session.isComplete = true
        
        // Should throw because session is complete but it's only set isn't
        XCTAssertThrowsError(try PersistenceController.save_throws(context!))
    }
    
}
