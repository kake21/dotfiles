import QtQuick
import QtQuick.Layouts
import Quickshell.Io

import "root:/"
import "root:/components"

Card {
    id: root

    property bool nightLight: false
    property bool dnd: false

    title: "Quick toggles"

    // hyprsunset runs as a daemon (started from the Hyprland start hook); a
    // second invocation talks to it over its socket.
    //
    // Note: the time profiles in hypr/hyprsunset.conf (07:30 identity,
    // 22:00 3700K) still fire and will override this at those times.
    function setNightLight(on) {
        root.nightLight = on;
        sunsetProc.exec(on ? [Config.hyprsunset, "-t", String(Config.nightTemp)] : [Config.hyprsunset, "-i"]);
    }

    function refreshDnd() {
        if (!dndReadProc.running)
            dndReadProc.running = true;
    }

    Process {
        id: sunsetProc
    }

    Process {
        id: dndToggleProc

        command: [Config.makoctl, "mode", "-t", "do-not-disturb"]
        onExited: root.refreshDnd()
    }

    // `makoctl mode` lists active modes, one per line.
    Process {
        id: dndReadProc

        running: true
        command: [Config.makoctl, "mode"]

        stdout: StdioCollector {
            onStreamFinished: root.dnd = text.split("\n").map(l => l.trim()).includes("do-not-disturb")
        }
    }

    Connections {
        target: Panels

        function onQuickSettingsOpenChanged() {
            if (Panels.quickSettingsOpen)
                root.refreshDnd();
        }
    }

    RowLayout {
        Layout.fillWidth: true
        spacing: Theme.spacing

        ToggleTile {
            icon: root.nightLight ? "󰖔" : "󰃞"
            label: "Night light"
            active: root.nightLight
            onClicked: root.setNightLight(!root.nightLight)
        }

        ToggleTile {
            icon: root.dnd ? "󰂛" : "󰂚"
            label: root.dnd ? "Silenced" : "Notify"
            active: root.dnd
            onClicked: {
                if (!dndToggleProc.running)
                    dndToggleProc.running = true;
            }
        }
    }
}
