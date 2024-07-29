//
//  HomeViewModel.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-17.
//

import Foundation

class HomeViewModel: ObservableObject {
    
    @Published public var navPath: [Int] = [Int]()
    @Published public var selectedProfile: Profile? = nil
    @Published public var selectedBodyEntry: BodyEntry? = nil
    
}
