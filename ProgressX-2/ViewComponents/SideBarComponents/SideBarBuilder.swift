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
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @EnvironmentObject var viewRouter: ViewRouter

    let safeArea: UIEdgeInsets
    
    @Binding var showMenu: Bool
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 12) {
                Text("ProgressX")
                    .foregroundColor(.white)
                    .font(.largeTitle.bold())
                    .padding(.bottom, 10)
                
                SideBarButton(.Home){
                    showMenu.toggle()
                    viewRouter.rootView = .HomeView
                }
                
                SideBarButton(.StartWorkout){
                    showMenu.toggle()
                }
                
                SideBarButton(.Routines){
                    viewRouter.rootView = .RoutineLibraryView
                    showMenu.toggle()
                }
                
                SideBarButton(.Exercises){
                    showMenu.toggle()
                    viewRouter.rootView = .ExerciseLibraryView
                }
                
                Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
                
                SideBarButton(.Profile){
                    showMenu.toggle()
                    viewRouter.rootView = .ProfileView
                    
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
        func SideBarButton(_ tab:Tab, onTap: @escaping() -> () = {}) -> some View {
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

        
        //Customise the buttons in the bar button menu
        enum Tab: String, CaseIterable {
            case Home = "house.fill"
            case StartWorkout = "figure.run"
            case Routines = "rectangle.stack"
            case Exercises = "dumbbell"
            case Profile = "person.crop.circle"
            
            var title: String {
                switch self {
                case .Home: return "Home"
                case .StartWorkout: return "Start workout"
                case .Routines: return "Routines"
                case .Exercises: return "Exercises"
                case .Profile: return "Profile"
                }
            }
        }
    }


