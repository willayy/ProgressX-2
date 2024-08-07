//
//  Timer.swift
//  ProgressX-2
//
//  Created by lucas häyhänen on 2024-07-24.
//

import SwiftUI

#warning("Delete this unused Struct / File ?")

struct TimerViewthr: View {
    @Binding public var countdownTimer: Int
    @Binding public var timerRunning: Bool
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack {
            ZStack{
                Rectangle()
                    .frame(width: 200, height: 150)
                    .cornerRadius(15)
                Text("\(countdownTimer)")
                    .padding()
                    .onReceive(timer) { _ in
                        if countdownTimer > 0 && timerRunning {
                            countdownTimer -= 1
                        } else {
                            timerRunning = false
                        }
                        
                    }
                    .font(.system(size: 60, weight: .bold))
                    .foregroundColor(.blue)

            }
            
        }
    }
    public func startTimer(){
        timerRunning = true
    }
    
    public func resetTimer(int: Int){
        countdownTimer = int
    }
}

#Preview {
    
    @State var countDownTimer: Int = 10
    @State var timerRunning: Bool = false
    
    return TimerViewthr(
        countdownTimer: $countDownTimer,
        timerRunning: $timerRunning
    )
    
}
