import QtQuick
import QtQuick.Layouts
import Quickshell.Bluetooth
import Quickshell.Networking
import Quickshell.Services.Pipewire
import Quickshell.Services.UPower

import "root:/"

// The right-hand cluster. Every pill opens quick settings - the bar itself
// stays read-only, so there is one place where things get changed.
RowLayout {
    id: root

    required property var screen

    readonly property var sink: Pipewire.defaultAudioSink
    readonly property var battery: UPower.displayDevice
    readonly property bool hasBattery: (root.battery?.isLaptopBattery ?? false) && (root.battery?.isPresent ?? false)

    readonly property var wifiDevice: {
        const devices = Networking.devices?.values ?? [];
        return devices.find(d => d.type === DeviceType.Wifi) ?? null;
    }

    readonly property var activeWifi: {
        const nets = root.wifiDevice?.networks?.values ?? [];
        return nets.find(n => n.connected) ?? null;
    }

    spacing: 4

    PwObjectTracker {
        objects: root.sink ? [root.sink] : []
    }

    component Pill: Rectangle {
        id: pill

        property string icon: ""
        property string label: ""
        property color iconColor: Theme.fg

        implicitWidth: pillRow.implicitWidth + Theme.spacing * 2
        implicitHeight: 24
        radius: Theme.radius
        color: pillHover.containsMouse ? Theme.sel : Theme.bgAlt

        RowLayout {
            id: pillRow

            anchors.centerIn: parent
            spacing: 5

            Text {
                text: pill.icon
                color: pill.iconColor
                font.family: Theme.monoFamily
                font.pixelSize: Theme.fontSize
            }

            Text {
                visible: pill.label !== ""
                text: pill.label
                color: Theme.fg
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSize - 1
            }
        }

        MouseArea {
            id: pillHover

            anchors.fill: parent
            hoverEnabled: true
            onClicked: Panels.toggleQuickSettings(root.screen)
        }
    }

    Pill {
        icon: {
            if (!root.sink?.audio || root.sink.audio.muted)
                return "󰖁";
            const v = root.sink.audio.volume;
            return v < 0.34 ? "󰕿" : v < 0.67 ? "󰖀" : "󰕾";
        }
        label: root.sink?.audio ? Math.round(root.sink.audio.volume * 100) + "%" : ""
        iconColor: root.sink?.audio?.muted ? Theme.fgDim : Theme.fg
    }

    Pill {
        visible: root.wifiDevice !== null
        icon: {
            if (!Networking.wifiEnabled)
                return "󰤮";
            if (!root.activeWifi)
                return "󰤯";
            const s = root.activeWifi.signalStrength ?? 0;
            if (s > 0.8)
                return "󰤨";
            if (s > 0.6)
                return "󰤥";
            if (s > 0.4)
                return "󰤢";
            if (s > 0.2)
                return "󰤟";
            return "󰤯";
        }
        label: root.activeWifi?.name ?? ""
        iconColor: root.activeWifi ? Theme.fg : Theme.fgDim
    }

    Pill {
        visible: Bluetooth.defaultAdapter !== null
        icon: {
            if (!Bluetooth.defaultAdapter?.enabled)
                return "󰂲";
            const connected = (Bluetooth.defaultAdapter?.devices?.values ?? []).filter(d => d.connected);
            return connected.length > 0 ? "󰂱" : "󰂯";
        }
        iconColor: Bluetooth.defaultAdapter?.enabled ? Theme.fg : Theme.fgDim
    }

    Pill {
        visible: root.hasBattery

        readonly property real pct: root.battery?.percentage ?? 0
        readonly property bool charging: root.battery?.state === UPowerDeviceState.Charging

        icon: {
            if (charging)
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
        label: Math.round(pct * 100) + "%"
        iconColor: {
            if (charging)
                return Theme.ok;
            if (pct <= 0.15)
                return Theme.err;
            if (pct <= 0.3)
                return Theme.warn;
            return Theme.fg;
        }
    }
}
