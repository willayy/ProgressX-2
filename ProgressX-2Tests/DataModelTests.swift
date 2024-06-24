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
        // Roll back all Entities inserted into the context but not saved.
        context!.rollback()
    }
    
    // MARK: CONSTRAINT TESTING
    // These tests check if Cosntraints set in the DataModel works.
    // Yes these should be camel-case according to convention but it becomes too hard to read.
  
    func test_Create_PersonalRecord_With_Mismatching_Types() {
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
    
    func test_Create_PersonalRecord_With_No_Exercise() {
        // Create a PersonalRecord with no exercise set.
        let pr = PersonalRecord(context: context!)
        pr.exercise = nil
        pr.prType = "onerepmax"
        pr.prQuantity = 100
        pr.weightLoad = 100
        pr.achievedOnDate = Date()
        
        XCTAssertThrowsError(try PersistenceController.save_throws(context!))
    }
    
    func test_Create_PersonalRecord_With_Invalid_Type() {
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
    
    func test_Create_PersonalRecord_With_Invalid_Quantity_1() {
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
    
    func test_Create_PersonalRecord_With_Invalid_Weight_Load_1() {
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
    
    func test_Create_PersonalRecord_With_Invalid_Quantity_2() {
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
    
    func test_Create_PersonalRecord_With_Invalid_WeightLoad_2() {
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
    
    func test_Create_Exercise_With_Invalid_Type() {
        // Create an Exercise with an invalid type string
        _ = PersistenceController.createExercise(
            context!,
            name: "some name",
            desc: "some description",
            type: "This type is not even close to being valid"
        )
        
        XCTAssertThrowsError(try PersistenceController.save_throws(context!))
    }
    
    func test_Create_Exercise_With_Invalid_Name() {
        // Create an exercise name that is too long
        let invalidExerciseName: String = String(repeating: "a", count: 51)
        
        // Put invalid name into Exercise
        let exercise = PersistenceController.createExercise(
            context!,
            name: invalidExerciseName,
            desc: "some description",
            type: "reps"
        )
        
        // Should throw
        XCTAssertThrowsError(try PersistenceController.save_throws(context!))
        
        exercise.exerciseName = String(repeating: "a", count: 50)
        
        // Should not throw since name is now within valid range
        XCTAssertNoThrow(try PersistenceController.save_throws(context!))
    }
    
    func test_Create_Exercise_With_Invalid_Desc() {
        // Create an exercise desc that is too long
        let invalidExerciseDesc: String = String(repeating: "a", count: 501)
        
        // Put invalid desc into Exercise
        let exercise = PersistenceController.createExercise(
            context!,
            name: "some name",
            desc: invalidExerciseDesc,
            type: "reps"
        )
        
        // Should throw
        XCTAssertThrowsError(try PersistenceController.save_throws(context!))
        
        // String within allowed range
        exercise.exerciseDesc = String(repeating: "a", count: 500)
        
        // Should not throw as exercise has valid description
        XCTAssertNoThrow(try PersistenceController.save_throws(context!))
    }
    
    func test_Create_Exercise_With_Non_Unique_Name() {
        // Create an exercise with a name that is already taken
        let exercise = PersistenceController.createExercise(
            context!,
            name: "testing exercise (reps)",
            desc: "some desc",
            type: "reps"
        )
        
        // Should throw
        XCTAssertThrowsError(try PersistenceController.save_throws(context!))
        
        exercise.exerciseName = "abc123"
        
        // Should not throw since name is changed
        XCTAssertNoThrow(try PersistenceController.save_throws(context!))
    }
    
    func test_Create_Profile_With_Invalid_Gender() {
        // Create a profile with a gender string that is not valid against constraints
        let profile = Profile(context: context!)
        profile.profileUserName = "some username"
        profile.birthDay = Date()
        profile.height = 180
        profile.gender = "This is not a valid gender"
        
        // Should throw
        XCTAssertThrowsError(try PersistenceController.save_throws(context!))
        
        profile.gender = "male"
        
        // Should not throw since gender is now a valid string
        XCTAssertNoThrow(try PersistenceController.save_throws(context!))
    }
    
    func test_Create_BodyEntry_With_No_Profile() {
        // Try to create a BodyEntry with no profile
        let bodyEntry = BodyEntry(context: context!)
        bodyEntry.bodyWeight = 100
        bodyEntry.achievedOnDate = Date()
        bodyEntry.profile = nil
        
        // Should throw
        XCTAssertThrowsError(try PersistenceController.save_throws(context!))
        
        bodyEntry.profile = Profile(context: context!)
        bodyEntry.profile!.gender = "male"
        
        // Should not throw since a profile has been assigned
        XCTAssertNoThrow(try PersistenceController.save_throws(context!))
    }
    
    func test_Complete_Session_With_Incoomplete_Sets() {
        let routine = Routine(context: context!)
        routine.timePeriodName = "some named routine"
        let cycle = Cycle(context: context!)
        cycle.positionIndex = 2
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
        
        set.isComplete = true
        
        // Should not throw because set is now completed
        XCTAssertNoThrow(try PersistenceController.save_throws(context!))
    }
    
    func test_Set_Quantity_To_Double_On_PersonalRecord() {
        // Create a onerepmax PR with a quantity thats not an integer
        let pr = PersistenceController.createPersonalRecord(
            context!,
            exercise: exercise!,
            wl: 100,
            q: 1.2321312,
            date: Date(),
            type: "onerepmax"
        )
        
        // Should throw quantity is double
        XCTAssertThrowsError(try PersistenceController.save_throws(context!))
        
        pr.prQuantity = 1
        
        // Should not throw quantity is integer
        XCTAssertNoThrow(try PersistenceController.save_throws(context!))
    }
    
    func test_Set_QuantityTodo_To_Double_On_TrainingSet() {
        let routine = Routine(context: context!)
        routine.timePeriodName = "some named routine 2"
        let cycle = Cycle(context: context!)
        cycle.positionIndex = 2
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
        
        set.quantityTodo = 1
        
        XCTAssertNoThrow(try PersistenceController.save_throws(context!))
        
        set.quantityTodo = 1.2321312
        
        XCTAssertThrowsError(try PersistenceController.save_throws(context!))
    }
    
    func test_Set_QuantityDone_To_Double_On_TrainingSet() {
        let routine = Routine(context: context!)
        routine.timePeriodName = "some named routine 3"
        let cycle = Cycle(context: context!)
        cycle.positionIndex = 2
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
        
        set.quantityDone = 1
        
        XCTAssertNoThrow(try PersistenceController.save_throws(context!))
        
        set.quantityDone = 1.2321312
        
        XCTAssertThrowsError(try PersistenceController.save_throws(context!))
    }
    
    func test_Orderable_Has_Invalid_positionIndex() {
        let routine = Routine(context: context!)
        let cycle1 = Cycle(context: context!)
        let cycle2 = Cycle(context: context!)
        cycle1.isComplete = true
        cycle1.routine = routine
        cycle1.positionIndex = 2
        cycle2.routine = routine
        cycle2.positionIndex = 3
        
        routine.addToCycles(cycle1)
        routine.addToCycles(cycle2)
        
        // Try with valid postionIndexes
        XCTAssertNoThrow(try PersistenceController.save_throws(context!))
        
        cycle2.positionIndex = 2
        
        // try with invalid (positionIndexes are the same) positionIndexes
        XCTAssertThrowsError(try PersistenceController.save_throws(context!))
    }
    
    func test_Routine_Has_Non_Unique_Name() {
        let routine1 = Routine(context: context!)
        let routine2 = Routine(context: context!)
        routine1.timePeriodName = "A"
        routine2.timePeriodName = "A"
        
        // SHould throw, non unique name
        XCTAssertThrowsError(try PersistenceController.save_throws(context!))
        
        routine2.timePeriodName = "B"
        
        // SHould not throw because the names are now uniqure
        XCTAssertNoThrow(try PersistenceController.save_throws(context!))
    }
        
}
