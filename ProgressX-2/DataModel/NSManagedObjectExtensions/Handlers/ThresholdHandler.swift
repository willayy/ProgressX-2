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
        
        // sort in ascending order by upperBound value.
        self.thresholds = thresholds.sorted { $0.upperBound < $1.upperBound}
        
    }
    
    /// Handels the triggering of the thresholds in a set.
    internal func handleThresholds(quantityDone: Double, loadDone: Double) -> Void {
        
        let triggeredThreshold = thresholds.first {
            
            $0.isTriggered(quantityDone: quantityDone)
            
        }
        
        triggeredThreshold?.addLoadModifiers()
        
        triggeredThreshold?.addQuantityModifiers()
        
        triggeredThreshold?.generatePersonalRecord(quantityDone: quantityDone, loadDone: loadDone)
                
    }
}
