import QtQuick
import QtQuick.Layouts

import "root:/"

// Hand-rolled slider: avoids pulling in QtQuick.Controls just to restyle it.
// `value` is 0..1. Emits `moved` while dragging; the owner writes it back.
Item {
    id: root

    property string icon: ""
    property real value: 0
    property bool active: true
    property bool showPercent: true

    signal moved(real value)

    readonly property real clamped: Math.max(0, Math.min(1, root.value))

    Layout.fillWidth: true
    implicitHeight: 26

    RowLayout {
        anchors.fill: parent
        spacing: Theme.spacing

        Text {
            Layout.preferredWidth: 20
            text: root.icon
            color: root.active ? Theme.fg : Theme.muted
            font.family: Theme.monoFamily
            font.pixelSize: Theme.fontSize + 2
            horizontalAlignment: Text.AlignHCenter
        }

        Item {
            id: slot

            Layout.fillWidth: true
            Layout.fillHeight: true

            Rectangle {
                id: track

                anchors.verticalCenter: parent.verticalCenter
                width: parent.width
                height: 8
                radius: height / 2
                color: Theme.sel

                Rectangle {
                    width: parent.width * root.clamped
                    height: parent.height
                    radius: parent.radius
                    color: root.active ? Theme.accent : Theme.muted
                }
            }

            MouseArea {
                anchors.fill: parent
                onPressed: mouse => root.moved(Math.max(0, Math.min(1, mouse.x / width)))
                onPositionChanged: mouse => {
                    if (pressed)
                        root.moved(Math.max(0, Math.min(1, mouse.x / width)));
                }
            }
        }

        Text {
            visible: root.showPercent
            Layout.preferredWidth: 36
            text: Math.round(root.clamped * 100) + "%"
            color: Theme.fgDim
            font.family: Theme.monoFamily
            font.pixelSize: Theme.fontSize - 1
            horizontalAlignment: Text.AlignRight
        }
    }
}
