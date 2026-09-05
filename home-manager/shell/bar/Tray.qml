import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray

import "root:/"

RowLayout {
    id: root

    spacing: 6

    Repeater {
        model: SystemTray.items

        Item {
            id: entry

            required property var modelData

            implicitWidth: 18
            implicitHeight: 18

            Image {
                anchors.fill: parent
                source: entry.modelData.icon
                sourceSize.width: width
                sourceSize.height: height
                fillMode: Image.PreserveAspectFit
                smooth: true
            }

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.RightButton

                onClicked: mouse => {
                    if (mouse.button === Qt.RightButton || entry.modelData.onlyMenu) {
                        if (entry.modelData.hasMenu)
                            entry.modelData.display(QsWindow.window, entry.width / 2, entry.height);
                    } else {
                        entry.modelData.activate();
                    }
                }
            }
        }
    }
}
