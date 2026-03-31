import Foundation

struct BootpayConfig {
    #if DEBUG
    static let isDebug = true
    #else
    static let isDebug = false
    #endif

    // PG API
    static var applicationId: String {
        isDebug ? "5b9f51264457636ab9a07cdd" : "5b8f6a4d396fa665fdc2b5e9"
    }

    // Commerce API
    static var clientKey: String {
        isDebug ? "hxS-Up--5RvT6oU6QJE0JA" : "sEN72kYZBiyMNytA8nUGxQ"
    }
}
