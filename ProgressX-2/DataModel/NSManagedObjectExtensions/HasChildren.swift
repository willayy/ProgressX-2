//
//  HasChildren.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-08-17.
//

import Foundation

protocol HasChildren {
    
    associatedtype ChildrenType
    
    var children: [ChildrenType] { get }
    
}
