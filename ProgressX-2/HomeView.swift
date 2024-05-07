//
//  ContentView.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-04-12.
//

import SwiftUI
import CoreData

struct HomeView: View {
    
    @EnvironmentObject var viewRouter: ViewRouter
    
        var body: some View {
            NavigationView {
                Text("Homeview")
            }
        }
}

#Preview {
    HomeView()
}

