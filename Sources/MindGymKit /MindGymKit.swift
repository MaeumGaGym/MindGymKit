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
    var counter: Double
    var timer: Timer?
    var lapTimes: [Double] = []

    
    override init() {
        counter = 0.0
        timer = nil
    }
    
    func start() {
        timer = Timer.scheduledTimer(timeInterval: 0.035, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
    }
    
    func stop() {
        timer?.invalidate()
        timer = nil
    }
    
    func reset() {
        counter = 0
    }
    
    @objc private func updateCounter() {
        counter += 0.035
    }
}

public class MindGymStopWatchKit {

    public init () {}
    
    public let mainStopwatch: Stopwatch = Stopwatch()
    
    public func updateTimer(_ stopwatch: Stopwatch, label: UILabel) {
        let minutes: String = String(format: "%02d", Int(stopwatch.counter / 60))
        let seconds: String = String(format: "%02d", Int(stopwatch.counter.truncatingRemainder(dividingBy: 60)))
        let milliseconds: String = String(format: "%02d", Int((stopwatch.counter * 100).truncatingRemainder(dividingBy: 100)))
        let timeString = "\(minutes):\(seconds).\(milliseconds)"
        
        DispatchQueue.main.async { [weak label] in
            label?.text = timeString
        }
    }
    
    public func startTimer(label: UILabel) {
        mainStopwatch.start()
        
        mainStopwatch.timer = Timer.scheduledTimer(withTimeInterval: 0.035, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            updateTimer(mainStopwatch, label: label)
        }
    }
    
    public func stopTimer() {
        mainStopwatch.stop()
        mainStopwatch.timer?.invalidate()
        mainStopwatch.timer = nil
    }
    
    public func resetTimer(label: UILabel) {
        mainStopwatch.reset()
        updateTimer(mainStopwatch, label: label)
        resetRecord()
    }
    
    public func resetRecord() {
        mainStopwatch.lapTimes.removeAll()
    }
    
    public func recordTime() {
        mainStopwatch.lapTimes.append(mainStopwatch.counter)
        printLapTimes()
    }
    
    public func printLapTimes() {
        print("Lap Times:")
        for (index, lapTime) in mainStopwatch.lapTimes.enumerated() {
            let minutes: String = String(format: "%02d", Int(lapTime / 60))
            let seconds: String = String(format: "%02d", Int(lapTime.truncatingRemainder(dividingBy: 60)))
            let milliseconds: String = String(format: "%02d", Int((lapTime * 100).truncatingRemainder(dividingBy: 100)))
            let lapTimeString = "\(minutes):\(seconds).\(milliseconds)"
            print("\(index + 1). \(lapTimeString)")
        }
    }
}
