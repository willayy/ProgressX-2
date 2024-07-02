//
//  SetListItem.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-06-21.
//

import SwiftUI

struct TemplateSetListItem: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var navPath: [Int]
    @Binding var selectedTemplateSet: TemplateSet?
    @State private var showDeleteAlert: Bool = false
    @State private var showMagnifiedView: Bool = false
    @ObservedObject var set: TemplateSet
    
    var body: some View {
        
        let weightUnit: String = PersistenceController.getWeightUnit(viewContext)!
        
        HStack {
            VStack(alignment: .leading) {
                
                Text(set.timePeriodName ?? "")
                
                (Text("Exercise: ")
                    .fontWeight(.bold)
                 + Text("\(set.setExerciseName!)"))
                .lineLimit(1)
                .minimumScaleFactor(0.6)
                
                (Text("Quantity: ")
                    .fontWeight(.bold)
                 + Text("\(set.quantityTodoString) \(set.quantityUnit)"))
                .lineLimit(1)
                .minimumScaleFactor(0.6)
                
                (Text("Load: ")
                    .fontWeight(.bold)
                 + Text("\(set.loadTodoString) \(weightUnit)"))
                .lineLimit(1)
                .minimumScaleFactor(0.6)
                
                (Text("Thresholds: ")
                    .fontWeight(.bold)
                 + Text("\(set.thresholds?.count ?? 0)"))
                .lineLimit(1)
                .minimumScaleFactor(0.6)
                
            }
            .frame(width: 155, height: 45)
            .padding(.vertical, 10)
            .sheet(isPresented: $showMagnifiedView) {
                MagnifiedTemplateSetView(set: set)
                    .presentationDetents([.fraction(0.3)])
                    .environment(\.managedObjectContext, viewContext)
            }
            
            Spacer()
            
            // MARK: Magnify button
            Button(action: {
                showMagnifiedView = true
            }) { Image(systemName: "plus.magnifyingglass") }
                .frame(width: 20)
                .padding(.horizontal, 10)
                .buttonStyle(BorderlessButtonStyle())
            
            // MARK: Edit button
            Button(action: {
                selectedTemplateSet = set
                navPath.append(6)
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
                        message: Text("Are you sure you want to delete \(set.timePeriodName!)?"),
                        primaryButton: .destructive(Text("Delete")) {
                            PersistenceController.delete(viewContext, object: set)
                            PersistenceController.save(viewContext)
                        },
                        secondaryButton: .cancel()
                    )
                })
        }
    }
}
