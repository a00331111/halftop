import Foundation
import IOKit.pwr_mgt

enum SystemSleepError: LocalizedError {
    case serviceUnavailable
    case sleepFailed(IOReturn)
    case sleepDisabled

    var errorDescription: String? {
        switch self {
        case .serviceUnavailable:
            L10n.SleepError.serviceUnavailable
        case .sleepDisabled:
            L10n.SleepError.sleepDisabled
        case .sleepFailed(let code):
            L10n.SleepError.sleepFailed(code)
        }
    }
}

struct SystemSleep {
    static func sleepNow() throws {
        let port = IOPMFindPowerManagement(mach_port_t(MACH_PORT_NULL))
        guard port != 0 else { throw SystemSleepError.serviceUnavailable }
        defer { IOServiceClose(port) }

        let result = IOPMSleepSystem(port)
        if UInt32(bitPattern: result) == 0xe00002e2 { throw SystemSleepError.sleepDisabled }
        guard result == kIOReturnSuccess else { throw SystemSleepError.sleepFailed(result) }
    }
}
