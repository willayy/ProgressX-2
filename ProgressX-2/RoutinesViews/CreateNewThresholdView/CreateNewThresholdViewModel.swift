//
//  CreateNewThresholdViewModel.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-08.
//

import Foundation
import CoreData

class CreateNewThresholdViewModel: ViewModel, AddingViewModel {
    
    @Published public var triggerQuantity: String = ""
    @Published public var triggerQuantityIsInvalid: Bool = false
    @Published public var triggerQuantityIsInvalidMSg: String = ""
    
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
    public let addPrSegments: [String : Bool] = [
        "Add PR" : true,
        "Don't add PR" : false
    ]
    
    public let repPrSegments: [String : String] = [
        "1RM" : "onerepmax",
        "AMRAP" : "maxreps"
    ]
    
    public let timePrSegments: [String : String] = [
        "Time-max" : "timemax"
    ]
    
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
            triggeredAt: Double(triggerQuantity)!,
            generatesPr: addPrSelection,
            prType: addPrSelection ? prSelection : nil,
            flatLoadAdd: inputFlatLoadAdd,
            flatQuantityAdd: inputFlatQuantityAdd
        )
            
        self.save(viewContext)
        
    }
        
}
