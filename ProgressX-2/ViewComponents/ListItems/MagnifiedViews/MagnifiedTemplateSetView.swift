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
        
        let weightUnit: String = PersistenceController.getWeightUnit(viewContext)!
        
        VStack(alignment: .leading, content: {
            
            Text(set.timePeriodName ?? "")
            
            (Text("Exercise: ")
                .fontWeight(.bold)
             + Text("\(set.setExerciseName!)"))
            .lineLimit(1)
            .minimumScaleFactor(0.6)
            
            (Text("Quantity: ")
                .fontWeight(.bold)
             + Text("\(set.quantityTodoString) \(set.quantityUnit)"))
            .lineLimit(1)
            .minimumScaleFactor(0.6)
            
            (Text("Load: ")
                .fontWeight(.bold)
             + Text("\(set.loadTodoString) \(weightUnit)"))
            .lineLimit(1)
            .minimumScaleFactor(0.6)
            
            (Text("Thresholds: ")
                .fontWeight(.bold)
             + Text("\(set.thresholds?.count ?? 0)"))
            .lineLimit(1)
            .minimumScaleFactor(0.6)
            
        })
    }
}
