import QtQuick

import QtQuick.Layouts
import QtQuick.Controls

import qs.config
import qs.services

ColumnLayout {
    id: root

    property string locale: "en_GB"
    property int year: Date.date.getFullYear()
    property int month: Date.date.getMonth()
    property real fontSize: Appearance.fonts.pixelSize.small

    function thisMonth() {
        grid.month = root.month;
        grid.year = root.year;
    }

    function prevMonth() {
        if (grid.month > 0) {
            grid.month -= 1;
        } else {
            grid.year -= 1;
            grid.month = 11;
        }
    }

    function nextMonth() {
        if (grid.month < 11) {
            grid.month += 1;
        } else {
            grid.year += 1;
            grid.month = 0;
        }
    }

    RowLayout {
        Layout.fillWidth: true

        StyledText {
            text: ''
            rightPadding: 20

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: root.prevMonth()
            }
        }

        Item {
            Layout.fillWidth: true
        }

        StyledText {
            leftPadding: 50
            rightPadding: 50
            text: `${grid.year} / ${grid.month + 1}`

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: root.thisMonth()
                onWheel: event => {
                    if (event.angleDelta.y > 0) {
                        root.nextMonth();
                    } else {
                        root.prevMonth();
                    }
                }
            }
        }

        Item {
            Layout.fillWidth: true
        }

        StyledText {
            text: ''
            leftPadding: 20

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: root.nextMonth()
            }
        }
    }

    GridLayout {
        rowSpacing: 0
        columnSpacing: 0

        DayOfWeekRow {
            locale: grid.locale

            Layout.column: 1
            Layout.fillWidth: true

            delegate: StyledText {
                text: model.shortName
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: root.fontSize
                color: Appearance.colors.magenta
            }
        }

        WeekNumberColumn {
            month: grid.month
            year: grid.year
            locale: grid.locale

            Layout.row: 1
            Layout.fillHeight: true

            delegate: StyledText {
                text: model.weekNumber
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: root.fontSize
                color: Appearance.colors.green
            }
        }

        MonthGrid {
            id: grid
            month: root.month
            year: root.year
            locale: Qt.locale(root.locale)

            Layout.fillWidth: true
            Layout.fillHeight: true

            delegate: Item {
                Rectangle {
                    visible: model.today
                    anchors.fill: parent
                    color: Appearance.colors.blue
                    radius: 100
                }

                StyledText {
                    anchors.fill: parent
                    text: model.day
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.pixelSize: root.fontSize
                    color: {
                        const isWeekend = [0, 6].includes(model.date.getDay());
                        return model.month != grid.month ? (isWeekend ? Appearance.colors.darkRed : Appearance.colors.darkWhite) : (model.today ? Appearance.colors.black : (isWeekend ? Appearance.colors.red : Appearance.colors.white));
                    }
                }
            }
        }
    }
}
