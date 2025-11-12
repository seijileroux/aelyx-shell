import qs.core.appearance
import qs.core.config
import qs.common.widgets
import qs.services
import QtQuick
import Quickshell
import QtQuick.Layouts
import Quickshell.Wayland
import Quickshell.Io
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
import Quickshell.Services.Notifications

PanelWindow {
    id: notifications
    WlrLayershell.layer: WlrLayer.Top
    visible: Config.ready

    color: "transparent"
    focusable: true
    exclusiveZone: 0

    // --- Directly use Hyprland's focused monitor ---
    property var monitor: Hyprland.focusedMonitor
    property real screenW: monitor ? monitor.width : 0
    property real screenH: monitor ? monitor.height : 0
    property real scale: monitor ? monitor.scale : 1


    property real notificationsWidth: 450
    property real notificationsHeight: 180

    implicitWidth: notificationsWidth
    implicitHeight: notificationsHeight

    anchors {
        top: true
        left: true
        right: true
        bottom: true
    }

    function shortText(str, len = 25) {
        if (!str)
            return ""
        return str.length > len ? str.slice(0, len) + "" : str
    }

    component Anim: NumberAnimation {
        duration: 400
        easing.type: Easing.BezierSpline
        easing.bezierCurve: Appearance.animation.curves.standard
    }

    mask: Region {
        item: overlay
        intersection: Intersection.Xor
    }

    Rectangle {
        id: overlay
        anchors.fill: parent
        color: "transparent"
        opacity: 0
    }


    NotificationServer {
        id: notifServer
        keepOnReload: true
        persistenceSupported: true
    }

    MergedEdgeRect {
        id: container
        visible: implicitHeight > 0
        color: Appearance.m3colors.m3background
        cornerRadius: Appearance.rounding.verylarge
        implicitWidth: notifications.notificationsWidth 
        implicitHeight: notifications.notificationsHeight

        Behavior on implicitWidth { Anim {} }

        anchors {
            right: parent.right
            rightMargin: Config.options.global.borderEnabled ? Appearance.margin.tiny + 2 : 0
            horizontalCenter: parent.horizontalCenter
            verticalCenter: parent.verticalCenter
        }

        states: [
            State {
                name: "nfAtBottom"
                when: Config.options.bar.position === 2
                AnchorChanges {
                    target: container
                    anchors.top: undefined
                    anchors.bottom: parent.bottom
                }
            },
            State {
                name: "nfAtTop"
                when: Config.options.bar.position === 1
                AnchorChanges {
                    target: container
                    anchors.bottom: undefined
                    anchors.top: parent.top
                }
            }
        ]

        content: StyledText {
            anchors.centerIn: parent 
            text: Notification?.summary ?? "NO NOTIFICATION"
        }

    }

    Connections {
        target: Hyprland
        function onFocusedMonitorChanged() {
            notifications.monitor = Hyprland.focusedMonitor
        }
    }
}
