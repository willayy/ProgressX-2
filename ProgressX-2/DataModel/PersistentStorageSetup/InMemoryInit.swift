//
//  InMemoryInit.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-06-09.
//

import Foundation
import CoreData

// This extension houses a function that staticly creates NSManagedObjects for an in-memory database
class InMemory {
    
    public static func initialize(context: NSManagedObjectContext) -> Void {
        initProfile(context)
        initExercisesAndPrs(context)
        initRoutines(context)
        PersistenceController.generateBasicExerciseCategories(context)
    }
    
    private static func initProfile(_ context: NSManagedObjectContext) {
        
        let profile = Profile(
            context,
            userName: "TestProfile",
            gender: "male",
            height: 187,
            isMetric: true,
            smallestPlate: 2.5,
            birthDay: Date()
        )
        
        let _ = BodyEntry(
            context,
            profile: profile,
            bodyWeight: 65,
            date: Date()
        )
        
        let _ = BodyEntry(
            context,
            profile: profile,
            bodyWeight: 78,
            date: Date()-100000
        )
        
        let _ = BodyEntry(
            context,
            profile: profile,
            bodyWeight: 82,
            date: Date()-200000
        )
        
        let _ = BodyEntry(
            context,
            profile: profile,
            bodyWeight: 85,
            date: Date()-300000
        )
        
        let _ = BodyEntry(
            context,
            profile: profile,
            bodyWeight: 87,
            date: Date()-400000
        )
        
        let _ = BodyEntry(
            context,
            profile: profile,
            bodyWeight: 90,
            date: Date()-500000
        )
    }
    
    private static func initExercisesAndPrs(_ context: NSManagedObjectContext) {
        let testExercise1 = Exercise(
            context,
            name: "testing exercise (reps)",
            description: "This exercise is used for debugging purposes within the canvas preview",
            type: "reps"
        )
        
        let testExercise2 = Exercise(
            context,
            name: "testing exercise (time)",
            description: "This exercise is used for debugging purposes within the canvas preview",
            type: "time"
        )
        
        let _ = PersonalRecord(
            context,
            exercise: testExercise1,
            weightLoad: 50,
            quantity: 1,
            date: Date(),
            type: "onerepmax"
        )
        
        let _ = PersonalRecord(
            context,
            exercise: testExercise1,
            weightLoad: 45,
            quantity: 1,
            date: Date()-100000,
            type: "onerepmax"
        )
        
        let _ = PersonalRecord(
            context,
            exercise: testExercise1,
            weightLoad: 67,
            quantity: 1,
            date: Date()-200000,
            type: "onerepmax"
        )
        
        let _ = PersonalRecord(
            context,
            exercise: testExercise1,
            weightLoad: 89,
            quantity: 1,
            date: Date()-300000,
            type: "onerepmax"
        )
        
        let _ = PersonalRecord(
            context,
            exercise: testExercise1,
            weightLoad: 72,
            quantity: 1,
            date: Date()-400000,
            type: "onerepmax"
        )
        
        let _ = PersonalRecord(
            context,
            exercise: testExercise1,
            weightLoad: 50,
            quantity: 31,
            date: Date(),
            type: "maxreps"
        )
        
        let _ = PersonalRecord(
            context,
            exercise: testExercise1,
            weightLoad: 45,
            quantity: 21,
            date: Date()-100000,
            type: "maxreps"
        )
        
        let _ = PersonalRecord(
            context,
            exercise: testExercise1,
            weightLoad: 67,
            quantity: 18,
            date: Date()-200000,
            type: "maxreps"
        )
        
        let _ = PersonalRecord(
            context,
            exercise: testExercise1,
            weightLoad: 89,
            quantity: 11,
            date: Date()-300000,
            type: "maxreps"
        )
        
        let _ = PersonalRecord(
            context,
            exercise: testExercise1,
            weightLoad: 72,
            quantity: 15,
            date: Date()-400000,
            type: "maxreps"
        )
        
        let _ = PersonalRecord(
            context,
            exercise: testExercise2,
            weightLoad: 50,
            quantity: 31,
            date: Date(),
            type: "timemax"
        )
        
        let _ = PersonalRecord(
            context,
            exercise: testExercise2,
            weightLoad: 45,
            quantity: 21,
            date: Date()-100000,
            type: "timemax"
        )
        
        let _ = PersonalRecord(
            context,
            exercise: testExercise2,
            weightLoad: 67,
            quantity: 18,
            date: Date()-200000,
            type: "timemax"
        )
        
        let _ = PersonalRecord(
            context,
            exercise: testExercise2,
            weightLoad: 89,
            quantity: 11,
            date: Date()-300000,
            type: "timemax"
        )
        
        let _ = PersonalRecord(
            context,
            exercise: testExercise2,
            weightLoad: 72,
            quantity: 15,
            date: Date()-400000,
            type: "timemax"
        )
    }
    
