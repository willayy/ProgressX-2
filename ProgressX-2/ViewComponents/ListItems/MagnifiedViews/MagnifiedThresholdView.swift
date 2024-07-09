//
//  MagnifiedThresholdView.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-04.
//

import SwiftUI

struct MagnifiedThresholdView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @ObservedObject var threshold: SetThreshold
    
    var body: some View {
        VStack(alignment: .leading, content: {
            
            Text("Threshold number: ")
                .fontWeight(.bold) +
            Text(String(threshold.positionIndex))
            
            Text("trigger quantity: ")
                .fontWeight(.bold) +
            Text(threshold.triggerQuantityString)
            
            Text("Generates PR?: ")
                .fontWeight(.bold) +
            Text(String(threshold.generatePr))
            
            Text("PR type ")
                .fontWeight(.bold) +
            Text(threshold.prType!)
            
            Text("Flat load add: ")
                .fontWeight(.bold) +
            Text(String(threshold.flatLoadAddString))
            
            Text("Flat quantity add: ")
                .fontWeight(.bold) +
            Text(threshold.flatQuantityAddString)
            
        })
    }
}
