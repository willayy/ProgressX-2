//
//  RACList.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-06-20.
//

import SwiftUI
import CoreData

// This is a list that takes a randomAccessCollection as an argument
struct SearchableRACList<T: NSManagedObject, Content: View>: View where T: Identifiable {
    
    @FetchRequest var allData: FetchedResults<T>
    @FetchRequest var searchedData: FetchedResults<T>
    let content: (FetchedResults<T>.Element) -> Content

    var body: some View {
        if allData.isEmpty {
            Text("You currently have no routines saved to the routine library...")
                .font(.subheadline)
                .fontWeight(.light)
                .padding(.vertical, 20)
                .foregroundStyle(.red)
        } else if searchedData.isEmpty {
            LightSubHeadline(text: "No Routines matched your search...")
                .padding(.vertical, 20)
        } else {
            List{
                ForEach(searchedData) { item in
                    content(item)
                }
            }
            .frame(height: 400)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .padding(.horizontal, 20)
        }
    }
}


