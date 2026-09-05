import QtQuick
import QtQuick.Layouts

import "root:/"

// One entry in the Wi-Fi / Bluetooth lists.
Rectangle {
    id: root

    property string icon: ""
    property string label: ""
    property string detail: ""
    property bool active: false
    property bool busy: false

    signal clicked
    signal secondaryClicked

    Layout.fillWidth: true
    implicitHeight: 38
    radius: Theme.radius - 2
    color: hover.containsMouse ? Theme.sel : "transparent"

    RowLayout {
        anchors.fill: parent
        anchors.leftMargin: Theme.spacing
        anchors.rightMargin: Theme.spacing
        spacing: Theme.spacing

        Text {
            Layout.preferredWidth: 20
            text: root.icon
            color: root.active ? Theme.accent : Theme.fgDim
            font.family: Theme.monoFamily
            font.pixelSize: Theme.fontSize + 1
            horizontalAlignment: Text.AlignHCenter
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 0

            Text {
                Layout.fillWidth: true
                text: root.label
                elide: Text.ElideRight
                color: root.active ? Theme.fgBright : Theme.fg
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSize
                font.bold: root.active
            }

            Text {
                Layout.fillWidth: true
                visible: root.detail !== ""
                text: root.detail
                elide: Text.ElideRight
                color: Theme.fgDim
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSize - 3
            }
        }

        Text {
            visible: root.busy
            text: "󰑓"
            color: Theme.fgDim
            font.family: Theme.monoFamily
            font.pixelSize: Theme.fontSize
        }
    }

    MouseArea {
        id: hover

        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: mouse => {
            if (mouse.button === Qt.RightButton)
                root.secondaryClicked();
            else
                root.clicked();
        }
    }
}
