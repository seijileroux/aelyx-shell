import QtQuick
import QtQuick.Layouts
import qs.config

ColumnLayout {
    Layout.fillWidth: true
    spacing: 8

    Repeater {
        model: PluginLoader.pluginNames

        delegate: Loader {
            Layout.fillWidth: true
            asynchronous: true
            source: Qt.resolvedUrl(
                Directories.shellConfig + "/plugins/" + modelData + "/Settings.qml"
            )
        }
    }
}
