//
//  MagnifiedPrView.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-05.
//

import SwiftUI

struct MagnifiedPrView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @ObservedObject var personalRecord: PersonalRecord
    
    var body: some View {
        VStack(alignment: .leading, content: {
            
            (Text("Type: ")
                .fontWeight(.bold)
            + Text("\(personalRecord.typeString!)"))
            .minimumScaleFactor(0.6)
            
            (Text("Date: ")
                .fontWeight(.bold)
             + (Text("\(personalRecord.dateString ?? "")")))
            .minimumScaleFactor(0.6)
            
            (Text("Load: ")
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
             + (Text("\(personalRecord.loadString!)")))
            .minimumScaleFactor(0.6)
            
            (Text("Quantity: ")
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
            + Text("\(personalRecord.quantityString!)"))
            .minimumScaleFactor(0.6)
            
        })
    }
}
