import CoreGraphics
import Darwin

@MainActor enum BuiltInDisplayControl {
    private typealias ConfigureEnabled = @convention(c) (CGDisplayConfigRef, CGDirectDisplayID, Bool) -> CGError
    private static var displayID: CGDirectDisplayID?
    private static var isDisabled = false

    static func setDisabled(_ disabled: Bool) -> String? {
        guard disabled != isDisabled else { return nil }
        guard let configureEnabled = loadConfigureEnabled() else {
            return L10n.DisplayError.controlUnavailable
        }

        if disabled {
            guard let builtIn = onlineBuiltInDisplay() else { return L10n.DisplayError.builtinNotFound }
            displayID = builtIn
        }
        guard let displayID else { return disabled ? L10n.DisplayError.builtinNotFound : nil }

        var configuration: CGDisplayConfigRef?
        guard CGBeginDisplayConfiguration(&configuration) == .success, let configuration else {
            return L10n.DisplayError.configBeginFailed
        }
        guard configureEnabled(configuration, displayID, !disabled) == .success,
              CGCompleteDisplayConfiguration(configuration, .forSession) == .success else {
            CGCancelDisplayConfiguration(configuration)
            return disabled ? L10n.DisplayError.disableFailed : L10n.DisplayError.enableFailed
        }

        isDisabled = disabled
        return nil
    }

    static func invalidateState() {
        isDisabled = false
    }

    private static func onlineBuiltInDisplay() -> CGDirectDisplayID? {
        var count: UInt32 = 0
        guard CGGetOnlineDisplayList(0, nil, &count) == .success else { return nil }
        var displays = [CGDirectDisplayID](repeating: 0, count: Int(count))
        guard CGGetOnlineDisplayList(count, &displays, &count) == .success else { return nil }
        return displays.prefix(Int(count)).first { CGDisplayIsBuiltin($0) != 0 }
    }

    private static func loadConfigureEnabled() -> ConfigureEnabled? {
        let path = "/System/Library/Frameworks/CoreGraphics.framework/CoreGraphics"
        guard let library = dlopen(path, RTLD_NOW), let symbol = dlsym(library, "CGSConfigureDisplayEnabled") else {
            return nil
        }
        return unsafeBitCast(symbol, to: ConfigureEnabled.self)
    }
}
