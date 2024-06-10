//
//  ContentView.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-04-12.
//

import SwiftUI
import CoreData

struct HomeView: View {
    
    @EnvironmentObject var viewRouter: ViewRouter
    // View propperties
    @State private var showMenu: Bool = false
    
        var body: some View {
            SideBar(
                rotateWhenExpands: true, // true
                disableInteractions: true, // true
                sideMenuWidth: 200,
                cornerRadius: 25, // 25
                showMenu: $showMenu
            ) { safeArea in
                NavigationStack{
                    List{
                        NavigationLink("Detail View") {
                            Text("hello")
                                .navigationTitle("Detail")
                        }
                    }
                    .navigationTitle("Home")
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            Button(action: { showMenu.toggle()}, label: {
                                Image(systemName: showMenu ? "xmark" : "line.3.horizontal")
                                    .foregroundColor(Color.primary)
                                    .contentTransition(.symbolEffect)
                            })
                        }
                    }
                }
            } menuView: { safeArea in
                SideBarMenuView(safeArea)
            } Background: {
                Rectangle()
                    
            }
        }
        
        @ViewBuilder
    func SideBarMenuView(_ safeArea: UIEdgeInsets) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("ProgressX")
                .font(.largeTitle.bold())
                .padding(.bottom, 10)
            
            SideBarButton(.home)
            SideBarButton(.Statistics)
            SideBarButton(.Routines)
            SideBarButton(.Exercises)
            SideBarButton(.Settings)
            
            Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
                
            SideBarButton(.Profile)
            
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
        case home = "house.fill"
        case Statistics = "chart.xyaxis.line"
        case Routines = "rectangle.stack"
        case Exercises = "dumbbell"
        case Settings = "slider.horizontal.3"
        case Profile = "person.crop.circle"
        
        var title: String {
            switch self {
            case .home: return "Home"
            case .Statistics: return "Statistics"
            case .Routines: return "Routines"
            case .Exercises: return "Exercises"
            case .Settings: return "Settings"
            case .Profile: return "Profile"
            }
        }
    }
}

#Preview {
    HomeView()
}
