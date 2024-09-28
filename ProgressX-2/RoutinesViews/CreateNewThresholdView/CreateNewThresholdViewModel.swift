//
//  CreateNewThresholdViewModel.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-08.
//

import Foundation
import CoreData

class CreateNewThresholdViewModel: ViewModel, AddingViewModel {
    
    @Published public var upperBound: String = ""
    @Published public var upperBoundIsInvalid: Bool = false
    @Published public var upperBoundIsInvalidMSg: String = ""
    
    @Published public var lowerBound: String = ""
    @Published public var lowerBoundIsInvalid: Bool = false
    @Published public var lowerBoundIsInvalidMSg: String = ""
    
    @Published public var flatLoadAdd: String = ""
    @Published public var flatLoadAddIsInvalid: Bool = false
    @Published public var flatLoadAddIsInvalidMsg: String = ""
    
    @Published public var flatQuantityAdd: String = ""
    @Published public var flatQuantityAddIsInvalid: Bool = false
    @Published public var flatQuantityAddIsInvalidMsg: String = ""
    
    // Variable for saveEntry
    @Published public var selectedTemplateSet: TemplateSet? = nil
    
    // Seg picker selections
    @Published public var addPrSelection: Bool = false
    
    @Published public var prSelection: String = ""
    
    // Seg picker options
    public let addPrSegments: KeyValueList<String, Bool> = KeyValueList([
        ("Add PR", true),
        ("Don't add PR", false)
    ])
    
    public let repPrSegments: KeyValueList<String, String> = KeyValueList([
        ("1RM", "onerepmax"),
        ("AMRAP", "maxreps")
    ])
    
    public let timePrSegments: KeyValueList<String, String> = KeyValueList([
        ("Time-max", "timemax")
    ])
    
    public func saveEntry(viewContext: NSManagedObjectContext) -> Void {
        
        let inputFlatLoadAdd: NSNumber? = {
            
            if flatLoadAdd.isEmpty { return nil }
            
            else if Double(flatLoadAdd) == 0 { return nil }
            
            else { return NSNumber(value: Double(flatLoadAdd)!) }
            
        }()
        
        let inputFlatQuantityAdd: NSNumber? = {
            
            if flatQuantityAdd.isEmpty { return nil }
            
            else if Double(flatQuantityAdd) == 0 { return nil }
            
            else { return NSNumber(value: Double(flatQuantityAdd)!) }
            
        }()
        
        let _ = SetThreshold(
            viewContext,
            templateSet: selectedTemplateSet!,
            upperBound: Double(upperBound)!,
            lowerBound: Double(lowerBound)!,
            generatesPr: addPrSelection,
            prType: addPrSelection ? prSelection : nil,
            flatLoadAdd: inputFlatLoadAdd,
            flatQuantityAdd: inputFlatQuantityAdd
        )
            
        self.save(viewContext)
        
    }
        
}
