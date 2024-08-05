//
//  CreateNewThresholdViewModel.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-08.
//

import Foundation
import CoreData

class CreateNewThresholdViewModel: SavingViewModel, AddingViewModel {
    
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
    @Published public var addPrSelection: String = "Don't add PR"
    @Published public var addRepPrSelection: String = "1RM"
    
    // Seg picker options
    public let addPrSegments: [String] = ["Add PR", "Don't add PR"]
    public let addRepPrSegments: [String] = ["1RM", "AMRAP"]
    
    public func saveEntry(viewContext: NSManagedObjectContext) -> Void {
        
        let exerciseType = selectedTemplateSet!.exercise!.exerciseType
        let addPr = addPrSelection == "Add PR" ? true : false
        var prType: String? = nil
        
        if exerciseType == "reps" && addPr && addRepPrSelection == "1RM" {
            prType = "onerepmax"
        }
        
        else if exerciseType == "reps" && addPr && addRepPrSelection == "AMRAP" {
            prType = "maxreps"
        }
        
        else if exerciseType == "time" && addPr {
            prType = "timemax"
        }
        
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
        
        let threshold = SetThreshold(
            viewContext,
            templateSet: selectedTemplateSet!,
            triggeredAt: Double(triggerQuantity)!,
            generatesPr: addPr,
            prType: prType,
            flatLoadAdd: inputFlatLoadAdd,
            flatQuantityAdd: inputFlatQuantityAdd
        )
        
        selectedTemplateSet!.addToThresholds(threshold)
        
        self.safeSave(viewContext: viewContext)
        
    }
        
}
