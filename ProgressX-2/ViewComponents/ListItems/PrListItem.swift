//
//  OneRepMaxListItem.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-06-02.
//

import SwiftUI

// PersonalRecord list item inteded to be used combined with a dynamic list that fetches the correct PR's for a given exercise.
struct PrListItem: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    // Access to the parents navigationstack.
    @Binding var navPath: [Int]
    @Binding var editingPr: PersonalRecord?
    @State private var showDeleteAlert: Bool = false
    @ObservedObject var pr: PersonalRecord
    
    var body: some View {
        
        let weightUnit = PersistenceController.getWeightUnit(viewContext)!
        
        HStack {
            VStack(alignment: .leading) {
                (Text("Type: ")
                    .fontWeight(.bold)
                + Text("\(pr.typeString())"))
                .minimumScaleFactor(0.6)
                
                (Text("Date: ")
                    .fontWeight(.bold)
                 + (Text("\(pr.dateString() ?? "")")))
                .minimumScaleFactor(0.6)
                
                (Text("Load: ")
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                 + (Text("\(pr.loadString()) \(weightUnit) ")))
                .minimumScaleFactor(0.6)
                
                (Text("Quantity: ")
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                + Text("\(pr.quantityString()) \(pr.quantityUnitString())"))
                .minimumScaleFactor(0.6)
            }
            .frame(width: 135, height: 20)
            .padding(.vertical, 10)
            
            Spacer()
            
            Button(action: {
                editingPr = pr
                navPath.append(4)
            }) { Image(systemName: "pencil") }
                .frame(width: 20)
                .padding(.horizontal, 10)
                .buttonStyle(BorderlessButtonStyle())
            
            Button(action: {
                showDeleteAlert = true
            }) { Image(systemName: "trash") }
                .frame(width: 20)
                .padding(.horizontal, 10)
                .buttonStyle(BorderlessButtonStyle())
                .alert(isPresented: $showDeleteAlert, content: {
                    Alert(
                        title: Text("Delete PR"),
                        message: Text("Are you sure you want to delete this Pr?"),
                        primaryButton: .destructive(Text("Delete")) {
                            PersistenceController.delete(viewContext, object: pr)
                            PersistenceController.save(viewContext)
                        },
                        secondaryButton: .cancel()
                    )
                })
        }
    }
}
