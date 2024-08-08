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
            .frame(width: 200, height: 20, alignment: .leading)
            .padding(.vertical, 10)
            
            Spacer()
            
            if !trainingSession.isComplete {
                
                // MARK: Edit button
                Button(action: {
                    selectedTrainingSession = trainingSession
                    currentTrainingSet = selectedTrainingSession!.getNextTrainingSet()
                    navPath.append(2)
                }) { Image(systemName: "figure.run") }
                    .frame(width: 20)
                    .padding(.horizontal, 10)
                    .buttonStyle(BorderlessButtonStyle())
            
            } else {
                
                Image(systemName: "checkmark.seal.fill")
                    .frame(width: 20)
                    .padding(.horizontal, 10)
                    .foregroundStyle(.green)
                
            }
        }
    }
}
