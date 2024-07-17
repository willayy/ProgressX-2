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
    @Environment(\.managedObjectContext) private var viewContext
    
    @EnvironmentObject var viewRouter: ViewRouter
    
    @FetchRequest(
        entity: Profile.entity(),
        sortDescriptors: []
    ) private var profiles: FetchedResults<Profile>
    
    @StateObject private var viewModel = ProfileViewModel()
    
    var body: some View {
        SideBarView(content: {
            NavigationStack {
                ScrollView {
                    
                    BoldTitle(text: "Profile")
                    
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
                    
                    VStack(alignment: .center) {
                        
                        BoldSubHeadline(text: "Change username")
                        
                        InputTextField(
                            placeHolder: "Username",
                            text: $viewModel.userName, 
                            maxChars: 25,
                            markAsWrong: $viewModel.userNameIsInvalid,
                            width: 0.5,
                            errorMessage: $viewModel.userNameIsInvalidMsg
                        ).padding(.bottom)
                        
                        BoldSubHeadline(text: "Change birth date")
                        
                        DatePicker(
                            "",
                            selection: $viewModel.birthDay ,
                            displayedComponents: .date
                        )
                        .datePickerStyle(DefaultDatePickerStyle())
                        .labelsHidden()
                        .padding(.bottom)
                        
                        BoldSubHeadline(text: "Change default rest-time (seconds)")
                        
                        InputDecimalNumberField(
                            placeHolder: "Default rest-time",
                            allowNegatives: false,
                            numberText: $viewModel.standardRestTime,
                            markAsWrong: $viewModel.standardRestTimeIsInvalid,
                            width: 0.3,
                            errorMessage: $viewModel.standardRestTimeIsInvalidMsg
                        ).padding(.bottom)
                        
                        BoldSubHeadline(text: "Change weight and length units")
                        
                        BasicSegPicker(
                            selectedSegment: $viewModel.selectedUnitSegment,
                            segments: viewModel.unitSegments,
                            frameWidth: 230,
                            horizontalPadding: 20
                        )
                        .padding(.bottom)
                        
                        BoldSubHeadline(text: "Change height")
                        
                        InputDecimalNumberField(
                            placeHolder: "Height",
                            allowNegatives: false,
                            numberText: $viewModel.height,
                            markAsWrong: $viewModel.heightIsInvalid,
                            width: 0.3,
                            errorMessage: $viewModel.heightIsInvalidMsg
                        ).padding(.bottom)
                        
                        BoldSubHeadline(text: "Gender")
                        
                        BasicSegPicker(
                            selectedSegment: $viewModel.selectedGenderSegment,
                            segments: viewModel.genderSegments,
                            frameWidth: 230,
                            horizontalPadding: 20
                        )
                        
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
                    .frame(width: 390, height: 650, alignment: .top)
                    .toolbar(.hidden, for: .tabBar)
                    .foregroundColor(Color(UIColor.lightGray))
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            SideBarButton(showMenu: $viewModel.showMenu)
                                .environmentObject(viewRouter)
                        }
                    }
                }.onAppear(perform: {
                    viewModel.setViewStartValues(profiles: profiles)
                })
            }
        },showMenu: $viewModel.showMenu)
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
        .environmentObject(ViewRouter())
        .environment(\.managedObjectContext, context)
}
