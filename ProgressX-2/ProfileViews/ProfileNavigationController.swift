//
//  ProfileNavigationController.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-26.
//

import SwiftUI

struct ProfileNavigationController<Content: View>: View {
    
    private var content: Content
    
    init(@ViewBuilder content: () -> Content) {
        
        self.content = content()
        
    }
    
    var body: some View {
        
        NavigationStack {
            
            InputFieldForm {
                
                content
                
            }
            
        }
        
    }
    
}
