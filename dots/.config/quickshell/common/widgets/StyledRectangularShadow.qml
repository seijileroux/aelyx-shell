import QtQuick
import QtQuick.Effects
import qs.core.appearance
import "."

RectangularShadow {
    required property var target
    anchors.fill: target
    radius: 20
    blur: 0.9 * 10
    offset: Qt.vector2d(0.0, 1.0)
    spread: 1
    color: Appearance.colors.colShadow
    cached: true
}
