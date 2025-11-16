import qs.core.config
import qs.core.appearance
import qs.common.widgets
import qs.services
import Quickshell.Widgets
import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts

BaseMenu {
    title: "Bar"
    description: "Adjust how the bar behaves."

    BaseCard {
        StyledText {
            text: "Bar"
            font.pixelSize: 20
            font.bold: true
        }

        ColumnLayout {
            StyledText {
                text: "Position"
                font.pixelSize: 16
            }
            RowLayout {
                Repeater {
                    model: ['Bottom', 'Top']
                    delegate: StyledButton {
                        text: modelData
                        Layout.fillWidth: true
                        implicitWidth: 0
                        checked: Config.options.bar.position === (modelData.toLowerCase() === "bottom" ? 2 : 1)

                        topLeftRadius: (modelData === "Left" || Config.options.bar.position === (modelData.toLowerCase() === "bottom" ? 2 : 1)) 
                            ? Appearance.rounding.normal 
                            : Appearance.rounding.small
                        bottomLeftRadius: (modelData === "Left" || Config.options.bar.position === (modelData.toLowerCase() === "bottom" ? 2 : 1)) 
                            ? Appearance.rounding.normal 
                            : Appearance.rounding.small
                        topRightRadius: (modelData === "Right" || Config.options.bar.position === (modelData.toLowerCase() === "bottom" ? 2 : 1)) 
                            ? Appearance.rounding.normal 
                            : Appearance.rounding.small
                        bottomRightRadius: (modelData === "Right" || Config.options.bar.position === (modelData.toLowerCase() === "bottom" ? 2 : 1)) 
                            ? Appearance.rounding.normal 
                            : Appearance.rounding.small

                        property int position: modelData.toLowerCase() === "bottom" ? 2 : 1

                        onClicked: {
                            Config.setNestedValue("bar.position", position)
                        }
                    }
                }
            }
        }

        StyledSwitchOption {
            title: "Visible";
            description: "Change the bar's visiblity."
            prefField: "bar.enabled"
        }

        StyledSwitchOption {
            title: "Large Workspace Icons";
            description: "Whether to keep the workspace icons large or not\nIf disabled, the bar will use small icons."
            prefField: "bar.modules.workspaces.largeWorkspacesIcon"
        }

        StyledSwitchOption {
            title: "Workspace Numbers"
            description: "Whether to keep numbers on workspace icons or not.\nNote - This will only work with large workspace icons."
            prefField: "bar.modules.workspaces.showNumbers"
        }

        StyledSwitchOption {
            title: "Autohide"
            description: "Automaticly hide bar when not focused. Still experimental"
            prefField: "bar.autohide"
        }
    }
}
