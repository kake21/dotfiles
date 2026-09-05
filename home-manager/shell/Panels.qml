pragma Singleton

import QtQuick
import Quickshell

// Shared UI state. Named Panels rather than State to avoid colliding with
// QtQuick's State type.
Singleton {
    id: root

    property bool quickSettingsOpen: false

    // The screen the quick settings panel should appear on. Set when opened so
    // the panel follows the focused monitor on multi-head hosts.
    property var quickSettingsScreen: null

    function openQuickSettings(screen) {
        if (screen)
            root.quickSettingsScreen = screen;
        root.quickSettingsOpen = true;
    }

    function closeQuickSettings() {
        root.quickSettingsOpen = false;
    }

    function toggleQuickSettings(screen) {
        if (root.quickSettingsOpen)
            root.closeQuickSettings();
        else
            root.openQuickSettings(screen);
    }
}
