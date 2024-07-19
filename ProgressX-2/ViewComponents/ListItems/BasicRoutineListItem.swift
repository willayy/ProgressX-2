//
//  BasicRoutineListItem.swift
//  ProgressX-2
//
//  Created by lucas häyhänen on 2024-07-17.
//

import SwiftUI

struct BasicRoutineListItem: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var navPath: [Int]
    @Binding var selectedRoutine: Routine?
    @Binding var selectedTrainingCycle: TrainingCycle?
    @State private var showDeleteAlert: Bool = false
    @ObservedObject var routine: Routine
    
    var body: some View {
        
        HStack {
            
            VStack(alignment: .leading) {
                
                Text(routine.timePeriodName ?? "")
                
                (Text("Created: ")
                    .fontWeight(.bold)
                 + Text("\(routine.creationDateString!)"))
                .lineLimit(1)
                .minimumScaleFactor(0.6)
                
                (Text("Completed cycles: ")
                    .fontWeight(.bold)
                 + Text("\(routine.completedCycles.count)"))
                .lineLimit(1)
                .minimumScaleFactor(0.6)
                
                (Text("Weeks: ")
                    .fontWeight(.bold)
                 + Text("\(routine.templateCycle?.templateWeeks?.count ?? 0)"))
                .lineLimit(1)
                .minimumScaleFactor(0.6)
                
                Button {
                    
                } label: {
                    Text("Start workout")
                }
        
            }
            .frame(width: 135, height: 55)
            .padding(.vertical, 10)
            
            Spacer()
        }
    }
}
