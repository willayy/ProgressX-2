//
//  Achievement.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-06-14.
//

import Foundation

extension Achievement {
    
    //MARK: Extra properties
    
    /// Formatted Date-string in format "yyyy-MM-dd"  from PR
    public var dateString: String? {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        
        if self.achievedOnDate != nil {
            return df.string(from: self.achievedOnDate!)
        }
        
        else {
            return nil
        }
    }
    
}
