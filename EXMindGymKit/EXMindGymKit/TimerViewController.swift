import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa

class TimerViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    let count = 3600.0
    private var initTimerLabel = UILabel().then {
        $0.textAlignment = .center
        $0.numberOfLines = 1
        $0.font = UIFont.monospacedDigitSystemFont(ofSize: 20, weight: .ultraLight)
        $0.textColor = .white
        $0.text = "00 : 00"
    }
    
    private var timerLabel = UILabel().then {
        $0.textAlignment = .center
        $0.numberOfLines = 1
        $0.font = UIFont.monospacedDigitSystemFont(ofSize: 64, weight: .ultraLight)
        $0.textColor = .white
        $0.text = ""
    }
    
    private var finishTimeLabel = UILabel().then {
        $0.textAlignment = .center
        $0.numberOfLines = 1
        $0.font = UIFont.monospacedDigitSystemFont(ofSize: 20, weight: .ultraLight)
        $0.textColor = .white
        $0.text = "0:00"
    }
    
    private var timerOnOffButton = UIButton().then {
        $0.backgroundColor = .green
        $0.setTitle("시작", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.layer.cornerRadius = 45.0
    }
    
    private var timerResetButton = UIButton().then {
        $0.backgroundColor = .gray
        $0.isEnabled = true
        $0.setTitle("초기화", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 40.0
    }
    
    private var timerRestartButton = UIButton().then {
        $0.backgroundColor = .gray
        $0.isEnabled = true
        $0.setTitle("다시 시작", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 40.0
    }
    
    private let timer = MindGymTimerKit()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        var time: [Double] = [0.0, 0.0, 0.0]
        time[0] = Double(Int(count / 3600))
        time[1] = Double(Int(count / 60))
        time[2] = count.truncatingRemainder(dividingBy: 60)
        if count / 3600 >= 1  {
            initTimerLabel.text = "\(Int(time[0]))시간  \(Int(time[1]))분"
        } else if count / 60 > 1 {
            initTimerLabel.text = "\(Int(time[1]))분 \(Int(time[2]))초"
        } else if count / 60 == 0 {
            time[2] = 60.0
            initTimerLabel.text = "\(Int(time[2]))초"
        } else {
            initTimerLabel.text = "\(Int(time[2]))초"
        }
        
        subscribeToStopwatchUpdates()
        timer.setting(count: count)
        buttonTap()
        layout()
        alarmTime()
    }
    
    private func layout() {
        [initTimerLabel,timerLabel, timerOnOffButton, finishTimeLabel ,timerResetButton, timerResetButton, timerRestartButton].forEach { view.addSubview($0) }
        
        initTimerLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(129.0)
            $0.width.equalToSuperview()
        }
        
        timerLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(185.0)
            $0.width.equalToSuperview()
        }
        
        finishTimeLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(281.0)
            $0.width.equalToSuperview()
        }

        timerOnOffButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(90.0)
            $0.centerY.equalToSuperview().offset(200.0)
        }
        
        timerResetButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-35.0)
            $0.width.height.equalTo(80.0)
            $0.centerY.equalToSuperview().offset(200.0)
        }
        
        timerRestartButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(35.0)
            $0.width.height.equalTo(80.0)
            $0.centerY.equalToSuperview().offset(200.0)
        }
        
    }
    
    private func subscribeToStopwatchUpdates() {
        timer.mainTimer.timeUpdate
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] timeString in
                self?.timerLabel.text = timeString
            })
            .disposed(by: disposeBag)
    }
    
    private func buttonTap() {
        var isRunning: Bool = false
        
        timerOnOffButton.rx.tap
            .subscribe(onNext: { [self] in
                if isRunning {
                    timer.stopTimer()
                    timerOnOffButton.backgroundColor = .green
                    timerOnOffButton.setTitle("시작", for: .normal)
                } else {
                    timer.startTimer()
                    timerOnOffButton.backgroundColor = .red
                    timerOnOffButton.setTitle("끝", for: .normal)
                }
                isRunning.toggle()
            })
            .disposed(by: disposeBag)
        
        timerRestartButton.rx.tap
            .subscribe(onNext: { [self] in
                timer.stopTimer()
                timer.restartTimer()
            }).disposed(by: disposeBag)
        
        timerResetButton.rx.tap
            .subscribe(onNext: { [self] in
                timer.resetTimer()
                timer.stopTimer()
            }).disposed(by: disposeBag)
    }
    
    private func alarmTime() {
        let formatter_time = DateFormatter()
        formatter_time.dateFormat = "a hh:mm"
        formatter_time.amSymbol = "오전"
        formatter_time.pmSymbol = "오후"
        let current_time_string = formatter_time.string(from: Date().addingTimeInterval(count))
        finishTimeLabel.text = current_time_string
    }
}
