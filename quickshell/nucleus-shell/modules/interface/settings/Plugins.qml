import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.config
import qs.modules.widgets
import qs.plugins

ContentMenu {
    title: "Plugins"
    description: "Modify and Customize Installed Plugins."

    ContentCard {
        ColumnLayout {
            anchors.fill: parent
            spacing: 12

            StyledText {
                font.bold: true
                font.pixelSize: 20
                text: "Plugins not found!"
                visible: PluginLoader.pluginNames.length === 0
                Layout.alignment: Qt.AlignCenter
            }

            PluginSettings {
                Layout.fillWidth: true
            }

        }

    }

}
