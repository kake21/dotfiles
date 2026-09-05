import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

import "root:/"
import "root:/bar"

PanelWindow {
    id: root

    required property var modelData

    screen: root.modelData

    anchors {
        left: true
        right: true
        top: Config.barPosition === "top"
        bottom: Config.barPosition === "bottom"
    }

    implicitHeight: Config.barHeight
    color: Theme.bg

    WlrLayershell.namespace: "vshell-bar"

    Item {
        anchors.fill: parent
        anchors.leftMargin: Theme.spacing
        anchors.rightMargin: Theme.spacing

        Workspaces {
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            screen: root.modelData
        }

        Clock {
            anchors.centerIn: parent
        }

        RowLayout {
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            spacing: Theme.spacing

            Tray {}

            StatusPills {
                screen: root.modelData
            }
        }
    }
}
