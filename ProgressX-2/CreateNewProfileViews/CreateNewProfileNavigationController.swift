//
//  CreateNewProfileNavigationController.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-04.
//

import SwiftUI

struct CreateNewProfileNavigationController<Content: View>: View {
    
    var content: Content
    
    @EnvironmentObject var viewRouter: ViewRouter
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @Binding var navPath: [Int]
    
    init(@ViewBuilder content: () -> Content, navPath: Binding<[Int]>) {
        self._navPath = navPath
        self.content = content()
    }
    
    var body: some View {
        NavigationStack(path: $navPath) {
            VStack {
                content
            }
            .navigationDestination(for: Int.self) { selection in
                if selection == 1 {
                    
                    CreateNewProfile2(navPath: $navPath)
                        .environmentObject(viewRouter)
                        .environment(\.managedObjectContext, viewContext)
                    
                } else if selection == 2 {
                    
                    CreateNewProfile3(navPath: $navPath)
                        .environment(\.managedObjectContext, viewContext)
                    
                } else if selection == 3 {
                    
                    CreateNewProfile4(navPath: $navPath)
                        .environmentObject(viewRouter)
                        .environment(\.managedObjectContext, viewContext)
                }
            }
        }
    }
}

