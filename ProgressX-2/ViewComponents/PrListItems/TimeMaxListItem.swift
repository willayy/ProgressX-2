//
//  TimeMaxListItem.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-06-02.
//

import SwiftUI

struct TimeMaxListItem: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var belongsTo: [PersonalRecord]
    @Binding var navPath: [Int]
    @Binding var editingPr: PersonalRecord?
    @State var loadString = ""
    @State var dateString = ""
    @State var timeString = ""
    @State var showDeleteAlert = false
    let typeString = "Timed"
    let pr: PersonalRecord
    
    var body: some View {
        
        let weightUnit = DataFetching.getProfile(viewContext)!.isMetric ? "kg's" : "lbs"
        
        HStack {
            VStack(alignment: .leading) {
                Text("Type: ")
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                + Text("\(typeString)")
                
                Text("Date: ")
                    .fontWeight(.bold)
                + Text("\(dateString)")
                
                Text("Load: ")
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                + Text("\(loadString) \(weightUnit) ")
                
                Text("Time: ")
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                + Text("\(timeString) s")
            }
            .onAppear(perform: {
                loadString = String(format: "%.2f", pr.load)
                timeString = String(format: "%.2f", (pr as! TimeMax).time)
                dateString = DataUtility.formatDate(date: pr.achievedOnDate!)
            })
            
            Spacer()
            
            Button(action: {
                editingPr = pr
                navPath.append(5)
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
                            DataFetching.deleteNSManagedObject(viewContext, object: pr)
                            belongsTo.removeAll(where: { $0 === pr })
                            DataFetching.save(viewContext)
                        },
                        secondaryButton: .cancel()
                    )
                })
        }
    }
    
}
