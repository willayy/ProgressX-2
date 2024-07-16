//
//  SucessfulSubmitAlert.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-06-16.
//

import SwiftUI

struct SubmitAlert: View {
    
    let message: String
    let color: any ShapeStyle
    @Binding var showAlertState: Bool
    
    var body: some View {
        Text(message)
            .fontWeight(.light)
            .foregroundStyle(color)
            .padding(.bottom, 10)
            .onAppear(perform: {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        showAlertState = false
                    }
                }
            })
    }
}

#Preview {
    
    @State var showAlert: Bool = true
    
    return SubmitAlert(message: "Test", color: .green, showAlertState: $showAlert)
}
