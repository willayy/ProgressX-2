//
//  ProgressX_2Tests.swift
//  ProgressX-2Tests
//
//  Created by William Norland on 2024-04-12.
//

import XCTest
@testable import ProgressX_2

final class PersistenceTests: XCTestCase {
    
    // MARK: SETUP
    override func setUpWithError() throws {
        let p = PersistenceController.shared
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
        let p = PersistenceController.shared
        p.wipeCoreDataBase()
        p.save()
    }
    
    // MARK: TESTS
    func testGetProfile() throws {
        let p = PersistenceController.shared
        var profile = p.getProfile()
        XCTAssertNotNil(profile)
        XCTAssertEqual(profile!.userName, "TestProfile")
        XCTAssertTrue(profile!.isMetric)
        p.deleteNSManagedObject(object: profile!)
        p.save()
        profile = p.getProfile()
        XCTAssertNil(profile)
    }
    
    func testGetProfileAsArray() throws {
        let p = PersistenceController.shared
        let profileArray = p.getProfileAsArray()
        XCTAssertEqual(profileArray.count, 1)
        XCTAssertEqual(profileArray.first!.userName, "TestProfile")
    }
    
    func testProfileState() throws {
        let p = PersistenceController.shared
        let profileState = p.verifyProfileState()
        XCTAssertTrue(profileState)
    }
    
    func testDoesProfileExist() throws {
        let p = PersistenceController.shared
        var doesTheProfileExist = p.doesProfileExist()
        XCTAssertTrue(doesTheProfileExist)
        let profile = p.getProfile()!
        p.deleteNSManagedObject(object: profile)
        p.save()
        doesTheProfileExist = p.doesProfileExist()
        XCTAssertFalse(doesTheProfileExist)
    }
    
    func testGetBodyWeightEntriesAsArray() throws {
        let p = PersistenceController.shared
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
    
}
