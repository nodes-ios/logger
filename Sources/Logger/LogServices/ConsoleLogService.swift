import Foundation

public final class ConsoleLogService {

    /// use NSLog instead of print, default is false
    public var useNSLog = false
    public let minLevel: LogLevel
    
    public init(useNSLog: Bool = false,
                minLevel: LogLevel = .info
    ) {
        self.useNSLog = useNSLog
        self.minLevel = minLevel
    }
    
    //public logging client conformance
    
    public func log(level: LogLevel, log: String, context: CustomStringConvertible? = nil) {
        guard level >= minLevel else { return }
        self.consoleLog(level: level, string: log, context: context)
    }
    
    //private functions
    
    private func consoleLog(level: LogLevel,
                       string: String,
                       context: CustomStringConvertible?) {
        var output = "\n\(level.levelEmoji) \(string)"
        if let context = context {
            output.append(contentsOf: "\n\ncontext: \(context.description)")
        }
        if useNSLog {
            NSLog("%@", output)
        } else {
            print(output)
        }
    }
}
