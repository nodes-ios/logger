import Foundation
import Dependencies

public struct LogManagerClient {
    public var addLogClient: (_ client: LoggingClient) -> Void
    
    var _log: (LogLevel, String, CustomStringConvertible?) -> Void
}
extension LogManagerClient {
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
extension LogManagerClient: DependencyKey {
    public static let liveValue = LogManagerClient { client in
        LogManager.addLogClient(client)
    } _log: { level, log, context in
        LogManager.log(level, log: log, context: context)
    }

}
extension LogManagerClient: TestDependencyKey {
    public static let testValue = LogManagerClient(addLogClient: { _ in },
                                                   _log: { _, _, _ in })
}

public extension DependencyValues {
    var logManagerClient: LogManagerClient {
        get { self[LogManagerClient.self] }
        set { self[LogManagerClient.self] = newValue }
    }
}

final class LogManager {
    private static var logClients: [LoggingClient] = []
    
    static func addLogClient(_ client: LoggingClient) {
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
