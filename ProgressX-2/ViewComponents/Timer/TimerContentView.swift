//
//  TimerView.swift
//  ProgressX-2
//
//  Created by lucas häyhänen on 2024-07-24.
//

import Foundation
import SwiftUI

struct TimerView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject public var viewModel = TimerViewModel()

    @Binding var selectedHoursAmount: Int
    @Binding var selectedMinutesAmount: Int
    @Binding var selectedSecondsAmount: Int
    @State public var StartWorcoutNotification: Bool = false
    static var Buttontoggle: Bool = false
    
var timerControls: some View {
    HStack {
        Button("Cancel") {
            viewModel.state = .cancelled
        }
        Spacer()
        switch viewModel.state {
        case .cancelled:
            Button("Start") {
                StartTimer()
            }
        case .paused:
            Button("Resume") {
                viewModel.state = .resumed
            }
        case .active, .resumed:
            Button("Pause") {
                viewModel.state = .paused
            }
        }
    }
    .padding(.horizontal, 32)
    

}
    public func StartTimer(){
        viewModel.selectedHoursAmount = selectedHoursAmount
        viewModel.selectedMinutesAmount = selectedMinutesAmount
        viewModel.selectedSecondsAmount = selectedSecondsAmount
        viewModel.state = .active
    }
    
    public func PauseTimer(){
        viewModel.state = .paused
    }
    
    public func ResumeTimer(){
        viewModel.state = .resumed
    }
    
    public func CancelTimer(){
        viewModel.state = .cancelled
    }


var progressView: some View {
    
        ZStack {
            withAnimation {
                CircleProgressView(progress: $viewModel.progress)
            }
            
            VStack {
                Text(viewModel.secondsToCompletion.asTimestamp)
                    .font(.largeTitle)
                    .foregroundColor(.black)
            }
            
        }
    
    .frame(width: 360, height: 255)
    .padding(.all, 32)
}

var body: some View {
    
    VStack {
        progressView
    }.alert("Start your next set", isPresented: $StartWorcoutNotification) {
        Button("OK", role: .cancel) {
            print(TimerView.Buttontoggle)}
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .foregroundColor(.white)
}
}

#Preview{
    let context = PersistenceController.preview.container.viewContext
    
    @State var selectedHoursAmount = 0
    @State var selectedMinutesAmount = 0
    @State var selectedSecondsAmount = 10
    return TimerView(selectedHoursAmount: $selectedHoursAmount, selectedMinutesAmount: $selectedMinutesAmount, selectedSecondsAmount: $selectedSecondsAmount)
        .environment(\.managedObjectContext, context)
}
