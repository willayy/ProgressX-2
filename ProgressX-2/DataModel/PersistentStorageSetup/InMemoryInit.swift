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
        
        let bw1 = BodyEntry(
            context,
            profile: profile,
            bodyWeight: 65,
            date: Date()
        )
        
        let bw2 = BodyEntry(
            context,
            profile: profile,
            bodyWeight: 78,
            date: Date()-100000
        )
        
        let bw3 = BodyEntry(
            context,
            profile: profile,
            bodyWeight: 82,
            date: Date()-200000
        )
        
        let bw4 = BodyEntry(
            context,
            profile: profile,
            bodyWeight: 85,
            date: Date()-300000
        )
        
        let bw5 = BodyEntry(
            context,
            profile: profile,
            bodyWeight: 87,
            date: Date()-400000
        )
        
        let bw6 = BodyEntry(
            context,
            profile: profile,
            bodyWeight: 90,
            date: Date()-500000
        )
        
        profile.addToBodyEntries(bw1)
        profile.addToBodyEntries(bw2)
        profile.addToBodyEntries(bw3)
        profile.addToBodyEntries(bw4)
        profile.addToBodyEntries(bw5)
        profile.addToBodyEntries(bw6)
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
        
        let ORMpr1 = PersonalRecord(
            context,
            exercise: testExercise1,
            weightLoad: 50,
            quantity: 1,
            date: Date(),
            type: "onerepmax"
        )
        
        let ORMpr2 = PersonalRecord(
            context,
            exercise: testExercise1,
            weightLoad: 45,
            quantity: 1,
            date: Date()-100000,
            type: "onerepmax"
        )
        
        let ORMpr3 = PersonalRecord(
            context,
            exercise: testExercise1,
            weightLoad: 67,
            quantity: 1,
            date: Date()-200000,
            type: "onerepmax"
        )
        
        let ORMpr4 = PersonalRecord(
            context,
            exercise: testExercise1,
            weightLoad: 89,
            quantity: 1,
            date: Date()-300000,
            type: "onerepmax"
        )
        
        let ORMpr5 = PersonalRecord(
            context,
            exercise: testExercise1,
            weightLoad: 72,
            quantity: 1,
            date: Date()-400000,
            type: "onerepmax"
        )
        
        let MRpr1 = PersonalRecord(
            context,
            exercise: testExercise1,
            weightLoad: 50,
            quantity: 31,
            date: Date(),
            type: "maxreps"
        )
        
        let MRpr2 = PersonalRecord(
            context,
            exercise: testExercise1,
            weightLoad: 45,
            quantity: 21,
            date: Date()-100000,
            type: "maxreps"
        )
        
        let MRpr3 = PersonalRecord(
            context,
            exercise: testExercise1,
            weightLoad: 67,
            quantity: 18,
            date: Date()-200000,
            type: "maxreps"
        )
        
        let MRpr4 = PersonalRecord(
            context,
            exercise: testExercise1,
            weightLoad: 89,
            quantity: 11,
            date: Date()-300000,
            type: "maxreps"
        )
        
        let MRpr5 = PersonalRecord(
            context,
            exercise: testExercise1,
            weightLoad: 72,
            quantity: 15,
            date: Date()-400000,
            type: "maxreps"
        )
        
        let TMpr1 = PersonalRecord(
            context,
            exercise: testExercise2,
            weightLoad: 50,
            quantity: 31,
            date: Date(),
            type: "timemax"
        )
        
        let TMpr2 = PersonalRecord(
            context,
            exercise: testExercise2,
            weightLoad: 45,
            quantity: 21,
            date: Date()-100000,
            type: "timemax"
        )
        
        let TMpr3 = PersonalRecord(
            context,
            exercise: testExercise2,
            weightLoad: 67,
            quantity: 18,
            date: Date()-200000,
            type: "timemax"
        )
        
        let TMpr4 = PersonalRecord(
            context,
            exercise: testExercise2,
            weightLoad: 89,
            quantity: 11,
            date: Date()-300000,
            type: "timemax"
        )
        
        let TMpr5 = PersonalRecord(
            context,
            exercise: testExercise2,
            weightLoad: 72,
            quantity: 15,
            date: Date()-400000,
            type: "timemax"
        )
        
        
        testExercise1.addToPersonalRecords(ORMpr1)
        testExercise1.addToPersonalRecords(ORMpr2)
        testExercise1.addToPersonalRecords(ORMpr3)
        testExercise1.addToPersonalRecords(ORMpr4)
        testExercise1.addToPersonalRecords(ORMpr5)
        testExercise1.addToPersonalRecords(MRpr1)
        testExercise1.addToPersonalRecords(MRpr2)
        testExercise1.addToPersonalRecords(MRpr3)
        testExercise1.addToPersonalRecords(MRpr4)
        testExercise1.addToPersonalRecords(MRpr5)
        testExercise2.addToPersonalRecords(TMpr1)
        testExercise2.addToPersonalRecords(TMpr2)
        testExercise2.addToPersonalRecords(TMpr3)
        testExercise2.addToPersonalRecords(TMpr4)
        testExercise2.addToPersonalRecords(TMpr5)
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
        routine.templateCycle = templateCycle
        
        // Since every routine needs at least one active cycle
        let trainingCycle = TrainingCycle(
            context,
            routine: routine
        )
        routine.addToTrainingCycles(trainingCycle)
        
        // Adding a template week to the template cycle
        let templateWeek1 = TemplateWeek(
            context,
            templateCycle: templateCycle
        )
        templateCycle.addToTemplateWeeks(templateWeek1)
        
        // Adding a template session to the template week
        let templateSession1 = TemplateSession(
            context,
            templateWeek: templateWeek1
        )
        templateWeek1.addToTemplateSessions(templateSession1)
        
        // Adding a second template session to the template week
        let templateSession2 = TemplateSession(
            context,
            templateWeek: templateWeek1
        )
        templateWeek1.addToTemplateSessions(templateSession2)
        
        // Adding a third template session to the template week
        let templateSession3 = TemplateSession(
            context,
            templateWeek: templateWeek1
        )
        templateWeek1.addToTemplateSessions(templateSession3)
        
        // Fetch exercises for the set
        let exerciseFetchRequest = Exercise.fetchRequest()
        exerciseFetchRequest.predicate = NSPredicate(format: "exerciseName == %@", "testing exercise (reps)")
        let exercises = PersistenceController.fetch(context, fetchRequest: exerciseFetchRequest)
        let exercise = exercises.first!
        
        // Adding a template set to the template session
        let templateSet11 = TemplateSet(
            context,
            templateSession: templateSession1,
            exercise: exercise,
            loadType: "numerical",
            load: 1,
            quantityType: "numerical",
            quantity: 1
        )
        templateSession1.addToTemplateSets(templateSet11)
        
        // Adding thresholds to the set
        let threshold1 = SetThreshold(
            context,
            templateSet: templateSet11,
            triggeredAt: 5,
            generatesPr: true,
            prType: "onerepmax",
            flatLoadAdd: nil,
            flatQuantityAdd: nil
        )

        templateSet11.addToThresholds(threshold1)
        
        // Adding some more template sets to the sessions, these are without thresholds
        let templateSet12 = TemplateSet(
            context,
            templateSession: templateSession1,
            exercise: exercise,
            loadType: "numerical",
            load: 2,
            quantityType: "numerical",
            quantity: 2
        )
        
        let templateSet21 = TemplateSet(
            context,
            templateSession: templateSession1,
            exercise: exercise,
            loadType: "numerical",
            load: 1,
            quantityType: "numerical",
            quantity: 1
        )
        
        let templateSet22 = TemplateSet(
            context,
            templateSession: templateSession1,
            exercise: exercise,
            loadType: "numerical",
            load: 2,
            quantityType: "numerical",
            quantity: 2
        )
        
        let templateSet31 = TemplateSet(
            context,
            templateSession: templateSession1,
            exercise: exercise,
            loadType: "numerical",
            load: 1,
            quantityType: "numerical",
            quantity: 1
        )
        
        let templateSet32 = TemplateSet(
            context,
            templateSession: templateSession1,
            exercise: exercise,
            loadType: "numerical",
            load: 2,
            quantityType: "numerical",
            quantity: 2
        )
        
        // MARK: Setting up a training routine
        // MARK: -----------------------------------------------------------------------------------------------------------------------
        
        // Adding a training week to the the training cycle
        let trainingWeek1 = TrainingWeek(
            context,
            trainingCycle: trainingCycle,
            templateWeek: templateWeek1
        )
        trainingCycle.addToTrainingWeeks(trainingWeek1)
        
        // Adding the first session to the training week
        // This session is COMPLETED
        let trainingSession1 = TrainingSession(
            context,
            trainingWeek: trainingWeek1,
            templateSession: templateSession1
        )
        trainingWeek1.addToTrainingSessions(trainingSession1)
        trainingSession1.complete()
        
        // Adding the second session to the training week
        let trainingSession2 = TrainingSession(
            context,
            trainingWeek: trainingWeek1,
            templateSession: templateSession2
        )
        trainingWeek1.addToTrainingSessions(trainingSession2)
        
        // Adding the third session to the training week
        let trainingSession3 = TrainingSession(
            context,
            trainingWeek: trainingWeek1,
            templateSession: templateSession3
        )
        trainingWeek1.addToTrainingSessions(trainingSession3)
        
        // Adding the first set to the first training week
        // This set is COMPLETED
        let trainingSet11 = TrainingSet(
            context,
            trainingSession: trainingSession1,
            templateSet: templateSet11
        )
        trainingSession1.addToTrainingSets(trainingSet11)
        trainingSet11.complete()
        trainingSet11.loadDone = trainingSet11.loadTodo
        trainingSet11.quantityDone = trainingSet11.quantityTodo
        
        // Adding the second set to the first training week
        // This set is COMPLETED
        let trainingSet12 = TrainingSet(
            context,
            trainingSession: trainingSession1,
            templateSet: templateSet12
        )
        trainingSession1.addToTrainingSets(trainingSet12)
        trainingSet12.complete()
        trainingSet12.loadDone = trainingSet12.loadTodo
        trainingSet12.quantityDone = trainingSet12.quantityTodo
        
        // Adding the first set to the second training week
        let trainingSet21 = TrainingSet(
            context,
            trainingSession: trainingSession2,
            templateSet: templateSet21
        )
        trainingSession2.addToTrainingSets(trainingSet21)
        
        // Adding the second set to the second training week
        let trainingSet22 = TrainingSet(
            context,
            trainingSession: trainingSession2,
            templateSet: templateSet22
        )
        trainingSession2.addToTrainingSets(trainingSet22)
        
        // Adding the first set to the third training week
        let trainingSet31 = TrainingSet(
            context,
            trainingSession: trainingSession3,
            templateSet: templateSet31
        )
        trainingSession3.addToTrainingSets(trainingSet31)
        
        // Adding the second set to the third training week
        let trainingSet32 = TrainingSet(
            context,
            trainingSession: trainingSession3,
            templateSet: templateSet32
        )
        trainingSession3.addToTrainingSets(trainingSet32)
        
        

        
    }
}
