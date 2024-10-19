//
//  StartWorkoutViewModel.swift
//  ProgressX-2
//
//  Created by lucas häyhänen on 2024-07-17.
//

import Foundation

class StartWorkoutViewModel: ObservableObject {
    
    @Published var exercise: Exercise?
    @Published var searchText: String = ""
    @Published public var showMenu: Bool = false
    
}
