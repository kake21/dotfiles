import QtQuick
import QtQuick.Layouts

import "root:/"

// A titled container. Children are placed in a column inside the card.
Rectangle {
    id: root

    property string title: ""
    default property alias content: body.data

    Layout.fillWidth: true
    implicitHeight: col.implicitHeight + Theme.padding * 2
    color: Theme.bgAlt
    radius: Theme.radius

    ColumnLayout {
        id: col

        anchors.fill: parent
        anchors.margins: Theme.padding
        spacing: Theme.spacing

        Text {
            visible: root.title !== ""
            text: root.title
            color: Theme.fgDim
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSize - 1
            font.bold: true
        }

        ColumnLayout {
            id: body

            Layout.fillWidth: true
            spacing: Theme.spacing
        }
    }
}
