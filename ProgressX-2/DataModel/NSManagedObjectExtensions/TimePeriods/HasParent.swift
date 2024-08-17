//
//  HasParent.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-08-17.
//

import Foundation

protocol HasParent {
    
    associatedtype ParentType
    
    var parent: ParentType { get set }
    
}
