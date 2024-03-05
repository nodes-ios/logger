# logger

A Swift logging package for use with the pointfree swift-dependencies library. For more information on that dependencies framework, please [see here](https://github.com/pointfreeco/swift-dependencies)

This library simplifies logging to multiple logging service clients making debugging and catching bugs easier than ever before. It comes packaged with implementations for console, OSLog and File logging. 

### ❗️Please note
We have an extension of the package that includes the option to log to **Firebase Crashlytics** available [here](https://github.com/nodes-ios/logger-with-firebase-crashlytics). If you would like to use Firebase Crashlytics logging, please use that repository instead of this one. 


## SDK Use

The SDK is simple to use. Using the pointfree dependency library you can pull out your logger dependency instance the same way you would any other dependency using that library.

```
import Logger

@Dependency(\.loggerClient) var logger
``` 

## Logging Levels

The logger has five levels of logging available. Each of the included logging services have default minimum levels that can be configured to control what severity of log should be captured. These can be customised when initalising the log services to meet your needs. 


The severity of the log levels is as listed below from `info` being most verbose to `fault` being most severe, as well as some guidelines that you should adhere your log levels to.

**info** - Used for verbose informational messages that might be helpful for debugging or understanding the application's behavior.

**default** - Used for general messages or information that doesn't require special attention.

**debug** - Used for debug messages that provide detailed information helpful for debugging purposes. These messages are typically only enabled during development.

**error** - Used for indicating errors or exceptional conditions that occur but don't necessarily result in a failure of the application.

**fault** - Used for critical errors or faults that indicate severe issues that may lead to the failure of the application or significant loss of functionality.


## Adding Logging Services

You can add a logging service to the dependency like shown below. This should be done at app launch as early as possible.
Once the log clients are added, logs will be captured for these services. 
 
```
// Adding Console Service Client to Logger
logger.addLogClient(.console())

// Adding OSLog Service Client to Logger
logger.addLogClient(.osLog(category: "LoggerDemo"))

// Adding File Service Client to Logger
logger.addLogClient(.file())
```

### Configuring Logging Services
Each of these service clients can be initalised with default values set withing the SDK or customised to your needs like so.

**Console**

The `console` client can be configured with a minimum logging level to determine which logs should be captured and whether to use NSLog or simply print to the terminal. It defaults to not use NSLog and to a minimum log level of `debug`.
eg.
```
logger.addLogClient(.console(useNSLog: false, minLevel: .debug))
```

**OSLog**

The `osLog` client can be configured with a subsystem, category and minLevel. The subsystem will default to the app bundle id and min level will default to debug. Category is a manadatory parameter when initalizing the osLog client.
eg.
```
logger.addLogClient(.osLog(subsystem: "subsystem", category: "category", minLevel: .debug))
```

**File**

The `file` client can be configured with a log file URL and minLevel. If not set, the SDK will write to a default file location set within the SDK.
eg.
```
logger.addLogClient(.osLog(subsystem: "subsystem", category: "category", minLevel: .debug))
```

**Custom**

In the case you need to add additional logging service clients, you can easily do so like below. A logging service client needs to provide a log function handler that will be called whenever a log is sent. The function will pass three paramters. The log level, the log and optional context to provide additional data.
```
logger.addLogClient(.init(log: { level, log, context in
    //handle custom logging here
}))
```

## Sending logs

Sending logs could not be simpler. Once log clients have been added, you can call the `log` function to record logs to them.

You can simply call log with a string. This will provide no context and default the log level to `default`.
```
logger.log("A Log")
```

You can provide the level and then the log.
```
logger.log(.debug, "Some log")
```

You also have the option to provide additional context with the log. This context can be any data that conform to the [CustomStringConvertable protocol](https://developer.apple.com/documentation/swift/customstringconvertible)
```
logger.log(.info, "info log button tapped", context: [1, "some info log mock context"])
```
