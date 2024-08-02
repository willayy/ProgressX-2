//
//  TimerViewModel.swift
//  ProgressX-2
//
//  Created by lucas häyhänen on 2024-07-24.
//

import Foundation
import SwiftUI
import Foundation

final class TimerViewModel: ObservableObject {
    // Represents the different states the timer can be in
    enum TimerState {
        case active
        case paused
        case resumed
        case cancelled
    }
    @Published public var StartWorcoutNotification: Bool = false
    @Published public var Donebutton: Bool = false

    // MARK: Private Properties
    private var timer = Timer()
    private var totalTimeForCurrentSelection: Int {
        (selectedHoursAmount * 3600) + (selectedMinutesAmount * 60) + selectedSecondsAmount
    }
    
    static let timerDidFinishNotification = Notification.Name("timerDidFinishNotification")

    // MARK: Public Properties
    public var selectedHoursAmount: Int = 0
    public var selectedMinutesAmount: Int = 0
    public var selectedSecondsAmount: Int = 10
    @Published var state: TimerState = .cancelled {
        didSet {
            switch state {
            case .cancelled:
                timer.invalidate()
                secondsToCompletion = 0
                progress = 0

            case .active:
                startTimer()
                secondsToCompletion = totalTimeForCurrentSelection
                progress = 1.0
                
                updateCompletionDate()

            case .paused:
                timer.invalidate()

            case .resumed:
                startTimer()
                updateCompletionDate()
            }
        }
    }

    // Powers the ProgressView
    @Published var secondsToCompletion = 0
    @Published var progress: Float = 0.0
    @Published var completionDate = Date.now

    let hoursRange = 0...23
    let minutesRange = 0...59
    let secondsRange = 0...59

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { [weak self] _ in
            guard let self else { return }

            DispatchQueue.main.async {
                self.secondsToCompletion -= 1
                self.progress = Float(self.secondsToCompletion) / Float(self.totalTimeForCurrentSelection)
                
                if self.secondsToCompletion < 0 {
                    self.state = .cancelled
                    NotificationCenter.default.post(name: TimerViewModel.timerDidFinishNotification, object: nil)
                }
            }
        })
    }

    private func updateCompletionDate() {
        completionDate = Date.now.addingTimeInterval(Double(secondsToCompletion))
    }
}
