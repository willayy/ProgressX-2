//
//  SideBarView.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-05.
//

import SwiftUI

struct SideBarView<Content: View>: View {
    
    var content: Content
    @StateObject private var showMenuController = ShowMenuController()
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        SideBar() { safeArea in
            VStack {
                content
            }
        } menuView: { safeArea in
            SideBarMenuView(safeArea)
        } Background: {
            // propperty of the background in side menu
            Rectangle()
        }
        .environmentObject(showMenuController)
    }
    
    @ViewBuilder
    func SideBarMenuView(_ safeArea: UIEdgeInsets) -> some View {
        SideBarBuilder(safeArea: safeArea)
    }
    
}
