import UIKit
import HealthKit
import RxSwift

// MARK: - MindGymKit
public protocol StepCountProvider {
    func fetchTodayStepCount(completion: @escaping (Double?) -> Void)
    func observeStepCountUpdates(completion: @escaping (Double?) -> Void)
}

open class HealthKitStepCountProvider: StepCountProvider {
    private let healthStore = HKHealthStore()

    public init() {}

    public func fetchTodayStepCount(completion: @escaping (Double?) -> Void) {
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(nil)
            return
        }

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
                            print("Error fetching step count: \(error.localizedDescription)")
                        }
                    }
                }
                self.healthStore.execute(query)
            } else {
                completion(nil)
                if let error = error {
                    print("Error requesting HealthKit authorization: \(error.localizedDescription)")
                }
            }
        }
    }

    public func observeStepCountUpdates(completion: @escaping (Double?) -> Void) {
        let stepType = HKObjectType.quantityType(forIdentifier: .stepCount)!
        let query = HKObserverQuery(sampleType: stepType, predicate: nil) { query, completionHandler, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else {
                self.fetchTodayStepCount(completion: completion)
            }
            completionHandler()
        }

        healthStore.execute(query)
        healthStore.enableBackgroundDelivery(for: stepType, frequency: .immediate) { success, error in
            if let error = error {
                print("Failed to enable background delivery: \(error.localizedDescription)")
            }
        }
    }
}
