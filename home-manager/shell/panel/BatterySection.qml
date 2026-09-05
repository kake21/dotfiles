import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import Quickshell.Services.UPower

import "root:/"
import "root:/components"

// Read-only. Switching CPU governors would need root, and this laptop is
// driven by auto-cpufreq + tlp rather than power-profiles-daemon, so there is
// nothing here we can safely set from a user session.
Card {
    id: root

    readonly property var battery: UPower.displayDevice
    readonly property bool hasBattery: (root.battery?.isLaptopBattery ?? false) && (root.battery?.isPresent ?? false)

    property string governor: ""

    title: "Battery"
    visible: root.hasBattery

    function stateText() {
        if (!root.battery)
            return "";
        switch (root.battery.state) {
        case UPowerDeviceState.Charging:
            return "Charging";
        case UPowerDeviceState.Discharging:
            return "Discharging";
        case UPowerDeviceState.FullyCharged:
            return "Fully charged";
        case UPowerDeviceState.Empty:
            return "Empty";
        case UPowerDeviceState.PendingCharge:
            return "Pending charge";
        case UPowerDeviceState.PendingDischarge:
            return "Pending discharge";
        default:
            return "Unknown";
        }
    }

    function durationText() {
        if (!root.battery)
            return "";
        const secs = root.battery.state === UPowerDeviceState.Charging ? root.battery.timeToFull : root.battery.timeToEmpty;
        if (!secs || secs <= 0)
            return "";
        const h = Math.floor(secs / 3600);
        const m = Math.floor((secs % 3600) / 60);
        const label = root.battery.state === UPowerDeviceState.Charging ? " until full" : " remaining";
        return (h > 0 ? h + "h " + m + "m" : m + "m") + label;
    }

    // auto-cpufreq flips this on AC/battery transitions, so re-read on open
    // rather than caching it once at startup.
    Process {
        id: govProc

        command: [Config.cat, "/sys/devices/system/cpu/cpu0/cpufreq/scaling_governor"]

        stdout: StdioCollector {
            onStreamFinished: root.governor = text.trim()
        }
    }

    Connections {
        target: Panels

        function onQuickSettingsOpenChanged() {
            if (Panels.quickSettingsOpen && !govProc.running)
                govProc.running = true;
        }
    }

    RowLayout {
        Layout.fillWidth: true
        spacing: Theme.spacing

        Text {
            text: {
                const pct = root.battery?.percentage ?? 0;
                if (root.battery?.state === UPowerDeviceState.Charging)
                    return "󰂄";
                if (pct > 0.9)
                    return "󰁹";
                if (pct > 0.7)
                    return "󰂁";
                if (pct > 0.5)
                    return "󰁿";
                if (pct > 0.3)
                    return "󰁽";
                if (pct > 0.15)
                    return "󰁻";
                return "󰁺";
            }
            color: {
                const pct = root.battery?.percentage ?? 0;
                if (root.battery?.state === UPowerDeviceState.Charging)
                    return Theme.ok;
                if (pct <= 0.15)
                    return Theme.err;
                if (pct <= 0.3)
                    return Theme.warn;
                return Theme.fg;
            }
            font.family: Theme.monoFamily
            font.pixelSize: Theme.fontSize + 8
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 0

            Text {
                text: Math.round((root.battery?.percentage ?? 0) * 100) + "%"
                color: Theme.fg
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSize + 4
                font.bold: true
            }

            Text {
                Layout.fillWidth: true
                text: root.durationText()
                visible: text !== ""
                elide: Text.ElideRight
                color: Theme.fgDim
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSize - 2
            }
        }
    }

    Text {
        Layout.fillWidth: true
        text: {
            const bits = [root.stateText()];
            const rate = root.battery?.changeRate ?? 0;
            if (rate > 0)
                bits.push(rate.toFixed(1) + " W");
            if (root.governor !== "")
                bits.push("governor: " + root.governor);
            return bits.filter(b => b !== "").join(" · ");
        }
        elide: Text.ElideRight
        color: Theme.fgDim
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSize - 3
    }
}
