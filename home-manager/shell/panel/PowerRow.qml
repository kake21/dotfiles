import QtQuick
import QtQuick.Layouts
import Quickshell.Io

import "root:/"
import "root:/components"

Card {
    id: root

    title: "Session"

    function run(command) {
        Panels.closeQuickSettings();
        proc.exec(command);
    }

    Process {
        id: proc
    }

    RowLayout {
        Layout.fillWidth: true
        spacing: Theme.spacing

        ToggleTile {
            icon: "󰌾"
            label: "Lock"
            onClicked: root.run([Config.hyprlock])
        }

        ToggleTile {
            icon: "󰒲"
            label: "Suspend"
            onClicked: root.run([Config.systemctl, "suspend"])
        }

        ToggleTile {
            icon: "󰜉"
            label: "Reboot"
            onClicked: root.run([Config.systemctl, "reboot"])
        }

        ToggleTile {
            icon: "󰐥"
            label: "Shutdown"
            onClicked: root.run([Config.systemctl, "poweroff"])
        }
    }
}
