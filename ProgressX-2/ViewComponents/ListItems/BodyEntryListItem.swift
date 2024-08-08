//
//  BodyEntryListItem.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-18.
//

import SwiftUI

struct BodyEntryListItem: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    public let bodyEntry: BodyEntry
    @Binding var selectedBodyEntry: BodyEntry?
    @Binding var navPath: [Int]
    @State private var showDeleteAlert: Bool = false
    @State private var showMagnifiedView: Bool = false
    
    var body: some View {
        
        VStack(alignment: .leading, content: {
            
            VStack(alignment: .leading, content: {
                
                Text("Weigh-in done at \(bodyEntry.dateString ?? "")")
                
                (Text("Bodyweight: ")
                    .fontWeight(.bold)
                 + Text("\(bodyEntry.bodyWeightString ?? "")"))
                .lineLimit(1)
                .minimumScaleFactor(0.6)
                
            })
            .frame(width: 250, height: 45, alignment: .leading)
            .padding(.vertical, 10)
            .sheet(isPresented: $showMagnifiedView) {
                MagnifiedBodyEntryView(bodyEntry: bodyEntry)
                    .presentationDetents([.fraction(0.3)])
            }
                        
            HStack {
                
                // MARK: Magnify button
                Button(action: {
                    showMagnifiedView = true
                }) { Image(systemName: "plus.magnifyingglass") }
                    .frame(width: 20)
                    .padding(.horizontal, 10)
                    .buttonStyle(BorderlessButtonStyle())
                
                Spacer()
                
                // MARK: Edit button
                Button(action: {
                    selectedBodyEntry = bodyEntry
                    navPath.append(3)
                }) { Image(systemName: "pencil") }
                    .frame(width: 20)
                    .padding(.horizontal, 10)
                    .buttonStyle(BorderlessButtonStyle())
                
                Spacer()
                
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
                            message: Text("Are you sure you want to delete weigh-in done at \(bodyEntry.dateString!)?"),
                            primaryButton: .destructive(Text("Delete")) {
                                PersistenceController.delete(viewContext, object: bodyEntry)
                                PersistenceController.save(viewContext)
                            },
                            secondaryButton: .cancel()
                        )
                    })
            }
            .padding(.horizontal, 10)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
        })
    }
}

