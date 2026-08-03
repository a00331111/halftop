enum LidState: Equatable, Sendable {
    case open, closed, unavailable
    var text: String { switch self { case .open: L10n.State.open; case .closed: L10n.State.closed; case .unavailable: L10n.State.notConnected } }
}

enum EnergyMode: Hashable, Sendable, CaseIterable {
    case automatic, lowPower, highPower, unavailable

    static var configurable: [Self] { [.lowPower, .automatic, .highPower] }

    var text: String {
        switch self {
        case .automatic: L10n.Energy.automatic
        case .lowPower: L10n.Energy.lowPower
        case .highPower: L10n.Energy.highPower
        case .unavailable: L10n.Energy.unavailable
        }
    }
}

enum EnergyPowerSource: Sendable {
    case battery, adapter

    var title: String { self == .battery ? L10n.Energy.onBattery : L10n.Energy.onAdapter }
    var helperKey: String { self == .battery ? "b" : "c" }
}

enum ActiveMode: Equatable, Sendable {
    case normal, clamshellReady, noExternalDisplay
    static func resolve(hasExternalDisplay: Bool, isOnACPower: Bool, allowOnBattery: Bool, activeModeEnabled: Bool) -> Self {
        if !activeModeEnabled { return .normal }
        if !hasExternalDisplay { return .noExternalDisplay }
        return isOnACPower || allowOnBattery ? .clamshellReady : .normal
    }
    static func selfCheck() {
        assert(resolve(hasExternalDisplay: false, isOnACPower: false, allowOnBattery: true, activeModeEnabled: true) == .noExternalDisplay)
        assert(resolve(hasExternalDisplay: true, isOnACPower: false, allowOnBattery: false, activeModeEnabled: true) == .normal)
        assert(resolve(hasExternalDisplay: true, isOnACPower: false, allowOnBattery: true, activeModeEnabled: true) == .clamshellReady)
        assert(resolve(hasExternalDisplay: true, isOnACPower: true, allowOnBattery: false, activeModeEnabled: true) == .clamshellReady)
        assert(resolve(hasExternalDisplay: true, isOnACPower: true, allowOnBattery: false, activeModeEnabled: false) == .normal)
    }
    var text: String { switch self { case .normal: L10n.ActiveMode.normal; case .clamshellReady: L10n.ActiveMode.clamshellReady; case .noExternalDisplay: L10n.ActiveMode.noExternalDisplay } }
}
