//
//  SideBarBuilder.swift
//  ProgressX-2
//
//  Created by lucas häyhänen on 2024-06-18.
//

import Foundation
import SwiftUI
import CoreData

struct SideBarBuilder: View {
    
    @EnvironmentObject var viewRouter: ViewRouter
    let safeArea: UIEdgeInsets
    @EnvironmentObject private var showMenuController: ShowMenuController
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 12) {
                Text("ProgressX")
                    .foregroundColor(.white)
                    .font(.largeTitle.bold())
                    .padding(.bottom, 10)
                
                SideBarButton(.Home) {
                    viewRouter.rootView = .HomeView
                    showMenuController.showMenu.toggle()
                }
                
                SideBarButton(.StartWorkout) {
                    viewRouter.rootView = .StartWorkoutView
                    showMenuController.showMenu.toggle()
                }
                
                SideBarButton(.Routines) {
                    viewRouter.rootView = .RoutineLibraryView
                    showMenuController.showMenu.toggle()
                }
                
                SideBarButton(.Exercises) {
                    viewRouter.rootView = .ExerciseLibraryView
                    showMenuController.showMenu.toggle()
                }
                
                SideBarButton(.SessionHistory) {
                    viewRouter.rootView = .ChooseSessionHistoryView
                    showMenuController.showMenu.toggle()
                }
                
                SideBarButton(.InfoHelp) {
                    viewRouter.rootView = .InfoHelp
                    showMenuController.showMenu.toggle()
                }
                
                Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
                
                SideBarButton(.Profile) {
                    viewRouter.rootView = .ProfileView
                    showMenuController.showMenu.toggle()
                }
            }
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 20)
        .padding(.top, safeArea.top)
        .padding(.bottom, safeArea.bottom)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .environment(\.colorScheme, .dark)
        
    }
        
        @ViewBuilder
        func SideBarButton(_ tab: Tab, onTap: @escaping() -> () = {}) -> some View {
            Button(action: onTap, label: {
                HStack(spacing: 12) {
                    Image(systemName: tab.rawValue)
                        .font(.title3)
                    Text(tab.title)
                        .font(.callout)
                    Spacer(minLength: 0)
                    
                }
                .padding(.vertical, 10)
                .contentShape(.rect)
                .foregroundStyle(Color.primary)
                
            })
        }
    }


