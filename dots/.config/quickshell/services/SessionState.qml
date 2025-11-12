// SessionState.qml
import QtQuick
pragma Singleton
pragma ComponentBehavior: Bound
import Quickshell

Singleton {
    id: root

    property QtObject launcher: QtObject {
        property bool isOpen: false
    }
    property QtObject powerMenu: QtObject {
        property bool isOpen: false
    }
    property QtObject controlCenter: QtObject {
        property bool isOpen: false
    }
    property QtObject mediaPlayer: QtObject {
        property bool isOpen: false
    }
}
