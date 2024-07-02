//
//  SearchBar.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-06-19.
//

import SwiftUI
import CoreData

struct SearchBar<T: NSManagedObject>: View {
    
    let searchAttribute: String
    @Binding var searchText: String
    @FetchRequest var fetchRequest: FetchedResults<T>
    
    var body: some View {
        
        var initialPredicate: NSPredicate?
        
        TextField("Search...",
                  text: $searchText)
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                .padding(.horizontal, 20)
                .onDisappear(perform: { searchText = "" })
                .onAppear(perform: {
                    // Save the initial predicate
                    initialPredicate = fetchRequest.nsPredicate
                })
                .onChange(of: searchText, initial: true) {
                    // If search text isnt empty
                    if !searchText.isEmpty {
                        if fetchRequest.nsPredicate is NSCompoundPredicate {
                            /* If the predicate is a compound predicate add the search predicate instead
                            of replaceing it
                            MARK: IF YOU WANT TO USE ANY OTHER PREDICATE TOGETHER WITH THE SEARCH PREDICATE YOU NEED
                            MARK: TO MAKE THE INITIAL PREDICATE OF THE FETCHREQUEST INTO A COMPOUND PREDICATE*/
                            let compoundPredicate = fetchRequest.nsPredicate as! NSCompoundPredicate
                            var predicates: [NSPredicate] = compoundPredicate.subpredicates as! [NSPredicate]
                            predicates.append(NSPredicate(format: "\(searchAttribute) CONTAINS[c] %@", searchText))
                        } else {
                            // else replace with search predicate
                            fetchRequest.nsPredicate = NSPredicate(format: "\(searchAttribute) CONTAINS[c] %@", searchText)
                        }
                    } else {
                        fetchRequest.nsPredicate = initialPredicate
                    }
                }
    }
}
