//import UIKit
//import SnapKit
//import HealthKit
//
//class ViewController: UIViewController {
//    private let stepCountLabel = UILabel()
//    private let activityIndicator = UIActivityIndicatorView()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        view.backgroundColor = .white
//
//        view.addSubview(stepCountLabel)
//        stepCountLabel.snp.makeConstraints { make in
//            make.center.equalToSuperview()
//        }
//        stepCountLabel.font = .systemFont(ofSize: 24)
//        stepCountLabel.text = "오늘의 걸음 수:"
//
//        let fetchButton = UIButton()
//        view.addSubview(fetchButton)
//        fetchButton.snp.makeConstraints { make in
//            make.top.equalTo(stepCountLabel.snp.bottom).offset(20)
//            make.centerX.equalToSuperview()
//        }
//        fetchButton.backgroundColor = .red
//        fetchButton.setTitle("걸음 수 가져오기", for: .normal)
//        fetchButton.addTarget(self, action: #selector(fetchStepCount), for: .touchUpInside)
//
//        view.addSubview(activityIndicator)
//        activityIndicator.snp.makeConstraints { make in
//            make.center.equalToSuperview()
//        }
//    }
//
//    @objc func fetchStepCount() {
//        startLoading()
//        getTodayStepCount { stepCount in
//            DispatchQueue.main.async {
//                self.stopLoading()
//                if let stepCount = stepCount {
//                    self.stepCountLabel.text = "오늘의 걸음 수: \(stepCount)"
//                } else {
//                    self.stepCountLabel.text = "걸음 수를 가져올 수 없습니다."
//                }
//            }
//        }
//    }
//
//    func startLoading() {
//        DispatchQueue.main.async {
//            self.activityIndicator.startAnimating()
//            self.activityIndicator.isHidden = false
//        }
//    }
//
//    func stopLoading() {
//        DispatchQueue.main.async {
//            self.activityIndicator.stopAnimating()
//            self.activityIndicator.isHidden = true
//        }
//    }
//
//    func getTodayStepCount(completion: @escaping (Double?) -> Void) {
//        let healthStore = HKHealthStore()
//
//        guard HKHealthStore.isHealthDataAvailable() else {
//            completion(nil)
//            return
//        }
//
//        let typesToRead: Set<HKSampleType> = [HKSampleType.quantityType(forIdentifier: .stepCount)!]
//
//        healthStore.requestAuthorization(toShare: nil, read: typesToRead) { (success, error) in
//            if success {
//                let calendar = Calendar.current
//                let now = Date()
//                let startOfDay = calendar.startOfDay(for: now)
//                let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
//
//                let stepType = HKSampleType.quantityType(forIdentifier: .stepCount)!
//                let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: endOfDay, options: .strictStartDate)
//
//                let query = HKStatisticsQuery(quantityType: stepType, quantitySamplePredicate: predicate, options: .cumulativeSum) { query, result, error in
//                    if let result = result, let sum = result.sumQuantity() {
//                        let stepCount = sum.doubleValue(for: HKUnit.count())
//                        completion(stepCount)
//                    } else {
//                        completion(nil)
//                        if let error = error {
//                            print("걸음 수 가져오기 오류: \(error.localizedDescription)")
//                        }
//                    }
//                }
//
//                healthStore.execute(query)
//            } else {
//                completion(nil)
//                if let error = error {
//                    print("HealthKit 권한 요청 중 오류 발생: \(error.localizedDescription)")
//                }
//            }
//        }
//    }
//}
