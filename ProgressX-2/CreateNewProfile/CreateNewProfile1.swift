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
    
    // The navPath variable is passed along to all following
    // views in this set of views.
    @State private var navPath = [Int]()
    
    @State private var userName = ""
    @State private var birthDay = Date()
    @State private var selectedUnitSegment = 0
    @State private var selectedGenderSegment = 0
    @State private var weight = ""
    @State private var height = ""
    
    @State private var userNameIsInvalid = false
    @State private var heightIsInvalid = false
    @State private var weightIsInvalid = false
    
    let unitSegments = ["Metric (meters)", "Imperial (feet)"]
    let genderSegments = ["Male", "Female"]
    
    // Validates input
    private func validateInput() -> Bool {
        
        var value = true
        
        // Check if username is empty
        if userName.isEmpty {
            value = false
            userNameIsInvalid = true
        } else {
            userNameIsInvalid = false
        }
        
        // Check if weight is empty
        if weight.isEmpty { 
            value = false
            weightIsInvalid = true
        } else {
            weightIsInvalid = false
        }
        
        // Check if height is empty
        if height.isEmpty {
            value = false
            heightIsInvalid = true
        } else {
            heightIsInvalid = false
        }
        
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
        // The navigation stack is the root of all following views
        // in this set of views (CreateProfileViews
        NavigationStack(path: $navPath) {
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
                    
                    InputShortTextField(placeHolder: "Enter username...", text: $userName, markAsWrong: $userNameIsInvalid, width: 0.4)
                    
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
                    InputDecimalNumberField(placeHolder: weightUnit, numberText: $weight, markAsWrong: $weightIsInvalid, width: 0.3)
                    
                    Text("What is your current Height")
                        .foregroundColor(.black)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .multilineTextAlignment(.center)
                        .padding(.top, 10)
                        .minimumScaleFactor(0.5);
                    
                    let lengthUnit = (selectedUnitSegment == 0) ? "m" : "ft"
                    InputDecimalNumberField(placeHolder: lengthUnit, numberText: $height, markAsWrong: $heightIsInvalid, width: 0.3)
                    
                    Text("What is your (biological) gender")
                        .foregroundColor(.black)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .multilineTextAlignment(.center)
                        .padding(.top, 10)
                        .minimumScaleFactor(0.5);
                    
                    BasicSegPicker(selectedSegment: $selectedGenderSegment, segments: genderSegments)
                    
                    Button {
                        if validateInput() {
                            createProfile()
                            navPath.append(2)
                        }
                    } label: {
                        Text("Continue")
                            .frame(width: 100, height: 50)
                    }
                        .buttonStyle(.borderedProminent)
                        .padding(.top, 30)
                    
                } 
                .navigationDestination(for: Int.self) { selection in
                    if selection == 2 {
                        // Pass along the navpath so following views can add to it.
                        CreateNewProfile2(navPath: $navPath)
                        // Also pass the viewRouter to be able to change the rootView to homeView.
                            .environmentObject(viewRouter)
                    }
                    else if selection == 3 {
                        CreateNewProfile3()
                            .environmentObject(viewRouter)
                    }
                }
            }
        }
    }
}
    

#Preview {
    CreateNewProfile1()
        .environmentObject(ViewRouter())
}
