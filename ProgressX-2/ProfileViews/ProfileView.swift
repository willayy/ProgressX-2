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
                VStack(alignment:.leading){
                    BoldSubHeadline(text: "Change Username")
                    InputShortTextField(placeHolder: "Enter username...", text: $userName, markAsWrong: $userNameIsInvalid, width: 0.5, errorMessage: $userNameIsInvalidMsg).padding(.bottom)
                    
                    Text("Change birthday").bold()
                    
                    Text("Change standard rest-time").bold()
                    
                    Text("Change weight units").bold()
                    
                    Text("Change length units").bold()
                    
                }.padding()
                    .frame(width: 390, height: 650, alignment: .topLeading)
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
