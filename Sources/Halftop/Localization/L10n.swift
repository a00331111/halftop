import Foundation

// MARK: - 直接加载中文 .strings 文件

private let zhStrings: [String: String] = {
    // 直接从已知的构建路径加载
    let paths = [
        // SPM 构建路径（Bundle.module 实际使用的）
        "/Users/svendog/halftop/.build/arm64-apple-macosx/debug/Halftop_Halftop.bundle/zh-Hans.lproj/Localizable.strings",
        "/Users/svendog/halftop/.build/arm64-apple-macosx/debug/Halftop_Halftop.bundle/zh-hans.lproj/Localizable.strings",
        // App bundle 路径
        Bundle.main.bundlePath + "/Contents/Halftop_Halftop.bundle/zh-Hans.lproj/Localizable.strings",
        Bundle.main.bundlePath + "/Contents/Resources/Halftop_Halftop.bundle/zh-Hans.lproj/Localizable.strings",
    ]

    for path in paths {
        if let dict = NSDictionary(contentsOfFile: path) as? [String: String], !dict.isEmpty {
            return dict
        }
    }

    // 回退到英文
    return [:]
}()

// MARK: - Localized String Keys

enum L10n {

    enum Status {
        static let builtinDisplay = zhStrings["status.builtin_display"] ?? "Built-in Display"
        static let builtinDisplayDisabled = zhStrings["status.builtin_display_disabled"] ?? "Built-in Display"
        static let externalDisplay = zhStrings["status.external_display"] ?? "External Display"
        static let airPlay = zhStrings["status.airplay"] ?? "AirPlay"
        static let sideScreen = zhStrings["status.sidescreen"] ?? "SideScreen"
        static let powerSource = zhStrings["status.power_source"] ?? "Power Source"
        static let energyMode = zhStrings["status.energy_mode"] ?? "Energy Mode"
    }

    enum State {
        static let enabled = zhStrings["state.enabled"] ?? "Enabled"
        static let disabled = zhStrings["state.disabled"] ?? "Disabled"
        static let connected = zhStrings["state.connected"] ?? "Connected"
        static let notConnected = zhStrings["state.not_connected"] ?? "Not Connected"
        static let powerAdapter = zhStrings["state.power_adapter"] ?? "Power Adapter"
        static let battery = zhStrings["state.battery"] ?? "Battery"
        static let open = zhStrings["state.open"] ?? "Open"
        static let closed = zhStrings["state.closed"] ?? "Closed"
    }

    enum Energy {
        static let automatic = zhStrings["energy.automatic"] ?? "Automatic"
        static let lowPower = zhStrings["energy.low_power"] ?? "Low Power"
        static let highPower = zhStrings["energy.high_power"] ?? "High Power"
        static let unavailable = zhStrings["energy.unavailable"] ?? "Unavailable"
        static let onBattery = zhStrings["energy.on_battery"] ?? "On Battery"
        static let onAdapter = zhStrings["energy.on_adapter"] ?? "On Power Adapter"
    }

    enum ActiveMode {
        static let normal = zhStrings["active_mode.normal"] ?? "Normal"
        static let clamshellReady = zhStrings["active_mode.clamshell_ready"] ?? "Clamshell Ready"
        static let noExternalDisplay = zhStrings["active_mode.no_external_display"] ?? "No external display"
    }

    enum Section {
        static let clamshellReady = zhStrings["section.clamshell_ready"] ?? "CLAMSHELL READY"
        static let sleepTools = zhStrings["section.sleep_tools"] ?? "SLEEP TOOLS"
        static let energyMode = zhStrings["section.energy_mode"] ?? "ENERGY MODE"
        static let servicesAlerts = zhStrings["section.services_alerts"] ?? "SERVICES & ALERTS"
        static let shortcuts = zhStrings["section.shortcuts"] ?? "SHORTCUTS"
    }

