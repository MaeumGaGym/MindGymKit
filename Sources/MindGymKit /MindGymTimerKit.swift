//
//  File.swift
//  
//
//  Created by 박준하 on 12/28/23.
//

import UIKit
import RxSwift

// MARK: - MindGymTimerKit
open class MindGymTimerKit {
    public let mainTimer: TimerControl = MindGaGymKitTimer()

    public func setting(count: Double) {
        (mainTimer as? MindGaGymKitTimer)?.setting(count: count)
    }

    public func startTimer() {
        mainTimer.start()
    }

    public func stopTimer() {
        mainTimer.stop()
    }

    public func resetTimer() {
        mainTimer.reset()
    }

    public func restartTimer() {
        (mainTimer as? MindGaGymKitTimer)?.restart()
    }
}

