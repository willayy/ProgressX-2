//
//  JsonValidtionTests.swift
//  ProgressX-2Tests
//
//  Created by William Norland on 2024-05-27.
//

import XCTest
@testable import ProgressX_2
import CoreData

final class JsonValidtionTests: XCTestCase {
    
    var container: NSPersistentContainer?
    var context: NSManagedObjectContext?
    
    override func setUpWithError() throws {
        container = PersistenceController.preview.container
        context = container!.viewContext
        PersistenceController.generateBasicExerciseLibrary(context!)
        PersistenceController.save(context!)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCreateBasicExerciseLibrary() throws {
        
        // Check that Basic exercises has been correctly created by the in-memory db
        XCTAssertTrue(PersistenceController.basicExercisesExist(context!))
        
        // Fatal error if exercies cant be found
        guard let asset = NSDataAsset(name: "Exercises", bundle: Bundle.main) else {
            fatalError("Could not find exercises")
        }
        
        // Assert they are not nil, kind of already done by the code above
        XCTAssertNotNil(asset)
        
        let jsonArray = try! JSONSerialization.jsonObject(with: asset.data, options: JSONSerialization.ReadingOptions.allowFragments) as! [[String: String]]
        
        // Assert JSON array isnt nil
        XCTAssertNotNil(jsonArray)
        
        // Assert JSON objects arent empty
        for json in jsonArray {
            XCTAssertFalse(json.isEmpty)
            XCTAssertTrue(json["name"] != nil)
            XCTAssertTrue(json["description"] != nil)
            XCTAssertTrue(json["type"] != nil)
            XCTAssertTrue(json["This should not exist"] == nil)
        }
        
    }

}
