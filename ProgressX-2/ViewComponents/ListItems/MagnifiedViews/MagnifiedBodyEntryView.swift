//
//  MagnifiedBodyEntryView.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-18.
//

import SwiftUI

struct MagnifiedBodyEntryView: View {
    
    public let bodyEntry: BodyEntry
    
    var body: some View {
        VStack(alignment: .leading, content: {
            
            (Text("Date: ")
                .fontWeight(.bold)
             + Text("\(bodyEntry.dateString!)"))
            .lineLimit(1)
            .minimumScaleFactor(0.6)
            
            (Text("Bodyweight: ")
                .fontWeight(.bold)
             + Text("\(bodyEntry.bodyWeightString!)"))
            .lineLimit(1)
            .minimumScaleFactor(0.6)
            
            (Text("Chest circumference: ")
                .fontWeight(.bold)
             + Text("\(bodyEntry.chestCircumferenceString!)"))
            .lineLimit(1)
            .minimumScaleFactor(0.6)
            
            (Text("Upper arm circumference: ")
                .fontWeight(.bold)
             + Text("\(bodyEntry.upperArmCircumferenceString!)"))
            .lineLimit(1)
            .minimumScaleFactor(0.6)
            
            (Text("Lower arm circumference: ")
                .fontWeight(.bold)
             + Text("\(bodyEntry.lowerArmCircumferenceString!)"))
            .lineLimit(1)
            .minimumScaleFactor(0.6)
            
            (Text("Waist circumference: ")
                .fontWeight(.bold)
             + Text("\(bodyEntry.waistCircumferenceString!)"))
            .lineLimit(1)
            .minimumScaleFactor(0.6)
            
            (Text("Thigh circumference: ")
                .fontWeight(.bold)
             + Text("\(bodyEntry.thighCircumferenceString!)"))
            .lineLimit(1)
            .minimumScaleFactor(0.6)
            
            (Text("Calf circumference: ")
                .fontWeight(.bold)
             + Text("\(bodyEntry.calfCircumferenceString!)"))
            .lineLimit(1)
            .minimumScaleFactor(0.6)
            
        })
    }
}
