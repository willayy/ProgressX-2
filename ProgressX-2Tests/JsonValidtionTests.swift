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
    
    var context: NSManagedObjectContext = PersistenceController.previewViewContext

    override func setUpWithError() throws {
        // Set up a full in-memory enviroment for the tests
    }

    override func tearDownWithError() throws {
        // Roll back all Entities inserted into the context but not saved.
        context.rollback()
    }

    func testCreateBasicExerciseLibrary() throws {
        #warning("TODO: Implement")
    }
    
    func testCreateExerciseCategories() throws {
        #warning("TODO: Implement")
    }

}
