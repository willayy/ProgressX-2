//
//  CreateNewProfileNavigationController.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-04.
//

import SwiftUI

struct CreateNewProfileNavigationController<Content: View>: View {
    
    private var content: Content
    @EnvironmentObject var viewRouter: ViewRouter
    @Binding var navPath: [Int]
    
    init(navPath: Binding<[Int]>, @ViewBuilder content: () -> Content) {
        self._navPath = navPath
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
                        
                        CreateNewProfile2View(navPath: $navPath)
                        
                    } else if selection == 2 {
                        
                        CreateNewProfile3View(navPath: $navPath)
                        
                    } else if selection == 3 {
                        
                        CreateNewProfile4View(navPath: $navPath)
                    }
                }
                
            }
            
        }
        
    }
    
}

