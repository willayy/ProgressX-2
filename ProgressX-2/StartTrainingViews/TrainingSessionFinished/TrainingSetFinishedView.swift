//
//  TrainingSetFinishedView.swift
//  ProgressX-2
//
//  Created by lucas häyhänen on 2024-08-05.
//

import Foundation
import SwiftUI

struct TrainingSetFinishedView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var viewRouter: ViewRouter
    @Binding var navPath: [Int]
    
    var body: some View {
        VStack{
            
            Title2(text: "Good job! You are now finished with this session")
                .padding(.horizontal, 40)
            
            // MARK: This button takes you back to the homeview
            Button(action:{
                
                // Uses view router to take user back to the homeview
                withAnimation {
                    viewRouter.rootView = .HomeView
                }
                
            }) {
                Text("Return to home")
                    .frame(width: 150, height: 40)
                    .foregroundColor(Color("buttonTextColor"))
            }
            .buttonStyle(BorderedProminentButtonStyle())
            .padding(.top, 10)
            
        }
        .navigationBarBackButtonHidden(true)
    }
}
#Preview {
    let context = PersistenceController.preview.container.viewContext
    @State var navPath: [Int] = [Int]()
    @State var selectedRoutine: Routine? = nil
    
    return TrainingSetFinishedView(
        navPath: $navPath
    )
    .environmentObject(ViewRouter())
    .environment(\.managedObjectContext, context)
}
