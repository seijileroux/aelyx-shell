import qs.services 
import qs.common.widgets 
import qs.core.config 
import qs.core.appearance
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import Quickshell.Hyprland
import "."

// From github.com/end-4/dots-hyprland with modifications

Scope {
    id: overviewScope
    Variants {
        id: overviewVariants
        model: Quickshell.screens
        PanelWindow {
            id: root
            required property var modelData
            readonly property HyprlandMonitor monitor: Hyprland.monitorFor(root.screen)
            property bool monitorIsFocused: (Hyprland.focusedMonitor?.id == monitor?.id)
            screen: modelData
            visible: SessionState.overviewOpen

            WlrLayershell.namespace: "quickshell:overview"
            WlrLayershell.layer: WlrLayer.Overlay
            WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
            color: "transparent"

            mask: Region {
                item: SessionState.overviewOpen ? keyHandler : null
            }

            anchors {
                top: true
                bottom: true
                left: !(Config?.options.overview.enable ?? true) 
                right: !(Config?.options.overview.enable ?? true) 
            }

            HyprlandFocusGrab {
                id: grab
                windows: [root]
                property bool canBeActive: root.monitorIsFocused
                active: false
                onCleared: () => {
                    if (!active)
                        SessionState.overviewOpen = false;
                }
            }

            Connections {
                target: SessionState
                function onOverviewOpenChanged() {
                    if (SessionState.overviewOpen) {
                        delayedGrabTimer.start();
                    }
                }
            }

            Timer {
                id: delayedGrabTimer
                interval: Config.options.hacks.arbitraryRaceConditionDelay
                repeat: false
                onTriggered: {
                    if (!grab.canBeActive)
                        return;
                    grab.active = SessionState.overviewOpen;
                }
            }

            implicitWidth: columnLayout.implicitWidth
            implicitHeight: columnLayout.implicitHeight

            Item {
                id: keyHandler
                anchors.fill: parent
                visible: SessionState.overviewOpen
                focus: SessionState.overviewOpen

                Keys.onPressed: event => {
                    if (event.key === Qt.Key_Escape) {
                        SessionState.overviewOpen = false;
                        event.accepted = true;
                    } else if (event.key === Qt.Key_Left || event.key === Qt.Key_Right) {
                        const workspacesPerGroup = Config.options.overview.rows * Config.options.overview.columns;
                        const currentId = Hyprland.focusedMonitor?.activeWorkspace?.id ?? 1;
                        const currentGroup = Math.floor((currentId - 1) / workspacesPerGroup);
                        const minWorkspaceId = currentGroup * workspacesPerGroup + 1;
                        const maxWorkspaceId = minWorkspaceId + workspacesPerGroup - 1;
                        
                        let targetId;
                        if (event.key === Qt.Key_Left) {
                            targetId = currentId - 1;
                            if (targetId < minWorkspaceId) targetId = maxWorkspaceId;
                        } else {
                            targetId = currentId + 1;
                            if (targetId > maxWorkspaceId) targetId = minWorkspaceId;
                        }
                        
                        Hyprland.dispatch("workspace " + targetId);
                        event.accepted = true;
                    }
                }
            }

            ColumnLayout {
                id: columnLayout
                visible: SessionState.overviewOpen
                anchors {
                    horizontalCenter: parent.horizontalCenter
                    top: parent.top
                    topMargin: 100
                }

                Loader {
                    id: overviewLoader
                    active: SessionState.overviewOpen && (Config?.options.overview.enable ?? true)
                    sourceComponent: OverviewWidget {
                        panelWindow: root
                        visible: true
                    }
                }
            }
        }
    }
    
    IpcHandler {
        target: "overview"

        function toggle() {
            SessionState.overviewOpen = !SessionState.overviewOpen;
        }
    }
}