    private static func initRoutines(_ context: NSManagedObjectContext) {
        
        // MARK: Setting up the template routines
        // MARK: -----------------------------------------------------------------------------------------------------------------------
        
        // Creating a Routine
        let routine = Routine(
            context,
            name: "Test routine 1",
            description: "Toutine used for in-memory debugging"
        )
        
        // Adding a template cycle to that routine
        let templateCycle = TemplateCycle(
            context,
            routine: routine
        )
        
        // Since every routine needs at least one active cycle
        let trainingCycle = TrainingCycle(
            context,
            routine: routine
        )
        
        // Adding a template week to the template cycle
        let templateWeek1 = TemplateWeek(
            context,
            templateCycle: templateCycle
        )
        
        // Adding a template session to the template week
        let templateSession1 = TemplateSession(
            context,
            templateWeek: templateWeek1
        )
        
        // Adding a second template session to the template week
        let templateSession2 = TemplateSession(
            context,
            templateWeek: templateWeek1
        )
        
        // Adding a third template session to the template week
        let templateSession3 = TemplateSession(
            context,
            templateWeek: templateWeek1
        )
        
        // Fetch exercises for the set
        let exerciseFetchRequest = Exercise.fetchRequest()
        exerciseFetchRequest.predicate = NSPredicate(format: "exerciseName == %@", "testing exercise (reps)")
        let exercises = PersistenceController.fetch(context, fetchRequest: exerciseFetchRequest)
        let exercise = exercises.first!
        
        // Get the standard rest time
        let profile = PersistenceController.getProfile(context)
        let standardRestTime = profile!.standardRestTime
        
        // Adding a template set to the template session
        let templateSet11 = TemplateSet(
            context,
            templateSession: templateSession1,
            exercise: exercise,
            loadType: "numerical",
            load: 1,
            quantityType: "numerical",
            quantity: 1,
            restTime: standardRestTime
        )
        
        // Adding thresholds to the set
        let _ = SetThreshold(
            context,
            templateSet: templateSet11,
            triggeredAt: 5,
            generatesPr: true,
            prType: "onerepmax",
            flatLoadAdd: nil,
            flatQuantityAdd: nil
        )
        
        // Adding some more template sets to the sessions, these are without thresholds
        let templateSet12 = TemplateSet(
            context,
            templateSession: templateSession1,
            exercise: exercise,
            loadType: "numerical",
            load: 2,
            quantityType: "numerical",
            quantity: 2,
            restTime: standardRestTime
        )
        
        let templateSet21 = TemplateSet(
            context,
            templateSession: templateSession2,
            exercise: exercise,
            loadType: "numerical",
            load: 1,
            quantityType: "numerical",
            quantity: 1,
            restTime: standardRestTime
        )
        
        let templateSet22 = TemplateSet(
            context,
            templateSession: templateSession2,
            exercise: exercise,
            loadType: "numerical",
            load: 2,
            quantityType: "numerical",
            quantity: 2,
            restTime: standardRestTime
        )
        
        let templateSet31 = TemplateSet(
            context,
            templateSession: templateSession3,
            exercise: exercise,
            loadType: "numerical",
            load: 1,
            quantityType: "numerical",
            quantity: 1,
            restTime: standardRestTime
        )
        
        let templateSet32 = TemplateSet(
            context,
            templateSession: templateSession3,
            exercise: exercise,
            loadType: "numerical",
            load: 2,
            quantityType: "numerical",
            quantity: 2,
            restTime: standardRestTime
        )
        
        // MARK: Setting up a training routine
        // MARK: -----------------------------------------------------------------------------------------------------------------------
        
        // Adding a training week to the the training cycle
        let trainingWeek1 = TrainingWeek(
            context,
            trainingCycle: trainingCycle,
            templateWeek: templateWeek1
        )
        
        // Adding the first session to the training week
        // This session is COMPLETED
        let trainingSession1 = TrainingSession(
            context,
            trainingWeek: trainingWeek1,
            templateSession: templateSession1
        )
        trainingSession1.complete()
        
        // Adding the second session to the training week
        let trainingSession2 = TrainingSession(
            context,
            trainingWeek: trainingWeek1,
            templateSession: templateSession2
        )
        
        // Adding the third session to the training week
        let trainingSession3 = TrainingSession(
            context,
            trainingWeek: trainingWeek1,
            templateSession: templateSession3
        )
        
        // Adding the first set to the first training week
        // This set is COMPLETED
        let trainingSet11 = TrainingSet(
            context,
            trainingSession: trainingSession1,
            templateSet: templateSet11
        )
        trainingSet11.loadDone = trainingSet11.loadTodo
        trainingSet11.quantityDone = trainingSet11.quantityTodo
        trainingSet11.complete()
        
        // Adding the second set to the first training week
        // This set is COMPLETED
        let trainingSet12 = TrainingSet(
            context,
            trainingSession: trainingSession1,
            templateSet: templateSet12
        )
        trainingSet12.loadDone = trainingSet12.loadTodo
        trainingSet12.quantityDone = trainingSet12.quantityTodo
        trainingSet12.complete()
        
        // Adding the first set to the second training week
        let _ = TrainingSet(
            context,
            trainingSession: trainingSession2,
            templateSet: templateSet21
        )
        
        // Adding the second set to the second training week
        let _ = TrainingSet(
            context,
            trainingSession: trainingSession2,
            templateSet: templateSet22
        )
        
        // Adding the first set to the third training week
        let _ = TrainingSet(
            context,
            trainingSession: trainingSession3,
            templateSet: templateSet31
        )
        
        // Adding the second set to the third training week
        let _ = TrainingSet(
            context,
            trainingSession: trainingSession3,
            templateSet: templateSet32
        )
    }
}
