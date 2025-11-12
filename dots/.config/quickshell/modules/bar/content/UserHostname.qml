import qs.core.appearance
import qs.common.widgets
import qs.services
import qs.modules.bar
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick.Layouts

BarModule {
    id: container
    Layout.alignment: Qt.AlignVCenter

    property Toplevel activeToplevel: Hyprland.isWorkspaceOccupied(Hyprland.focusedWorkspaceId)
        ? Hyprland.activeToplevel
        : null

    // Let layout calculate size dynamically
    implicitWidth: bgRect.implicitWidth
    implicitHeight: bgRect.implicitHeight
    property string userHostname: "you@aelyxshell"

    Process {
        id: userHostProc
        running: true
        command: [
            "/bin/sh",
            "-c",
            "printf '%s@%s\\n' \"$(id -un 2>/dev/null || whoami 2>/dev/null || echo unknown)\" \"$(hostname 2>/dev/null || cat /etc/hostname 2>/dev/null || echo unknown)\""
        ]
        stdout: StdioCollector {
            onStreamFinished: {
                var clean = text.trim()
                container.userHostname = clean
            }
        }
    }

    Rectangle {
        id: bgRect
        color: Appearance.m3colors.m3paddingContainer
        radius: Appearance.rounding.normal

        implicitWidth: textItem.implicitWidth + Appearance.margin.large
        implicitHeight: textItem.implicitHeight + Appearance.margin.small

        StyledText {
            id: textItem
            animate: true
            text: shortText(container.userHostname)
            anchors.centerIn: parent
        }
    }

    function shortText(str, len = 30) {
        if (!str)
            return ""
        return str.length > len ? str.slice(0, len) + "…" : str
    }
}
