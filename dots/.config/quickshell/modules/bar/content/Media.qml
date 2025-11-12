import qs.core.appearance
import qs.core.config
import qs.services
import qs.common.widgets
import qs.modules.bar
import QtQuick
import Quickshell
import QtQuick.Layouts
import Quickshell.Io

BarModule {
    id: root
    Layout.alignment: Qt.AlignCenter | Qt.AlignVCenter
    implicitWidth: bgRect.implicitWidth
    implicitHeight: bgRect.implicitHeight

    Rectangle {
        id: bgRect
        color: Appearance.m3colors.m3paddingContainer
        radius: Appearance.rounding.normal
        implicitWidth: row.implicitWidth + Appearance.margin.large
        implicitHeight: Math.max(row.implicitHeight + Appearance.margin.small - 2, 28)

        MouseArea {
            anchors.fill: parent 
            onClicked: {
                SessionState.mediaPlayer.isOpen = !SessionState.mediaPlayer.isOpen
                Qt.callLater(() => SessionState.mediaPlayer.isOpen = SessionState.mediaPlayer.isOpen)
            }
        }

    }

    Row {
        id: row
        spacing: Appearance.margin.small
        anchors.centerIn: parent
        property bool isPlaying: false

        // Icon button with rounded background
        Rectangle {
            id: iconButton
            width: 24
            height: 24
            radius: height / 2
            color: Appearance.m3colors.m3paddingContainer
            opacity: 1

            MaterialSymbol {
                id: playPauseIcon
                anchors.centerIn: parent
                anchors.verticalCenterOffset: -0.6
                font.pixelSize: 18
                text: row.isPlaying ? "pause" : "play_arrow"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    toggleProcess.running = true
                    updateStatusProcess.running = true
                }
                hoverEnabled: true
                onEntered: iconButton.opacity = 1
                onExited: iconButton.opacity = 0.9
            }
        }

        // MPRIS Album Title
        StyledText {
            id: textItem
            text: shortText(Mpris.albumTitle)          
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: 0.2
            
        }

        // Play/pause toggle
        Process {
            id: toggleProcess
            command: ["playerctl", "play-pause"]
        }

        // Get current player status
        Process {
            id: updateStatusProcess
            command: ["playerctl", "status"]
            stdout: StdioCollector {
                onStreamFinished: {
                    let s = text.trim().toLowerCase()
                    row.isPlaying = (s === "playing")
                }
            }
        }

        // Poll every half second
        Timer {
            interval: 500
            running: true
            repeat: true
            onTriggered: updateStatusProcess.running = true
        }
    }

    function shortText(str, len = 20) {
        return !str ? "" : str.length > len ? str.slice(0, len) + "…" : str
    }
}
