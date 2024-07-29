//
//  TimerViewModel.swift
//  ProgressX-2
//
//  Created by lucas häyhänen on 2024-07-24.
//

import Foundation
import SwiftUI

final class TimerViewModel: ObservableObject {
    // Represents the different states the timer can be in
    enum TimerState {
        case active
        case paused
        case resumed
        case cancelled
    }

    // MARK: Private Properties
    private var timer = Timer()
    private var totalTimeForCurrentSelection: Int {
        (selectedHoursAmount * 3600) + (selectedMinutesAmount * 60) + selectedSecondsAmount
    }

    // MARK: Public Properties
    public var selectedHoursAmount: Int = 0
    public var selectedMinutesAmount: Int = 3
    public var selectedSecondsAmount: Int = 0
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

            self.secondsToCompletion -= 1
            self.progress = Float(self.secondsToCompletion) / Float(self.totalTimeForCurrentSelection)

            // We can't do <= here because we need the time from T-1 seconds to
            // T-0 seconds to animate through first
            if self.secondsToCompletion < 0 {
                self.state = .cancelled
            }
        })
    }

    private func updateCompletionDate() {
        completionDate = Date.now.addingTimeInterval(Double(secondsToCompletion))
    }
}
