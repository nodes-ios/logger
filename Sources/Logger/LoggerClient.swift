import Foundation
import Dependencies

public struct LoggerClient {
    public var addLogClient: (_ client: LoggingServiceClient) -> Void
    
    var _log: (LogLevel, String, CustomStringConvertible?) -> Void
}
extension LoggerClient {
    public func log(
        _ level: LogLevel,
        _ log: String,
        context: CustomStringConvertible? = nil
    ) {
      _log(level, log, context)
    }
    
    public func log(_ log: String, context: CustomStringConvertible? = nil) {
        _log(.default, log, context)
    }
}
extension LoggerClient: DependencyKey {
    public static let liveValue = LoggerClient { client in
        LogManager.addLogClient(client)
    } _log: { level, log, context in
        LogManager.log(level, log: log, context: context)
    }

}
extension LoggerClient: TestDependencyKey {
    public static let testValue = LoggerClient(addLogClient: { _ in },
                                                   _log: { _, _, _ in })
}

public extension DependencyValues {
    var loggerClient: LoggerClient {
        get { self[LoggerClient.self] }
        set { self[LoggerClient.self] = newValue }
    }
}

final class LogManager {
    private static var logClients: [LoggingServiceClient] = []
    
    static func addLogClient(_ client: LoggingServiceClient) {
        logClients.append(client)
    }
    
    static func log(_ level: LogLevel,
                    log: String,
                    context: CustomStringConvertible? = nil) {
        for client in logClients {
            client.log(level, log, context)
        }
    }
}
