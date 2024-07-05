//
//  ContentView.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-04-12.
//

import SwiftUI
import CoreData

struct HomeView: View {
        
    @Environment(\.managedObjectContext) private var viewContext
    
    @EnvironmentObject var viewRouter: ViewRouter
    
    // View propperties
    @State private var showMenu: Bool = false
    var FirstBubbleHeight: CGFloat = 200
    var FirstBubbleWidth: CGFloat = 300
    var CornerRadius: CGFloat = 15
    
    var body: some View {
        SideBarView(content: {
            NavigationStack {
                ScrollView {
                    VStack(alignment: .center) {
                        
                        BoldTitle(text: "Home")
                        
                        Rectangle()
                            .frame(
                                width: FirstBubbleWidth,
                                height: FirstBubbleHeight,
                                alignment: .top
                            )
                            .cornerRadius(CornerRadius)
                            .foregroundStyle(.gray)
                        
                        Rectangle()
                            .frame(
                                width: FirstBubbleWidth,
                                height: FirstBubbleHeight,
                                alignment: .top
                            )
                            .cornerRadius(CornerRadius)
                            .foregroundStyle(.gray)
                        
                        Rectangle()
                            .frame(
                                width: FirstBubbleWidth,
                                height: FirstBubbleHeight,
                                alignment: .top
                            )
                            .cornerRadius(CornerRadius)
                            .foregroundStyle(.gray)
                        
                        Rectangle()
                            .frame(
                                width: FirstBubbleWidth,
                                height: FirstBubbleHeight,
                                alignment: .top
                            )
                            .cornerRadius(CornerRadius)
                            .foregroundStyle(.gray)
                    }
                    .frame(maxWidth: .infinity)
                    .toolbar {
                        ToolbarItem(placement: .topBarLeading) {
                            SideBarButton(showMenu: $showMenu)
                                .environmentObject(viewRouter)
                        }
                    }
                }
            }
        }, showMenu: $showMenu)
        .environmentObject(viewRouter)
    }
}

#Preview {
    HomeView()
        .environmentObject(ViewRouter())
}
