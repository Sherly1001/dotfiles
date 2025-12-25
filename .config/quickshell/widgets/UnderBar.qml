import QtQuick

import qs.config

Item {
    property real paddingTop: 5
    property real cornerSize: 10
    property bool isSnapedRight: false
    default property alias content: contentItem.data

    anchors.fill: parent
    anchors.topMargin: paddingTop
    anchors.leftMargin: cornerSize
    anchors.rightMargin: isSnapedRight ? 0 : cornerSize
    anchors.bottomMargin: cornerSize

    Rectangle {
        anchors.fill: parent
        color: Appearance.colors.background
        bottomLeftRadius: cornerSize
        bottomRightRadius: isSnapedRight ? 0 : cornerSize
    }

    RoundCorner {
        anchors.right: parent.left
        color: Appearance.colors.background
        implicitSize: cornerSize
        corner: RoundCorner.CornerEnum.TopRight
    }

    RoundCorner {
        visible: !isSnapedRight
        anchors.left: parent.right
        corner: RoundCorner.CornerEnum.TopLeft
        color: Appearance.colors.background
        implicitSize: cornerSize
    }

    RoundCorner {
        visible: isSnapedRight
        anchors.top: parent.bottom
        anchors.right: parent.right
        corner: RoundCorner.CornerEnum.TopRight
        color: Appearance.colors.background
        implicitSize: cornerSize
    }

    Item {
        id: contentItem
        anchors.fill: parent
    }
}
