// I'm too lazy to modify all modules sooo.... I will fix it later but not right now.

import QtQuick
import QtQuick.Layouts
import qs.config
import qs.modules.bar.widgets
import qs.widgets

Item {
    // Horizontal Bar Content
    // Vertical Bar Content

    property bool isHorizontal: Shell.flags.bar.position === "top" || Shell.flags.bar.position === "bottom"

    RowLayout {
        id: hLeftRow

        visible: isHorizontal
        anchors.left: parent.left
        anchors.leftMargin: Shell.flags.bar.density * 0.2
        anchors.verticalCenter: parent.verticalCenter
        spacing: 4

        SidebarLeftToggle {
        }

        Workspaces {
        }

        LauncherToggle {
        }

    }

    Row {
        id: hCenterRow

        visible: isHorizontal
        anchors.centerIn: parent
        spacing: 4

        Media {
        }

        ActiveTopLevel {
        }

        Clock {
        }

    }

    RowLayout {
        id: hRightRow

        visible: isHorizontal
        anchors.right: parent.right
        anchors.rightMargin: Shell.flags.bar.density * 0.2
        anchors.verticalCenter: parent.verticalCenter
        spacing: 4

        Battery {
        }

        Utilities {
        }

        BluetoothWifi {
        }

        PowerMenuToggle {
        }

    }

    Item {
        visible: !isHorizontal
        anchors.top: parent.top
        anchors.topMargin: Shell.flags.bar.density * 0.1
        anchors.horizontalCenter: parent.horizontalCenter
        // Contain rotated bounds
        implicitWidth: vRow.implicitHeight
        implicitHeight: vRow.implicitWidth

        Row {
            id: vRow

            anchors.centerIn: parent
            spacing: 8
            rotation: 90

            Glyph {
                rotation: 270
            }

            Workspaces {
            }

            Battery {
            }

        }

    }

    Item {
        visible: !isHorizontal
        anchors.centerIn: parent
        anchors.verticalCenterOffset: 35
        implicitWidth: centerRow.implicitHeight
        implicitHeight: centerRow.implicitWidth

        Row {
            id: centerRow

            anchors.centerIn: parent

            ActiveTopLevel {
                rotation: 90
            }

        }

    }

    Item {
        visible: !isHorizontal
        anchors.bottom: parent.bottom
        anchors.bottomMargin: Shell.flags.bar.density * 0.1
        anchors.horizontalCenter: parent.horizontalCenter
        implicitWidth: row.implicitHeight
        implicitHeight: row.implicitWidth

        Row {
            id: row

            anchors.centerIn: parent
            spacing: 2
            rotation: 90

            SystemTray {
                rotation: 270
            }

            Clock {
                rotation: 270
            }

            BluetoothWifi {
            }

            PowerMenuToggle {
                rotation: 270
            }

        }

    }

    RControl {
        visible: isHorizontal
    }

    LControl {
        visible: isHorizontal
    }

}
