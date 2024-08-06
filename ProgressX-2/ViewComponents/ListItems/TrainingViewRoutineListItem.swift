//
//  BasicRoutineListItem.swift
//  ProgressX-2
//
//  Created by lucas häyhänen on 2024-07-17.
//

import SwiftUI
import CoreData

struct TrainingViewRoutineListItem: View {
    
    @Binding var navPath: [Int]
    @Binding var selectedRoutine: Routine?
    @ObservedObject var routine: Routine
    
    var body: some View {
        
        HStack {
            
            VStack(alignment: .leading) {
                
                Text(routine.timePeriodName ?? "")
                
                (Text("Created: ")
                    .fontWeight(.bold)
                 + Text("\(routine.creationDateString ?? "")"))
                .lineLimit(1)
                .minimumScaleFactor(0.6)
                
                (Text("Completed cycles: ")
                    .fontWeight(.bold)
                 + Text("\(routine.completedCycles!.count)"))
                .lineLimit(1)
                .minimumScaleFactor(0.6)
                
                (Text("Weeks: ")
                    .fontWeight(.bold)
                 + Text("\(routine.weeksInRoutine.count)"))
                .lineLimit(1)
                .minimumScaleFactor(0.6)
                
            }
            .frame(width: 135, height: 55, alignment: .leading)
            .padding(.vertical, 10)
            
            Spacer()
            
            Button(action: {
                selectedRoutine = routine
                navPath.append(1)
            }) { Image(systemName: "calendar") }
                .frame(width: 20)
                .padding(.horizontal, 10)
                .buttonStyle(BorderlessButtonStyle())
            
            Button(action: {
                selectedRoutine = routine
                navPath.append(2)
            }) { Image(systemName: "figure.run" ) }
                .frame(width: 20)
                .padding(.horizontal, 10)
                .buttonStyle(BorderlessButtonStyle())}
    }
}
