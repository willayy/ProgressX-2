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
    
    @Environment(\.managedObjectContext) private var viewContext
        
    @Binding var navPath: [Int]
    
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
            
            HStack(spacing: 20) {
                
                Button {
                    goToHomeView()
                } label: {
                    Text("No, im good!")
                        .frame(maxWidth: .infinity)
                        .frame(width: 100, height: 50)
                }
                    .buttonStyle(.borderedProminent)
                
                Button {
                    navPath.append(3)
                } label: {
                    Text("Yes, let's continue")
                        .frame(maxWidth: .infinity)
                        .frame(width: 100, height: 50)
                }
                    .buttonStyle(.borderedProminent)
                
            }
                .padding(.top, 20)
            
        }
    }
    
    private func goToHomeView() {
        viewRouter.rootView = .HomeView
    }
    
}
    
#Preview {
    @State var navPath = [Int]()
    let context = PersistenceController.preview.container.viewContext
    return CreateNewProfile2(navPath: $navPath)
            .environmentObject(ViewRouter())
            .environment(\.managedObjectContext, context)
}
