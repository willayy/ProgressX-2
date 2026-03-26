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
            
        ScrollView {
            
            VStackWithSideBarButton {
                
                BoldTitle(text: "Profile")
                    .padding(.horizontal, 20)
                    .onAppear(perform: {
                        /* Have to call this function here because
                         of the order SwiftUI loads in views */
                        viewModel.setViewStartValues(entity: profiles.first!)
                    })
                
                LightSubHeadline(text: "Here you can change/update the settings of your current profile")
                    .padding(.horizontal, 20)
                
                // MARK: Submit alert states
                if viewModel.showProfileChangedAlert {
                    
                    SubmitAlert(
                        message: "Profile changes succesfully saved!",
                        color: .green,
                        showAlertState: $viewModel.showProfileChangedAlert
                    )
                    .padding(.top, 10)
                    
                } else if viewModel.showNoChangeAlert {
                    
                    SubmitAlert(
                        message: "No change!",
                        color: .blue,
                        showAlertState: $viewModel.showNoChangeAlert
                    )
                    .padding(.top, 10)
                    
                }
                
                // MARK: Edit username
                BoldSubHeadline(text: "Change username")
                    .padding(.top, 10)
            
                InputField(
                    placeHolder: "Username",
                    text: $viewModel.userName,
                    variant: TextIF()
                )
                .padding(.horizontal, 60)
                .padding(.bottom, 10)
                
                // MARK: Edit birthday
                BoldSubHeadline(text: "Change birth date")
                
                DatePicker(
                    "",
                    selection: $viewModel.birthDay ,
                    displayedComponents: .date
                )
                .datePickerStyle(DefaultDatePickerStyle())
                .labelsHidden()
                .padding(.bottom, 10)
                
                // MARK: Edit default rest-time
                BoldSubHeadline(text: "Change default rest-time (seconds)")
                
                InputField(
                    placeHolder: "Default rest-time",
                    text: $viewModel.standardRestTime,
                    variant: DecimalIF(
                        min: 0,
                        max: 6000
                    )
                )
                .padding(.horizontal, 60)
                .padding(.bottom, 10)
                
                // MARK: Notification sound toggle
                Toggle(isOn: $viewModel.notificationSound) {
                    BoldSubHeadline(text: "Workout timer notification")
                }
                .padding(.horizontal, 55)
                .padding(.bottom, 10)
                
                // MARK: Edit units
                BoldSubHeadline(text: "Change weight and length units")
                
                BooleanSegPicker(
                    selectedSegment: $viewModel.selectedUnitSegment,
                    segments: viewModel.unitSegments
                )
                .padding(.horizontal, 55)
                .padding(.bottom, 10)
                
                // MARK: Edit smallest plate
                BoldSubHeadline(text: "Change smallest plate")
                
                StringSelectionList(
                    selected: $viewModel.selectedSmallestPlate,
                    selections: viewModel.smallestPlateSegments
                )
                .padding(.bottom, 10)
                .padding(.horizontal, 55)
                
                // MARK: Edit height
                BoldSubHeadline(text: "Change height")
                
                InputField(
                    placeHolder: "Height",
                    text: $viewModel.height,
                    variant: DecimalIF(
                        min: 0,
                        max: 1000
                    )
                )
                .padding(.horizontal, 60)
                .padding(.bottom, 10)
                
                // MARK: Edit gender
                BoldSubHeadline(text: "Gender")
                
                BasicSegPicker(
                    selectedSegment: $viewModel.selectedGenderSegment,
                    segments: viewModel.genderSegments
                )
                .padding(.horizontal, 55)
                .padding(.bottom, 10)
                
            }
        }
            
        // MARK: Save changes button
        Button {
            
            if GlobalInputFieldValidator.allFieldsValid() {
                
                viewModel.saveEdits(entity: profiles.first!, viewContext: viewContext)
                
            }
            
        } label: {
            
            Text("Save changes")
                .frame(height: 40)
                .foregroundColor(Color("buttonTextColor"))
            
            Image(systemName: "square.and.arrow.down")
                .foregroundColor(Color("buttonTextColor"))
            
        }
        .padding(.vertical, 20)
        .buttonStyle(BorderedProminentButtonStyle())
        
    }
    
}

#Preview {
    
    let context = PersistenceController.previewViewContext
    
    return ProfileView()
        .environment(\.managedObjectContext, context)
        .environmentObject(ShowMenuController())
}
