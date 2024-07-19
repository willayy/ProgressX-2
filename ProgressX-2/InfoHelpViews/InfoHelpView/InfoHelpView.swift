//
//  InfoHelpView.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-19.
//

import SwiftUI

struct InfoHelpView: View {
    
    @EnvironmentObject var viewRouter: ViewRouter
    @StateObject private var viewModel = InfoHelpViewModel()
    
    var body: some View {
        SideBarView(content: {
            NavigationStack {
                ScrollView {
                    VStack {
                        
                        BoldTitle(text: "Help / Information")
                        
                        LightSubHeadline(text: "Here you can find helpful information and how-to's for how this app works.")
                            .padding(.horizontal, 20)
                            .padding(.bottom, 20)
                        
                        Text("How-to's")
                            .font(.title2)
                        
                        ExpandingVStack(
                            title: "Weigh-in's and body tracking") {
                                Text("Placeholder")
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 10)
                        
                        ExpandingVStack(
                            title: "Creating and using exercises") {
                                Text("Placeholder")
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 10)
                        
                        ExpandingVStack(
                            title: "Creating a training routine") {
                                Text("Placeholder")
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 10)
                        
                        ExpandingVStack(
                            title: "Starting a workout") {
                                Text("Placeholder")
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 10)
                        
                        ExpandingVStack(
                            title: "Changing profile settings") {
                                Text("Placeholder")
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 20)
                        
                        Text("Other")
                            .font(.title2)
                        
                        ExpandingVStack(
                            title: "Report bugs, Developers, Contact") {
                                Text("Placeholder")
                            }
                            .padding(.horizontal, 20)
                            .padding(.bottom, 10)
                        
                        ExpandingVStack(
                            title: "Data management") {
                                Text("Placeholder")
                            }
                            .padding(.horizontal, 20)
                        
                    }.toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            SideBarButton(showMenu: $viewModel.showMenu)
                                .environmentObject(viewRouter)
                        }
                    }
                }
            }
        },
                    showMenu: $viewModel.showMenu)
    }
}

#Preview {
    InfoHelpView()
        .environmentObject(ViewRouter())
}
