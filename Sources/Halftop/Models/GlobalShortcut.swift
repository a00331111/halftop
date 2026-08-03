import Carbon.HIToolbox

enum ShortcutCommand: Int, CaseIterable, Identifiable, Sendable {
    case airPlay = 1
    case sleepNow = 4
    case sideScreenUSB = 2
    case sideScreenWireless = 3

    var id: Int { rawValue }

    var title: String {
        switch self {
        case .airPlay: L10n.Shortcuts.autoAirPlay
        case .sideScreenUSB: L10n.Shortcuts.sideScreenUSB
        case .sideScreenWireless: L10n.Shortcuts.sideScreenWiFi
        case .sleepNow: L10n.Shortcuts.sleepNow
        }
    }

    var icon: String {
        switch self {
        case .airPlay: "airplayvideo"
        case .sideScreenUSB: "cable.connector"
        case .sideScreenWireless: "wifi"
        case .sleepNow: "moon.zzz"
        }
    }

    var requiresSideScreen: Bool {
        switch self {
        case .airPlay, .sleepNow: false
        case .sideScreenUSB, .sideScreenWireless: true
        }
    }

    var defaultBinding: ShortcutBinding {
        switch self {
        case .airPlay:
            ShortcutBinding(keyCode: 0, modifiers: UInt32(controlKey | optionKey), key: "A")
        case .sideScreenUSB:
            ShortcutBinding(keyCode: 1, modifiers: UInt32(controlKey | optionKey), key: "S")
        case .sideScreenWireless:
            ShortcutBinding(keyCode: 13, modifiers: UInt32(controlKey | optionKey), key: "W")
        case .sleepNow:
            ShortcutBinding(keyCode: 1, modifiers: UInt32(controlKey | optionKey | cmdKey), key: "S")
        }
    }

    static func selfCheck() {
        assert(ShortcutCommand.airPlay.defaultBinding.display == "⌃⌥A")
        assert(ShortcutCommand.sideScreenUSB.defaultBinding.display == "⌃⌥S")
        assert(ShortcutCommand.sideScreenWireless.defaultBinding.display == "⌃⌥W")
        assert(ShortcutCommand.sleepNow.defaultBinding.display == "⌃⌥⌘S")
        assert(ShortcutCommand.airPlay.defaultBinding.readableDisplay == "Control + Option + A")
    }
}

struct ShortcutBinding: Codable, Equatable, Sendable {
    let keyCode: UInt32
    let modifiers: UInt32
    let key: String

    var display: String {
        var value = ""
        if modifiers & UInt32(controlKey) != 0 { value += "⌃" }
        if modifiers & UInt32(optionKey) != 0 { value += "⌥" }
        if modifiers & UInt32(shiftKey) != 0 { value += "⇧" }
        if modifiers & UInt32(cmdKey) != 0 { value += "⌘" }
        return value + key
    }

    var readableDisplay: String {
        var parts: [String] = []
        if modifiers & UInt32(controlKey) != 0 { parts.append(L10n.Shortcuts.control) }
        if modifiers & UInt32(optionKey) != 0 { parts.append(L10n.Shortcuts.option) }
        if modifiers & UInt32(shiftKey) != 0 { parts.append(L10n.Shortcuts.shift) }
        if modifiers & UInt32(cmdKey) != 0 { parts.append(L10n.Shortcuts.command) }
        parts.append(key)
        return parts.joined(separator: " + ")
    }
}
