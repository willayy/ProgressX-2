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
    
    var body: some View {
        VStack{
            
            BoldTitle(text: "Good job!")
                .padding(.bottom, 10)
            
            Title2(text: "You are now finished with this session")
                .padding(.horizontal, 40)
                .padding(.bottom, 10)
            
            // MARK: This button takes you back to the homeview
            Button(action:{
                
                // Uses view router to take user back to the homeview
                withAnimation {
                    viewRouter.rootView = .HomeView
                }
                
            }) {
                Text("Return to home screen")
                    .frame(width: 200, height: 40)
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
    @State var selectedRoutine: Routine? = nil
    
    return TrainingSetFinishedView()
        .environmentObject(ViewRouter())
        .environment(\.managedObjectContext, context)
}
