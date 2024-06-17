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

final class PersistenceTests: XCTestCase {
    
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
    }

    // MARK: TEAR DOWN
    override func tearDownWithError() throws {
        
    }
    
    func testCreatePersonalRecordWithWrongType() {
        // Creating a Personal record with the wrong type for the exercise.
        // This should throw an error since willSave() is overwritten
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
    
    // MARK: TESTS
    
    
}
