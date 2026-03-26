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
    
    func testGetSessionsDoneLast30DaysIn() {
        
        let routine = getPreviewRoutine()
        
        var sessionsDoneLast30Days = CoreDataAccess.getSessionsDoneLast30DaysIn(routine: routine, context)
        
        // Nothing completed so this should be empty.
        XCTAssertTrue(sessionsDoneLast30Days.isEmpty)
        
        // Fetch a session from the context.
        let sessionFetchRequest: NSFetchRequest = TrainingSession.fetchRequest()
        let sessionResults = CoreDataAccess.fetch(context, fetchRequest: sessionFetchRequest)
        let session = sessionResults.first!
        
        // Complete the session today – it should appear in the last-30-days results.
        session.complete()
        
        sessionsDoneLast30Days = CoreDataAccess.getSessionsDoneLast30DaysIn(routine: routine, context)
        XCTAssertFalse(sessionsDoneLast30Days.isEmpty, "A session completed today should appear in the last-30-days results")
        
        // Complete the same session in 1970 – it should no longer appear.
        session.complete(onDate: Date(timeIntervalSince1970: 100))
        
        sessionsDoneLast30Days = CoreDataAccess.getSessionsDoneLast30DaysIn(routine: routine, context)
        XCTAssertTrue(sessionsDoneLast30Days.isEmpty, "A session completed in 1970 should not appear in the last-30-days results")
        
    }
    
    func testGetAllSessionsDoneLast30Days() {
        
        var allSessionsDoneLast30Days = CoreDataAccess.getAllSessionsDoneLast30days(context)
        
        // Nothing completed so this should be empty.
        XCTAssertTrue(allSessionsDoneLast30Days.isEmpty)
        
        // Fetch a session from the context.
        let sessionFetchRequest: NSFetchRequest = TrainingSession.fetchRequest()
        let sessionResults = CoreDataAccess.fetch(context, fetchRequest: sessionFetchRequest)
        let session = sessionResults.first!
        
        // Complete the session today – it should appear in the last-30-days results.
        session.complete()
        
        allSessionsDoneLast30Days = CoreDataAccess.getAllSessionsDoneLast30days(context)
        XCTAssertFalse(allSessionsDoneLast30Days.isEmpty, "A session completed today should appear in the all-routines last-30-days results")
        
        // Complete the same session in 1970 – it should no longer appear.
        session.complete(onDate: Date(timeIntervalSince1970: 100))
        
        allSessionsDoneLast30Days = CoreDataAccess.getAllSessionsDoneLast30days(context)
        XCTAssertTrue(allSessionsDoneLast30Days.isEmpty, "A session completed in 1970 should not appear in the all-routines last-30-days results")
        
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
    
    func testGetLastSessionDone() {
        
        // No sessions completed yet – should return nil.
        XCTAssertNil(CoreDataAccess.getLastSessionDone(context))
        
        let sessionFetchRequest: NSFetchRequest<TrainingSession> = TrainingSession.fetchRequest()
        let sessions = CoreDataAccess.fetch(context, fetchRequest: sessionFetchRequest)
        
        XCTAssertFalse(sessions.isEmpty, "Preview data should contain at least two sessions")
        
        let olderDate = Date(timeIntervalSince1970: 1_000_000)
        let newerDate = Date(timeIntervalSince1970: 2_000_000)
        
        // Complete two sessions at different dates.
        sessions[0].complete(onDate: olderDate)
        sessions[1].complete(onDate: newerDate)
        
        // getLastSessionDone should return the session with the most recent (newer) date.
        let last = CoreDataAccess.getLastSessionDone(context)
        XCTAssertNotNil(last)
        XCTAssertEqual(last?.completedOnDate, newerDate)
    }
    
    func testGetAllSessionsDoneThisWeek() {
        
        let calendar = Calendar.current
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
        
        let sessionFetchRequest: NSFetchRequest<TrainingSession> = TrainingSession.fetchRequest()
        let sessions = CoreDataAccess.fetch(context, fetchRequest: sessionFetchRequest)
        
        XCTAssertTrue(sessions.count >= 2, "Preview data should contain at least two sessions")
        
        // No sessions completed yet.
        XCTAssertTrue(CoreDataAccess.getAllSessionsDoneThisWeek(context).isEmpty)
        
        // Complete sessions[0] exactly on the start of the week (boundary test).
        sessions[0].complete(onDate: startOfWeek)
        
        let sessionsThisWeekAfterBoundary = CoreDataAccess.getAllSessionsDoneThisWeek(context)
        XCTAssertFalse(sessionsThisWeekAfterBoundary.isEmpty, "A session completed exactly on the start of the week should be included")
        
        // Complete sessions[1] in the distant past – it should not appear in this week's results.
        sessions[1].complete(onDate: Date(timeIntervalSince1970: 100))
        
        let sessionsThisWeekAfterDistantCompletion = CoreDataAccess.getAllSessionsDoneThisWeek(context)
        // sessions[0] (at startOfWeek) should still be included; sessions[1] (in the distant past) should not.
        XCTAssertFalse(sessionsThisWeekAfterDistantCompletion.isEmpty, "Boundary session should still be counted")
        XCTAssertEqual(sessionsThisWeekAfterDistantCompletion.count, 1, "Only the boundary session should be counted")
    }
    
    func testBasicExercisesExistAndBasicRoutinesExist() {
        
        // The preview context does not contain the live starter exercises or routines,
        // so both checkers should return false for the preview data.
        XCTAssertFalse(CoreDataAccess.basicExercisesExist(context))
        XCTAssertFalse(CoreDataAccess.basicRoutinesExists(context))
        
        // Generate the starter data.
        CoreDataAccess.generateExerciseCategories(context)
        CoreDataAccess.generateStarterExerciseLibrary(context)
        
        // Now the basic exercises should be found.
        XCTAssertTrue(CoreDataAccess.basicExercisesExist(context))
        
        // Generate the starter routine.
        CoreDataAccess.generateStarterRoutines(context)
        
        // Now the basic routine should be found.
        XCTAssertTrue(CoreDataAccess.basicRoutinesExists(context))
    }
    
    func testGetLastSessionDoneIn() {
        
        let routine = getPreviewRoutine()
        
        // No sessions completed yet – should return nil.
        XCTAssertNil(CoreDataAccess.getLastSessionDoneIn(routine: routine, context), "getLastSessionDoneIn should return nil when no sessions have been completed")
        
        let sessionFetchRequest: NSFetchRequest<TrainingSession> = TrainingSession.fetchRequest()
        let sessions = CoreDataAccess.fetch(context, fetchRequest: sessionFetchRequest)
        
        XCTAssertTrue(sessions.count >= 2, "Preview data should contain at least two sessions")
        
        let olderDate = Date(timeIntervalSince1970: 1_000_000)
        let newerDate = Date(timeIntervalSince1970: 2_000_000)
        
        // Complete two sessions at different dates.
        sessions[0].complete(onDate: olderDate)
        sessions[1].complete(onDate: newerDate)
        
        // getLastSessionDoneIn should return the session with the most recent (newer) date.
        let last = CoreDataAccess.getLastSessionDoneIn(routine: routine, context)
        XCTAssertNotNil(last, "getLastSessionDoneIn should return a session after completions are recorded")
        XCTAssertEqual(last?.completedOnDate, newerDate, "getLastSessionDoneIn should return the most recently completed session")
    }
    
    func testGetSessionsDoneLast7DaysIn() {
        
        let routine = getPreviewRoutine()
        
        // No sessions completed yet – should be empty.
        XCTAssertTrue(CoreDataAccess.getSessionsDoneLast7DaysIn(routine: routine, context).isEmpty, "No sessions should be in the last-7-days results before any completions")
        
        let sessionFetchRequest: NSFetchRequest<TrainingSession> = TrainingSession.fetchRequest()
        let sessions = CoreDataAccess.fetch(context, fetchRequest: sessionFetchRequest)
        
        XCTAssertTrue(sessions.count >= 2, "Preview data should contain at least two sessions")
        
        // Complete a session today – it should appear in the last-7-days results.
        sessions[0].complete()
        
        let sessionsLast7DaysAfterCompletion = CoreDataAccess.getSessionsDoneLast7DaysIn(routine: routine, context)
        XCTAssertFalse(sessionsLast7DaysAfterCompletion.isEmpty, "A session completed today should appear in the last-7-days results")
        XCTAssertEqual(sessionsLast7DaysAfterCompletion.count, 1)
        
        // Complete a second session in the distant past – it should not appear.
        sessions[1].complete(onDate: Date(timeIntervalSince1970: 100))
        
        let sessionsLast7DaysAfterDistantCompletion = CoreDataAccess.getSessionsDoneLast7DaysIn(routine: routine, context)
        XCTAssertEqual(sessionsLast7DaysAfterDistantCompletion.count, 1, "Only the recently completed session should be in the last-7-days results")
        
    }
    
}
