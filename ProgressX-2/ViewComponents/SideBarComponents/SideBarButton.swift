//
//  SideBarButton.swift
//  ProgressX-2
//
//  Created by lucas häyhänen on 2024-06-18.
//

import Foundation
import SwiftUI
import CoreData

struct SideBarButton: View {
    
    @EnvironmentObject private var showMenuController: ShowMenuController
    
    var body: some View {
        Button(action: { showMenuController.showMenu.toggle() }, label: {
            Image(systemName: showMenuController.showMenu ? "xmark" : "line.3.horizontal")
                .foregroundColor(Color.primary)
                .contentTransition(.symbolEffect)
        })
    }
}
