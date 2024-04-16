//
//  NewProfileView1.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-04-12.
//

import SwiftUI
import CoreData

struct CreateNewProfile1: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        NavigationView {
            
            VStack(alignment: .center) {
                
                Text("Create profile")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color.gray)
                    .multilineTextAlignment(.center);
                
                Text("To use ProgressX you need to create a profile, this profile and all its data will be stored locally only")
                    .font(.subheadline)
                    .fontWeight(.light)
                    .foregroundColor(Color.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30.0);
            }
        }
    }
}

#Preview {
    CreateNewProfile1()
}
