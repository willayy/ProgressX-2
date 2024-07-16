//
//  RoutineListItem.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-06-19.
//

import SwiftUI

// Exercise list item inteded to be used combined with a search bar and a list
struct RoutineListItem: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var navPath: [Int]
    @Binding var selectedRoutine: Routine?
    @Binding var selectedTemplateCycle: TemplateCycle?
    @State private var showDeleteAlert: Bool = false
    @ObservedObject var routine: Routine
    
    var body: some View {
        
        HStack {
            
            VStack(alignment: .leading) {
                
                Text(routine.timePeriodName ?? "")
                
                (Text("Created: ")
                    .fontWeight(.bold)
                 + Text("\(routine.creationDateString)"))
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
        
            }
            .frame(width: 135, height: 55)
            .padding(.vertical, 10)
            
            Spacer()
            
            // MARK: Edit button
            Button(action: {
                selectedRoutine = routine
                selectedTemplateCycle = routine.templateCycle
                navPath.append(2)
            }) { Image(systemName: "pencil") }
                .frame(width: 20)
                .padding(.horizontal, 10)
                .buttonStyle(BorderlessButtonStyle())
            
            // MARK: Statistics button
            Button(action: {
                selectedRoutine = routine
                selectedTemplateCycle = routine.templateCycle
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
