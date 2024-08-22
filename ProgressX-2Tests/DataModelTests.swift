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
   
    var context: NSManagedObjectContext = PersistenceController.preview.container.viewContext
    
    // MARK: SETUP
    override func setUpWithError() throws {
        // In memory profile, routine, and exercises should already be set up by PersistenceController.
    }

    // MARK: TEAR DOWN
    override func tearDownWithError() throws {
        // Roll back all Entities inserted into the context but not saved.
        context.rollback()
    }
    
    func testCoreDataAccess() {
        #warning("TODO: Implement")
    }
    
    func testCoreDataAccessGenerate() {
        #warning("TODO: Implement")
    }
    
    func testCoreDataAccessGetters() {
        #warning("TODO: Implement")
    }
    
    func testCoreDataAccessCheckers() {
        #warning("TODO: Implement")
    }
    
    func testProfile() {
        #warning("TODO: Implement")
    }
    
    func testExercise() {
        #warning("TODO: Implement")
    }
    
    func testExerciseCategory() {
        #warning("TODO: Implement")
    }
    
    func testOrderableTimePeriod() {
        #warning("TODO: Implement")
    }
    
    func testCompleteableTimePeriod() {
        #warning("TODO: Implement")
    }
    
    func testRoutine() {
        #warning("TODO: Implement")
    }
    
    func testTemplateCycle() {
        #warning("TODO: Implement")
    }
    
    func testTemplateWeek() {
        #warning("TODO: Implement")
    }
    
    func testTemplateSession() {
        #warning("TODO: Implement")
    }
    
    func testTemplateSet() {
        #warning("TODO: Implement")
    }
    
    func testSetThreshold() {
        #warning("TODO: Implement")
    }
        
}
