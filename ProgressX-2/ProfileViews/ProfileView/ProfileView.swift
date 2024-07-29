//
//  ProfileView.swift
//  ProgressX-2
//
//  Created by lucas häyhänen on 2024-06-18.
//

import Foundation
import SwiftUI
import CoreData

struct ProfileView: View {
    
    @FetchRequest(
        entity: Profile.entity(),
        sortDescriptors: []
    ) private var profiles: FetchedResults<Profile>
    
    @StateObject private var viewModel = ProfileViewModel()
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        ProfileNavigationController {
            ScrollView {
                VStackWithSideBarButton {
                    BoldTitle(text: "Profile")
                        .padding(.horizontal, 20)
                    
                    LightSubHeadline(text: "Here you can change/update the settings of your current profile")
                        .padding(.horizontal, 20)
                    
                    if viewModel.showProfileChangedAlert {
                        SubmitAlert(
                            message: "Profile changes succesfully saved!",
                            color: .green,
                            showAlertState: $viewModel.showProfileChangedAlert
                        )
                    } else if viewModel.showNoChangeAlert {
                        SubmitAlert(
                            message: "No change!",
                            color: .blue,
                            showAlertState: $viewModel.showNoChangeAlert
                        )
                    }
                    
                    BoldSubHeadline(text: "Change username")
                        .padding(.top, 10)
                    
                    InputTextField(
                        placeHolder: "Username",
                        text: $viewModel.userName,
                        markAsWrong: $viewModel.userNameIsInvalid,
                        errorMessage: $viewModel.userNameIsInvalidMsg,
                        maxChars: 25
                    )
                    .padding(.horizontal, 60)
                    .padding(.bottom, 10)
                    
                    BoldSubHeadline(text: "Change birth date")
                    
                    DatePicker(
                        "",
                        selection: $viewModel.birthDay ,
                        displayedComponents: .date
                    )
                    .datePickerStyle(DefaultDatePickerStyle())
                    .labelsHidden()
                    .padding(.bottom, 10)
                    
                    BoldSubHeadline(text: "Change default rest-time (seconds)")
                    
                    DecimalTextField(
                        placeHolder: "Default rest-time",
                        numberText: $viewModel.standardRestTime,
                        markAsWrong: $viewModel.standardRestTimeIsInvalid,
                        errorMessage: $viewModel.standardRestTimeIsInvalidMsg
                    )
                    .padding(.horizontal, 60)
                    .padding(.bottom, 10)
                    
                    BoldSubHeadline(text: "Change weight and length units")
                    
                    BasicSegPicker(
                        selectedSegment: $viewModel.selectedUnitSegment,
                        segments: viewModel.unitSegments
                    )
                    .padding(.horizontal, 55)
                    .padding(.bottom, 10)
                    
                    BoldSubHeadline(text: "Change smallest plate")
                    
                    StringSelectionList(
                        selected: $viewModel.selectedSmallestPlate,
                        selections: viewModel.smallestPlateSegments
                    )
                    .padding(.bottom, 10)
                    .padding(.horizontal, 55)
                    
                    BoldSubHeadline(text: "Change height")
                    
                    DecimalTextField(
                        placeHolder: "Height",
                        numberText: $viewModel.height,
                        markAsWrong: $viewModel.heightIsInvalid,
                        errorMessage: $viewModel.heightIsInvalidMsg
                    )
                    .padding(.horizontal, 60)
                    .padding(.bottom, 10)
                    
                    BoldSubHeadline(text: "Gender")
                    
                    BasicSegPicker(
                        selectedSegment: $viewModel.selectedGenderSegment,
                        segments: viewModel.genderSegments
                    )
                    .padding(.horizontal, 55)
                    .padding(.bottom, 10)
                    
                    Button(action: {
                        if validateInput() {
                            viewModel.saveProfileChanges(viewContext: viewContext, profiles: profiles)
                        }
                    })
                    {
                        Text("Save changes")
                            .frame(height: 40)
                            .foregroundColor(Color("buttonTextColor"))
                        Image(systemName: "square.and.arrow.down")
                            .foregroundColor(Color("buttonTextColor"))
                    }
                    .padding(.top, 20)
                    .buttonStyle(BorderedProminentButtonStyle())
                    .foregroundColor(.white)
                    .padding(.bottom, 10)
                    
                }
            }
            .onAppear(perform: {
                viewModel.setViewStartValues(profiles: profiles)
            })
        }
    }
    
    private func validateInput() -> Bool {
        
        var valid: Int = 0
        let userNameFieldValidator = StringFieldValidator()
        let StandardRestFieldValidator = DoubleFieldValidator()
        let heightFieldValidator = DoubleFieldValidator()
        
        valid += userNameFieldValidator.valideField(
            inputVar: viewModel.userName,
            errorMessage: $viewModel.userNameIsInvalidMsg,
            fieldInvalid: $viewModel.userNameIsInvalid
        )
        
        valid += StandardRestFieldValidator.valideField(
            inputVar: viewModel.standardRestTime,
            errorMessage: $viewModel.standardRestTimeIsInvalidMsg,
            fieldInvalid: $viewModel.standardRestTimeIsInvalid
        )
        
        valid += heightFieldValidator.valideField(
            inputVar: viewModel.height,
            errorMessage: $viewModel.heightIsInvalidMsg,
            fieldInvalid: $viewModel.heightIsInvalid
        )
        
        return valid == 0
        
    }
    
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    
    return ProfileView()
        .environment(\.managedObjectContext, context)
        .environmentObject(ShowMenuController())
}
