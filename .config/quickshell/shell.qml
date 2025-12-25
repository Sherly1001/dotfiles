//@ pragma UseQApplication
//@ pragma Env QS_NO_RELOAD_POPUP=1

import QtQuick
import QtQuick.Controls

import Quickshell
import Quickshell.Io
import Quickshell.Widgets
import Quickshell.Services.SystemTray

import qs.config
import qs.services
import qs.widgets

ShellRoot {
    id: shellRoot

    property int gapOuter: 20
    property int cornerSize: gapOuter / 2

    // the main bar
    PanelWindow {
        id: root

        anchors {
            top: true
            left: true
            right: true
        }

        color: Appearance.colors.background
        implicitHeight: 30

        // left corner
        PanelWindow {
            anchors {
                top: true
                left: true
            }

            color: Appearance.colors.transparent
            implicitWidth: shellRoot.cornerSize
            implicitHeight: shellRoot.cornerSize

            RoundCorner {
                color: Appearance.colors.background
                implicitSize: shellRoot.cornerSize
                corner: RoundCorner.CornerEnum.TopLeft
            }
        }

        // right corner
        PanelWindow {
            anchors {
                top: true
                right: true
            }

            color: Appearance.colors.transparent
            implicitWidth: shellRoot.cornerSize
            implicitHeight: shellRoot.cornerSize

            RoundCorner {
                color: Appearance.colors.background
                implicitSize: shellRoot.cornerSize
                corner: RoundCorner.CornerEnum.TopRight
            }
        }

        // left items: workspace ids
        Row {
            id: workspaces

            anchors.left: parent.left
            anchors.leftMargin: shellRoot.gapOuter
            anchors.verticalCenter: parent.verticalCenter

            spacing: 10

            Repeater {
                model: Hyprland.workspaces

                Item {
                    implicitHeight: 30
                    implicitWidth: workspaceText.width

                    StyledText {
                        id: workspaceText
                        anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: Appearance.fonts.pixelSize.normal
                        color: {
                            modelData.focused ? (workspaceMouseArea.containsMouse ? Appearance.colors.brightYellow : Appearance.colors.yellow) : (workspaceMouseArea.containsMouse ? Appearance.colors.white : Appearance.colors.darkWhite);
                        }
                        text: {
                            const name = (modelData.name.startsWith('special:') ? modelData.name.slice('special:'.length) : modelData.name) + '  ';
                            const icon = Hyprland.icons[modelData.id - 1] ?? Hyprland.specialIcon;
                            return name + icon;
                        }
                    }

                    MouseArea {
                        id: workspaceMouseArea
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            if (modelData.name.startsWith('special:')) {
                                Hyprland.dispatch('togglespecialworkspace ' + modelData.name.slice('special:'.length));
                            } else {
                                Hyprland.dispatch('workspace ' + modelData.id);
                            }
                        }
                    }
                }
            }

            Item {
                implicitWidth: submap.width
                implicitHeight: parent.height

                StyledText {
                    id: submap
                    anchors.verticalCenter: parent.verticalCenter
                    color: Appearance.colors.red
                    text: Hyprland.submap
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        Hyprland.resetSubmap();
                    }
                }
            }
        }

        // right items
        Row {
            spacing: 15
            anchors.right: parent.right
            anchors.rightMargin: shellRoot.gapOuter
            anchors.verticalCenter: parent.verticalCenter

            // systray items
            Row {
                spacing: 10
                anchors.verticalCenter: parent.verticalCenter

                Repeater {
                    model: SystemTray.items

                    IconImage {
                        id: icon
                        asynchronous: true
                        anchors.verticalCenter: parent.verticalCenter

                        width: 18
                        height: width

                        source: {
                            let icon = modelData.icon;
                            if (icon.includes("?path=")) {
                                const [name, path] = icon.split("?path=");
                                icon = `file://${path}/${name.slice(name.lastIndexOf("/") + 1)}`;
                            }
                            return icon;
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor
                            acceptedButtons: Qt.LeftButton | Qt.RightButton
                            onClicked: event => {
                                if (event.button === Qt.LeftButton) {
                                    modelData.activate();
                                } else if (modelData.hasMenu) {
                                    menu.open();
                                }
                            }
                        }

                        QsMenuAnchor {
                            id: menu
                            menu: modelData.menu
                            anchor.item: icon
                            anchor.margins.top: icon.height
                        }
                    }
                }
            }

            // brightness
            StyledText {
                color: Appearance.colors.brightBlue
                text: `󰛨  ${Brightness.value}`

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    acceptedButtons: Qt.LeftButton | Qt.RightButton
                    onClicked: event => {
                        if (event.button === Qt.LeftButton) {
                            Brightness.changeBrightness('80%');
                        } else {
                            Brightness.changeBrightness('20%');
                        }
                    }
                    onWheel: wheel => {
                        const sign = Math.sign(wheel.angleDelta.y);
                        Brightness.changeBrightness(sign > 0 ? '5%+' : '5%-');
                    }
                }
            }

            // volume
            StyledText {
                color: Appearance.colors.yellow
                text: {
                    const icon = Audio.muted ? '󰝟' : '';
                    `${icon}  ${Audio.volume}`;
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    acceptedButtons: Qt.LeftButton | Qt.RightButton
                    onClicked: event => {
                        if (event.button === Qt.LeftButton) {
                            Audio.setMuted(!Audio.muted);
                        } else {
                            Audio.openPwvucontrol();
                        }
                    }
                    onWheel: wheel => {
                        const sign = Math.sign(wheel.angleDelta.y);
                        const newVolume = Audio.volume + sign * 5;
                        if (newVolume <= 150) {
                            Audio.setVolume(newVolume / 100);
                        }
                    }
                }
            }

            // battery
            ItemWithPopup {
                id: batteryRoot

                implicitWidth: battery.width
                implicitHeight: battery.height

                paddingTop: (root.height - battery.height) / 2
                cornerSize: shellRoot.cornerSize
                implicitPopupHeight: 28 * 3

                StyledText {
                    id: battery
                    color: Appearance.colors.green
                    text: Battery.icon + (Battery.isLaptopBattery ? `  ${Battery.percentage}%` : '')
                }

                popupChildren: Column {
                    Repeater {
                        model: PowerProfile.options

                        Control {
                            leftPadding: 20
                            implicitHeight: 26
                            implicitWidth: batteryRoot.popupWidth

                            contentItem: StyledText {
                                anchors.verticalCenter: parent.verticalCenter
                                color: {
                                    modelData.selected ? Appearance.colors.green : (powerProfileOptionMouseArea.containsMouse ? Appearance.colors.yellow : Appearance.colors.white);
                                }
                                text: modelData.icon + '   ' + modelData.label
                            }

                            MouseArea {
                                id: powerProfileOptionMouseArea
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    PowerProfile.changeProfile(modelData.label);
                                }
                            }
                        }
                    }
                }
            }

            // date
            ItemWithPopup {
                implicitWidth: datetime.width
                implicitHeight: datetime.height

                paddingTop: (root.height - datetime.height) / 2
                cornerSize: shellRoot.cornerSize

                implicitPopupWidth: 320
                implicitPopupHeight: 220

                StyledText {
                    id: datetime
                    text: Date.time
                }

                popupChildren: Calendar {
                    id: calendar
                    anchors.fill: parent
                    anchors.rightMargin: shellRoot.gapOuter
                    anchors.leftMargin: shellRoot.cornerSize
                    anchors.bottomMargin: shellRoot.cornerSize
                }

                onHoverActived: hovered => {
                    if (hovered) {
                        calendar.thisMonth();
                    }
                }
            }

            // poweroff
            ItemWithPopup {
                id: poweroffRoot

                implicitWidth: poweroff.width
                implicitHeight: poweroff.height

                paddingTop: (root.height - poweroff.height) / 2
                cornerSize: shellRoot.cornerSize

                implicitPopupWidth: 150
                implicitPopupHeight: 28 * 3

                StyledText {
                    id: poweroff
                    text: '   '
                    color: Appearance.colors.red
                }

                popupChildren: Column {
                    Process {
                        id: poweroffProc
                        running: false
                        command: ['poweroff']
                    }

                    Repeater {
                        model: [
                            {
                                icon: '',
                                label: 'Power Off',
                                command: ['poweroff']
                            },
                            {
                                icon: '',
                                label: 'Restart',
                                command: ['reboot']
                            },
                            {
                                icon: '󰒲',
                                label: 'Sleep',
                                command: ['systemctl', 'suspend']
                            },
                        ]

                        Control {
                            leftPadding: 20
                            implicitHeight: 26
                            implicitWidth: poweroffRoot.popupWidth

                            contentItem: StyledText {
                                anchors.verticalCenter: parent.verticalCenter
                                color: powerOptionMouseArea.containsMouse ? Appearance.colors.yellow : Appearance.colors.white
                                text: modelData.icon + '   ' + modelData.label
                            }

                            MouseArea {
                                id: powerOptionMouseArea
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: {
                                    poweroffProc.command = modelData.command;
                                    poweroffProc.running = true;
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
