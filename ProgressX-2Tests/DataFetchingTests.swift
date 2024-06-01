//
//  ProgressX_2Tests.swift
//  ProgressX-2Tests
//
//  Created by William Norland on 2024-04-12.
//

import XCTest
@testable import ProgressX_2

// These functions are now in the DataUtility file but since they still deal with persistance their tests are in this file.

final class DataFetchingTests: XCTestCase {
    
    // MARK: SETUP
    override func setUpWithError() throws {
        DataFetching.wipeContext() // Wipe the initialization that is used for the preview
        let today = Date()
        let testHeight = 187.00
        let testIsMetric = true
        let testGender = "male"
        let testWeight = 80.00
        DataFetching.createProfile(userName: "TestProfile", birthDay: today, height: testHeight, isMetric: testIsMetric, gender: testGender)
        DataFetching.addBodyWeightEntry(dateAchieved: today, weight: testWeight)
        DataFetching.save()
    }

    // MARK: TEAR DOWN
    override func tearDownWithError() throws {
        DataFetching.wipeContext()
        DataFetching.save()
    }
    
    // MARK: TESTS
    func testGetProfile() throws {
        var profile = DataFetching.getProfile()
        XCTAssertNotNil(profile)
        XCTAssertEqual(profile!.userName, "TestProfile")
        XCTAssertTrue(profile!.isMetric)
        // nil values in body measurements are 0.0 apparently
        DataFetching.deleteNSManagedObject(object: profile!)
        DataFetching.save()
        profile = DataFetching.getProfile()
        XCTAssertNil(profile)
    }
    
    func testGetProfileAsArray() throws {
        let profileArray = DataFetching.getProfileAsArray()
        XCTAssertEqual(profileArray.count, 1)
        XCTAssertEqual(profileArray.first!.userName, "TestProfile")
    }
    
    func testProfileState() throws {
        let profileState = DataFetching.verifyProfileState()
        XCTAssertTrue(profileState)
    }
    
    func testDoesProfileExist() throws {
        var doesTheProfileExist = DataFetching.doesProfileExist()
        XCTAssertTrue(doesTheProfileExist)
        let profile = DataFetching.getProfile()!
        DataFetching.deleteNSManagedObject(object: profile)
        DataFetching.save()
        doesTheProfileExist = DataFetching.doesProfileExist()
        XCTAssertFalse(doesTheProfileExist)
    }
    
    func testGetBodyWeightEntriesAsArray() throws {
        var bodyEntries = DataFetching.getBodyWeightEntriesAsArray()
        XCTAssertTrue(bodyEntries.count == 1)
        var firstEntry = bodyEntries.first
        XCTAssertEqual(firstEntry!.bodyWeight, 80.00)
        
        DataFetching.addBodyWeightEntry(dateAchieved: Date(), weight: 70.00)
        DataFetching.save()
        
        bodyEntries = DataFetching.getBodyWeightEntriesAsArray()
        XCTAssertTrue(bodyEntries.count == 2)
        firstEntry = bodyEntries.first
        let secondEntry = bodyEntries[1]
        XCTAssertEqual(firstEntry!.bodyWeight, 80.00)
        XCTAssertEqual(secondEntry.bodyWeight, 70.00)
    }
    
    func testGetExercisesAsArray() throws {
        // Create basic exercise library
        DataFetching.generateBasicExerciseLibrary()
        let exercises = DataFetching.getExercisesAsArray()
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
