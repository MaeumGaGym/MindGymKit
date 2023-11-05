// The Swift Programming Language
// https://docs.swift.org/swift-book

import UIKit

public struct MindGymKit {
    var helloMind: String = "마음가짐"
    public var publicHelloMind: String = "안녕 마음가짐"
    
    public init(helloMind: String) {
        publicHelloMind = helloMind
    }
}
