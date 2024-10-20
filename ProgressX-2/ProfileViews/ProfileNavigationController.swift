//
//  ProfileNavigationController.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-26.
//

import SwiftUI

struct ProfileNavigationController: View {
        
    var body: some View {
        
        NavigationStack {
            
            InputFieldForm {
                
                VStack {
                    
                    ProfileView()
                    
                }
                    
            }
            
        }
        
    }
    
}
