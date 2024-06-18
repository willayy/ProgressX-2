//
//  Completable.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-06-17.
//

import Foundation

extension Completeable {
    
    @objc public func completionDateString() -> String? {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        
        if self.completedOnDate != nil {
            return df.string(from: self.completedOnDate!)
        }
        
        else {
            return nil
        }
    }
    
    public override func validateForInsert() throws {
        try super.validateForInsert()
        try validateIsComplete()
    }
    
    public override func validateForUpdate() throws {
        try super.validateForUpdate()
        try validateIsComplete()
    }
    
    private func validateIsComplete() throws {
        if self.isComplete && self.completedOnDate == nil {
            throw NSError(
                domain: "CoreDataErrorDomain",
                code: 9988,
                userInfo: [NSLocalizedDescriptionKey: "A Completable object can't be complete without a completionDate"]
            )
        }
    }
    
}
