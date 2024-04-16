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
        var body: some View {
            NavigationView {
                Text("Homeview")
            }
        }
}

#Preview {
    HomeView()
}

