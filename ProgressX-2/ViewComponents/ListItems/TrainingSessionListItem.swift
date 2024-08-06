//
//  TrainingSessionListItem.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-08-05.
//

import SwiftUI

struct TrainingSessionListItem: View {
    
    @Binding var navPath: [Int]
    @Binding var selectedTrainingSession: TrainingSession?
    @Binding var currentTrainingSet: TrainingSet?
    @ObservedObject var trainingSession: TrainingSession
    
    var body: some View {
        
        HStack {
            
            VStack(alignment: .leading) {
                
                Text(trainingSession.timePeriodName ?? "")
                
                (Text("Sets: ")
                    .fontWeight(.bold)
                 + Text("\(trainingSession.trainingSets?.count ?? 0)"))
                .lineLimit(1)
                .minimumScaleFactor(0.6)
        
            }
            .frame(width: 135, height: 20, alignment: .leading)
            .padding(.vertical, 10)
            
            Spacer()
            
            // MARK: Edit button
            Button(action: {
                selectedTrainingSession = trainingSession
                currentTrainingSet = selectedTrainingSession!.getNextSet()
                navPath.append(2)
            }) { Image(systemName: "figure.run") }
                .frame(width: 20)
                .padding(.horizontal, 10)
                .buttonStyle(BorderlessButtonStyle())
        }
    }
}
