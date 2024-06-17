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
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                    withAnimation {
                        showAlertState = false
                    }
                }
            }
    }
}

#Preview {
    
    @State var showAlert: Bool = true
    
    return SubmitAlert(message: "Test", color: .green, showAlertState: $showAlert)
}
