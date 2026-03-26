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
   
    var context: NSManagedObjectContext = PersistenceController.previewViewContext
    
    // MARK: SETUP
    override func setUpWithError() throws {
        // In memory profile, routine, and exercises should already be set up by PersistenceController.
    }

    // MARK: TEAR DOWN
    override func tearDownWithError() throws {
        // Roll back all Entities inserted into the context but not saved.
        context.rollback()
    }
    
    private func getPreviewRoutine() -> Routine {
        
        let routineFetchRequest: NSFetchRequest = Routine.fetchRequest()
        
        routineFetchRequest.predicate = NSPredicate(format: "timePeriodName == %@", "Preview routine")
        
        let routineResults = CoreDataAccess.fetch(context, fetchRequest: routineFetchRequest)
        
        let routine = routineResults.first!
        
        return routine
    }
    
    func testCascadeCompletion() {
        
        let previewRoutine = getPreviewRoutine()
        
        let sessions = CoreDataAccess.getAllTrainingSessionsIn(routine: previewRoutine, context)
        
        let session = sessions.first!
        
        let sets = session.children
        
        // Session should not be complete before any sets are done.
        XCTAssertFalse(session.isComplete, "Session should not be complete before any sets are done")
        
        // Complete all sets except the last one – session should still be incomplete.
        for set in sets.dropLast() { set.complete() }
        XCTAssertFalse(session.isComplete, "Session should not be complete until every set is done")
        
        // Complete the last set – cascade should now mark the session as complete.
        sets.last!.complete()
        XCTAssertTrue(session.isComplete, "Session should be complete after all its sets are done")
        
        // Complete all remaining sessions in the routine so we can check higher-level cascades.
        // Note: saving is intentionally skipped here because completing sessions without their
        // sets triggers a validation error; the cascade logic itself is what is being verified.
        for remainingSession in sessions where !remainingSession.isComplete {
            remainingSession.complete()
        }
        
        let trainingCycle = previewRoutine.children.first!
        
        // All sessions are complete, so the training weeks and cycle should cascade to complete.
        for trainingWeek in trainingCycle.children {
            XCTAssertTrue(trainingWeek.isComplete, "TrainingWeek should be complete after all its sessions are done")
        }
        XCTAssertTrue(trainingCycle.isComplete, "TrainingCycle should be complete after all its weeks are done")
        
    }
    
    func testOrderableTimePeriod() {
        
        let previewRoutine = getPreviewRoutine()
        
        let templateCycles: TemplateCycle? = previewRoutine.templateCycle
        
        let templateWeeks: [TemplateWeek] = templateCycles.flatMap { $0.children }!
        
        let templateSessions: [TemplateSession] = templateWeeks.flatMap { $0.children }
        
        let templateSets: [TemplateSet] = templateSessions.flatMap { $0.children }
        
        // Capture the original positions before any switches so we can verify changes.
        let originalWeekPositions = templateWeeks.map { $0.positionIndex }
        
        // Switch the last template week to position 1 (index 0 equivalent) and verify the swap.
        if templateWeeks.count >= 2 {
            let lastWeek = templateWeeks.last!
            let firstWeek = templateWeeks.first!
            let firstWeekOriginalPosition = firstWeek.positionIndex
            let lastWeekOriginalPosition = lastWeek.positionIndex
            
            lastWeek.switchPositionIndex(to: firstWeekOriginalPosition)
            
            // The swap should have exchanged the two position indexes.
            XCTAssertEqual(lastWeek.positionIndex, firstWeekOriginalPosition, "Last week should now hold the first week's original position")
            XCTAssertEqual(firstWeek.positionIndex, lastWeekOriginalPosition, "First week should now hold the last week's original position after the swap")
        }
        
        // Switch all template time periods to position 1 and verify the sorted positions
        // remain the same set of values (no duplicates or missing indexes).
        for templateWeek in templateWeeks {
            templateWeek.switchPositionIndex(to: 1)
        }
        
        let finalWeekPositions = templateWeeks.map { $0.positionIndex }.sorted()
        XCTAssertEqual(finalWeekPositions, originalWeekPositions.sorted(), "Position index values should be preserved (same set) after all switches")
        
        for templateSession in templateSessions {
            templateSession.switchPositionIndex(to: 1)
        }
        
        for templateSet in templateSets {
            templateSet.switchPositionIndex(to: 1)
        }
        
        // After all switches the context must be saveable without validation errors (no duplicate position indexes).
        CoreDataAccess.save(context)
        XCTAssertFalse(context.hasChanges, "Context should have no pending changes after a successful save")
        
    }
    
    func testPropogateChanges() throws {
        
        let previewRoutine = getPreviewRoutine()
        
        let trainingCycles = previewRoutine.children
        
        let templateCycle = previewRoutine.templateCycle!
        
        // Get template and training weeks.
        
        let trainingWeeks = trainingCycles.first!.children
        
        let templateWeeks = templateCycle.children
        
        var renameCounter = 1
        
        // Rename all template weeks and propagate to training weeks.
        
        for templateWeek in templateWeeks {
            
            templateWeek.timePeriodName = "Renamed week \(renameCounter)"
            
            templateWeek.propogateChanges()
            
            renameCounter += 1
            
        }
        
        // Each training week should carry the exact same name as the template week it belongs to.
        
        for trainingWeek in trainingWeeks {
            
            let templateWeek = try XCTUnwrap(trainingWeek.templateWeek, "Training week should have an associated template week")
            
            XCTAssertEqual(trainingWeek.timePeriodName, templateWeek.timePeriodName, "Training week name should exactly match its template week name after propagation")
            
        }
        
    }
    
    /// Helper method for testSetThreshold
    private func templateSetData(templateSets: [TemplateSet]) -> [[String : Any]] {
        
        var templateSetsData: [[String : Any]] = []
        
        for templateSet in templateSets {
            
            let templateSetData: [String : Any] = [
                "index" : templateSet.positionIndex,
                "loadTodo" : templateSet.loadTodo!,
                "quantityTodo" : templateSet.quantityTodo!
            ]
            
            templateSetsData.append(templateSetData)
            
        }
        
        return templateSetsData
        
    }
    
    func testSetThreshold() {
        
        let previewRoutine = getPreviewRoutine()
        
        // Get all training sessions in routine
        let trainingSessionsInRoutine = CoreDataAccess.getAllTrainingSessionsIn(routine: previewRoutine, context)
        
        // Map all template session
        let templateSessionsInRoutine: [TemplateSession] = trainingSessionsInRoutine.map { $0.templateSession! }
        
        let templateSets: [TemplateSet] = templateSessionsInRoutine.flatMap { $0.children }
        
        // Save all template set data to an array of dictionaries so we can compare before and after threshold effects.
        let templateSetDataBefore = templateSetData(templateSets: templateSets)
        
        // Get all trainingSets
        let trainingSets: [TrainingSet] = trainingSessionsInRoutine.flatMap { $0.children }
        
        // Complete all training sets
        for trainingSet in trainingSets {
            
            trainingSet.loadDone = trainingSet.loadTodo
            
            trainingSet.quantityDone = trainingSet.quantityTodo
            
            trainingSet.complete()
            
        }
        
        let templateSetDataAfter = templateSetData(templateSets: templateSets)
        
        var setDifferences = 0
        
        // Compare the data before and after completing the sets to see that progression got applied by thresholds.
        for templateSetData in templateSetDataAfter {
            
            let positionIndex = templateSetData["index"] as! Int64
            
            let beforeData = templateSetDataBefore.first { ($0["index"] as! Int64) == positionIndex }!
            
            let loadBefore = beforeData["loadTodo"] as! Double
            
            let loadAfter = templateSetData["loadTodo"] as! Double
            
            let quantityBefore = beforeData["quantityTodo"] as! Double
            
            let quantityAfter = templateSetData["quantityTodo"] as! Double
            
            if quantityBefore != quantityAfter { setDifferences += 1 }
            
            if loadBefore != loadAfter { setDifferences += 1 }
                        
        }
        
        // The preview routine has 8 training sets (2 weeks × 2 sessions × 2 sets). Completing each set
        // triggers its threshold, which may increment loadTodo, quantityTodo, or both. For the current
        // preview data, 15 out of the 16 possible (8 sets × 2 values) quantities change after completion,
        // confirming that the threshold system is applied correctly for every set.
        XCTAssertEqual(setDifferences, 15)
        
    }
        
}
