import QtQuick
import Quickshell

import "root:/"

Text {
    id: root

    // Minute resolution is all the bar shows, so don't wake every second.
    SystemClock {
        id: clock

        precision: SystemClock.Minutes
    }

    text: Qt.formatDateTime(clock.date, "HH:mm")
    color: Theme.fg
    font.family: Theme.fontFamily
    font.pixelSize: Theme.fontSize
    font.bold: true
}
