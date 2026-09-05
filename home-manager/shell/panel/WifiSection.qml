import QtQuick
import QtQuick.Layouts
import Quickshell.Networking

import "root:/"
import "root:/components"

Card {
    id: root

    readonly property var wifiDevice: {
        const devices = Networking.devices?.values ?? [];
        return devices.find(d => d.type === DeviceType.Wifi) ?? null;
    }

    readonly property var networks: {
        const list = root.wifiDevice?.networks?.values ?? [];
        // Connected first, then strongest.
        return list.slice().sort((a, b) => {
            if (a.connected !== b.connected)
                return a.connected ? -1 : 1;
            return (b.signalStrength ?? 0) - (a.signalStrength ?? 0);
        });
    }

    // Network awaiting a passphrase, or null when the prompt is closed.
    property var pskTarget: null

    title: "Wi-Fi"
    visible: root.wifiDevice !== null

    function signalIcon(strength) {
        const s = strength ?? 0;
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

    function activate(network) {
        if (network.connected) {
            network.disconnect();
            return;
        }
        if (network.known || network.security === WifiSecurityType.Open) {
            network.connect();
            return;
        }
        root.pskTarget = network;
    }

    // Only scan while the panel is actually on screen.
    Binding {
        target: root.wifiDevice
        property: "scannerEnabled"
        value: Panels.quickSettingsOpen
        when: root.wifiDevice !== null
    }

    RowLayout {
        Layout.fillWidth: true
        spacing: Theme.spacing

        Text {
            Layout.fillWidth: true
            text: Networking.wifiEnabled ? (root.wifiDevice?.connected ? "Connected" : "Not connected") : "Wi-Fi off"
            color: Theme.fgDim
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSize - 2
        }

        ToggleTile {
            Layout.preferredWidth: 76
            Layout.fillWidth: false
            icon: Networking.wifiEnabled ? "󰤨" : "󰤮"
            label: Networking.wifiEnabled ? "On" : "Off"
            active: Networking.wifiEnabled
            onClicked: Networking.wifiEnabled = !Networking.wifiEnabled
        }
    }

    // Passphrase prompt, shown in place of the list.
    ColumnLayout {
        Layout.fillWidth: true
        visible: root.pskTarget !== null
        spacing: Theme.spacing

        Text {
            Layout.fillWidth: true
            text: "Passphrase for " + (root.pskTarget?.name ?? "")
            elide: Text.ElideRight
            color: Theme.fg
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSize - 1
        }

        Rectangle {
            Layout.fillWidth: true
            implicitHeight: 32
            radius: Theme.radius - 2
            color: Theme.bg
            border.width: 1
            border.color: pskInput.activeFocus ? Theme.accent : Theme.muted

            TextInput {
                id: pskInput

                anchors.fill: parent
                anchors.leftMargin: Theme.spacing
                anchors.rightMargin: Theme.spacing
                verticalAlignment: TextInput.AlignVCenter
                echoMode: TextInput.Password
                color: Theme.fg
                font.family: Theme.monoFamily
                font.pixelSize: Theme.fontSize
                selectionColor: Theme.accent
                clip: true

                onAccepted: {
                    root.pskTarget.connectWithPsk(text);
                    text = "";
                    root.pskTarget = null;
                }

                // Escape cancels the prompt rather than closing the panel.
                Keys.onEscapePressed: root.pskTarget = null

                // Focus follows the prompt appearing.
                Connections {
                    target: root

                    function onPskTargetChanged() {
                        if (root.pskTarget)
                            pskInput.forceActiveFocus();
                        else
                            pskInput.text = "";
                    }
                }
            }
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: Theme.spacing

            ToggleTile {
                icon: "󰅖"
                label: "Cancel"
                onClicked: root.pskTarget = null
            }

            ToggleTile {
                icon: "󰌘"
                label: "Connect"
                active: true
                onClicked: {
                    root.pskTarget.connectWithPsk(pskInput.text);
                    pskInput.text = "";
                    root.pskTarget = null;
                }
            }
        }
    }

    ColumnLayout {
        Layout.fillWidth: true
        visible: Networking.wifiEnabled && root.pskTarget === null
        spacing: 0

        Repeater {
            model: root.networks.slice(0, 5)

            ListRow {
                required property var modelData

                icon: root.signalIcon(modelData.signalStrength)
                label: modelData.name
                active: modelData.connected
                busy: modelData.stateChanging
                detail: {
                    const bits = [];
                    if (modelData.connected)
                        bits.push("connected");
                    else if (modelData.known)
                        bits.push("saved");
                    if (modelData.security !== WifiSecurityType.Open)
                        bits.push(WifiSecurityType.toString(modelData.security));
                    return bits.join(" · ");
                }

                onClicked: root.activate(modelData)
                // Right click forgets a saved network.
                onSecondaryClicked: {
                    if (modelData.known)
                        modelData.forget();
                }
            }
        }

        Text {
            Layout.fillWidth: true
            visible: root.networks.length === 0
            text: "Scanning…"
            color: Theme.fgDim
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSize - 2
        }
    }
}
