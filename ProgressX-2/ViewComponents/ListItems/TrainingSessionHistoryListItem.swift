//
//  TrainingSessionHistoryListItem.swift
//  ProgressX-2
//
//  Created by lucas häyhänen on 2024-08-14.
//

import Foundation
import SwiftUI

struct TrainingSessionHistoryListItem: View {
    
    @Binding var navPath: [Int]
    @Binding var selectedTrainingSession: TrainingSession?
    @ObservedObject var session: TrainingSession
    
    var body: some View {
        HStack{
            VStack(alignment: .leading) {
                
                Text("Session name: ")
                    .fontWeight(.bold)
                + Text(session.timePeriodName ?? "")
                
                Text("Completion date: ")
                    .fontWeight(.bold)
                + Text(session.formattedCompletionDate ?? "")
                
                (Text("Sets: ")
                    .fontWeight(.bold)
                 + Text("\(session.trainingSets?.count ?? 0)"))
                .lineLimit(1)
                .minimumScaleFactor(0.6)
            }
            
            Spacer()
            
            Button(action: {
                selectedTrainingSession = session
                navPath.append(1)
            }) { Image(systemName: "calendar.badge.checkmark") }
                .frame(width: 20)
                .padding(.horizontal, 10)
                .buttonStyle(BorderlessButtonStyle())
        }
        
    }
    
}
