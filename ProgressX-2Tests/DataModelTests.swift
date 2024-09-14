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
        
        for set in sets { set.complete() }
        
        // Test if completing sets cascades to session
        XCTAssertTrue(session.isComplete)
        
        /* Complete all sessions in the routine, if you where to try to save this you would get an error
         but since we arent saving and cascading completion works anyway its fine*/
        for session in sessions { session.complete() }
        
        let trainingCycle = previewRoutine.children.first!
        
        XCTAssertTrue(trainingCycle.isComplete)
        
    }
    
    func testOrderableTimePeriod() {
        
        let previewRoutine = getPreviewRoutine()
        
        let templateCycles: TemplateCycle? = previewRoutine.templateCycle
        
        let templateWeeks: [TemplateWeek] = templateCycles.flatMap { $0.children }!
        
        let templateSessions: [TemplateSession] = templateWeeks.flatMap { $0.children }
        
        let templateSets: [TemplateSet] = templateSessions.flatMap { $0.children }
        
        // Try to switch around every template time period in the routine to 1, in the end it should be able to save.
        
        for templateWeek in templateWeeks {
            templateWeek.switchPositionIndex(to: 1)
        }
        
        for templateSession in templateSessions {
            templateSession.switchPositionIndex(to: 1)
        }
        
        for templateSet in templateSets {
            templateSet.switchPositionIndex(to: 1)
        }
        
        CoreDataAccess.save(context)
        
    }
    
    func testPropogateChanges() {
        
        let previewRoutine = getPreviewRoutine()
        
        let trainingCycles = previewRoutine.children
        
        let templateCycle = previewRoutine.templateCycle!
        
        // Get template and training weeks.
        
        let trainingWeeks = trainingCycles.first!.children
        
        let templateWeeks = templateCycle.children
        
        var renameCounter = 1
        
        // Rename all weeks.
        
        for templateWeek in templateWeeks {
            
            templateWeek.timePeriodName = "Renamed week \(renameCounter)"
            
            templateWeek.propogateChanges()
            
            renameCounter += 1
            
        }
        
        // Check that all weeks has been renamed, this is not very rigourous but it works for now.
        
        for trainingWeek in trainingWeeks {
            
            XCTAssertTrue(trainingWeek.timePeriodName!.contains("Renamed week"))
            
        }
        
    }
    
    /// Helper method for testSetThreshold
    private func templateSetData(templateSets: [TemplateSet]) -> [[String : Double]] {
        
        var templateSetsData: [[String : Double]] = []
        
        for templateSet in templateSets {
            
            let templateSetData = [
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
        
        for trainingSet in trainingSets {
            
            trainingSet.loadDone = trainingSet.loadTodo
            
            trainingSet.quantityDone = trainingSet.quantityTodo
            
            trainingSet.complete()
            
        }
        
        let templateSetDataAfter = templateSetData(templateSets: templateSets)
        
    }
        
}
