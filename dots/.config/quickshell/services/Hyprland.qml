pragma Singleton

import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import Quickshell.Io
import QtQuick

Singleton {
  id: root

  readonly property var toplevels: Hyprland.toplevels
  readonly property var workspaces: Hyprland.workspaces
  readonly property var monitors: Hyprland.monitors
  readonly property Toplevel activeToplevel: ToplevelManager.activeToplevel
  readonly property HyprlandWorkspace focusedWorkspace: Hyprland.focusedWorkspace
  readonly property HyprlandMonitor focusedMonitor: Hyprland.focusedMonitor
  readonly property int focusedWorkspaceId: focusedWorkspace?.id ?? 1
  property string keyboardLayout: "?"

  function dispatch(request: string): void {
    Hyprland.dispatch(request);
  }

  function isWorkspaceOccupied(id: int): bool {
    return Hyprland.workspaces.values.find((w) => {
      return w?.id === id;
    })?.lastIpcObject.windows > 0 || false
  }

  function refreshKeyboardLayout(): string {
    hyprctlDevices.running = true
  }

  // Process to run hyprctl devices -j
  Process {
    id: hyprctlDevices
    command: ["hyprctl", "devices", "-j"]
    running: true // Start manually or via timer

    stdout: StdioCollector {
      onStreamFinished: {
        try {
          // Parse JSON output
          let devices = JSON.parse(this.text)
          // Find the main keyboard or the first keyboard
          let keyboard = devices.keyboards.find(k => k.main) || devices.keyboards[0]
          if (keyboard && keyboard.active_keymap) {
            // Extract first two letters of the layout in uppercase (e.g., "US", "CZ")
            keyboardLayout = keyboard.active_keymap.toUpperCase().slice(0, 2)
          } else {
            keyboardLayout = "?"
          }
        } catch (err) {
          console.error("Failed to parse keyboard layout: " + err)
          keyboardLayout = "?"
        }
      }
    }
  }

  Connections {
    target: Hyprland

    function onRawEvent(event: HyprlandEvent): void {
      if (event.name.endsWith("v2"))
        return;

      if (event.name.includes("activelayout"))
        refreshKeyboardLayout()
      if (event.name.includes("mon"))
        Hyprland.refreshMonitors();
      else if (event.name.includes("workspace") || event.name.includes("window"))
        Hyprland.refreshWorkspaces();
      else
        Hyprland.refreshToplevels();
    }
  }
}