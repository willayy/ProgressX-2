//
//  DefaultValueViewModel.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-08-02.
//

import Foundation

protocol DefaultValueViewModel {
    
    associatedtype T
    
    func setViewStartValues(entity: T)
    
}
