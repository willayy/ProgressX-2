//
//  HomeViewNavigationController.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-17.
//

import SwiftUI

struct HomeViewNavigationController: View {
    
    @State private var navPath: [Int] = [Int]()
    
    @State private var selectedProfile: Profile? = nil
    
    @State private var selectedBodyEntry: BodyEntry? = nil
    
    var body: some View {
        
        NavigationStack(path: $navPath) {
            
            InputFieldForm {
                
                VStack {
                    
                    // MARK: The root view of the Home hierarchy
                    HomeView(
                        navPath: $navPath
                    )
                    
                }
                .navigationDestination(for: Int.self) { selection in
                    if selection == 1 {
                        
                        //MARK: WeighInView
                        WeighInView(
                            navPath: $navPath
                        )
                        
                    } else if selection == 2 {
                        
                        //MARK: View bodyEntries
                        ViewAllWeighInsView(
                            selectedBodyEntry: $selectedBodyEntry,
                            navPath: $navPath
                        )
                        
                    } else if selection == 3 {
                        
                        //MARK: Edit bodyEntry
                        EditWeighInView(
                            selectedBodyEntry: $selectedBodyEntry
                        )
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
}