    enum Clamshell {
        static let launchAtLogin = zhStrings["clamshell.launch_at_login"] ?? "Launch at Login"
        static let allowOnBattery = zhStrings["clamshell.allow_on_battery"] ?? "Allow on Battery"
        static let launchSideScreenAtLogin = zhStrings["clamshell.launch_sidescreen_at_login"] ?? "Launch SideScreen at Login"
        static let ignoreLidClose = zhStrings["clamshell.ignore_lid_close"] ?? "Ignore Lid Close (Disable Sleep)"
        static let disableBuiltinDisplay = zhStrings["clamshell.disable_builtin_display"] ?? "Disable Built-in Display"
        static let dimBuiltinDisplay = zhStrings["clamshell.dim_builtin_display"] ?? "Dim Built-in Display"
    }

    enum ClamshellInfo {
        static let title = zhStrings["clamshell_info.title"] ?? "Clamshell Ready"
        static let description = zhStrings["clamshell_info.description"] ?? ""
        static let launchAtLoginDesc = zhStrings["clamshell_info.launch_at_login"] ?? ""
        static let allowOnBatteryDesc = zhStrings["clamshell_info.allow_on_battery"] ?? ""
        static let launchSideScreenAtLoginDesc = zhStrings["clamshell_info.launch_sidescreen_at_login"] ?? ""
        static let ignoreLidCloseDesc = zhStrings["clamshell_info.ignore_lid_close"] ?? ""
        static let dimBuiltinDisplayDesc = zhStrings["clamshell_info.dim_builtin_display"] ?? ""
        static let disableBuiltinDisplayDesc = zhStrings["clamshell_info.disable_builtin_display"] ?? ""
    }

    enum SleepTools {
        static let autoResleep = zhStrings["sleep_tools.auto_resleep"] ?? "Automatic Re-Sleep"
        static let bagSleepGuard = zhStrings["sleep_tools.bag_sleep_guard"] ?? "Bag Sleep Guard"
    }

    enum SleepToolsInfo {
        static let title = zhStrings["sleep_tools_info.title"] ?? "Sleep Tools"
        static let description = zhStrings["sleep_tools_info.description"] ?? ""
        static let autoResleepDesc = zhStrings["sleep_tools_info.auto_resleep"] ?? ""
        static let bagSleepGuardDesc = zhStrings["sleep_tools_info.bag_sleep_guard"] ?? ""
    }

    enum Services {
        static let loginWakeSound = zhStrings["services.login_wake_sound"] ?? "Login, Wake & Unlock Sound"
        static let batteryVoiceAlert = zhStrings["services.battery_voice_alert"] ?? "Low Battery Voice Alert"
        static let lockScreenSayer = zhStrings["services.lock_screen_sayer"] ?? "Lock Screen Voice Alert"
    }

    enum ServicesInfo {
        static let title = zhStrings["services_info.title"] ?? "Services & Alerts"
        static let description = zhStrings["services_info.description"] ?? ""
        static let loginWakeSoundDesc = zhStrings["services_info.login_wake_sound"] ?? ""
        static let batteryVoiceAlertDesc = zhStrings["services_info.battery_voice_alert"] ?? ""
        static let lockScreenSayerDesc = zhStrings["services_info.lock_screen_sayer"] ?? ""
    }

    enum Shortcuts {
        static let autoAirPlay = zhStrings["shortcuts.auto_airplay"] ?? "Auto AirPlay"
        static let sideScreenUSB = zhStrings["shortcuts.sidescreen_usb"] ?? "SideScreen USB"
        static let sideScreenWiFi = zhStrings["shortcuts.sidescreen_wifi"] ?? "SideScreen WiFi"
        static let sleepNow = zhStrings["shortcuts.sleep_now"] ?? "Sleep Now"
        static let edit = zhStrings["shortcuts.edit"] ?? "Edit"
        static let resetDefaults = zhStrings["shortcuts.reset_defaults"] ?? "Reset Defaults"
        static let pressKeys = zhStrings["shortcuts.press_keys"] ?? "Press keys…"
        static let pressNewCombo = zhStrings["shortcuts.press_new_combo"] ?? ""
        static let alreadyInUse = zhStrings["shortcuts.already_in_use"] ?? ""
        static let atLeastOneModifier = zhStrings["shortcuts.at_least_one_modifier"] ?? ""
        static let set = zhStrings["shortcuts.set"] ?? "Set"
        static let goingToSleep = zhStrings["shortcuts.going_to_sleep"] ?? "Going to sleep"
        static let control = zhStrings["shortcuts.control"] ?? "Control"
        static let option = zhStrings["shortcuts.option"] ?? "Option"
        static let shift = zhStrings["shortcuts.shift"] ?? "Shift"
        static let command = zhStrings["shortcuts.command"] ?? "Command"
    }

