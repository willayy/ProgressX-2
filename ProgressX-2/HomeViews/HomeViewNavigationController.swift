//
//  HomeViewNavigationController.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-17.
//

import SwiftUI

struct HomeViewNavigationController<Content: View>: View {
    
    private var content: Content
    @Binding var navPath: [Int]
    @Binding var profile: Profile?
    @Binding var selectedBodyEntry: BodyEntry?
    
    init(
        navPath: Binding<[Int]>,
        profile: Binding<Profile?>,
        selectedBodyEntry: Binding<BodyEntry?>,
        @ViewBuilder content: () -> Content
    ) {
        self._navPath = navPath
        self._profile = profile
        self._selectedBodyEntry = selectedBodyEntry
        self.content = content()
    }
    
    var body: some View {
        
        NavigationStack(path: $navPath) {
            
            InputFieldForm {
                
                VStack {
                    content
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
