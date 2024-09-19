//
//  SetHistoryListItem.swift
//  ProgressX-2
//
//  Created by lucas häyhänen on 2024-09-14.
//

import Foundation
import SwiftUI

struct SetHistoryListItem: View {
    
    @Binding var navPath: [Int]
    @Binding var selectedTrainingSet: TrainingSet?
    @ObservedObject var set: TrainingSet
    
    
    var body: some View {
        HStack{
            VStack(alignment: .leading) {
                
                Text("Set name: ")
                    .fontWeight(.bold)
                + Text(set.timePeriodName ?? "")
                
                Text("Position in session: ")
                    .fontWeight(.bold)
                + Text(String(set.positionIndex))
                
                (Text("Status: ")
                    .fontWeight(.bold)
                 + Text("\(status(set: set))"))
                .lineLimit(1)
                .minimumScaleFactor(0.6)
            }
            Spacer()
            
            Button(action: {
                selectedTrainingSet = set
                navPath.append(2)
            }) { Image(systemName: "align.vertical.bottom.fill") }
                .frame(width: 20)
                .padding(.horizontal, 10)
                .buttonStyle(BorderlessButtonStyle())
        }
    }
    
    
    public func status(set:TrainingSet) -> String {
        if  set.quantityDone > 0{
            return ("Completed " + String(Int(set.quantityDone)) + " out of " + String(Int(set.quantityTodo)) + " reps")
        } else {
            return "Skipped set"
        }
        
    }
}
