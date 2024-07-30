//
//  CreateNewProfile2.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-04-22.
//

import Foundation
import SwiftUI

struct CreateNewProfile2View: View {
    
    @Binding var navPath: [Int]
    
    var body: some View {
 
        VStack(alignment: .center, spacing: 10) {
            
            Text("Great job!")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .minimumScaleFactor(0.5);
             
            Text("We would like you to provide some extra information to set up your profile correctly. This data will only be saved locally.")
                .font(.subheadline)
                .fontWeight(.light)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
                .minimumScaleFactor(0.5);
                
            Button {
                navPath.append(2)
            } label: {
                Text("Yes, let's continue!")
                    .frame(maxWidth: .infinity)
                    .frame(width: 100, height: 50)
                    .foregroundColor(Color("buttonTextColor"))
            }
            .buttonStyle(.borderedProminent)
            .padding(.top, 20)
            
        }
    }
}
    
#Preview {
    @State var navPath = [Int]()
    let context = PersistenceController.preview.container.viewContext
    return CreateNewProfile2View(navPath: $navPath)
            .environmentObject(ViewRouter())
            .environment(\.managedObjectContext, context)
}
