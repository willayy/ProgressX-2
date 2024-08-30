//
//  TriggerHandler.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-08-28.
//

import Foundation

/// Class that handles triggering of thresholds
internal class ThresholdHandler {
    
    private var thresholds: [SetThreshold]
    
    internal init(thresholds: [SetThreshold]) {
        self.thresholds = thresholds
    }
    
    internal func handleThresholds(quantityDone: Double, loadDone: Double) -> Void {
        
        /* Personal record generation, only the threshold with the largest
         trigger quantity gets to generate a PR if it exists */
        let triggeredThresholds = thresholds.filter {
            
            $0.isTriggered(quantityDone: quantityDone)
            
        }
        
        // Sort so the lowest triggerquantity is first, also use trigger thresholds.
        let highestTriggeredThreshold = triggeredThresholds.max {
            
            $0.triggerQuantity < $1.triggerQuantity
            
        }
        
        highestTriggeredThreshold?.addLoadModifiers()
        
        highestTriggeredThreshold?.addQuantityModifiers()
        
        highestTriggeredThreshold?.generatePersonalRecord(quantityDone: quantityDone, loadDone: loadDone)
        
    }
}
