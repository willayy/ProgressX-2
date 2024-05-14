//
//  ProgressX_2Tests.swift
//  ProgressX-2Tests
//
//  Created by William Norland on 2024-04-12.
//

import XCTest
@testable import ProgressX_2

final class PersistenceTests: XCTestCase {
    
    let p = PersistenceController.shared
    
    // MARK: SETUP
    override func setUpWithError() throws {
        let today = Date()
        let testHeight = 187.00
        let testIsMetric = true
        let testGender = "male"
        let testWeight = 80.00
        p.createProfile(userName: "TestProfile", birthDay: today, height: testHeight, isMetric: testIsMetric, gender: testGender)
        p.addBodyWeightEntry(dateAchieved: today, weight: testWeight)
        p.save()
    }

    // MARK: TEAR DOWN
    override func tearDownWithError() throws {
        p.wipeCoreDataBase()
        p.save()
    }
    
    // MARK: TESTS
    func testGetProfile() throws {
        var profile = p.getProfile()
        XCTAssertNotNil(profile)
        XCTAssertEqual(profile!.userName, "TestProfile")
        XCTAssertTrue(profile!.isMetric)
        // nil values in body measurements are 0.0 apparently
        p.deleteNSManagedObject(object: profile!)
        p.save()
        profile = p.getProfile()
        XCTAssertNil(profile)
    }
    
    func testGetProfileAsArray() throws {
        let profileArray = p.getProfileAsArray()
        XCTAssertEqual(profileArray.count, 1)
        XCTAssertEqual(profileArray.first!.userName, "TestProfile")
    }
    
    func testProfileState() throws {
        let profileState = p.verifyProfileState()
        XCTAssertTrue(profileState)
    }
    
    func testDoesProfileExist() throws {
        var doesTheProfileExist = p.doesProfileExist()
        XCTAssertTrue(doesTheProfileExist)
        let profile = p.getProfile()!
        p.deleteNSManagedObject(object: profile)
        p.save()
        doesTheProfileExist = p.doesProfileExist()
        XCTAssertFalse(doesTheProfileExist)
    }
    
    func testGetBodyWeightEntriesAsArray() throws {
        var bodyEntries = p.getBodyWeightEntriesAsArray()
        XCTAssertTrue(bodyEntries.count == 1)
        var firstEntry = bodyEntries.first
        XCTAssertEqual(firstEntry!.bodyWeight, 80.00)
        
        p.addBodyWeightEntry(dateAchieved: Date(), weight: 70.00)
        p.save()
        
        bodyEntries = p.getBodyWeightEntriesAsArray()
        XCTAssertTrue(bodyEntries.count == 2)
        firstEntry = bodyEntries.first
        let secondEntry = bodyEntries[1]
        XCTAssertEqual(firstEntry!.bodyWeight, 80.00)
        XCTAssertEqual(secondEntry.bodyWeight, 70.00)
    }
    
    func testGetExercisesAsArray() throws {
        // Create basic exercise library
        p.generateBasicExerciseLibrary()
        let exercises = p.getExercisesAsArray()
        XCTAssertTrue(exercises.contains { $0.exerciseName == "Bench-press" })
        XCTAssertTrue(exercises.contains { $0.exerciseName == "Shoulder-press" })
        XCTAssertTrue(exercises.contains { $0.exerciseName == "Squat" })
        XCTAssertTrue(exercises.contains { $0.exerciseName == "Deadlift" })
        XCTAssertTrue(exercises.contains { $0.exerciseName == "Sit-up" })
        XCTAssertTrue(exercises.contains { $0.exerciseName == "Push-up" })
        
    }
    
    func testAddPersonalRecords() throws {
        //TODO: Implement this test!
    }
    
}
