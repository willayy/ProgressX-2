//
//  WeekListItem.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-06-20.
//

import SwiftUI

struct TemplateWeekListItem: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var navPath: [Int]
    @Binding var selectedWeek: TrainingWeek?
    @State var showDeleteAlert: Bool = false
    @ObservedObject var week: TrainingWeek
    
    var body: some View {
        
        HStack {
            VStack(alignment: .leading) {
                
                Text(week.timePeriodName ?? "")
                
                (Text("Sessions: ")
                    .fontWeight(.bold)
                 + Text("\(week.sessions?.count ?? 0)"))
                .lineLimit(1)
                .minimumScaleFactor(0.6)
        
            }
            .frame(width: 135, height: 20)
            .padding(.vertical, 10)
            
            Spacer()
            
            // MARK: Edit button
            Button(action: {
                selectedWeek = week
                navPath.append(5)
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
                        message: Text("Are you sure you want to delete \(week.timePeriodName!)?"),
                        primaryButton: .destructive(Text("Delete")) {
                            PersistenceController.delete(viewContext, object: week)
                            PersistenceController.save(viewContext)
                        },
                        secondaryButton: .cancel()
                    )
                })
        }
    }
}

