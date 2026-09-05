import QtQuick
import QtQuick.Layouts

import "root:/"

// Square-ish tile used in the toggle grid. Highlights when `active`.
Rectangle {
    id: root

    property string icon: ""
    property string label: ""
    property bool active: false

    signal clicked

    Layout.fillWidth: true
    implicitHeight: 56
    radius: Theme.radius
    color: root.active ? Theme.accent : Theme.sel

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 2

        Text {
            Layout.alignment: Qt.AlignHCenter
            text: root.icon
            color: root.active ? Theme.bg : Theme.fg
            font.family: Theme.monoFamily
            font.pixelSize: Theme.fontSize + 4
        }

        Text {
            Layout.alignment: Qt.AlignHCenter
            text: root.label
            color: root.active ? Theme.bg : Theme.fgDim
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSize - 2
        }
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onClicked: root.clicked()
        onEntered: root.opacity = 0.85
        onExited: root.opacity = 1
    }

    Behavior on color {
        ColorAnimation {
            duration: 120
        }
    }
}
