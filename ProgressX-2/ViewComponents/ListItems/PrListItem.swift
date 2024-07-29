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
    @Binding var navPath: [Int]
    @Binding var editingPr: PersonalRecord?
    @State private var showDeleteAlert: Bool = false
    @State private var showMagnifiedView: Bool = false
    @ObservedObject var pr: PersonalRecord
    
    var body: some View {
        
        VStack(alignment: .leading, content: {
            HStack {
                VStack(alignment: .leading) {
                    (Text("Type: ")
                        .fontWeight(.bold)
                     + Text("\(pr.typeString!)"))
                    .minimumScaleFactor(0.6)
                    
                    (Text("Date: ")
                        .fontWeight(.bold)
                     + (Text("\(pr.dateString ?? "")")))
                    .minimumScaleFactor(0.6)
                    
                    (Text("Load: ")
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                     + (Text("\(pr.loadString!)")))
                    .minimumScaleFactor(0.6)
                    
                    (Text("Quantity: ")
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                     + Text("\(pr.quantityString!)"))
                    .minimumScaleFactor(0.6)
                }
                .frame(width: 135, height: 30)
                .padding(.vertical, 10)
                .sheet(isPresented: $showMagnifiedView) {
                    MagnifiedPrView(personalRecord: pr)
                        .presentationDetents([.fraction(0.3)])
                }
                
                Spacer()
                
                Button(action: {
                    showMagnifiedView = true
                }) { Image(systemName: "plus.magnifyingglass") }
                    .frame(width: 20)
                    .padding(.horizontal, 10)
                    .buttonStyle(BorderlessButtonStyle())
                
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
        })
        .frame(width: 300, height: 70)
    }
}
