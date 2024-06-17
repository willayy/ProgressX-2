//
//  ContentView.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-04-12.
//

import SwiftUI
import CoreData

struct HomeView: View {
    @State var showView = false
    @State var selectedTab = 0
    
    @EnvironmentObject var viewRouter: ViewRouter
    // View propperties
    @State private var showMenu: Bool = false
    var BackgroundHeight: CGFloat = 650
    var FirstBubbleHeigh: CGFloat = 200
    var FirstBubbleWidth: CGFloat = 350
    var CornerRadius: CGFloat = 15
    
        var body: some View {
            SideBar(
                rotateWhenExpands: true, // true
                disableInteractions: true, // true
                sideMenuWidth: 200,
                cornerRadius: 25, // 25
                showMenu: $showMenu
            ) { safeArea in
                TabView(selection: $selectedTab) {
                    
                    // HomeTab
                    NavigationStack{
                        ScrollView{
                            VStack{
                                Rectangle().frame(width: FirstBubbleWidth, height: FirstBubbleHeigh, alignment: .top)
                                    .cornerRadius(CornerRadius)
                                Rectangle().frame(width: FirstBubbleWidth, height: FirstBubbleHeigh, alignment: .top)
                                    .cornerRadius(CornerRadius)
                                Rectangle().frame(width: FirstBubbleWidth, height: FirstBubbleHeigh, alignment: .top)
                                    .cornerRadius(CornerRadius)
                                Rectangle().frame(width: FirstBubbleWidth, height: FirstBubbleHeigh, alignment: .top)
                                    .cornerRadius(CornerRadius)
                            }
                            .toolbar(.hidden, for: .tabBar)
                            .foregroundColor(Color(UIColor.lightGray))
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
                    }.tag(0)
                    
                    //StatisticsTab
                    NavigationStack{
                        ScrollView{
                            VStack{
                                NavigationLink(destination: Statistics()){
                                    Rectangle().frame(width: FirstBubbleWidth, height: FirstBubbleHeigh, alignment: .top)
                                        .cornerRadius(CornerRadius)
                                }
                                Rectangle().frame(width: FirstBubbleWidth, height: FirstBubbleHeigh, alignment: .top)
                                    .cornerRadius(CornerRadius)
                                Rectangle().frame(width: FirstBubbleWidth, height: FirstBubbleHeigh, alignment: .top)
                                    .cornerRadius(CornerRadius)
                                Rectangle().frame(width: FirstBubbleWidth, height: FirstBubbleHeigh, alignment: .top)
                                    .cornerRadius(CornerRadius)
                            }
                            .toolbar(.hidden, for: .tabBar)
                            .foregroundColor(Color(UIColor.lightGray))
                            .navigationTitle("Statistics")
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
                    }.tag(1)
                    
                    NavigationStack{
                        ScrollView{
                            VStack{
                                Rectangle().frame(width: FirstBubbleWidth, height: FirstBubbleHeigh, alignment: .top)
                                    .cornerRadius(CornerRadius)
                                Rectangle().frame(width: FirstBubbleWidth, height: FirstBubbleHeigh, alignment: .top)
                                    .cornerRadius(CornerRadius)
                                Rectangle().frame(width: FirstBubbleWidth, height: FirstBubbleHeigh, alignment: .top)
                                    .cornerRadius(CornerRadius)
                                Rectangle().frame(width: FirstBubbleWidth, height: FirstBubbleHeigh, alignment: .top)
                                    .cornerRadius(CornerRadius)
                            }
                            .toolbar(.hidden, for: .tabBar)
                            .foregroundColor(Color(UIColor.lightGray))
                            .navigationTitle("Routines")
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
                    }.tag(2)
                    
                    NavigationStack{
                        ScrollView{
                            VStack{
                                Rectangle().frame(width: FirstBubbleWidth, height: FirstBubbleHeigh, alignment: .top)
                                    .cornerRadius(CornerRadius)
                                Rectangle().frame(width: FirstBubbleWidth, height: FirstBubbleHeigh, alignment: .top)
                                    .cornerRadius(CornerRadius)
                                Rectangle().frame(width: FirstBubbleWidth, height: FirstBubbleHeigh, alignment: .top)
                                    .cornerRadius(CornerRadius)
                                Rectangle().frame(width: FirstBubbleWidth, height: FirstBubbleHeigh, alignment: .top)
                                    .cornerRadius(CornerRadius)
                            }
                            .toolbar(.hidden, for: .tabBar)
                            .foregroundColor(Color(UIColor.lightGray))
                            .navigationTitle("Exercises")
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
                    }.tag(3)
                    
                    NavigationStack{
                        ScrollView{
                            VStack{
                                Rectangle().frame(width: FirstBubbleWidth, height: FirstBubbleHeigh, alignment: .top)
                                    .cornerRadius(CornerRadius)
                                Rectangle().frame(width: FirstBubbleWidth, height: FirstBubbleHeigh, alignment: .top)
                                    .cornerRadius(CornerRadius)
                                Rectangle().frame(width: FirstBubbleWidth, height: FirstBubbleHeigh, alignment: .top)
                                    .cornerRadius(CornerRadius)
                                Rectangle().frame(width: FirstBubbleWidth, height: FirstBubbleHeigh, alignment: .top)
                                    .cornerRadius(CornerRadius)
                            }
                            .toolbar(.hidden, for: .tabBar)
                            .foregroundColor(Color(UIColor.lightGray))
                            .navigationTitle("Profile")
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
                    }.tag(4)
                    
                    
                    
                }
            } menuView: { safeArea in
                SideBarMenuView(safeArea)
            } Background: {
                // propperty of the background in side menu
                Rectangle()
                
            }

        }
        
        
        
        
        @ViewBuilder
    func SideBarMenuView(_ safeArea: UIEdgeInsets) -> some View {
        NavigationView{
            VStack(alignment: .leading, spacing: 12) {
                
                Text("ProgressX")
                    .font(.largeTitle.bold())
                    .padding(.bottom, 10)
                    
                    SideBarButton(.home){
                        selectedTab = 0
                        showMenu.toggle()
                    }
                    SideBarButton(.Statistics){
                        selectedTab = 1
                        showMenu.toggle()
                    }
                
                    SideBarButton(.Routines){
                        selectedTab = 2
                        showMenu.toggle()
                    }
                
                    SideBarButton(.Exercises){
                        selectedTab = 3
                        showMenu.toggle()
                    }
                
                
                    
                    Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
                    
                    SideBarButton(.Profile){
                        selectedTab = 4
                        showMenu.toggle()
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
    
    func PlaceNewView() {
        print("hej")
    }
    
    //Customise the buttons in the bar button menu
    enum Tab: String, CaseIterable {
        case home = "house.fill"
        case Statistics = "chart.xyaxis.line"
        case Routines = "rectangle.stack"
        case Exercises = "dumbbell"
        case Profile = "person.crop.circle"
        
        var title: String {
            switch self {
            case .home: return "Home"
            case .Statistics: return "Statistics"
            case .Routines: return "Routines"
            case .Exercises: return "Exercises"
            case .Profile: return "Profile"
            }
        }
    }
}


#Preview {
    HomeView().environmentObject(ViewRouter())
}
