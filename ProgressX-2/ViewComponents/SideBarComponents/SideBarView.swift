//
//  SideBarView.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-05.
//

import SwiftUI

struct SideBarView<Content: View>: View {
    
    var content: Content
    @Binding var showMenu: Bool
    
    init(showMenu: Binding<Bool>, @ViewBuilder content: () -> Content) {
        self._showMenu = showMenu
        self.content = content()
    }
    
    var body: some View {
        SideBar(
            rotateWhenExpands: true,
            disableInteractions: true,
            sideMenuWidth: 200,
            cornerRadius: 25,
            showMenu: $showMenu
        ) { safeArea in
            VStack {
                content
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
    }
    
}
