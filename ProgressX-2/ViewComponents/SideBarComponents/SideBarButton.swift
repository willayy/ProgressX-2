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
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @EnvironmentObject var viewRouter: ViewRouter
    
    @Binding var showMenu: Bool
    
    var body: some View {
        Button(action: { showMenu.toggle()}, label: {
            Image(systemName: showMenu ? "xmark" : "line.3.horizontal")
                .foregroundColor(Color.primary)
                .contentTransition(.symbolEffect)
        })
    }
}
