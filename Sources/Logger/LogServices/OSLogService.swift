import Foundation
import os.log

public final class OSLogService {
    public let minLevel: LogLevel
    
    private let subsystem: String
    private let category: String
    
    //subsystem defauls to bundle id if not provided
    public init(subsystem: String,
                category: String,
                minLevel: LogLevel = .debug
    ) {
        self.subsystem = subsystem
        self.category = category
        self.minLevel = minLevel
    }
    
    //public logging client conformance
    
    public func log(level: LogLevel, log: String, context: CustomStringConvertible? = nil) {
        guard level >= minLevel else { return }
        self.logToFile(level: level, string: log, context: context)
    }

    //private functions
    
    
    private var logger: os.Logger {
        os.Logger(subsystem: subsystem, category: self.category)
    }
    
    private func logToFile(level: LogLevel,
                           string: String,
                           context: CustomStringConvertible?) {
        var output = "\n\(level.levelEmoji) \(string)"
        if let context = context {
            output.append(contentsOf: "\n\ncontext: \(context.description)")
        }
        self.logger.log(level: level.osLogLevel, "\(output)")
    }
}
