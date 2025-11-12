import qs.core.config 
import qs.core.appearance
import qs.common.widgets
import qs.services
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import QtQuick.Controls

import "content/"

Scope {
    id: root

    PanelWindow {
        id: controlCenterRoot
        visible: SessionState.controlCenter.isOpen
        color: "transparent"
        exclusiveZone: 0

        // --- Add monitor-based scaling like launcher ---
        property var monitor: Hyprland.focusedMonitor
        property real screenW: monitor ? monitor.width : 0
        property real screenH: monitor ? monitor.height : 0
        property real scale: monitor ? monitor.scale : 1

        property real panelWidth: screenW * 0.26 / scale
        property real panelHeight: screenH * 0.78 / scale

        implicitWidth: panelWidth
        implicitHeight: panelHeight

        anchors {
            top: true
            bottom: true 
            right: true
            left: false
        }

        margins {
            top: Appearance.margin.normal
            bottom: Appearance.margin.normal
            right: Appearance.margin.normal
        }

        Rectangle {
            color: Appearance.m3colors.m3background
            anchors.fill: parent
            radius: Config.options.controlCenter.radius
        }

        // --- Update when Hyprland changes the focused monitor ---
        Connections {
            target: Hyprland
            function onFocusedMonitorChanged() {
                controlCenterRoot.monitor = Hyprland.focusedMonitor
            }
        }
    }
    
    IpcHandler {
        target: "controlCenter"
        function toggleVisible() {
            SessionState.controlCenter.isOpen = !SessionState.controlCenter.isOpen
        }
    }
}
