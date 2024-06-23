//
//  CycleListItem.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-06-23.
//

import SwiftUI

struct CycleListItem: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var navPath: [Int]
    @Binding var selectedCycle: Cycle?
    @State var showDeleteAlert: Bool = false
    @ObservedObject var cycle: Cycle
    
    var body: some View {
        
        let completetionColor = cycle.isComplete ? Color.green : Color.red
        
        HStack {
            VStack(alignment: .leading) {
                
                Text(cycle.timePeriodName ?? "")
                
                (Text("Weeks: ")
                    .fontWeight(.bold)
                 + Text("\(cycle.weeks?.count ?? 0)"))
                .lineLimit(1)
                .minimumScaleFactor(0.6)
                
                (Text("Complete: ")
                    .fontWeight(.bold)
                 + Text("\(cycle.isComplete ? "true" : "false")")
                    .foregroundStyle(completetionColor))
                .lineLimit(1)
                .minimumScaleFactor(0.6)
                
                
            }
            .frame(width: 135, height: 20)
            .padding(.vertical, 10)
            
            Spacer()
            
            // MARK: Edit button
            Button(action: {
                selectedCycle = cycle
                navPath.append(4)
            }) { Image(systemName: "pencil") }
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
                        message: Text("Are you sure you want to delete \(cycle.timePeriodName!)?"),
                        primaryButton: .destructive(Text("Delete")) {
                            PersistenceController.delete(viewContext, object: cycle)
                            PersistenceController.save(viewContext)
                        },
                        secondaryButton: .cancel()
                    )
                })
        }
    }
}
