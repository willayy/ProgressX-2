//
//  KeyValueList.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-09-21.
//

import Foundation

/// A list of keyvalue pairs represented by tuples, this is like an ordered dictinary without the speed of a dictionary.
class KeyValueList<K: Equatable,V>: Sequence {
    
    // Underlying datastructure
    private let keyValuePairs: [(K,V)]
    
    // Init making KVList immutable
    init(_ keyValuePairs: [(K,V)] = []) {
        
        self.keyValuePairs = keyValuePairs
        
    }
    
    // Sequence compliance
    func makeIterator() -> Array<(K,V)>.Iterator {
        return keyValuePairs.makeIterator()
    }
    
    // Keys accessor
    public var keys: [K] {
        
        return keyValuePairs.map { $0.0 }
        
    }
    
    // Values accessor
    public var values: [V] {
        
        return keyValuePairs.map { $0.1 }
        
    }
    
    // get method for key value pairs
    public func get(key: K) -> V? {
        
        let kvPair = keyValuePairs.first { $0.0 == key }
        
        return kvPair?.1
        
    }
    
}
