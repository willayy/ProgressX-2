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
                    VStack(alignment:.center){
                    BoldSubHeadline(text: "Change Username")
                    InputShortTextField(placeHolder: "Enter username...", text: $userName, markAsWrong: $userNameIsInvalid, width: 0.5, errorMessage: $userNameIsInvalidMsg).padding(.bottom)
                    
                    BoldSubHeadline(text: "Birth date")
                    DatePicker("", selection: $birthDay, displayedComponents: .date)
                        .datePickerStyle(DefaultDatePickerStyle())
                        .labelsHidden()
                        .padding(-3)
                    
                    Text("Change default rest-time").bold()
                        
                    
                    BoldSubHeadline(text: "Change Units")
                    BasicSegPicker(selectedSegment: $selectedUnitSegment, segments: unitSegments, frameWidth: 230, horizontalPadding: 20)
                    
                    BoldSubHeadline(text: "Change height")
                    let lengthUnit = (selectedUnitSegment == "Metric (meters)") ? "m" : "ft"
                    InputDecimalNumberField(placeHolder: lengthUnit, numberText: $height, markAsWrong: $heightIsInvalid, width: 0.3, errorMessage: $heightIsInvalidMsg)
                    
                    BoldSubHeadline(text: "Gender")
                    BasicSegPicker(selectedSegment: $selectedGenderSegment, segments: genderSegments, frameWidth: 230, horizontalPadding: 20)
                    
                    
                }.padding()
                    .frame(width: 390, height: 650, alignment: .top)
                    .toolbar(.hidden, for: .tabBar)
                    .foregroundColor(Color(UIColor.lightGray))
                    .navigationTitle("Profile")
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
    ProfileView().environmentObject(ViewRouter())
}
