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
    
    @Environment(\.managedObjectContext) private var viewContext
    
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
        SideBarBuilder(safeArea: safeArea, showMenu: $showMenu)
            .environmentObject(viewRouter)
    }
}


#Preview {
    HomeView().environmentObject(ViewRouter())
}
