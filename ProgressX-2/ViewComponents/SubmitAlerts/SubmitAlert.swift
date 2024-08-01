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
    @State private var taskStarted: Bool = false
    
    var body: some View {
        
        Text(message)
            .fontWeight(.light)
            .foregroundStyle(color)
            .task {
                if !taskStarted { await startBackgroundTask()}
            }
            .onAppear(perform: {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        showAlertState = false
                    }
                }
            })
    }
    
    /* Background task that continously checks if the alertstate is true to prevent the alert from hanging up.
     There is a huge possibility that you might actually be able to create very many of these and crumble the processor or
     blow the call stack but there are some attempts (like .taskStarted) to stop this. */
    private func startBackgroundTask() async {
        if !taskStarted {
            taskStarted = true
            Task {
                while true {
                    try await Task.sleep(nanoseconds: 4_000_000_000)
                    await MainActor.run {
                        if showAlertState {
                            withAnimation {
                                showAlertState = false
                            }
                        }
                    }
                }
            }
        }
    }
}
