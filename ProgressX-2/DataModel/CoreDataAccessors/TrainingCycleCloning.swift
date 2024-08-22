//
//  FetchingTemplate.swift
//  ProgressX-2
//
//  Created by lucas häyhänen on 2024-07-04.
//

import CoreData

extension CoreDataAccess {
    
    public static func createNewCycleFromRoutine(routine: Routine, context: NSManagedObjectContext) {
        
        // Create the new training cycle
        let newCycle = TrainingCycle(
            context,
            routine: routine
        )
        
        // Copy and create new training weeks
        if let templateWeeksSet = routine.templateCycle?.templateWeeks as? Set<TemplateWeek> {
            let templateWeeks = Array(templateWeeksSet)
                .sorted(by: {$0.positionIndex < $1.positionIndex })
            for templateWeek in templateWeeks {
                
                let newWeek = TrainingWeek(
                    context,
                    trainingCycle: newCycle,
                    templateWeek: templateWeek
                )
                
                // Copy and create new sessions
                if let templateSessionsSet = templateWeek.templateSessions as? Set<TemplateSession> {
                    let templateSessions = Array(templateSessionsSet)
                        .sorted(by: {$0.positionIndex < $1.positionIndex })
                    for templateSession in templateSessions {
                        
                        let newSession = TrainingSession(
                            context,
                            trainingWeek: newWeek,
                            templateSession: templateSession
                        )
                        
                        // Copy and create new sets
                        if let templateSetsSet = templateSession.templateSets as? Set<TemplateSet> {
                            let templateSets = Array(templateSetsSet)
                                .sorted(by: {$0.positionIndex < $1.positionIndex })
                            for templateSet in templateSets {
                                
                                let _ = TrainingSet(
                                    context,
                                    trainingSession: newSession,
                                    templateSet: templateSet
                                )
                                
                            }
                        }
                    }
                }
            }
        }
    }
}
