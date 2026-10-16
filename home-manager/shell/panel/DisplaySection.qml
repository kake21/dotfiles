import QtQuick
import QtQuick.Layouts
import Quickshell.Io

import "root:/"
import "root:/components"

// Presentation presets for a laptop with one external screen plugged in.
// Rules are applied live with `hyprctl eval` (the Lua config has no `keyword`)
// and last until Hyprland reloads, which restores my.hyprland.monitors.
// Hides itself unless there is an eDP panel plus at least one other output,
// so it never shows on the desktops.
Card {
    id: root

    property string internal: ""
    property string external: ""
    property string mode: "extend" // extend | mirror | external

    title: "Display"
    visible: root.internal !== "" && root.external !== ""

    function refresh() {
        if (!readProc.running)
            readProc.running = true;
    }

    function apply(mode) {
        const i = JSON.stringify(root.internal);
        const e = JSON.stringify(root.external);
        // Re-issuing a rule drops an earlier mirror, but `disabled` must be cleared
        // explicitly or a panel turned off by "external" stays off.
        const lua = {
            extend: `hl.monitor({ output = ${i}, mode = "preferred", position = "0x0", scale = "auto", disabled = false })
                     hl.monitor({ output = ${e}, mode = "preferred", position = "auto-right", scale = "auto", disabled = false })`,
            mirror: `hl.monitor({ output = ${i}, mode = "preferred", position = "0x0", scale = "auto", disabled = false })
                     hl.monitor({ output = ${e}, mode = "preferred", position = "auto-right", scale = "auto", disabled = false, mirror = ${i} })`,
            // External first, so there is never a moment with no screen on.
            external: `hl.monitor({ output = ${e}, mode = "preferred", position = "0x0", scale = "auto", disabled = false })
                       hl.monitor({ output = ${i}, disabled = true })`
        }[mode];
        root.mode = mode;
        setProc.exec([Config.hyprctl, "eval", lua]);
    }

    // `monitors all` so a disabled laptop panel still shows up and can be
    // switched back on.
    Process {
        id: readProc

        running: true
        command: [Config.hyprctl, "monitors", "all", "-j"]

        stdout: StdioCollector {
            onStreamFinished: {
                let mons = [];
                try {
                    mons = JSON.parse(text);
                } catch (e) {
                    return;
                }
                const i = mons.find(m => m.name.startsWith("eDP"));
                const e = mons.find(m => !m.name.startsWith("eDP"));
                root.internal = i?.name ?? "";
                root.external = e?.name ?? "";
                if (!i || !e)
                    return;
                root.mode = i.disabled ? "external" : e.mirrorOf === String(i.id) ? "mirror" : "extend";
            }
        }
    }

    Process {
        id: setProc

        onExited: root.refresh()
    }

    Connections {
        target: Panels

        function onQuickSettingsOpenChanged() {
            if (Panels.quickSettingsOpen)
                root.refresh();
        }
    }

    RowLayout {
        Layout.fillWidth: true
        spacing: Theme.spacing

        ToggleTile {
            icon: "󰍺"
            label: "Extend"
            active: root.mode === "extend"
            onClicked: root.apply("extend")
        }

        ToggleTile {
            icon: "󰍹"
            label: "Mirror"
            active: root.mode === "mirror"
            onClicked: root.apply("mirror")
        }

        ToggleTile {
            icon: "󰶐"
            label: "External"
            active: root.mode === "external"
            onClicked: root.apply("external")
        }
    }
}
