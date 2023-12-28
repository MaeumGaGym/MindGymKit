import UIKit
import RxSwift

// MARK: - Stopwatch
public protocol TimerControl {
    func start()
    func stop()
    func reset()
    func record()
}

public class Stopwatch: NSObject, TimerControl {
    private var counter: Double = 0.0
    private var timer: Timer?
    private var lapTimes: [Double] = []
    private let timeSubject = PublishSubject<String>()
    private let recordSubject = PublishSubject<[String]>()
    
    public var timeUpdate: Observable<String> {
        return timeSubject.asObservable()
    }
    
    public var recordUpdate: Observable<[String]> {
        return recordSubject.asObservable()
    }
    
    public func start() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.035, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.counter += 0.035
            let timeString = self.timeString(from: self.counter)
            self.timeSubject.onNext(timeString)
        }
    }
    
    public func stop() {
        timer?.invalidate()
        timer = nil
    }
    
    public func reset() {
        counter = 0
        lapTimes.removeAll()
    }
    
    public func record() {
        lapTimes.append(counter)
        let lapTimesString = lapTimes.map { timeString(from: $0) }
        recordSubject.onNext(lapTimesString)
    }
    
    private func timeString(from counter: Double) -> String {
        let minutes: String = String(format: "%02d", Int(counter / 60))
        let seconds: String = String(format: "%02d", Int(counter.truncatingRemainder(dividingBy: 60)))
        let milliseconds: String = String(format: "%02d", Int((counter * 100).truncatingRemainder(dividingBy: 100)))
        return "\(minutes):\(seconds).\(milliseconds)"
    }
}

