<div align=center>
<img src="https://github.com/MaeumGajim/MindGymKit/assets/102890390/e0b06d3b-a97d-4afc-9ba8-f29bee6e0f96" width="50%"/>

# MindGymKit
<aside>
💪🏿 v0.1.9
</aside>
<br>
<br>

This library was created to easily manage health-related functions.
</div>

## Installation
### Carthage

Add the following entry to your Cartfile:

```swift
preparing 🙏
```

### CocoaPods

Add the following entry to your Podfile:

```swift
preparing 🙏
```
Then run `pod install`

### Swift Package Manager

To integrate using Apple's Swift package manager, add the following as a dependency to your `Package.swift`:

```swift
https://github.com/MaeumGajim/MindGymKit.git
```

## Usage
### Info.plist 📄

- **How to allow camera access**:

    ```swift
    // Message explaining why the app requested permission to read samples from the HealthKit store.
    Privacy - Health Share Usage Description ⚓️
    ```
    
- **How to allow album access**:

    ```swift
    // Message explaining why the app requested permission to save samples to the HealthKit store.
    Privacy - Health Update Usage Description 🦾
    ```

`⚠️ Don't forget to fill in the value ⚠️`

### MindGymKit

- **Get today's number of steps**:

    ```swift
    let mindGym = MindGymKit()
    
    mindGym.fetchTodayStepCount { stepCount in
         DispatchQueue.main.async {
             if let stepCount = stepCount {
                    print("todayStep: \(stepCount)")
                } else {
                    print("Error")
                }
            }
      }
    ```
- **Using a stopwatch**:
    ```swift
    
    let stopwatch = MindGymStopWatchKit()
    
    stopwatch.mainStopwatch.timeUpdate
        .observe(on: MainScheduler.instance)
        .subscribe(onNext: { [weak self] timeString in
            self?.stopWatchLabel.text = timeString
        })
        .disposed(by: disposeBag)
        
    stopwatch.mainStopwatch.recordUpdate
        .observe(on: MainScheduler.instance)
        .subscribe(onNext: { [weak self] lapTimes in
            self?.lapRecords = lapTimes
            self?.lapRecords.append(lapTimes.last ?? "")
            print("Lap record : \(String(describing: self?.lapRecords ?? nil))")
        })
        .disposed(by: disposeBag)
    ```
