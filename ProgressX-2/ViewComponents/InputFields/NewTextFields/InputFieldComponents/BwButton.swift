//
//  BwButton.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-10-07.
//

import SwiftUI

struct BwButton: View {
        
    @Environment(\.managedObjectContext) private var viewContext
    
    @Binding public var text: String
    
    var body: some View {
            
            Button {
                
                let latestBodyEntry = CoreDataAccess.getLatestBodyEntry(viewContext)!
                
                let latestBodyWeight = String(format: "%.2f", latestBodyEntry.bodyWeight)
                
                if latestBodyWeight == text {
                    
                    text = ""
                    
                } else {
                    
                    text = latestBodyWeight
                    
                }
                
            } label: {
                
                Text("BW")
                
            }
            .buttonStyle(BorderedProminentButtonStyle())
            .foregroundColor(Color("buttonTextColor"))
        
    }
}
