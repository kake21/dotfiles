import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland

import "root:/"
import "root:/panel"

PanelWindow {
    id: root

    visible: Panels.quickSettingsOpen
    screen: Panels.quickSettingsScreen ?? Quickshell.screens[0]

    // No anchors: a layer-shell surface with nothing anchored is centred by the
    // compositor. On a superultrawide, a corner-pinned panel lands far outside
    // where you are actually looking.
    anchors {
        top: false
        right: false
        bottom: false
        left: false
    }

    implicitWidth: 380
    // Cap well short of the screen: centred, a full-height 380px column reads as
    // a thin strip rather than a panel. Anything taller scrolls in the Flickable.
    implicitHeight: Math.min(content.implicitHeight + Theme.padding * 2, (screen?.height ?? 1080) * 0.8)

    color: "transparent"
    // Ignore, not Normal: the panel is transient and must not push tiled
    // windows around while it is open.
    exclusionMode: ExclusionMode.Ignore
    // Needed so the Wi-Fi passphrase field can actually receive keystrokes.
    focusable: true

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "vshell-quicksettings"

    // Click anywhere outside the panel closes it.
    HyprlandFocusGrab {
        active: Panels.quickSettingsOpen
        windows: [root]
        onCleared: Panels.closeQuickSettings()
    }

    Rectangle {
        anchors.fill: parent
        radius: Theme.radius
        color: Theme.bg
        border.width: 1
        border.color: Theme.sel

        // Escape closes the panel. When the Wi-Fi passphrase field grabs focus
        // it handles Escape itself and cancels the prompt instead.
        focus: true
        Keys.onEscapePressed: Panels.closeQuickSettings()

        Flickable {
            anchors.fill: parent
            anchors.margins: Theme.padding
            contentHeight: content.implicitHeight
            clip: true
            boundsBehavior: Flickable.StopAtBounds

            ColumnLayout {
                id: content

                width: parent.width
                spacing: Theme.spacing

                VolumeSection {}
                BrightnessSection {}
                WifiSection {}
                BluetoothSection {}
                BatterySection {}
                ToggleGrid {}
                PowerRow {}
            }
        }
    }
}
