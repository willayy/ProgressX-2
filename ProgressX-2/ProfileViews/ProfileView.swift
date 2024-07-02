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
    
    @State private var userName = ""
    @State private var birthDay = Date()
    @State private var selectedUnitSegment = "Metric (meters)"
    @State private var selectedGenderSegment = "Male"
    @State private var weight = ""
    @State private var height = ""
    
    @State private var showMenu: Bool = false
    @State private var userNameIsInvalid = false
    @State private var heightIsInvalid = false
    @State private var weightIsInvalid = false
    
    @State private var userNameIsInvalidMsg = ""
    @State private var heightIsInvalidMsg = ""
    @State private var weightIsInvalidMsg = ""
    
    let unitSegments = ["Metric (meters)", "Imperial (feet)"]
    let genderSegments = ["Male", "Female"]
    
    var body: some View {
        SideBar(
            rotateWhenExpands: true, // true
            disableInteractions: true, // true
            sideMenuWidth: 200,
            cornerRadius: 25, // 25
            showMenu: $showMenu
        ) { safeArea in
            NavigationStack{
                ScrollView{
                    
                    BoldTitle(text: "Profile")
                    
                    LightSubHeadline(text: "Here you can change/update the settings of your current profile")
                    
                    VStack(alignment:.center){
                        BoldSubHeadline(text: "Change username")
                    
                        
                        InputShortTextField(placeHolder: profiles.first!.profileUserName!, text: $userName, markAsWrong: $userNameIsInvalid, width: 0.5, errorMessage: $userNameIsInvalidMsg).padding(.bottom)
                    
                    BoldSubHeadline(text: "Change birth date")
                        DatePicker("", selection: $birthDay , displayedComponents: .date)
                        .datePickerStyle(DefaultDatePickerStyle())
                        .labelsHidden()
                        .padding(.bottom)
                        .onAppear(perform: {
                            birthDay = profiles.first!.birthDay!
                        })
                    
                        BoldSubHeadline(text: "Change default rest-time").padding(.bottom)
                        
                        
                    
                        
                    BoldSubHeadline(text: "Change Units")
                    BasicSegPicker(selectedSegment: $selectedUnitSegment, segments: unitSegments, frameWidth: 230, horizontalPadding: 20)
                            .onAppear(perform: {
                                if profiles.first!.isMetric == true {
                                    selectedUnitSegment = "Metric (meters)"
                                }
                                else {
                                    selectedUnitSegment = "Imperial (feet)"
                                }
                            })
                            .padding(.bottom)
                    
                    BoldSubHeadline(text: "Change height")
                    
                        InputDecimalNumberField(placeHolder: String(format: "%1.f", profiles.first!.height), numberText: $height, markAsWrong: $heightIsInvalid, width: 0.3, errorMessage: $heightIsInvalidMsg).padding(.bottom)
                    
                    BoldSubHeadline(text: "Gender")
                        BasicSegPicker(selectedSegment: $selectedGenderSegment, segments: genderSegments, frameWidth: 230, horizontalPadding: 20).onAppear(perform: {
                            selectedGenderSegment = profiles.first!.gender!.capitalized
                        })
                        
                        Button(action: {
                            
                            // action for saving
                            if userName != "" {
                                profiles.first?.profileUserName = userName
                            }
                            
                            profiles.first?.birthDay = birthDay
                            
                            if selectedUnitSegment == "Metric (meters)" {
                                profiles.first?.isMetric = true
                            } else {
                                profiles.first?.isMetric = false
                            }

                            if height != "" {
                                profiles.first?.height = Double(height)!
                            }

                            profiles.first?.gender = selectedGenderSegment
                            
                            PersistenceController.save(viewContext)
                            
                        
                            
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
                        
                        
                        
                    
                    
                }.padding()
                    .frame(width: 390, height: 650, alignment: .top)
                    .toolbar(.hidden, for: .tabBar)
                    .foregroundColor(Color(UIColor.lightGray))
                    
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            SideBarButton(showMenu: $showMenu).environmentObject(viewRouter)
                        }
                    }
                
            }
        }
        }menuView: { safeArea in
            SideBarMenuView(safeArea)
        } Background: {
            // propperty of the background in side menu
            Rectangle()
        }
        
    }    
    @ViewBuilder
    func SideBarMenuView(_ safeArea: UIEdgeInsets) -> some View {
        SideBarBuilder(safeArea: safeArea, showMenu: $showMenu)
            .environmentObject(viewRouter)
    }
    

}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    
    return ProfileView()
        .environmentObject(ViewRouter())
        .environment(\.managedObjectContext, context)
}
