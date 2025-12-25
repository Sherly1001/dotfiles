import QtQuick
import Quickshell

import qs.config

Item {
    id: root

    property real paddingTop: 5
    property real cornerSize: 10

    property real implicitPopupWidth: 180
    readonly property real popupWidth: implicitPopupWidth

    property real implicitPopupHeight: 50
    readonly property real popupHeight: implicitPopupHeight + paddingTop + cornerSize

    property list<Item> popupChildren: []
    readonly property bool hoverActive: rootHover.hovered || (popupLoader.item?.popupHover.hovered ?? false)

    signal hoverActived(bool hovered)

    readonly property real overRight: {
        const x = root.mapToGlobal(0, 0).x ?? 0;
        const w = popupLoader.item?.width ?? 0;
        const right = (root.width - root.popupWidth) / 2 + x + w;
        const screenWidth = popupLoader.item?.screen?.width ?? 0;
        return right - screenWidth;
    }

    onHoverActiveChanged: {
        hoverActived(hoverActive);
        if (hoverActive) {
            popupLoader.loading = true;
            popupLoader.item.visible = true;
            popupLoader.item.implicitHeight = popupHeight;
        } else {
            popupLoader.item.visible = false;
            popupLoader.item.implicitHeight = 0;
        }
    }

    HoverHandler {
        id: rootHover
        cursorShape: Qt.PointingHandCursor
    }

    LazyLoader {
        id: popupLoader

        PopupWindow {
            property alias popupHover: popupLoaderHover

            anchor.item: root
            anchor.rect.x: (root.width - root.popupWidth) / 2 - (overRight > 0 ? overRight : 0)
            anchor.rect.y: root.height
            anchor.adjustment: PopupAdjustment.None

            color: Appearance.colors.transparent
            implicitWidth: root.popupWidth
            implicitHeight: root.popupHeight

            Behavior on implicitHeight {
                NumberAnimation {
                    duration: Appearance.animates.durations.normal
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: Appearance.animates.curves.standard
                }
            }

            Behavior on visible {
                NumberAnimation {
                    duration: Appearance.animates.durations.large
                    easing.type: Easing.BezierSpline
                    easing.bezierCurve: Appearance.animates.curves.standard
                }
            }

            HoverHandler {
                id: popupLoaderHover
            }

            // Rectangle {
            //   anchors.fill: parent
            //   color: Appearance.colors.blue
            // }

            UnderBar {
                isSnapedRight: root.overRight >= 0
                paddingTop: root.paddingTop
                cornerSize: root.cornerSize
                content: root.popupChildren
            }
        }
    }
}
