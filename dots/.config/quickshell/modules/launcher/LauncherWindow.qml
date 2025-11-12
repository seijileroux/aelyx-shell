import qs.core.config
import qs.core.appearance
import qs.common.widgets
import qs.services
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Wayland
import Quickshell.Io

PanelWindow {
    id: launcher
    WlrLayershell.layer: WlrLayer.Top
    WlrLayershell.keyboardFocus: SessionState.launcher.isOpen
    visible: Config.ready

    color: "transparent"
    focusable: true
    exclusiveZone: 0

    // --- Directly use Hyprland's focused monitor ---
    property var monitor: Hyprland.focusedMonitor
    property real screenW: monitor ? monitor.width : 0
    property real screenH: monitor ? monitor.height : 0
    property real scale: monitor ? monitor.scale : 1

    property real launcherWidth: screenW * 0.33 / scale
    property real launcherHeight: screenH * 0.69 / scale

    implicitWidth: launcherWidth
    implicitHeight: launcherHeight

    anchors {
        top: true
        left: true
        right: true
        bottom: true
    }

    component Anim: NumberAnimation {
        duration: 400
        easing.type: Easing.BezierSpline
        easing.bezierCurve: Appearance.animation.curves.standard
    }

    mask: Region {
        item: overlay
        intersection: SessionState.launcher.isOpen ? Intersection.Combine : Intersection.Xor
    }

    Rectangle {
        id: overlay
        anchors.fill: parent
        color: "transparent"

        Behavior on opacity { Anim {} }

        MouseArea {
            anchors.fill: parent
            enabled: SessionState.launcher.isOpen
            onClicked: {
                container.searchQuery = ""
                SessionState.launcher.isOpen = false
            }
        }
    }

    MergedEdgeRect { 
        id: container
        visible: implicitHeight > 0
        color: Appearance.m3colors.m3background
        cornerRadius: Appearance.rounding.verylarge
        implicitWidth: SessionState.launcher.isOpen ? launcher.launcherWidth : 0
        implicitHeight: SessionState.launcher.isOpen ? launcher.launcherHeight : 0
        opacity: SessionState.launcher.isOpen ? 1 : 0

        Behavior on implicitHeight { Anim {} }
        Behavior on implicitWidth { Anim {} }
        Behavior on opacity { Anim {} }

        anchors {
            horizontalCenter: parent.horizontalCenter
            bottomMargin: (Config.options.bar.style === 2 ? 14 : 0) 
            topMargin: (Config.options.bar.style === 2 ? 14 : 0)
            verticalCenter: parent.verticalCenter
        }

        content: LauncherContent {}
    }

    // Ah let me guess you're probably thinking why did
    // I use mergededgerect even though its not merged its just looks better than rect.


    function toggleLauncher() {
        SessionState.launcher.isOpen = !SessionState.launcher.isOpen
    }

    IpcHandler {
        target: "launcher"
        function toggleVisible() {
            toggleLauncher()
        }
    }

    // --- Update when Hyprland changes the focused monitor ---
    Connections {
        target: Hyprland
        function onFocusedMonitorChanged() {
            launcher.monitor = Hyprland.focusedMonitor
        }
    }
}
