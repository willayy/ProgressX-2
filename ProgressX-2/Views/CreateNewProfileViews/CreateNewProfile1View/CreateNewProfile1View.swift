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
                        
                        // MARK: User username
                        BoldSubHeadline(text: "Username")
                            .padding(.top, 10)
                        
                        InputField(
                            placeHolder: "username",
                            text: $viewModel.userName,
                            variant: TextIF(
                                allowEmpty: false
                            )
                        )
                        .padding(.horizontal, 60)
                        
                        // MARK: User birthday
                        BoldSubHeadline(text: "Birthday")
                            .padding(.top, 10)
                        
                        DatePicker("", selection: $viewModel.birthDay, displayedComponents: .date)
                            .datePickerStyle(DefaultDatePickerStyle())
                            .labelsHidden()
                            .padding(-3)
                        
                        // MARK: User unit preferences
                        BoldSubHeadline(text: "Metric or imperial units?")
                            .padding(.top, 10)
                        
                        BooleanSegPicker(
                            selectedSegment: $viewModel.selectedUnitSegment,
                            segments: viewModel.unitSegments
                        )
                        .padding(.horizontal, 55)
                        
                        // MARK: User's smallest available plate
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
                        
                        // MARK: User weight
                        BoldSubHeadline(text: "What is your current weight?")
                            .padding(.top, 10)
                        
                        InputField(
                            placeHolder: viewModel.weightUnit(viewContext),
                            text: $viewModel.weight,
                            variant: DecimalIF(
                                min: 0,
                                max: 10000
                            )
                        )
                        .padding(.horizontal, 60)
                        
                        // MARK: User Height
                        BoldSubHeadline(text:"What is your current Height")
                            .padding(.top, 10)
                        
                        InputField(
                            placeHolder: viewModel.lengthUnit(viewContext),
                            text: $viewModel.height,
                            variant: DecimalIF(
                                min: 0,
                                max: 1000
                            )
                        )
                        .padding(.horizontal, 60)
                        
                        BoldSubHeadline(text: "What is your (biological) gender")
                            .padding(.top, 10)
                        
                        // MARK: User Gender
                        BasicSegPicker(
                            selectedSegment: $viewModel.selectedGenderSegment,
                            segments: viewModel.genderSegments
                        )
                        .padding(.horizontal, 55)
                        
                    }
                }
                    
                Button {
                    
                    if GlobalInputFieldValidator.allFieldsValid() {
                        
                        viewModel.saveEntry(viewContext: viewContext)
                        
                        viewModel.navPath.append(1)
                        
                    }
                    
                } label: {
                    
                    Text("Continue")
                        .frame(width: 100, height: 40)
                        .foregroundColor(Color("buttonTextColor"))
                    
                }
                .buttonStyle(.borderedProminent)
                .padding(.vertical, 20)
        })
        
    }
    
}
    

#Preview {
    
    let context = PersistenceController.previewViewContext
    
    return CreateNewProfile1View()
        .environmentObject(ViewRouter())
        .environment(\.managedObjectContext, context)
    
}
