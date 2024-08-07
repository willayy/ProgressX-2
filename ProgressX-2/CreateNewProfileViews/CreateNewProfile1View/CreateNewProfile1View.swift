//
//  NewProfileView1.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-04-12.
//

import SwiftUI
import CoreData

struct CreateNewProfile1View: View {
    
    @FetchRequest(
        entity: Profile.entity(),
        sortDescriptors: []
    ) private var profiles: FetchedResults<Profile>
    
    @EnvironmentObject var viewRouter: ViewRouter
    @StateObject private var viewModel = CreateNewProfile1ViewModel()
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        CreateNewProfileNavigationController(
            navPath: $viewModel.navPath,
            content: {
            ScrollView {
                VStack(alignment: .center, spacing: 10) {
                    
                    BoldTitle(text: "Create a profile!")
                        .padding(.horizontal, 20)
                     
                    LightSubHeadline(text: "To use ProgressX you need to create a profile, this profile and all its data will be stored locally only.")
                        .padding(.horizontal, 20)
                    
                    BoldSubHeadline(text: "Username")
                        .padding(.top, 10)
                    
                    InputTextField(
                        placeHolder: "Enter username...",
                        text: $viewModel.userName, 
                        markAsWrong: $viewModel.userNameIsInvalid,
                        errorMessage: $viewModel.userNameIsInvalidMsg,
                        maxChars: 25
                    )
                    .padding(.horizontal, 60)

                    
                    BoldSubHeadline(text: "Birthday")
                        .padding(.top, 10)
                    
                    DatePicker("", selection: $viewModel.birthDay, displayedComponents: .date)
                        .datePickerStyle(DefaultDatePickerStyle())
                        .labelsHidden()
                        .padding(-3)
                    
                    BoldSubHeadline(text: "Metric or imperial units?")
                        .padding(.top, 10)
                    
                    BooleanSegPicker(
                        selectedSegment: $viewModel.selectedUnitSegment,
                        segments: viewModel.unitSegments
                    )
                    .padding(.horizontal, 55)
                    
                    BoldSubHeadline(text: "What is your smallest available plate?")
                        .padding(.top, 10)
                    
                    StringSelectionList(
                        selected: $viewModel.smallestPlateSelection,
                        selections: viewModel.smallestPlateSegments
                    )
                    .padding(.horizontal, 55)
                    .onChange(
                        of: viewModel.selectedUnitSegment,
                        initial: false, {
                            viewModel.smallestPlateSelection = viewModel.smallestPlateSegments.first!
                        }
                    )
                    
                    BoldSubHeadline(text: "What is your current weight?")
                        .padding(.top, 10)
                    
                    DecimalTextField(
                        placeHolder: viewModel.weightUnit(viewContext),
                        numberText: $viewModel.weight,
                        markAsWrong: $viewModel.weightIsInvalid,
                        errorMessage: $viewModel.weightIsInvalidMsg
                    )
                    .padding(.horizontal, 60)
                    
                    BoldSubHeadline(text:"What is your current Height")
                        .padding(.top, 10)
                    
                    DecimalTextField(
                        placeHolder: viewModel.lengthUnit(viewContext), 
                        numberText: $viewModel.height,
                        markAsWrong: $viewModel.heightIsInvalid,
                        errorMessage: $viewModel.heightIsInvalidMsg
                    )
                    .padding(.horizontal, 60)
                    
                    BoldSubHeadline(text: "What is your (biological) gender")
                        .padding(.top, 10)
                        
                    BasicSegPicker(
                        selectedSegment: $viewModel.selectedGenderSegment,
                        segments: viewModel.genderSegments
                    )
                    .padding(.horizontal, 55)
                    
                    Button {
                        if validateInput() {
                            viewModel.saveEntry(viewContext: viewContext)
                            viewModel.navPath.append(1)
                        }
                    } label: {
                        Text("Continue")
                            .frame(width: 100, height: 50)
                            .foregroundColor(Color("buttonTextColor"))
                    }
                    .buttonStyle(.borderedProminent)
                    .padding(.vertical, 20)
                    
                    if viewModel.savingError {
                        SavingErrorText()
                            .padding(.horizontal, 20)
                    }
                    
                }
            }
        })
    }
    
    // Validates input
    private func validateInput() -> Bool {
        var valid: Int = 0
        let heightValidator = DoubleFieldValidator(maxInputNumber: 1000)
        let weightValidator = DoubleFieldValidator(maxInputNumber: 1000)
        let stringFieldValidator = StringFieldValidator()
        
        valid += heightValidator.valideField(
            inputVar: viewModel.height,
            errorMessage: $viewModel.heightIsInvalidMsg,
            fieldInvalid: $viewModel.heightIsInvalid
        )
        
        valid += weightValidator.valideField(
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
