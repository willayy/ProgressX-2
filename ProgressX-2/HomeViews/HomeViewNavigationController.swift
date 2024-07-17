//
//  HomeViewNavigationController.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-17.
//

import SwiftUI

struct HomeViewNavigationController<Content: View>: View {
    
    public var content: Content
    @EnvironmentObject var viewRouter: ViewRouter
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var navPath: [Int]
    @Binding var profile: Profile?
    
    init(
        @ViewBuilder content: () -> Content,
        navPath: Binding<[Int]>,
        profile: Binding<Profile?>
    ) {
        self._navPath = navPath
        self._profile = profile
        self.content = content()
    }
    
    var body: some View {
        NavigationStack(path: $navPath) {
            VStack {
                content
            }
            .navigationDestination(for: Int.self) { selection in
                if selection == 1 {
    
                    //MARK: WeighInView
                    WeighInView()
                        .environment(\.managedObjectContext, viewContext)
                    
                }
            }
        }
    }
}

/*
#Preview {
    HomeViewNavigationController()
}
*/
