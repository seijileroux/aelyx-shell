import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland
import qs.functions
import qs.modules.bar
import qs.services
import qs.config
import qs.widgets

BarModule {
    id: container

    property Toplevel activeToplevel: Hyprland.isWorkspaceOccupied(Hyprland.focusedWorkspaceId) ? Hyprland.activeToplevel : null

    function simplifyTitle(title) {
        if (!title)
            return ""

        title = title.replace(/[●⬤○◉◌◎]/g, "")

        // Normalize separators
        title = title
            .replace(/\s*[|—]\s*/g, " - ")
            .replace(/\s+/g, " ")
            .trim()

        const parts = title.split(" - ").map(p => p.trim()).filter(Boolean)

        if (parts.length === 1)
            return parts[0]

        // Known app names (extend freely my fellow contributors)
        const apps = [
            "Firefox", "Mozilla Firefox",
            "Chromium", "Google Chrome",
            "Neovim", "VS Code", "Code",
            "Kitty", "Alacritty", "Terminal",
            "Discord", "Spotify", "Steam",
            "Aelyx Settings", "Settings"
        ]

        let app = ""
        for (let i = parts.length - 1; i >= 0; i--) {
            for (let a of apps) {
                if (parts[i].includes(a)) {
                    app = a
                    break
                }
            }
            if (app) break
        }

        if (!app)
            app = parts[parts.length - 1]

        const context = parts.find(p => p !== app)

        return context ? `${app} · ${context}` : app
    }


    function formatAppId(appId) { // Random ass function to make it look good
        if (!appId || appId.length === 0)
            return "";

        // split on dashes/underscores
        const parts = appId.split(/[-_]/);
        // capitalize each segment
        for (let i = 0; i < parts.length; i++) {
            const p = parts[i];
            parts[i] = p.charAt(0).toUpperCase() + p.slice(1);
        }
        return parts.join("-");
    }

    Layout.alignment: Qt.AlignLeft | Qt.AlignVCenter
    implicitWidth: col.implicitWidth
    implicitHeight: col.implicitHeight

    property string userHostname: simplifyTitle(activeToplevel?.title) || SystemDetails.username + "@" + SystemDetails.hostname

    Rectangle {
        id: col
        visible: (Shell.flags.bar.position === "top" || Shell.flags.bar.position === "bottom")
        color: Appearance.m3colors.m3paddingContainer
        radius: Shell.flags.bar.moduleRadius

        implicitWidth: textItem.implicitWidth + Appearance.margin.large
        implicitHeight: textItem.implicitHeight + Appearance.margin.small

        StyledText {
            id: textItem
            animate: true
            text: container.userHostname
            anchors.centerIn: parent
        }
    }

    RowLayout {
        visible: (Shell.flags.bar.position === "left" || Shell.flags.bar.position === "right")
        spacing: 12
        anchors.centerIn: parent

        MaterialSymbol {
            icon: "desktop_windows"
            rotation: 270
        }

        StyledText {
            text: formatAppId(activeToplevel?.appId || `Workspace ${Hyprland.focusedWorkspaceId}`)
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: Appearance.font.size.small
        }        
    }

}