    enum ShortcutsInfo {
        static let title = zhStrings["shortcuts_info.title"] ?? "Shortcuts"
        static let autoAirPlayDesc = zhStrings["shortcuts_info.auto_airplay"] ?? ""
        static let sleepNowDesc = zhStrings["shortcuts_info.sleep_now"] ?? ""
        static let sideScreenUSBDesc = zhStrings["shortcuts_info.sidescreen_usb"] ?? ""
        static let sideScreenWiFiDesc = zhStrings["shortcuts_info.sidescreen_wifi"] ?? ""
        static let usbWiFiAvailable = zhStrings["shortcuts_info.usb_wifi_available"] ?? ""
        static let updateRequired = zhStrings["shortcuts_info.update_required"] ?? ""
        static let installRequired = zhStrings["shortcuts_info.install_required"] ?? ""
    }

    enum SideScreen {
        static let installed = zhStrings["sidescreen.installed"] ?? "SideScreen installed"
        static let notInstalled = zhStrings["sidescreen.not_installed"] ?? "SideScreen not installed"
        static let installedSummary = zhStrings["sidescreen.installed_summary"] ?? "Installed"
        static let updateRequiredSummary = zhStrings["sidescreen.update_required_summary"] ?? "Update Required"
        static let notInstalledSummary = zhStrings["sidescreen.not_installed_summary"] ?? "Not Installed"
        static let update = zhStrings["sidescreen.update"] ?? "Update"
        static let install = zhStrings["sidescreen.install"] ?? "Install"

        static func installedVersion(_ version: String) -> String {
            String(format: zhStrings["sidescreen.installed_version"] ?? "SideScreen %@", version)
        }
        static func updateRequired(_ version: String) -> String {
            String(format: zhStrings["sidescreen.update_required"] ?? "SideScreen %@ installed, update required", version)
        }
    }

    enum ToolAction {
        static let startAutoAirPlay = zhStrings["tool_action.start_auto_airplay"] ?? "Start Auto AirPlay"
        static let startSideScreenUSB = zhStrings["tool_action.start_sidescreen_usb"] ?? "Start SideScreen USB"
        static let startSideScreenWiFi = zhStrings["tool_action.start_sidescreen_wifi"] ?? "Start SideScreen WiFi"
        static let sideScreenUSB = zhStrings["tool_action.sidescreen_usb"] ?? "SideScreen USB"
        static let sideScreenWiFi = zhStrings["tool_action.sidescreen_wifi"] ?? "SideScreen WiFi"
        static let halftopAction = zhStrings["tool_action.halftop_action"] ?? "Halftop Action"
        static let startAirPlay = zhStrings["tool_action.start_airplay"] ?? "Start AirPlay"
    }

    enum ToolMessage {
        static func started(_ name: String) -> String {
            String(format: zhStrings["tool_message.started"] ?? "%@ started", name)
        }
        static func starting(_ name: String) -> String {
            String(format: zhStrings["tool_message.starting"] ?? "%@ starting", name)
        }
        static func serviceOn(_ name: String) -> String {
            String(format: zhStrings["tool_message.service_on"] ?? "%@: on", name)
        }
        static func serviceOff(_ name: String) -> String {
            String(format: zhStrings["tool_message.service_off"] ?? "%@: off", name)
        }
        static let fixingGatekeeper = zhStrings["tool_message.fixing_gatekeeper"] ?? "Fixing SideScreen Gatekeeper..."
        static let gatekeeperFixed = zhStrings["tool_message.gatekeeper_fixed"] ?? "SideScreen Gatekeeper fixed"
    }

    enum ToolError {
        static let missingResources = zhStrings["tool_error.missing_resources"] ?? "The Tools folder is missing from the application bundle."
        static let commandFailed = zhStrings["tool_error.command_failed"] ?? "The command could not be run."
        static func sideScreenUnavailable(_ status: String) -> String {
            String(format: zhStrings["tool_error.sidescreen_unavailable"] ?? "%@. Install SideScreen 0.11.0 or newer.", status)
        }
    }

