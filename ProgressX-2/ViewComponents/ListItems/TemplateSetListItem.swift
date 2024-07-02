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
    @Binding var selectedSet: TrainingSet
    @State var showDeleteAlert: Bool = false
    @ObservedObject var set: TrainingSet
    
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
                
                (Text("PR set?: ")
                    .fontWeight(.bold)
                 + Text("\(String(set.prGeneratingSet))"))
                .lineLimit(1)
                .minimumScaleFactor(0.6)
                
                (Text("Progression set?: ")
                    .fontWeight(.bold)
                 + Text("\(String(set.progressingSet))"))
                .lineLimit(1)
                .minimumScaleFactor(0.6)
        
            }
            .frame(width: 135, height: 35)
            .padding(.vertical, 10)
            
            Spacer()
            
            // MARK: Edit button
            Button(action: {
                selectedSet = set
                navPath.append(7)
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
