//
//  VStackWithSideBarButton.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-26.
//

import SwiftUI

struct VStackWithSideBarButton<Content: View>: View {
    
    private let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        VStack {
            content
        }
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                SideBarButton()
            }
        }
    }
}
