import UIKit
import MindGymKit
import SnapKit

class ViewController: UIViewController {
    
    let mindGymKit = MindGymKit()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mindGymKit.fetchTodayStepCount { stepCount in
            if let stepCount = stepCount {
                print("오늘의 걸음 수: \(stepCount) 걸음")
            } else {
                print("걸음 수를 가져오는데 실패했습니다.")
            }
        }
    }
}
