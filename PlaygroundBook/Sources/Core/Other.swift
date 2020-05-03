import Foundation

public func repeating(_ times: Int, _ block: () -> Void) {
    if times > 0 {
        (0 ..< times).forEach { _ in block() }
    }
}

public func random(_ max: Double) -> Double {
    let upperBound = UInt32(Swift.min(Swift.max(Int64(max), 0), Int64(UInt32.max)))
    return Double(arc4random_uniform(upperBound))
}

public func degrees() {
    Angle.currentUnit = .degree
}

public func radians() {
    Angle.currentUnit = .radian
}

public func colorMode(_ mode: Int) {
    Color.currentMode = Color.Mode(rawValue: mode) ?? .range255
}

public var colorMode: Int {
    return Color.currentMode.rawValue
}
