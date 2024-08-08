//
//  MagnifiedTemplateSetView.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-01.
//

import SwiftUI

struct MagnifiedTemplateSetView: View {
    
    @ObservedObject var set: TemplateSet
    @Binding var navPath: [Int]
    @Binding var selectedThreshold: SetThreshold?
    
    var body: some View {
        
        @FetchRequest(
            entity: SetThreshold.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \SetThreshold.triggerQuantity, ascending: true)],
            predicate: NSPredicate(format: "templateSet == %@", set)
        ) var thresholds: FetchedResults<SetThreshold>
        
        VStack(alignment: .leading, content: {
            
            Text("Name: ").fontWeight(.bold) + Text(set.timePeriodName ?? "")
            
            (
                Text("Description: ")
                    .fontWeight(.bold)
                    .font(.subheadline) +
                Text(set.timePeriodDescription ?? "")
                    .font(.subheadline)
            )
            
            (Text("Exercise: ")
                .fontWeight(.bold)
             + Text("\(set.setExerciseName!)"))
            .lineLimit(1)
            .minimumScaleFactor(0.6)
            
            (Text("Quantity: ")
                .fontWeight(.bold)
             + Text("\(set.setQuantityString!)"))
            .lineLimit(1)
            .minimumScaleFactor(0.6)
            
            (Text("Load: ")
                .fontWeight(.bold)
             + Text("\(set.setLoadString!)"))
            .lineLimit(1)
            .minimumScaleFactor(0.6)
            
            (Text("Thresholds: ")
                .fontWeight(.bold)
             + Text("\(set.thresholds?.count ?? 0)"))
            .lineLimit(1)
            .minimumScaleFactor(0.6)
        })
        
        BasicList(
            height: 200,
            containerName: "this set",
            elementName: "thresholds",
            data: _thresholds) { 
                threshold in
                ThresholdListItem(
                    navPath: $navPath,
                    selectedThreshold: $selectedThreshold,
                    threshold: threshold
                )
            }
            .padding(.horizontal, 20)
    }
}
