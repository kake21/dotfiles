import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io

ShellRoot {
    id: root

    // The screen the panel should open on: whichever monitor Hyprland has
    // focused, falling back to the first if that lookup fails.
    readonly property var focusedScreen: {
        const name = Hyprland.focusedMonitor?.name;
        return Quickshell.screens.find(s => s.name === name) ?? Quickshell.screens[0] ?? null;
    }

    // One bar per monitor, and only where the host asked for it.
    Variants {
        model: Config.barEnabled ? Quickshell.screens : []

        Bar {}
    }

    QuickSettings {}

    // Driven from Hyprland: SUPER+ALT+SPACE runs
    //   qs -c vshell ipc call quicksettings toggle
    IpcHandler {
        target: "quicksettings"

        function toggle(): void {
            Panels.toggleQuickSettings(root.focusedScreen);
        }

        function open(): void {
            Panels.openQuickSettings(root.focusedScreen);
        }

        function close(): void {
            Panels.closeQuickSettings();
        }
    }
}
