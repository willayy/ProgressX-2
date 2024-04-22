//
//  NewProfileView1.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-04-12.
//

import SwiftUI
import CoreData

struct CreateNewProfile1: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @State private var userName = ""
    @State private var birthDay = Date()
    @State private var selectedSegment = 0
    let segments = ["Metric (meters)", "Imperial (feet)"]
    
    var body: some View {
        NavigationView {
            GeometryReader { metrics in
                VStack(alignment: .center) {
                    
                    Text("Create profile")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center)
                        .minimumScaleFactor(0.5);
                    
                    Text("To use ProgressX you need to create a profile, this profile and all its data will be stored locally only")
                        .font(.subheadline)
                        .fontWeight(.light)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30.0)
                        .minimumScaleFactor(0.5);
                    
                    Text("Username")
                        .foregroundColor(.black)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .multilineTextAlignment(.center)
                        .padding(.top, 10)
                        .minimumScaleFactor(0.5);
                    
                    InputTextField(placeHolder: "Enter username...", text: $userName, width: 0.4)
                        
                    Text("Birthday")
                        .foregroundColor(.black)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .multilineTextAlignment(.center)
                        .padding(.top, 10)
                        .minimumScaleFactor(0.5);
                    
                    DatePicker("", selection: $birthDay, displayedComponents: .date)
                        .datePickerStyle(DefaultDatePickerStyle())
                        .labelsHidden()
                        .padding(-3)
                    
                    Text("Metric or imperial units?")
                        .foregroundColor(.black)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .multilineTextAlignment(.center)
                        .padding(.top, 10)
                        .minimumScaleFactor(0.5);
                    
                    BasicSegPicker(selectedSegment: $selectedSegment, segments: segments)
                    
                    
                }
            }
        }
    }
}

#Preview {
    CreateNewProfile1()
}
