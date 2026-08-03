import AppKit
import SwiftUI

struct MenuContentView: View {
    @ObservedObject var monitor: SystemMonitor
    @ObservedObject var tools: ToolController
    @ObservedObject var shortcuts: GlobalShortcutStore
    @State private var showingClamshellInfo = false
    @State private var showingSleepToolsInfo = false
    @State private var showingNotificationsInfo = false
    @State private var showingShortcutsInfo = false
    @State private var showingShortcutEditor = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            systemStatus
            Divider()
            clamshellSection
            Divider()
            infoSection(L10n.Section.sleepTools, isPresented: $showingSleepToolsInfo, help: L10n.Help.aboutSleepTools) {
                ForEach(tools.services.filter { $0.id.contains("sleep") }, id: \.id) { serviceToggle($0) }
            } info: {
                sleepToolsInfo
            }
            Divider()
            energyModeSection
            Divider()
            infoSection(L10n.Section.servicesAlerts, isPresented: $showingNotificationsInfo, help: L10n.Help.aboutServices) {
                switchRow(L10n.Services.loginWakeSound, monitor.loginWakeSoundEnabled, monitor.setLoginWakeSoundEnabled)
                ForEach(tools.services.filter { !$0.id.contains("sleep") && !$0.id.contains("sidescreen-login") }, id: \.id) { serviceToggle($0) }
            } info: {
                notificationsInfo
            }
            Divider()
            shortcutsSection
            Divider()
            if let error = monitor.errorMessage {
                Label(error, systemImage: "exclamationmark.triangle")
                    .font(.caption)
                    .foregroundStyle(.red)
                    .fixedSize(horizontal: false, vertical: true)
            } else if let message = tools.lastMessage {
                Text(message).font(.caption).foregroundStyle(.secondary)
            }
            HStack {
                HStack(spacing: 3) {
                    Text(L10n.Footer.halftopBy)
                    Link("enesky", destination: URL(string: "https://github.com/enesky/halftop")!)
                        .underline()
                }
                .font(.callout)
                .foregroundStyle(.secondary)
                Spacer()
                Button(L10n.Footer.quit) { monitor.stop(); NSApplication.shared.terminate(nil) }
                    .keyboardShortcut("q")
            }
        }
        .padding(14)
        .frame(width: 360)
    }

    private var systemStatus: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 8) {
            status(monitor.disableBuiltInDisplay ? L10n.Status.builtinDisplayDisabled : L10n.Status.builtinDisplay, monitor.disableBuiltInDisplay ? L10n.State.disabled : L10n.State.enabled)
            status(L10n.Status.externalDisplay, monitor.hasExternalDisplay ? L10n.State.connected : L10n.State.notConnected)
            status(L10n.Status.airPlay, monitor.hasAirPlayDisplay ? L10n.State.connected : L10n.State.notConnected)
            sideScreenStatus
            status(L10n.Status.powerSource, monitor.isOnACPower ? L10n.State.powerAdapter : L10n.State.battery)
            status(L10n.Status.energyMode, monitor.energyMode.text)
        }
    }

    @ViewBuilder private var sideScreenStatus: some View {
        if tools.sideScreen.isSupported {
            status(L10n.Status.sideScreen, tools.sideScreen.summaryText, icon: "checkmark.circle", iconColor: .green)
        } else {
            Link(destination: SideScreenInstallation.releaseURL) {
                status(L10n.Status.sideScreen, tools.sideScreen.summaryText, icon: "exclamationmark.triangle", iconColor: .orange)
            }
            .buttonStyle(.plain)
        }
    }

    private var shortcutsSection: some View {
        VStack(alignment: .leading, spacing: 9) {
            HStack {
                Text(L10n.Section.shortcuts)
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(.secondary)
                Button {
                    tools.refreshSideScreen()
                    showingShortcutsInfo.toggle()
                } label: {
                    Image(systemName: "info.circle")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
                .help(L10n.Help.aboutShortcuts)
                .popover(isPresented: $showingShortcutsInfo, arrowEdge: .trailing) {
                    shortcutsInfo
                }
                Spacer()
                Button(L10n.Shortcuts.edit) { showingShortcutEditor.toggle() }
                    .buttonStyle(.plain)
                    .font(.caption)
                    .popover(isPresented: $showingShortcutEditor, arrowEdge: .trailing) {
                        shortcutEditor
                    }
            }
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                ForEach(visibleShortcutCommands) { shortcutButton($0) }
            }
            if !shortcuts.registrationErrors.isEmpty {
                Label(L10n.Shortcuts.alreadyInUse, systemImage: "exclamationmark.triangle")
                    .font(.caption2)
                    .foregroundStyle(.red)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }

    private var visibleShortcutCommands: [ShortcutCommand] {
        ShortcutCommand.allCases.filter { !$0.requiresSideScreen || tools.sideScreen.isSupported }
    }

    private var energyModeSection: some View {
        section(L10n.Section.energyMode) {
            if monitor.batteryEnergyMode != .unavailable {
                energyModePicker(.battery)
            }
            if monitor.adapterEnergyMode != .unavailable {
                energyModePicker(.adapter)
            }
        }
    }

    private func energyModePicker(_ source: EnergyPowerSource) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(source.title).font(.caption).foregroundStyle(.secondary)
            Picker(source.title, selection: Binding(
                get: { source == .battery ? monitor.batteryEnergyMode : monitor.adapterEnergyMode },
                set: { monitor.setEnergyMode($0, for: source) }
            )) {
                ForEach(EnergyMode.configurable.filter { monitor.supportsHighPowerMode || $0 != .highPower }, id: \.self) {
                    Text($0.text).tag($0)
                }
            }
            .labelsHidden()
            .pickerStyle(.segmented)
        }
    }

    private func shortcutButton(_ command: ShortcutCommand) -> some View {
        let display = shortcuts.bindings[command]?.readableDisplay ?? "—"
        let displayColor: Color = shortcuts.registrationErrors[command] == nil ? .secondary : .red
        return Button { shortcuts.run(command) } label: {
            HStack(spacing: 8) {
                Image(systemName: command.icon).frame(width: 18)
                VStack(alignment: .leading, spacing: 2) {
                    Text(command.title).lineLimit(2)
                    Text(display)
                        .font(.caption2)
                        .foregroundStyle(displayColor)
                        .lineLimit(2)
                }
                Spacer(minLength: 0)
            }
            .contentShape(Rectangle())
            .padding(.horizontal, 9)
            .padding(.vertical, 7)
            .frame(maxWidth: .infinity, minHeight: 64, alignment: .leading)
            .background(.quaternary, in: RoundedRectangle(cornerRadius: 8))
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(.separator.opacity(0.55), lineWidth: 0.5)
            }
        }
        .buttonStyle(.plain)
        .help(shortcuts.registrationErrors[command] ?? command.title)
    }

    private var shortcutsInfo: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(L10n.ShortcutsInfo.title).font(.headline)
            infoRow(L10n.Shortcuts.autoAirPlay, L10n.ShortcutsInfo.autoAirPlayDesc)
            infoRow(L10n.Shortcuts.sleepNow, L10n.ShortcutsInfo.sleepNowDesc)
            if tools.sideScreen.isSupported {
                infoRow(L10n.Shortcuts.sideScreenUSB, L10n.ShortcutsInfo.sideScreenUSBDesc)
                infoRow(L10n.Shortcuts.sideScreenWiFi, L10n.ShortcutsInfo.sideScreenWiFiDesc)
            }
            Divider()
            sideScreenInfo(
                installedMessage: L10n.ShortcutsInfo.usbWiFiAvailable,
                updateMessage: L10n.ShortcutsInfo.updateRequired,
                missingMessage: L10n.ShortcutsInfo.installRequired
            )
        }
        .padding(14)
        .frame(width: 340)
    }

    private func sideScreenInfo(installedMessage: String, updateMessage: String, missingMessage: String) -> some View {
        let isReady = tools.sideScreen.isSupported
        return VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: isReady ? "checkmark.circle" : "exclamationmark.triangle")
                    .foregroundStyle(isReady ? .green : .orange)
                VStack(alignment: .leading, spacing: 2) {
                    Text(tools.sideScreen.statusText)
                        .font(.caption)
                    Text(isReady ? installedMessage : (tools.sideScreen.isInstalled ? updateMessage : missingMessage))
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                if !isReady {
                    Link(tools.sideScreen.isInstalled ? L10n.SideScreen.update : L10n.SideScreen.install, destination: SideScreenInstallation.releaseURL)
                        .font(.caption)
                }
            }

        }
    }

    private var shortcutEditor: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(L10n.Section.shortcuts).font(.headline)
            Text(L10n.Shortcuts.pressNewCombo)
                .font(.caption)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
            ForEach(visibleShortcutCommands) { command in
                VStack(alignment: .leading, spacing: 3) {
                    HStack(spacing: 8) {
                        Image(systemName: command.icon)
                            .frame(width: 20, alignment: .center)
                        Text(command.title)
                            .lineLimit(1)
                        Spacer()
                        Button { shortcuts.beginRecording(command) } label: {
                            Text(shortcuts.recording == command ? L10n.Shortcuts.pressKeys : shortcuts.bindings[command]?.readableDisplay ?? L10n.Shortcuts.set)
                                .font(.caption2)
                                .foregroundStyle(shortcuts.recording == command ? Color.accentColor : .secondary)
                                .multilineTextAlignment(.center)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.horizontal, 9)
                                .frame(width: 190)
                                .frame(minHeight: 38)
                                .background(.quaternary, in: RoundedRectangle(cornerRadius: 8))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(.separator.opacity(0.55), lineWidth: 0.5)
                                }
                                .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                    }
                    if let error = shortcuts.registrationErrors[command] {
                        Text(error)
                            .font(.caption2)
                            .foregroundStyle(.red)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.leading, 28)
                    }
                }
            }
            HStack {
                Button(L10n.Shortcuts.resetDefaults) { shortcuts.resetDefaults() }
                Spacer()
                Button(L10n.Footer.quit) { showingShortcutEditor = false }
                    .keyboardShortcut(.defaultAction)
            }
        }
        .padding(14)
        .frame(width: 480)
    }

    private var clamshellSection: some View {
        VStack(alignment: .leading, spacing: 9) {
            HStack(spacing: 5) {
                Text(L10n.Section.clamshellReady)
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(.secondary)
                Button {
                    tools.refreshSideScreen()
                    showingClamshellInfo.toggle()
                } label: {
                    Image(systemName: "info.circle")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
                .help(L10n.Help.aboutClamshell)
                .popover(isPresented: $showingClamshellInfo, arrowEdge: .trailing) {
                    clamshellInfo
                }
                Spacer()
            }
            switchRow(L10n.Clamshell.launchAtLogin, monitor.launchAtLogin, monitor.setLaunchAtLogin)
            switchRow(L10n.Clamshell.allowOnBattery, monitor.allowOnBattery, monitor.setAllowOnBattery)
            if tools.sideScreen.isSupported {
                ForEach(tools.services.filter { $0.id.contains("sidescreen-login") }, id: \.id) { serviceToggle($0) }
            }
            switchRow(L10n.Clamshell.ignoreLidClose, monitor.lidOverrideDesired, monitor.setLidOverrideEnabled)
            if monitor.hasBuiltInDisplay {
                switchRow(L10n.Clamshell.disableBuiltinDisplay, monitor.disableBuiltInDisplay, monitor.setDisableBuiltInDisplay)
                if !monitor.disableBuiltInDisplay {
                    switchRow(L10n.Clamshell.dimBuiltinDisplay, monitor.dimBuiltInAtLogin, monitor.setDimBuiltInAtLogin)
                }
            }
        }
    }

    private var clamshellInfo: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(L10n.ClamshellInfo.title).font(.headline)
            Text(L10n.ClamshellInfo.description)
                .foregroundStyle(.secondary)
            infoRow(L10n.Clamshell.launchAtLogin, L10n.ClamshellInfo.launchAtLoginDesc)
            infoRow(L10n.Clamshell.allowOnBattery, L10n.ClamshellInfo.allowOnBatteryDesc)
            if tools.sideScreen.isSupported {
                infoRow(L10n.Clamshell.launchSideScreenAtLogin, L10n.ClamshellInfo.launchSideScreenAtLoginDesc)
            }
            infoRow(L10n.Clamshell.ignoreLidClose, L10n.ClamshellInfo.ignoreLidCloseDesc)
            infoRow(L10n.Clamshell.dimBuiltinDisplay, L10n.ClamshellInfo.dimBuiltinDisplayDesc)
            infoRow(L10n.Clamshell.disableBuiltinDisplay, L10n.ClamshellInfo.disableBuiltinDisplayDesc)
            Divider()
            sideScreenInfo(
                installedMessage: L10n.ShortcutsInfo.usbWiFiAvailable,
                updateMessage: L10n.ShortcutsInfo.updateRequired,
                missingMessage: L10n.ShortcutsInfo.installRequired
            )
        }
        .padding(14)
        .frame(width: 330)
    }

    private var sleepToolsInfo: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(L10n.SleepToolsInfo.title).font(.headline)
            Text(L10n.SleepToolsInfo.description)
                .foregroundStyle(.secondary)
            infoRow(L10n.SleepTools.autoResleep, L10n.SleepToolsInfo.autoResleepDesc)
            infoRow(L10n.SleepTools.bagSleepGuard, L10n.SleepToolsInfo.bagSleepGuardDesc)
        }
        .padding(14)
        .frame(width: 330)
    }

    private var notificationsInfo: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(L10n.ServicesInfo.title).font(.headline)
            Text(L10n.ServicesInfo.description)
                .foregroundStyle(.secondary)
            infoRow(L10n.Services.loginWakeSound, L10n.ServicesInfo.loginWakeSoundDesc)
            infoRow(L10n.Services.batteryVoiceAlert, L10n.ServicesInfo.batteryVoiceAlertDesc)
            infoRow(L10n.Services.lockScreenSayer, L10n.ServicesInfo.lockScreenSayerDesc)
        }
        .padding(14)
        .frame(width: 330)
    }

    private func infoRow(_ title: String, _ description: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(title).font(.subheadline.weight(.semibold))
            Text(description)
                .font(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private func section<Content: View>(_ title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 9) {
            Text(title).font(.caption2.weight(.semibold)).foregroundStyle(.secondary)
            content()
        }
    }

    private func infoSection<Content: View, Info: View>(
        _ title: String,
        isPresented: Binding<Bool>,
        help: String,
        @ViewBuilder content: () -> Content,
        @ViewBuilder info: @escaping () -> Info
    ) -> some View {
        VStack(alignment: .leading, spacing: 9) {
            HStack(spacing: 5) {
                Text(title).font(.caption2.weight(.semibold)).foregroundStyle(.secondary)
                Button { isPresented.wrappedValue.toggle() } label: {
                    Image(systemName: "info.circle")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
                .help(help)
                .popover(isPresented: isPresented, arrowEdge: .trailing) { info() }
                Spacer()
            }
            content()
        }
    }

    private func serviceToggle(_ service: ManagedService) -> some View {
        switchRow(service.title, tools.serviceStates[service.id] ?? false) { tools.set(service, enabled: $0) }
            .disabled(tools.busyService == service.id)
    }

    private func switchRow(_ title: String, _ value: Bool, _ update: @escaping (Bool) -> Void) -> some View {
        HStack {
            Text(title)
            Spacer()
            Toggle(title, isOn: Binding(get: { value }, set: update))
                .labelsHidden()
                .toggleStyle(.switch)
        }
        .frame(maxWidth: .infinity)
    }

    private func status(_ title: String, _ value: String, icon: String? = nil, iconColor: Color = .secondary) -> some View {
        VStack(alignment: .center, spacing: 1) {
            Text(title).font(.caption2).foregroundStyle(.secondary)
            HStack(spacing: 3) {
                if let icon {
                    Image(systemName: icon)
                        .font(.caption2)
                        .foregroundStyle(iconColor)
                }
                Text(value).font(.caption.weight(.medium))
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .multilineTextAlignment(.center)
    }
}
