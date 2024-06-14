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

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        let p = PersistenceController.preview
        let context: NSManagedObjectContext = p.container.viewContext
        
        guard let asset = NSDataAsset(name: "Exercises", bundle: Bundle.main) else {
            fatalError("Could not find exercises")
        }
        
        XCTAssertNotNil(asset)
        
        let jsonArray = try! JSONSerialization.jsonObject(with: asset.data, options: JSONSerialization.ReadingOptions.allowFragments) as! [[String: String]]
        
        XCTAssertNotNil(jsonArray)
        
        for json in jsonArray {
            XCTAssertFalse(json.isEmpty)
        }
    }

}
