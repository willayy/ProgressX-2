//
//  ChangePropogator.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-08-29.
//

import Foundation

protocol IsChangePropogator {
    
    /// Propogates changes made in a template TimePeriod to all inComplete training TImePeriods.
    func propogateChanges() ->  Void
    
}
