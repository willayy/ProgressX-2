//
//  JsonValidtionTests.swift
//  ProgressX-2Tests
//
//  Created by William Norland on 2024-05-27.
//

import XCTest
@testable import ProgressX_2
import CoreData

final class JsonValidtionTests: XCTestCase {
    
    private var context: NSManagedObjectContext = PersistenceController.previewViewContext

    override func setUpWithError() throws {
        // Set up a full in-memory enviroment for the tests
    }

    override func tearDownWithError() throws {
        // Roll back all Entities inserted into the context but not saved.
        context.rollback()
    }

    /// A brief test to check if the Exercise JSON data gets interpreted correctly by the generating algorithm.
    func testPreviewExercisesExist() throws {
        
        // Fetch Exercises
        let fetchRequest: NSFetchRequest = Exercise.fetchRequest()
        
        let results = CoreDataAccess.fetch(context, fetchRequest: fetchRequest)
        
        // Map Exercise names
        let exerciseNames = results.map { $0.exerciseName }
        
        XCTAssertTrue(exerciseNames.contains { $0 == "testing exercise (reps)" })
        
        XCTAssertTrue(exerciseNames.contains { $0 == "testing exercise (time)" })
        
    }
    
    /// A brief test to check if the ExerciseCategory JSON data gets interpreted correctly by the generating algorithm.
    func testPreviewExerciseCategoriesExist() throws {
        
        // Fetch categories
        let fetchRequest: NSFetchRequest = ExerciseCategory.fetchRequest()
        
        let results = CoreDataAccess.fetch(context, fetchRequest: fetchRequest)
        
        // Map Category names
        let categoryNames = results.map { $0.categoryName }
        
        // Check that all preview categories are generated correctly
        XCTAssertTrue(categoryNames.contains { $0 == "Category1" })
        
        XCTAssertTrue(categoryNames.contains { $0 == "Category2" })
        
        XCTAssertTrue(categoryNames.contains { $0 == "Category3" })
        
        XCTAssertTrue(categoryNames.contains { $0 == "Category4" })
        
        XCTAssertTrue(categoryNames.contains { $0 == "Category5" })
    }

    /// A brief test to check if the JSON data for the preview routine gets interpreted correctly, not very thorough but will catch any big errors in the algorithm converting JSON to NSManagedObjects.
    func testPreviewRoutineExist() throws {
        
        //  Fetch Routine
        let fetchRequest: NSFetchRequest = Routine.fetchRequest()
        
        fetchRequest.predicate = NSPredicate(format: "timePeriodName == %@", "Preview routine")
        
        let results = CoreDataAccess.fetch(context, fetchRequest: fetchRequest)
        
        // Test that the routine exists.
        XCTAssertFalse(results.isEmpty)
        
        let previewRoutine = results.first!
        
        // Check that routine has a template cycle.
        XCTAssertNotNil(previewRoutine.templateCycle)
        
        // Check that routine has a single training cycle.
        XCTAssertEqual(previewRoutine.children.count, 1)
        
        let templateCycle = previewRoutine.templateCycle!
        
        /* 
         MARK: This checks if the template TimePeriods has been generated but it does not
         MARK: check if the training TimePeriods have been generated
        */
        
        // Check htat the template cycle has two weeks.
        XCTAssertEqual(templateCycle.children.count, 2)
        
        // Get the first two template weeks.
        let templateWeek1 = templateCycle.children[0]
        
        let templateWeek2 = templateCycle.children[1]
        
        // Check that contains two sessions.
        XCTAssertEqual(templateWeek1.children.count, 2)
        
        XCTAssertEqual(templateWeek2.children.count, 2)
        
        // Get the sessions.
        let templateSession11 = templateWeek1.children[0]
        
        let templateSession12 = templateWeek1.children[1]
        
        let templateSession21 = templateWeek2.children[0]
        
        let templateSession22 = templateWeek2.children[1]
        
        // Check they have the right amount of children (sets).
        XCTAssertEqual(templateSession11.children.count, 2)
        
        XCTAssertEqual(templateSession12.children.count, 2)
        
        XCTAssertEqual(templateSession21.children.count, 2)
        
        XCTAssertEqual(templateSession22.children.count, 2)
        
    }
    
}