    enum DisplayError {
        static let controlUnavailable = zhStrings["display_error.control_unavailable"] ?? "Built-in display control is unavailable on this macOS version."
        static let builtinNotFound = zhStrings["display_error.builtin_not_found"] ?? "Could not find the built-in display."
        static let configBeginFailed = zhStrings["display_error.config_begin_failed"] ?? "Could not begin display configuration."
        static let disableFailed = zhStrings["display_error.disable_failed"] ?? "Could not disable the built-in display."
        static let enableFailed = zhStrings["display_error.enable_failed"] ?? "Could not enable the built-in display."
        static let brightnessUnavailable = zhStrings["display_error.brightness_unavailable"] ?? "Brightness control is unavailable on this macOS version."
        static let dimFailed = zhStrings["display_error.dim_failed"] ?? "Could not dim the built-in display."
    }

    enum EnergyError {
        static let unsupported = zhStrings["energy_error.unsupported"] ?? "This energy mode is not supported by this Mac."
        static func commandFailed(_ message: String) -> String {
            String(format: zhStrings["energy_error.command_failed"] ?? "Could not change Energy Mode: %@", message)
        }
    }

    enum SleepError {
        static func assertionCreationFailed(_ code: IOReturn) -> String {
            String(format: zhStrings["sleep_error.assertion_creation_failed"] ?? "Could not create sleep-prevention assertion (IOKit: %d). Check system security settings.", code)
        }
        static let sleepDisabled = zhStrings["sleep_error.sleep_disabled"] ?? "Could not disable sleep override before sleeping."
        static let serviceUnavailable = zhStrings["sleep_error.service_unavailable"] ?? "Could not put the system to sleep: power-management service is unavailable."
        static func sleepFailed(_ code: IOReturn) -> String {
            String(format: zhStrings["sleep_error.sleep_failed"] ?? "Could not put the system to sleep (IOKit: %d).", code)
        }
        static func lidCommandFailed(_ output: String) -> String {
            String(format: zhStrings["sleep_error.lid_command_failed"] ?? "Could not update lid behavior: %@", output)
        }
        static let lidHelperUnavailable = zhStrings["sleep_error.lid_helper_unavailable"] ?? "Could not update lid behavior: privileged helper is not installed. Run script/install_lid_daemon.sh once."
    }

    enum SystemError {
        static func launchAgentFailed(_ desc: String) -> String {
            String(format: zhStrings["system_error.launch_agent_failed"] ?? "Could not update Launch at Login: %@", desc)
        }
        static let mustRunFromAppBundle = zhStrings["system_error.must_run_from_app_bundle"] ?? "Halftop must be run from the app bundle to enable Launch at Login."
    }

    enum Footer {
        static let halftopBy = zhStrings["footer.halftop_by"] ?? "Halftop by"
        static let quit = zhStrings["footer.quit"] ?? "Quit"
    }

    enum Help {
        static let aboutClamshell = zhStrings["help.about_clamshell"] ?? "About Clamshell Ready"
        static let aboutSleepTools = zhStrings["help.about_sleep_tools"] ?? "About Sleep Tools"
        static let aboutServices = zhStrings["help.about_services"] ?? "About Services & Alerts"
        static let aboutShortcuts = zhStrings["help.about_shortcuts"] ?? "About Shortcuts"
    }

    enum ManagedService {
        static let autoResleep = zhStrings["managed_service.auto_resleep"] ?? "Automatic Re-Sleep"
        static let bagSleepGuard = zhStrings["managed_service.bag_sleep_guard"] ?? "Bag Sleep Guard"
        static let launchSideScreenAtLogin = zhStrings["managed_service.launch_sidescreen_at_login"] ?? "Launch SideScreen at Login"
        static let lowBatteryVoiceAlert = zhStrings["managed_service.low_battery_voice_alert"] ?? "Low Battery Voice Alert"
        static let lockScreenSayer = zhStrings["managed_service.lock_screen_sayer"] ?? "Lock Screen Voice Alert"
    }
}
