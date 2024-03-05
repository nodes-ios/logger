import Foundation
import Dependencies

public struct LoggingServiceClient {
    var log: (_ level: LogLevel, _ log: String, _ context: CustomStringConvertible?) -> Void
    
    public init(log: @escaping (LogLevel, String, CustomStringConvertible?) -> Void) {
        self.log = log
    }
}
public extension LoggingServiceClient {
    static func console(useNSLog: Bool = false, minLevel: LogLevel = .debug) -> LoggingServiceClient {
        let consoleLog = ConsoleLogService(useNSLog: useNSLog, minLevel: minLevel)
        return LoggingServiceClient(log: consoleLog.log(level:log:context:))
    }
    
    static func file(logFileURL: URL? = nil,
                     minLevel: LogLevel = .error
         ) -> LoggingServiceClient {
        let logService = FileLogService(logFileURL: logFileURL, minLevel: minLevel)
        return LoggingServiceClient(log: logService.log(level:log:context:))
    }
    
    static func osLog(subsystem: String = (Bundle.main.bundleIdentifier ?? ""),
                      category: String,
                      minLevel: LogLevel = .debug
          ) -> LoggingServiceClient {
        let logService = OSLogService(subsystem: subsystem, category: category, minLevel: minLevel)
        return LoggingServiceClient(log: logService.log(level:log:context:))
    }
}

