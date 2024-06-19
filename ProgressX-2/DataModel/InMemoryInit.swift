//
//  InMemoryInit.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-06-09.
//

import Foundation
import CoreData

// This extension houses a function that staticly creates NSManagedObjects for an in-memory database
extension PersistenceController {
    
    public static func initInMemoryDb(context: NSManagedObjectContext) -> Void {
        initProfile(context)
        initExercisesAndPrs(context)
        initRoutines(context)
    }
    
    private static func initProfile(_ context: NSManagedObjectContext) {
        
        let profile: Profile = Profile(context: context)
        profile.profileUserName = "TestProfile"
        profile.gender = "male"
        profile.isMetric = true
        profile.birthDay = Date()
        profile.height = 187
        
        let bw1 = PersistenceController.createBodyEntry(
            context,
            profile: profile,
            weight: 65,
            date: Date()
        )
        
        let bw2 = PersistenceController.createBodyEntry(
            context,
            profile: profile,
            weight: 78,
            date: Date()-100000
        )
        
        let bw3 = PersistenceController.createBodyEntry(
            context,
            profile: profile,
            weight: 82,
            date: Date()-200000
        )
        
        let bw4 = PersistenceController.createBodyEntry(
            context,
            profile: profile,
            weight: 85,
            date: Date()-300000
        )
        
        let bw5 = PersistenceController.createBodyEntry(
            context,
            profile: profile,
            weight: 87,
            date: Date()-400000
        )
        
        let bw6 = PersistenceController.createBodyEntry(
            context,
            profile: profile,
            weight: 90,
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
        let testExercise1 = PersistenceController.createExercise(
            context,
            name: "testing exercise (reps)",
            desc: "This exercise is used for debugging purposes within the canvas preview",
            type: "reps"
        )
        
        let testExercise2 = PersistenceController.createExercise(
            context,
            name: "testing exercise (time)",
            desc: "This exercise is used for debugging purposes within the canvas preview",
            type: "time"
        )
        
        let ORMpr1 = PersistenceController.createPersonalRecord(
            context,
            exercise: testExercise1,
            wl: 50,
            q: 1,
            date: Date(),
            type: "onerepmax"
        )
        
        let ORMpr2 = PersistenceController.createPersonalRecord(
            context,
            exercise: testExercise1,
            wl: 45,
            q: 1,
            date: Date()-100000,
            type: "onerepmax"
        )
        
        let ORMpr3 = PersistenceController.createPersonalRecord(
            context,
            exercise: testExercise1,
            wl: 67,
            q: 1,
            date: Date()-200000,
            type: "onerepmax"
        )
        
        let ORMpr4 = PersistenceController.createPersonalRecord(
            context,
            exercise: testExercise1,
            wl: 89,
            q: 1,
            date: Date()-300000,
            type: "onerepmax"
        )
        
        let ORMpr5 = PersistenceController.createPersonalRecord(
            context,
            exercise: testExercise1,
            wl: 72,
            q: 1,
            date: Date()-400000,
            type: "onerepmax"
        )
        
        let MRpr1 = PersistenceController.createPersonalRecord(
            context,
            exercise: testExercise1,
            wl: 50,
            q: 31,
            date: Date(),
            type: "maxreps"
        )
        
        let MRpr2 = PersistenceController.createPersonalRecord(
            context,
            exercise: testExercise1,
            wl: 45,
            q: 21,
            date: Date()-100000,
            type: "maxreps"
        )
        
        let MRpr3 = PersistenceController.createPersonalRecord(
            context,
            exercise: testExercise1,
            wl: 67,
            q: 18,
            date: Date()-200000,
            type: "maxreps"
        )
        
        let MRpr4 = PersistenceController.createPersonalRecord(
            context,
            exercise: testExercise1,
            wl: 89,
            q: 11,
            date: Date()-300000,
            type: "maxreps"
        )
        
        let MRpr5 = PersistenceController.createPersonalRecord(
            context,
            exercise: testExercise1,
            wl: 72,
            q: 15,
            date: Date()-400000,
            type: "maxreps"
        )
        
        let TMpr1 = PersistenceController.createPersonalRecord(
            context,
            exercise: testExercise2,
            wl: 50,
            q: 31,
            date: Date(),
            type: "timemax"
        )
        
        let TMpr2 = PersistenceController.createPersonalRecord(
            context,
            exercise: testExercise2,
            wl: 45,
            q: 21,
            date: Date()-100000,
            type: "timemax"
        )
        
        let TMpr3 = PersistenceController.createPersonalRecord(
            context,
            exercise: testExercise2,
            wl: 67,
            q: 18,
            date: Date()-200000,
            type: "timemax"
        )
        
        let TMpr4 = PersistenceController.createPersonalRecord(
            context,
            exercise: testExercise2,
            wl: 89,
            q: 11,
            date: Date()-300000,
            type: "timemax"
        )
        
        let TMpr5 = PersistenceController.createPersonalRecord(
            context,
            exercise: testExercise2,
            wl: 72,
            q: 15,
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
        let routine = Routine(context: context)
        routine.timePeriodName = "test routine 1"
        routine.timePeriodDescription = "routine used for in-memory debugging"
    }
}
