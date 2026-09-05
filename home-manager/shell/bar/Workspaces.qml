import QtQuick
import QtQuick.Layouts
import Quickshell.Hyprland

import "root:/"

RowLayout {
    id: root

    required property var screen

    readonly property var monitor: Hyprland.monitorFor(root.screen)

    // Only this monitor's workspaces, in numeric order.
    readonly property var workspaces: {
        const all = Hyprland.workspaces?.values ?? [];
        return all.filter(w => w.monitor === root.monitor && w.id > 0).sort((a, b) => a.id - b.id);
    }

    spacing: 4

    Repeater {
        model: root.workspaces

        Rectangle {
            required property var modelData

            implicitWidth: modelData.focused ? 28 : 20
            implicitHeight: 20
            radius: height / 2
            color: {
                if (modelData.focused)
                    return Theme.accent;
                if (modelData.urgent)
                    return Theme.err;
                return Theme.sel;
            }

            Text {
                anchors.centerIn: parent
                text: modelData.id
                color: modelData.focused ? Theme.bg : Theme.fgDim
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSize - 2
                font.bold: modelData.focused
            }

            MouseArea {
                anchors.fill: parent
                onClicked: modelData.activate()
            }

            Behavior on implicitWidth {
                NumberAnimation {
                    duration: 120
                    easing.type: Easing.OutCubic
                }
            }

            Behavior on color {
                ColorAnimation {
                    duration: 120
                }
            }
        }
    }
}
