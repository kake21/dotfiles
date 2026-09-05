import QtQuick
import Quickshell.Io

import "root:/"
import "root:/components"

// brightnessctl has no D-Bus/QML service in Quickshell, so this shells out.
// The whole card hides itself when the host has no backlight device, which is
// the normal case on the desktops.
Card {
    id: root

    property int current: 0
    property int max: 0
    property bool available: root.max > 0

    readonly property real fraction: root.available ? root.current / root.max : 0

    title: "Brightness"
    visible: root.available

    function refresh() {
        if (!readProc.running)
            readProc.running = true;
    }

    function apply(fraction) {
        if (!root.available)
            return;
        // Never go fully dark - a 0% backlight looks like a crashed shell.
        const pct = Math.max(1, Math.round(fraction * 100));
        root.current = Math.round(root.max * pct / 100);
        setProc.exec([Config.brightnessctl, "-m", "-c", "backlight", "set", pct + "%"]);
    }

    // `brightnessctl -m i` prints: device,class,current,percent%,max
    //
    // `-c backlight` is load-bearing: without it brightnessctl picks whatever
    // device comes first, which on a desktop is a keyboard LED (max=1). That
    // made this card show a bogus 0% slider wired to the capslock light. With
    // the class pinned, a machine with no backlight fails the read, max stays
    // 0, and the card hides itself.
    Process {
        id: readProc

        running: true
        command: [Config.brightnessctl, "-m", "-c", "backlight", "i"]

        stdout: StdioCollector {
            onStreamFinished: {
                const line = text.trim().split("\n")[0] ?? "";
                const parts = line.split(",");
                if (parts.length < 5)
                    return;
                root.current = parseInt(parts[2]) || 0;
                root.max = parseInt(parts[4]) || 0;
            }
        }
    }

    Process {
        id: setProc
    }

    // Re-read when the panel opens; the keyboard brightness keys change it
    // behind our back.
    Connections {
        target: Panels

        function onQuickSettingsOpenChanged() {
            if (Panels.quickSettingsOpen)
                root.refresh();
        }
    }

    LabeledSlider {
        icon: "󰃟"
        value: root.fraction
        onMoved: v => root.apply(v)
    }
}
