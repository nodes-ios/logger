import Foundation

public enum LogLevel {
    case `default`
    case debug
    case info
    case error
    case fault
}

extension LogLevel: Comparable {
    var levelValue: Int {
        switch self {
        case .info:     return 0
        case .`default`:  return 1
        case .debug:    return 1
        case .error:    return 2
        case .fault:    return 3
        }
    }

    public static func < (lhs: LogLevel, rhs: LogLevel) -> Bool {
        return lhs.levelValue < rhs.levelValue
    }
}

public extension LogLevel {
    var levelEmoji: String {
        switch self {
        case .info:     return "🟢"
        case .`default`:  return "⚫️"
        case .debug:    return "🔵"
        case .error:    return "🟠"
        case .fault:    return "🔴"
        }
    }
    
}
