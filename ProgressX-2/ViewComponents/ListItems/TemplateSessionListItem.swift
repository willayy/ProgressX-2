//
//  SessionListItem.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-06-21.
//

import SwiftUI

struct TemplateSessionListItem: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var navPath: [Int]
    @Binding var selectedSession: Session
    @State var showDeleteAlert: Bool = false
    @ObservedObject var session: Session
    
    var body: some View {
        
        HStack {
            VStack(alignment: .leading) {
                
                Text(session.timePeriodName ?? "")
                
                (Text("Sets: ")
                    .fontWeight(.bold)
                 + Text("\(session.sets?.count ?? 0)"))
                .lineLimit(1)
                .minimumScaleFactor(0.6)
        
            }
            .frame(width: 135, height: 20)
            .padding(.vertical, 10)
            
            Spacer()
            
            // MARK: Edit button
            Button(action: {
                selectedSession = session
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
                        message: Text("Are you sure you want to delete \(session.timePeriodName!)?"),
                        primaryButton: .destructive(Text("Delete")) {
                            PersistenceController.delete(viewContext, object: session)
                            PersistenceController.save(viewContext)
                        },
                        secondaryButton: .cancel()
                    )
                })
        }
    }
}
