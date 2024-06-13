//
//  InMemoryInit.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-06-09.
//

import Foundation
import CoreData

extension PersistenceController {
    
    public static func initInMemoryDb(context: NSManagedObjectContext) -> Void {
        
        let profile: Profile = Profile(context: context)
            .setValue_ch("TestProfile", forKey: "profileUserName")
            .setValue_ch("male", forKey: "gender")
            .setValue_ch(true, forKey: "isMetric")
            .setValue_ch(Date(), forKey: "birthDay")
            .setValue_ch(187, forKey: "height")
        
        let bw1 = BodyEntry(context: context)
            .setValue_ch(100, forKey: "bodyWeight")
            .setValue_ch(Date()-500000, forKey: "dateAchieved")
        bw1.profile = profile
        
        let bw2 = BodyEntry(context: context)
            .setValue_ch(95, forKey: "bodyWeight")
            .setValue_ch(Date()-400000, forKey: "dateAchieved")
        bw2.profile = profile
        
        let bw3 = BodyEntry(context: context)
            .setValue_ch(97, forKey: "bodyWeight")
            .setValue_ch(Date()-300000, forKey: "dateAchieved")
        bw3.profile = profile
        
        let bw4 = BodyEntry(context: context)
            .setValue_ch(98, forKey: "bodyWeight")
            .setValue_ch(Date()-200000, forKey: "dateAchieved")
        bw4.profile = profile
        
        let bw5 = BodyEntry(context: context)
            .setValue_ch(89, forKey: "bodyWeight")
            .setValue_ch(Date()-100000, forKey: "dateAchieved")
        bw5.profile = profile
        
        let bw6 = BodyEntry(context: context)
            .setValue_ch(87, forKey: "bodyWeight")
            .setValue_ch(Date(), forKey: "dateAchieved")
        bw6.profile = profile
        
        profile.addToBodyEntries(bw1)
        profile.addToBodyEntries(bw2)
        profile.addToBodyEntries(bw3)
        
        let testExercise1 = RepBasedExercise(context: context)
            .setValue_ch("testing exercise (reps)", forKey: "exerciseName")
            .setValue_ch("This exercise is used for debugging purposes within the canvas preview", forKey: "exerciseDesc")
        
        let testExercise2 = TimeBasedExercise(context: context)
            .setValue_ch("testing exercise (time)", forKey: "exerciseName")
            .setValue_ch("This exercise is used for debugging purposes within the canvas preview", forKey: "exerciseDesc")
        
        let ORMpr1 = OneRepMax(context: context)
            .setValue_ch(75.0, forKey: "weightLoad")
            .setValue_ch(1.0, forKey: "prQuantity")
            .setValue_ch(Date()-200000, forKey: "achievedOnDate")
            ORMpr1.exercise = testExercise1
        
        let ORMpr2 = OneRepMax(context: context)
            .setValue_ch(80.0, forKey: "weightLoad")
            .setValue_ch(1.0, forKey: "prQuantity")
            .setValue_ch(Date()-100000, forKey: "achievedOnDate")
            ORMpr2.exercise = testExercise1
        
        let ORMpr3 = OneRepMax(context: context)
            .setValue_ch(77.0, forKey: "weightLoad")
            .setValue_ch(1.0, forKey: "prQuantity")
            .setValue_ch(Date(), forKey: "achievedOnDate")
            ORMpr3.exercise = testExercise1
        
        let MRpr1 = MaxReps(context: context)
            .setValue_ch(100.0, forKey: "weightLoad")
            .setValue_ch(10.0, forKey: "prQuantity")
            .setValue_ch(Date()-200000, forKey: "achievedOnDate")
            MRpr1.exercise = testExercise1
        
        let MRpr2 = MaxReps(context: context)
            .setValue_ch(95.0, forKey: "weightLoad")
            .setValue_ch(12.0, forKey: "prQuantity")
            .setValue_ch(Date()-100000, forKey: "achievedOnDate")
            MRpr2.exercise = testExercise1
        
        let MRpr3 = MaxReps(context: context)
            .setValue_ch(97.0, forKey: "weightLoad")
            .setValue_ch(16.0, forKey: "prQuantity")
            .setValue_ch(Date(), forKey: "achievedOnDate")
            MRpr3.exercise = testExercise1
        
        let TIMpr1 = TimeMax(context: context)
            .setValue_ch(40.1, forKey: "weightLoad")
            .setValue_ch(100.0, forKey: "prQuantity")
            .setValue_ch(Date()-200000, forKey: "achievedOnDate")
            TIMpr1.exercise = testExercise2
        
        let TIMpr2 = TimeMax(context: context)
            .setValue_ch(45.6, forKey: "weightLoad")
            .setValue_ch(95.0, forKey: "prQuantity")
            .setValue_ch(Date()-100000, forKey: "achievedOnDate")
            TIMpr2.exercise = testExercise2
        
        let TIMpr3 = TimeMax(context: context)
            .setValue_ch(70.8, forKey: "weightLoad")
            .setValue_ch(97.0, forKey: "prQuantity")
            .setValue_ch(Date(), forKey: "achievedOnDate")
            TIMpr3.exercise = testExercise2
        
        testExercise1.addToPersonalRecords(ORMpr1)
        testExercise1.addToPersonalRecords(ORMpr2)
        testExercise1.addToPersonalRecords(ORMpr3)
        testExercise1.addToPersonalRecords(MRpr1)
        testExercise1.addToPersonalRecords(MRpr2)
        testExercise1.addToPersonalRecords(MRpr3)
        testExercise2.addToPersonalRecords(TIMpr1)
        testExercise2.addToPersonalRecords(TIMpr2)
        testExercise2.addToPersonalRecords(TIMpr3)
        
    }
    
}
