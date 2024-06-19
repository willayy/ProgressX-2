//
//  RoutineListItem.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-06-19.
//

import SwiftUI

struct RoutineListItem: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var navPath: [Int]
    @Binding var selectedRoutine: Routine?
    @State private var showDeleteAlert: Bool = false
    @ObservedObject var routine: Routine
    
    var body: some View {
        HStack {
            
            VStack {
                Text(routine.timePeriodName ?? "")
                (Text("Completed cycles: ")
                    .fontWeight(.bold)
                 + Text("\(routine.finishedCycles)"))
                .lineLimit(1)
                .minimumScaleFactor(0.01)
            }
            
            Spacer()
            
            // MARK: Edit button
            Button(action: {
                selectedRoutine = routine
                navPath.append(2)
            }) { Image(systemName: "pencil") }
                .frame(width: 20)
                .padding(.horizontal, 10)
                .buttonStyle(BorderlessButtonStyle())
            
            // MARK: Statistics button
            Button(action: {
                selectedRoutine = routine
                navPath.append(3)
            }) { Image(systemName: "chart.xyaxis.line") }
                .frame(width: 20)
                .padding(.horizontal, 10)
                .buttonStyle(BorderlessButtonStyle())
            
            // MARK: Delete button
            Button(action: {
                showDeleteAlert = true
            }) { Image(systemName: "trash") }
                .frame(width: 20)
                .padding(.horizontal, 10)
                .buttonStyle(BorderlessButtonStyle())
                // Shows an alert box
                .alert(isPresented: $showDeleteAlert, content: {
                    Alert(
                        title: Text("Delete Item"),
                        message: Text("Are you sure you want to delete \(routine.timePeriodName!)?"),
                        primaryButton: .destructive(Text("Delete")) {
                            PersistenceController.delete(viewContext, object: routine)
                            PersistenceController.save(viewContext)
                        },
                        secondaryButton: .cancel()
                    )
                })
        }
    }
}
