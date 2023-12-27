import UIKit
import HealthKit
import RxSwift

public class MindGymKit {
    public init() {}
    
    public func fetchTodayStepCount(completion: @escaping (Double?) -> Void) {
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(nil)
            return
        }
        
        let healthStore = HKHealthStore()
        let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        let calendar = Calendar.current
        let now = Date()
        let startOfDay = calendar.startOfDay(for: now)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: endOfDay, options: .strictStartDate)
        
        healthStore.requestAuthorization(toShare: nil, read: [stepType]) { (success, error) in
            if success {
                let query = HKStatisticsQuery(quantityType: stepType, quantitySamplePredicate: predicate, options: .cumulativeSum) { query, result, error in
                    if let result = result, let sum = result.sumQuantity() {
                        completion(sum.doubleValue(for: HKUnit.count()))
                    } else {
                        completion(nil)
                        if let error = error {
                            print("걸음 수 가져오기 오류: \(error.localizedDescription)")
                        }
                    }
                }
                healthStore.execute(query)
            } else {
                completion(nil)
                if let error = error {
                    print("HealthKit 권한 요청 중 오류 발생: \(error.localizedDescription)")
                }
            }
        }
    }
}

public class Stopwatch: NSObject {
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
    
    func start() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.035, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.counter += 0.035
            let timeString = self.timeString(from: self.counter)
            self.timeSubject.onNext(timeString)
        }
    }
    
    func stop() {
        timer?.invalidate()
        timer = nil
    }
    
    func reset() {
        counter = 0
        lapTimes.removeAll()
    }
    
    func record() {
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

public class MindGymStopWatchKit {
    
    public let mainStopwatch: Stopwatch = Stopwatch()
    
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
        mainStopwatch.record()
    }
}

public class MindGaGymKitTimer: NSObject {
    private var initCounter: Double = 0.0
    private var counter: Double = 0.0
    private var timer: Timer?
    private let timerSubject = PublishSubject<String>()
    
    public var timeUpdate: Observable<String> {
        return timerSubject.asObservable()
    }
    
    func setting(count: Double) {
        initCounter = count
        self.counter = count
        let timeString = self.timeString(from: self.counter)
        self.timerSubject.onNext(timeString)
    }
    
    func start() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.035, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.counter -= 0.035
            let timeString = self.timeString(from: self.counter)
            self.timerSubject.onNext(timeString)
        }
    }
    
    func stop() {
        timer?.invalidate()
        timer = nil
    }

    func restart() {
        counter = initCounter
        let timeString = self.timeString(from: self.counter)
        self.timerSubject.onNext(timeString)
    }

    func reset() {
        counter = 0.0
        initCounter = 0.0
        let timeString = self.timeString(from: self.counter)
        self.timerSubject.onNext(timeString)
    }
    
    private func timeString(from counter: Double) -> String {

        if counter == 0 {
            stop()
        }
        
        let hours: String = String(format: "%02d", Int(counter / 3600))
        let minutes: String = String(format: "%02d", Int(counter / 60))
        let seconds: String = String(format: "%02d", Int(counter.truncatingRemainder(dividingBy: 60)))
        if counter / 3600 >= 1  {
            return "\(hours) : \(minutes) : \(seconds)"
        } else if counter / 60 > 1 {
            return "\(minutes) : \(seconds)"
        } else {
            return "\(minutes) : \(seconds)"
        }
    }
}

public class MindGymTimerKit {
        
    public let mainTimer: MindGaGymKitTimer = MindGaGymKitTimer()
    
    public func setting(count: Double) {
        mainTimer.setting(count: count)
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
        mainTimer.restart()
    }

}
