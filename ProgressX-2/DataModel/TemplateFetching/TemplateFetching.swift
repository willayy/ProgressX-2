//
//  FetchingTemplate.swift
//  ProgressX-2
//
//  Created by lucas häyhänen on 2024-07-04.
//

import CoreData

    let fetchRequest: NSFetchRequest<Routine> = Routine.fetchRequest()
    
func copyRoutineTemplate(context: NSManagedObjectContext) {
    
    let templateRoutines: [Routine] = PersistenceController.fetch(context, fetchRequest: fetchRequest)
    
    print(templateRoutines.count, "count")
    print("---------------------------------fromdatabaseRoutine")
    
    for templateRoutine in templateRoutines {
        print("---------------------------------routine")
        print(templateRoutine)
               
                let newCycle = TrainingCycle(context: context)
                newCycle.templateCycle = templateRoutine.templateCycle
                newCycle.positionIndex = templateRoutine.getNextPositionIndex()
                newCycle.startedOnDate = Date()
                newCycle.timePeriodName =  templateRoutine.templateCycle?.timePeriodName
                newCycle.timePeriodDescription = templateRoutine.templateCycle?.timePeriodDescription
                newCycle.routine = templateRoutine
                templateRoutine.addToTrainingCycles(newCycle)
                print("---------------------------------cycle")
                print(newCycle)
                
                
                if let templateWeeksSet = templateRoutine.templateCycle?.templateWeeks as? Set<TemplateWeek> {
                    let templateWeeks = Array(templateWeeksSet)
                    for templateWeek in templateWeeks {
                        let newWeek = TrainingWeek(context: context)
                        newWeek.templateWeek = templateWeek
                        newWeek.positionIndex = newCycle.getNextPositionIndex()
                        newWeek.timePeriodName = templateWeek.timePeriodName
                        newWeek.timePeriodDescription = templateWeek.timePeriodDescription
                        newWeek.trainingCycle = newCycle
                        newWeek.startedOnDate = Date()
                        
                        print("---------------------------------week")
                        print(newWeek)
                        
                        
                        if let templateSessionsSet = templateWeek.templateSessions as? Set<TemplateSession> {
                            let templateSessions = Array(templateSessionsSet)
                            for templateSession in templateSessions {
                                let newSession = TrainingSession(context: context)
                                newSession.templateSession = templateSession
                                newSession.positionIndex = newWeek.getNextPositionIndex()
                                newSession.timePeriodName = templateSession.timePeriodName
                                newSession.trainingWeek = newWeek
                                newSession.startedOnDate = Date()
                                print("---------------------------------session")
                                print(newSession)
                                
                                if let templateSetsSet = templateSession.templateSets as? Set<TemplateSet> {
                                    let templateSets = Array(templateSetsSet)
                                    for templateSet in templateSets {
                                        let newSet = TrainingSet(context: context)
                                        newSet.templateSet = templateSet
                                        newSet.positionIndex = newSession.getNextPositionIndex()
                                        newSet.timePeriodName = templateSet.timePeriodName
                                        newSet.trainingSession = newSession
                                        newSet.exercise = templateSet.exercise
                                        newSet.startedOnDate = Date()
                                        newSet.templateSet = templateSet
                                        newSet.loadTodo = templateSet.setLoad
                                        newSet.quantityTodo = templateSet.setQuantity
                                        print("---------------------------------sett")
                                        print(newSet)
                                        
                                    }
                                }
                            }
                        }
                    }
                }
        }

        do {
            try context.save()
            print("det funkade")
        } catch {
            print("Failed to save new instances: \(error)")
        }
}

    
