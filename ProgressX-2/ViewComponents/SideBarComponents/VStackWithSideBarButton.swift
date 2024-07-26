//
//  VStackWithSideBarButton.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-26.
//

import SwiftUI

struct VStackWithSideBarButton<Content: View>: View {
    
    private let content: Content
    @EnvironmentObject var viewRouter: ViewRouter
    @Binding var showMenu: Bool
    
    var body: some View {
        VStack {
            
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                SideBarButton(showMenu: $showMenu)
                    .environmentObject(viewRouter)
            }
        }
    }
}
