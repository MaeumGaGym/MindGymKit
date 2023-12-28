import UIKit
import RxSwift

// MARK: - MindGymStopWatchKit
open class MindGymStopWatchKit {
    public let mainStopwatch: TimerControl = Stopwatch()

    public func startTimer() {
        mainStopwatch.start()
    }

    public func stopTimer() {
        mainStopwatch.stop()
    }

    public func resetTimer() {
        mainStopwatch.reset()
    }

    public func recordTime() {
        (mainStopwatch as? Stopwatch)?.record()
    }
}
