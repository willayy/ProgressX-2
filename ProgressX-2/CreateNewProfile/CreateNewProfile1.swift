//
//  NewProfileView1.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-04-12.
//

import SwiftUI
import CoreData

struct CreateNewProfile1: View {
    
    @EnvironmentObject var viewRouter: ViewRouter
    
    @State private var userName = ""
    @State private var birthDay = Date()
    @State private var selectedUnitSegment = 0
    @State private var selectedGenderSegment = 0
    @State private var weight = ""
    @State private var height = ""
    
    let unitSegments = ["Metric (meters)", "Imperial (feet)"]
    let genderSegments = ["Male", "Female"]
    
    // Validates input
    private func validateInput() -> Bool {
        
        var value = true
        
        // Check if username is empty
        if userName.isEmpty { value = false }
        
        // Check if weight is empty
        if weight.isEmpty { value = false }
        
        // Check if height is empty
        if height.isEmpty { value = false }
        
        return value
    }
    
    // Calls this method when "Continue" button is pressed
    private func createProfile() -> Void {
        
        let p = PersistenceController.shared
        
        if p.doesProfileExist() {
            let profile = p.getProfile()!
            p.deleteNSManagedObject(object: profile)
            p.save()
        }
        
        let isMetric = (selectedUnitSegment == 0) ? true : false
        let gender = (selectedGenderSegment == 0) ? "male" : "female"
        let inputWeight = Double(weight)!
        let inputHeight = Double(height)!
        
        p.createProfile(userName: userName, birthDay: birthDay, height: inputHeight, isMetric: isMetric, gender: gender)
        p.addBodyWeightEntry(dateAchieved: Date(), weight: inputWeight)
        p.save()
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .center, spacing: 10) {
                    
                    Text("Create a profile!")
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
                        .padding(.horizontal, 20)
                        .minimumScaleFactor(0.5);
                    
                    Text("Username")
                        .foregroundColor(.black)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .multilineTextAlignment(.center)
                        .padding(.top, 10)
                        .minimumScaleFactor(0.5);
                    
                    let userNameIsEmpty = (userName.isEmpty) ? true : false
                    InputShortTextField(placeHolder: "Enter username...", text: $userName, markAsWrong: userNameIsEmpty, width: 0.4)
                    
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
                    
                    BasicSegPicker(selectedSegment: $selectedUnitSegment, segments: unitSegments)
                    
                    Text("What is your current weight?")
                        .foregroundColor(.black)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .multilineTextAlignment(.center)
                        .padding(.top, 10)
                        .minimumScaleFactor(0.5);
                    
                    let weightUnit = (selectedUnitSegment == 0) ? "kg" : "lbs"
                    let weightIsEmpty = (weight.isEmpty) ? true : false
                    InputDecimalNumberField(placeHolder: weightUnit, numberText: $weight, markAsWrong: weightIsEmpty, width: 0.3)
                    
                    Text("What is your current Height")
                        .foregroundColor(.black)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .multilineTextAlignment(.center)
                        .padding(.top, 10)
                        .minimumScaleFactor(0.5);
                    
                    let lengthUnit = (selectedUnitSegment == 0) ? "m" : "ft"
                    let heightIsEmpty = (height.isEmpty) ? true : false
                    InputDecimalNumberField(placeHolder: lengthUnit, numberText: $height, markAsWrong: heightIsEmpty, width: 0.3)
                    
                    Text("What is your (biological) gender")
                        .foregroundColor(.black)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .multilineTextAlignment(.center)
                        .padding(.top, 10)
                        .minimumScaleFactor(0.5);
                    
                    BasicSegPicker(selectedSegment: $selectedGenderSegment, segments: genderSegments)
                    
                    NavigationLink("Continue", destination: 
                                    CreateNewProfile2()
                                        .environmentObject(viewRouter)
                                        .onAppear { createProfile() })
                    .buttonStyle(.borderedProminent)
                    .padding(.top, 20)
                    .disabled(!validateInput())
                }
            }
        }
    }
}

#Preview {
    CreateNewProfile1()
        .environmentObject(ViewRouter())
}
