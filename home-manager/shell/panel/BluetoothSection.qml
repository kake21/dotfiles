import QtQuick
import QtQuick.Layouts
import Quickshell.Bluetooth

import "root:/"
import "root:/components"

Card {
    id: root

    readonly property var adapter: Bluetooth.defaultAdapter

    readonly property var devices: {
        const list = root.adapter?.devices?.values ?? [];
        return list.slice().sort((a, b) => {
            if (a.connected !== b.connected)
                return a.connected ? -1 : 1;
            if (a.paired !== b.paired)
                return a.paired ? -1 : 1;
            return (a.name ?? "").localeCompare(b.name ?? "");
        });
    }

    title: "Bluetooth"
    // Desktops without a controller get no card at all.
    visible: root.adapter !== null

    function deviceIcon(device) {
        switch (device.icon) {
        case "audio-headset":
        case "audio-headphones":
            return "󰋋";
        case "audio-card":
            return "󰓃";
        case "input-mouse":
            return "󰍽";
        case "input-keyboard":
            return "󰌌";
        case "input-gaming":
            return "󰊴";
        case "phone":
            return "󰄜";
        default:
            return "󰂯";
        }
    }

    // Discover only while the panel is open, so we are not scanning forever.
    Binding {
        target: root.adapter
        property: "discovering"
        value: Panels.quickSettingsOpen && (root.adapter?.enabled ?? false)
        when: root.adapter !== null
    }

    RowLayout {
        Layout.fillWidth: true
        spacing: Theme.spacing

        Text {
            Layout.fillWidth: true
            text: {
                if (!root.adapter?.enabled)
                    return "Bluetooth off";
                const connected = root.devices.filter(d => d.connected).length;
                return connected > 0 ? connected + " connected" : "No devices connected";
            }
            color: Theme.fgDim
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSize - 2
        }

        ToggleTile {
            Layout.preferredWidth: 76
            Layout.fillWidth: false
            icon: root.adapter?.enabled ? "󰂯" : "󰂲"
            label: root.adapter?.enabled ? "On" : "Off"
            active: root.adapter?.enabled ?? false
            onClicked: {
                if (root.adapter)
                    root.adapter.enabled = !root.adapter.enabled;
            }
        }
    }

    ColumnLayout {
        Layout.fillWidth: true
        visible: root.adapter?.enabled ?? false
        spacing: 0

        Repeater {
            model: root.devices.slice(0, 5)

            ListRow {
                required property var modelData

                icon: root.deviceIcon(modelData)
                label: modelData.name
                active: modelData.connected
                busy: modelData.pairing || modelData.state === BluetoothDeviceState.Connecting
                detail: {
                    const bits = [];
                    if (modelData.connected)
                        bits.push("connected");
                    else if (modelData.paired)
                        bits.push("paired");
                    if (modelData.batteryAvailable)
                        bits.push(Math.round(modelData.battery * 100) + "%");
                    return bits.join(" · ");
                }

                onClicked: {
                    if (modelData.connected)
                        modelData.disconnect();
                    else if (modelData.paired)
                        modelData.connect();
                    else
                        modelData.pair();
                }
                // Right click forgets a paired device.
                onSecondaryClicked: {
                    if (modelData.paired)
                        modelData.forget();
                }
            }
        }

        Text {
            Layout.fillWidth: true
            visible: root.devices.length === 0
            text: "Searching…"
            color: Theme.fgDim
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSize - 2
        }
    }
}
