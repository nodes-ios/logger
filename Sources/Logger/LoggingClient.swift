import Foundation
import Dependencies

public struct LoggingClient {
    var log: (_ level: LogLevel, _ log: String, _ context: CustomStringConvertible?) -> Void
    
    public init(log: @escaping (LogLevel, String, CustomStringConvertible?) -> Void) {
        self.log = log
    }
}

