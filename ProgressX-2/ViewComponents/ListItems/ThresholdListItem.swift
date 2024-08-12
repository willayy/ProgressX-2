//
//  ThresholdListItem.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-01.
//

import SwiftUI

struct ThresholdListItem: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var navPath: [Int]
    @Binding var selectedThreshold: SetThreshold?
    @State private var showDeleteAlert: Bool = false
    @State private var showMagnifiedView: Bool = false
    let threshold: SetThreshold
    
    var body: some View {
        
        VStack(alignment: .leading, content: {
            HStack {
                VStack(alignment: .leading) {
                    
                    Text("Threshold \(threshold.positionIndex)")
                    
                    (Text("Triggered at: ")
                        .fontWeight(.bold)
                     + Text("\(threshold.formattedTriggerQuantity ?? "")"))
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)
                    
                    (Text("Generates PR: ")
                        .fontWeight(.bold)
                     + Text("\(String(threshold.generatePr))"))
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)
                    
                }
                .frame(width: 155, height: 45, alignment: .leading)
                .padding(.vertical, 10)
                .sheet(isPresented: $showMagnifiedView) {
                    MagnifiedThresholdView(threshold: threshold)
                        .presentationDetents([.fraction(0.3)])
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
                    selectedThreshold = threshold
                    navPath.append(10)
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
                            message: Text("Are you sure you want to delete Threshold \(threshold.positionIndex)?"),
                            primaryButton: .destructive(Text("Delete")) {
                                PersistenceController.delete(viewContext, object: threshold)
                                PersistenceController.save(viewContext)
                            },
                            secondaryButton: .cancel()
                        )
                    })
            }
        })
        .frame(width: 300, height: 90)
    }
}

