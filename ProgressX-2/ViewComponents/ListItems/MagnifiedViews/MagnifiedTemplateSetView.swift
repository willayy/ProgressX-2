//
//  MagnifiedTemplateSetView.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-01.
//

import SwiftUI

struct MagnifiedTemplateSetView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    let set: TemplateSet
    
    var body: some View {
        
        VStack(alignment: .leading, content: {
            
            Text("Name: ").fontWeight(.bold) + Text(set.timePeriodName ?? "")
            
            (
                Text("Description: ")
                .fontWeight(.bold)
                .font(.subheadline) +
                Text(set.timePeriodDescription ?? "")
                .font(.subheadline)
            )
                .padding(.bottom, 10)
            
            (Text("Exercise: ")
                .fontWeight(.bold)
             + Text("\(set.setExerciseName!)"))
            .lineLimit(1)
            .minimumScaleFactor(0.6)
            
            (Text("Quantity: ")
                .fontWeight(.bold)
             + Text("\(set.quantityTodoString)"))
            .lineLimit(1)
            .minimumScaleFactor(0.6)
            
            (Text("Load: ")
                .fontWeight(.bold)
             + Text("\(set.loadTodoString)"))
            .lineLimit(1)
            .minimumScaleFactor(0.6)
            
            (Text("Thresholds: ")
                .fontWeight(.bold)
             + Text("\(set.thresholds?.count ?? 0)"))
            .lineLimit(1)
            .minimumScaleFactor(0.6)
            
            #warning("TODO: Add Threshold information here aswell")
            
        })
    }
}
