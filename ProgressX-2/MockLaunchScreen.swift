//
//  MockLaunchScreen.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-06-16.
//

import SwiftUI

struct MockLaunchScreen: View {
    var body: some View {
        VStack {
            
            Text("ProgressX-2")
                .font(.largeTitle)
                .bold()
                .animation(.smooth)
            
            Text("Linear progression, routine building and statistics")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 62)
            
            ProgressView()
                .scaleEffect(CGSize(width: 3.0, height: 3.0))
                .padding(.top, 25)
            
        }
    }
}

#Preview {
    MockLaunchScreen()
}
