//
//  CreateNewProfile2.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-04-22.
//

import Foundation
import SwiftUI

struct CreateNewProfile2: View {
    
    @EnvironmentObject var viewRouter: ViewRouter
    
    private func goToHomeView() {
        viewRouter.rootView = "HomeView"
    }
    
    var body: some View {
 
        VStack(alignment: .center, spacing: 10) {
            
            Text("Great job!")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.5);
            
            Text("Do you wish to supply some extra data so we can set the correct PR's for some common exercises and make sure your profile body-metric's are correct? ")
                .font(.subheadline)
                .fontWeight(.light)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 30.0)
                .minimumScaleFactor(0.5);
            
            NavigationLink("Yes, let's continue",destination: CreateNewProfile3().environmentObject(viewRouter))
                .buttonStyle(.borderedProminent)
                .padding(.top, 20)
            
            Button("No thank you im good!", action: goToHomeView)
                .buttonStyle(.borderedProminent)
                .padding(.top, 10)
            
        }
    }
}
    
    
#Preview {
    CreateNewProfile2()
        .environmentObject(ViewRouter())
}
