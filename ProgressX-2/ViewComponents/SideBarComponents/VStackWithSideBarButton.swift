//
//  VStackWithSideBarButton.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-26.
//

import SwiftUI

struct VStackWithSideBarButton<Content: View>: View {
    
    private let content: Content
    @Binding var showMenu: Bool
    
    init(showMenu: Binding<Bool>, @ViewBuilder content: () -> Content) {
        self._showMenu = showMenu
        self.content = content()
    }
    
    var body: some View {
        VStack {
            content
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                SideBarButton(showMenu: $showMenu)
            }
        }
    }
}
