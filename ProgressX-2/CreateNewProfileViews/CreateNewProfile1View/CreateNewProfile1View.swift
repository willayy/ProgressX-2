//
//  NewProfileView1.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-04-12.
//

import SwiftUI
import CoreData

struct CreateNewProfile1View: View {
    
    @EnvironmentObject var viewRouter: ViewRouter
    @StateObject private var viewModel = CreateNewProfile1ViewModel()
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        entity: Profile.entity(),
        sortDescriptors: []
    ) private var profileResults: FetchedResults<Profile>
    
    var body: some View {
        CreateNewProfileNavigationController(content: {
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
                    
                    InputTextField(
                        placeHolder: "Enter username...",
                        text: $viewModel.userName, 
                        maxChars: 25,
                        markAsWrong: $viewModel.userNameIsInvalid,
                        width: 0.4,
                        errorMessage: $viewModel.userNameIsInvalidMsg
                    )
                    
                    Text("Birthday")
                        .foregroundColor(.black)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .multilineTextAlignment(.center)
                        .padding(.top, 10)
                        .minimumScaleFactor(0.5);
                    
                    DatePicker("", selection: $viewModel.birthDay, displayedComponents: .date)
                        .datePickerStyle(DefaultDatePickerStyle())
                        .labelsHidden()
                        .padding(-3)
                    
                    Text("Metric or imperial units?")
                        .foregroundColor(.black)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .multilineTextAlignment(.center)
                        .padding(.top, 10)
                        .minimumScaleFactor(0.5);
                    
                    BasicSegPicker(
                        selectedSegment: $viewModel.selectedUnitSegment,
                        segments: viewModel.unitSegments,
                        frameWidth: 230,
                        horizontalPadding: 20
                    )
                    
                    Text("What is your current weight?")
                        .foregroundColor(.black)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .multilineTextAlignment(.center)
                        .padding(.top, 10)
                        .minimumScaleFactor(0.5);
                    
                    InputDecimalNumberField(
                        placeHolder: viewModel.weightUnit,
                        numberText: $viewModel.weight,
                        markAsWrong: $viewModel.weightIsInvalid,
                        width: 0.3,
                        errorMessage: $viewModel.weightIsInvalidMsg
                    )
                    
                    Text("What is your current Height")
                        .foregroundColor(.black)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .multilineTextAlignment(.center)
                        .padding(.top, 10)
                        .minimumScaleFactor(0.5);
                    
                    
                    InputDecimalNumberField(
                        placeHolder: viewModel.lengthUnit,
                        numberText: $viewModel.height,
                        markAsWrong: $viewModel.heightIsInvalid,
                        width: 0.3,
                        errorMessage: $viewModel.heightIsInvalidMsg
                    )
                    
                    Text("What is your (biological) gender")
                        .foregroundColor(.black)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .multilineTextAlignment(.center)
                        .padding(.top, 10)
                        .minimumScaleFactor(0.5);
                    
                    BasicSegPicker(
                        selectedSegment: $viewModel.selectedGenderSegment,
                        segments: viewModel.genderSegments,
                        frameWidth: 230,
                        horizontalPadding: 20
                    )
                    
                    Button {
                        if validateInput() {
                            viewModel.createProfile(viewContext: viewContext, profiles: profileResults)
                            viewModel.navPath.append(1)
                        }
                    } label: {
                        Text("Continue")
                            .frame(width: 100, height: 50)
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.top, 30)
                    
                }
            }
        },navPath: $viewModel.navPath)
        .environmentObject(viewRouter)
        .environment(\.managedObjectContext, viewContext)
    }
    
    // Validates input
    private func validateInput() -> Bool {
        var valid: Int = 0
        let doubleFieldValidator = DoubleFieldValidator()
        let stringFieldValidator = StringFieldValidator()
        
        valid += doubleFieldValidator.valideField(
            inputVar: viewModel.height,
            errorMessage: $viewModel.heightIsInvalidMsg,
            fieldInvalid: $viewModel.heightIsInvalid
        )
        
        valid += doubleFieldValidator.valideField(
            inputVar: viewModel.weight,
            errorMessage: $viewModel.weightIsInvalidMsg,
            fieldInvalid: $viewModel.weightIsInvalid
        )
        
        valid += stringFieldValidator.valideField(
            inputVar: viewModel.userName,
            errorMessage: $viewModel.userNameIsInvalidMsg,
            fieldInvalid: $viewModel.userNameIsInvalid
        )
        
        return valid == 0
    }
}
    

#Preview {
    let context = PersistenceController.preview.container.viewContext
    return CreateNewProfile1View()
        .environmentObject(ViewRouter())
        .environment(\.managedObjectContext, context)
}
