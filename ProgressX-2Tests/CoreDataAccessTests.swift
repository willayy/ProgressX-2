//
//  CoreDataAccessTests.swift
//  ProgressX-2Tests
//
//  Created by William Norland on 2024-09-02.
//

@testable import ProgressX_2
import CoreData
import XCTest

final class CoreDataAccessTests: XCTestCase {

    var context: NSManagedObjectContext = PersistenceController.previewViewContext
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        context.rollback()
    }
    
    private func getPreviewRoutine() -> Routine {
        
        let routineFetchRequest: NSFetchRequest = Routine.fetchRequest()
        
        routineFetchRequest.predicate = NSPredicate(format: "timePeriodName == %@", "Preview routine")
        
        let routineResults = CoreDataAccess.fetch(context, fetchRequest: routineFetchRequest)
        
        let routine = routineResults.first!
        
        return routine
    }

    func testGetCategoriesIn() {
        
        let routine = getPreviewRoutine()
        
        let categoriesInPreviewRoutine = CoreDataAccess.getCategoriesIn(routine: routine, context)
        
        // There is currently only 2 categories in the preview routine, change this if the preview routine data changes.
        
        XCTAssertEqual(categoriesInPreviewRoutine.count, 2)
        
        let categoryNames = categoriesInPreviewRoutine.map { $0.0 }
        
        // The preview routine should currently contain Category1 and Category2, nothing more.
        
        XCTAssertTrue(categoryNames.contains { $0 == "Category1" })
        
        XCTAssertTrue(categoryNames.contains { $0 == "Category2" })
    }
    
    func testSessionsDoneLast30DaysIn() {
        
        let routine = getPreviewRoutine()
        
        var sessionsDoneLast30Days = CoreDataAccess.getSessionsDoneLast30DaysIn(routine: routine, context)
        
        // This is another method but its so similiar its tested with testSessionsDoneLast30DaysIn.
        var allSessionsDoneLast30Days = CoreDataAccess.getAllSessionsDoneLast30days(context)
        
        // Nothing completed so this should be true
        XCTAssertTrue(sessionsDoneLast30Days.isEmpty)
        
        // Try to fetch a session, all sessions in the context are part of the Preview routine so we dont need to be picky with a predicate.
        let sessionFetchRequest: NSFetchRequest = TrainingSession.fetchRequest()
        
        let sessionResults = CoreDataAccess.fetch(context, fetchRequest: sessionFetchRequest)
        
        let session = sessionResults.first!
        
        // Test completing the sessions
        session.complete()
        
        sessionsDoneLast30Days = CoreDataAccess.getSessionsDoneLast30DaysIn(routine: routine, context)
        
        allSessionsDoneLast30Days = CoreDataAccess.getAllSessionsDoneLast30days(context)
        
        // These should be false
        XCTAssertFalse(sessionsDoneLast30Days.isEmpty)
        
        XCTAssertFalse(allSessionsDoneLast30Days.isEmpty)
        
        // Now test completing it in 1970
        session.complete(onDate: Date(timeIntervalSince1970: 100))
        
        sessionsDoneLast30Days = CoreDataAccess.getSessionsDoneLast30DaysIn(routine: routine, context)
        
        allSessionsDoneLast30Days = CoreDataAccess.getAllSessionsDoneLast30days(context)
        
        // This should be true since it's to long ago
        XCTAssertTrue(sessionsDoneLast30Days.isEmpty)
        
        XCTAssertTrue(allSessionsDoneLast30Days.isEmpty)
        
    }
    
    func testGetAllSessionsIn() {
        
        let routine = getPreviewRoutine()
        
        let sessionsInRoutine = CoreDataAccess.getAllTrainingSessionsIn(routine: routine, context)
        
        // There are only for sessions in the Preview routine so this crude test should be enough to ensure all are fetched.
        XCTAssertEqual(sessionsInRoutine.count, 4)
        
        let trainingCycle = routine.children.first!
        
        let sessionsInTrainingCycle = CoreDataAccess.getAllTrainingSessionsIn(trainingCycle: trainingCycle, context)
        
        XCTAssertEqual(sessionsInTrainingCycle.count, 4)
        
        let trainingWeek = trainingCycle.children.first!
        
        let sessionsInTrainingWeek = CoreDataAccess.getAllTrainingSessionsIn(trainingWeek: trainingWeek, context)
        
        XCTAssertEqual(sessionsInTrainingWeek.count, 2)
    }
    
}
