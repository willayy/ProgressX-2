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
    
    @Binding var showMenu: Bool
    @StateObject private var viewModel = ProfileViewModel()
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        
        ProfileNavigationController {
            ScrollView {
                VStackWithSideBarButton(showMenu: $showMenu) {
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
                        maxChars: 25,
                        markAsWrong: $viewModel.userNameIsInvalid,
                        width: 0.5,
                        errorMessage: $viewModel.userNameIsInvalidMsg
                    )
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
                    
                    InputDecimalNumberField(
                        placeHolder: "Default rest-time",
                        allowNegatives: false,
                        numberText: $viewModel.standardRestTime,
                        markAsWrong: $viewModel.standardRestTimeIsInvalid,
                        width: 0.3,
                        errorMessage: $viewModel.standardRestTimeIsInvalidMsg
                    )
                    .padding(.bottom, 10)
                    
                    BoldSubHeadline(text: "Change weight and length units")
                    
                    BasicSegPicker(
                        selectedSegment: $viewModel.selectedUnitSegment,
                        segments: viewModel.unitSegments,
                        frameWidth: 230,
                        horizontalPadding: 20
                    )
                    .padding(.bottom, 10)
                    
                    BoldSubHeadline(text: "Change smallest plate")
                    
                    StringSelectionList(
                        selected: $viewModel.selectedSmallestPlate,
                        selections: viewModel.smallestPlateSegments
                    )
                    .padding(.bottom, 10)
                    .padding(.horizontal, 40)
                    
                    BoldSubHeadline(text: "Change height")
                    
                    InputDecimalNumberField(
                        placeHolder: "Height",
                        allowNegatives: false,
                        numberText: $viewModel.height,
                        markAsWrong: $viewModel.heightIsInvalid,
                        width: 0.3,
                        errorMessage: $viewModel.heightIsInvalidMsg
                    )
                    .padding(.bottom, 10)
                    
                    BoldSubHeadline(text: "Gender")
                    
                    BasicSegPicker(
                        selectedSegment: $viewModel.selectedGenderSegment,
                        segments: viewModel.genderSegments,
                        frameWidth: 230,
                        horizontalPadding: 20
                    )
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
    @State var showMenu: Bool = false
    
    return ProfileView(showMenu: $showMenu)
        .environment(\.managedObjectContext, context)
}
