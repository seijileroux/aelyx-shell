import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import qs.config
import qs.modules.widgets
import qs.plugins

ContentMenu {
    title: "Store"
    description: "Manage plugins and other stuff for the shell."

    ContentCard {
        Repeater {
            model: PluginParser.model

            delegate: StyledRect {
                width: parent.width
                height: 96
                radius: 10
                color: Appearance.m3colors.m3surfaceContainer

                Row {
                    spacing: 8
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    anchors.margins: 12

                    StyledButton {
                        text: "Install"
                        visible: !installed
                        onClicked: PluginParser.install(id)
                        secondary: true
                    }

                    StyledButton {
                        text: "Update"
                        visible: installed
                        onClicked: PluginParser.update(id)
                        secondary: true
                    }

                    StyledButton {
                        text: "Remove"
                        visible: installed
                        onClicked: PluginParser.uninstall(id)
                        secondary: true
                    }

                }

                Row {
                    anchors.fill: parent
                    anchors.margins: 12
                    spacing: 12

                    ClippingRectangle {
                        radius: Appearance.rounding.small
                        anchors.verticalCenter: parent.verticalCenter
                        width: 170
                        height: 80

                        Image {
                            anchors.fill: parent
                            fillMode: Image.PreserveAspectCrop
                            source: img !== "none" ? img : "image://icon/plugin"
                        }

                    }

                    Column {
                        spacing: 4
                        width: parent.width - 220

                        StyledText {
                            text: name
                            font.pixelSize: 16
                            elide: Text.ElideRight
                        }

                        StyledText {
                            text: description
                            font.pixelSize: 12
                            color: Appearance.colors.colSubtext
                            elide: Text.ElideRight
                        }

                        StyledText {
                            text: "v" + version + " • " + author
                            font.pixelSize: 11
                            color: Appearance.colors.colSubtext
                        }

                    }

                }

            }

        }

    }

}
