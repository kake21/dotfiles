import QtQuick
import QtQuick.Layouts
import Quickshell.Services.Pipewire

import "root:/"
import "root:/components"

Card {
    id: root

    readonly property var sink: Pipewire.defaultAudioSink
    readonly property var source: Pipewire.defaultAudioSource

    title: "Audio"

    // Pipewire node properties are only kept live for tracked objects.
    PwObjectTracker {
        objects: [root.sink, root.source].filter(o => o !== null)
    }

    LabeledSlider {
        icon: {
            if (!root.sink?.audio || root.sink.audio.muted)
                return "󰖁";
            const v = root.sink.audio.volume;
            return v < 0.34 ? "󰕿" : v < 0.67 ? "󰖀" : "󰕾";
        }
        value: root.sink?.audio?.volume ?? 0
        active: !!root.sink?.audio && !root.sink.audio.muted
        onMoved: v => {
            if (root.sink?.audio)
                root.sink.audio.volume = v;
        }
    }

    LabeledSlider {
        visible: !!root.source?.audio
        icon: root.source?.audio?.muted ? "󰍭" : "󰍬"
        value: root.source?.audio?.volume ?? 0
        active: !!root.source?.audio && !root.source.audio.muted
        onMoved: v => {
            if (root.source?.audio)
                root.source.audio.volume = v;
        }
    }

    RowLayout {
        Layout.fillWidth: true
        spacing: Theme.spacing

        ToggleTile {
            icon: root.sink?.audio?.muted ? "󰖁" : "󰕾"
            label: root.sink?.audio?.muted ? "Muted" : "Output"
            active: !!root.sink?.audio?.muted
            onClicked: {
                if (root.sink?.audio)
                    root.sink.audio.muted = !root.sink.audio.muted;
            }
        }

        ToggleTile {
            visible: !!root.source?.audio
            icon: root.source?.audio?.muted ? "󰍭" : "󰍬"
            label: root.source?.audio?.muted ? "Mic off" : "Mic"
            active: !!root.source?.audio?.muted
            onClicked: {
                if (root.source?.audio)
                    root.source.audio.muted = !root.source.audio.muted;
            }
        }
    }

    Text {
        Layout.fillWidth: true
        visible: !!root.sink
        text: root.sink?.description ?? root.sink?.nickname ?? ""
        elide: Text.ElideRight
        color: Theme.fgDim
        font.family: Theme.fontFamily
        font.pixelSize: Theme.fontSize - 3
    }
}
