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
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        entity: Profile.entity(),
        sortDescriptors: []
    ) private var profileResults: FetchedResults<Profile>
    
    // The navPath variable is passed along to all following
    // views in this set of views.
    @State private var navPath = [Int]()
    @State private var userName = ""
    @State private var birthDay = Date()
    @State private var selectedUnitSegment = "Metric (meters)"
    @State private var selectedGenderSegment = "Male"
    @State private var weight = ""
    @State private var height = ""
    
    // Input field States
    @State private var userNameIsInvalid = false
    @State private var heightIsInvalid = false
    @State private var weightIsInvalid = false
    @State private var userNameIsInvalidMsg = ""
    @State private var heightIsInvalidMsg = ""
    @State private var weightIsInvalidMsg = ""
    
    let unitSegments = ["Metric (meters)", "Imperial (feet)"]
    let genderSegments = ["Male", "Female"]
    
    var body: some View {
        // The navigation stack is the root of all following views
        // in this set of views (CreateProfileViews
        NavigationStack(path: $navPath) {
            ScrollView {
                VStack(alignment: .center, spacing: 10) {
                    
                    BoldTitle(text: "Create a profile!")
                     
                    LightSubHeadline(text: "To use ProgressX you need to create a profile, this profile and all its data will be stored locally only.")
                    
                    Text("Username")
                        .foregroundColor(.black)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .multilineTextAlignment(.center)
                        .padding(.top, 10)
                        .minimumScaleFactor(0.5);
                    
                    InputShortTextField(placeHolder: "Enter username...", text: $userName, markAsWrong: $userNameIsInvalid, width: 0.4, errorMessage: $userNameIsInvalidMsg)
                    
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
                    
                    BasicSegPicker(selectedSegment: $selectedUnitSegment, segments: unitSegments, frameWidth: 230, horizontalPadding: 20)
                    
                    Text("What is your current weight?")
                        .foregroundColor(.black)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .multilineTextAlignment(.center)
                        .padding(.top, 10)
                        .minimumScaleFactor(0.5);
                    
                    let weightUnit = (selectedUnitSegment == "Metric (meters)") ? "kg" : "lbs"
                    InputDecimalNumberField(placeHolder: weightUnit, numberText: $weight, markAsWrong: $weightIsInvalid, width: 0.3, errorMessage: $weightIsInvalidMsg)
                    
                    Text("What is your current Height")
                        .foregroundColor(.black)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .multilineTextAlignment(.center)
                        .padding(.top, 10)
                        .minimumScaleFactor(0.5);
                    
                    let lengthUnit = (selectedUnitSegment == "Metric (meters)") ? "m" : "ft"
                    InputDecimalNumberField(placeHolder: lengthUnit, numberText: $height, markAsWrong: $heightIsInvalid, width: 0.3, errorMessage: $heightIsInvalidMsg)
                    
                    Text("What is your (biological) gender")
                        .foregroundColor(.black)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .multilineTextAlignment(.center)
                        .padding(.top, 10)
                        .minimumScaleFactor(0.5);
                    
                    BasicSegPicker(selectedSegment: $selectedGenderSegment, segments: genderSegments, frameWidth: 230, horizontalPadding: 20)
                    
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
                            .environment(\.managedObjectContext, viewContext)
                    }
                    else if selection == 3 {
                        CreateNewProfile3(navPath: $navPath)
                            .environment(\.managedObjectContext, viewContext)
                    }
                    else if selection == 4 {
                        CreateNewProfile4(navPath: $navPath)
                            .environmentObject(viewRouter)
                            .environment(\.managedObjectContext, viewContext)
                    }
                }
            }
        }
    }
    
    // Validates input
    private func validateInput() -> Bool {
        var valid: Int = 0
        let doubleFieldValidator = DoubleFieldValidator()
        let stringFieldValidator = StringFieldValidator()
        valid += doubleFieldValidator.valideField(inputVar: height, errorMessage: $heightIsInvalidMsg, fieldInvalid: $heightIsInvalid)
        valid += doubleFieldValidator.valideField(inputVar: weight, errorMessage: $weightIsInvalidMsg, fieldInvalid: $weightIsInvalid)
        valid += stringFieldValidator.valideField(inputVar: userName, errorMessage: $userNameIsInvalidMsg, fieldInvalid: $userNameIsInvalid)
        return valid == 0
    }
    
    // Calls this method when "Continue" button is pressed
    private func createProfile() -> Void {
        if PersistenceController.profileExists(viewContext) {
            let profile = profileResults.first!
            PersistenceController.delete(viewContext, object: profile)
            PersistenceController.save(viewContext)
        }
        
        // Transform input values into values that can be used in the datamodel.
        let isMetric = (selectedUnitSegment == "Metric (meters)") ? true : false
        let gender = (selectedGenderSegment == "Male") ? "male" : "female"
        let inputWeight = Double(weight)!
        let inputHeight = Double(height)!
        
        // Create Profile
        let profile = Profile(context: viewContext)
        profile.birthDay = birthDay
        profile.profileUserName = userName
        profile.height = inputHeight
        profile.gender = gender
        profile.isMetric = isMetric
        
        // Create BodyEntry
        let bodyWeightEntry = PersistenceController.createBodyEntry(
            viewContext,
            profile: profile,
            weight: inputWeight,
            date: Date()
        )
        
        // Add BodyEntry to the profile
        profile.addToBodyEntries(bodyWeightEntry)
        
        // Create basic exercies if they dont exist
        if !PersistenceController.basicExercisesExist(viewContext) {
            PersistenceController.generateBasicExerciseLibrary(viewContext)
        }
        
        PersistenceController.save(viewContext)
    }
    
}
    

#Preview {
    let context = PersistenceController.preview.container.viewContext
    return CreateNewProfile1()
        .environmentObject(ViewRouter())
        .environment(\.managedObjectContext, context)
}
