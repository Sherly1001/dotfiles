pragma Singleton

import QtQuick
import Quickshell

Singleton {
    property QtObject colors
    property QtObject fonts
    property QtObject animates

    colors: QtObject {
        property color transparent: '#00000000'
        property color background: '#ee222436'
        property color black: '#1b1d2b'
        property color brightBlack: '#444a73'
        property color darkBlack: '#17192b'
        property color white: '#c8d3f5'
        property color brightWhite: '#dbe4ff'
        property color darkWhite: '#828bb8'
        property color red: '#ff757f'
        property color brightRed: '#ff8d94'
        property color darkRed: '#c53b53'
        property color green: '#c3e88d'
        property color brightGreen: '#c7fb6d'
        property color darkGreen: '#a9d962'
        property color yellow: '#ffc777'
        property color brightYellow: '#ffd8ab'
        property color darkYellow: '#ffbc5e'
        property color blue: '#82aaff'
        property color brightBlue: '#9ab8ff'
        property color darkBlue: '#3e68d7'
        property color magenta: '#c099ff'
        property color brightMagenta: '#caabff'
        property color darkMagenta: '#b080ff'
        property color cyan: '#86e1fc'
        property color brightCyan: '#b2ebff'
        property color darkCyan: '#5dbcd9'
    }

    fonts: QtObject {
        property QtObject families: QtObject {
            property string sans: 'Noto Sans'
            property string mono: 'SauceCodePro Nerd Font Mono'
        }

        property QtObject pixelSize: QtObject {
            property int smallest: 10
            property int smaller: 12
            property int small: 15
            property int normal: 16
            property int large: 17
            property int larger: 19
            property int huge: 22
            property int hugeass: 23
            property int title: huge
        }
    }

    animates: QtObject {
        property QtObject curves: QtObject {
            property list<real> emphasized: [0.05, 0, 2 / 15, 0.06, 1 / 6, 0.4, 5 / 24, 0.82, 0.25, 1, 1, 1]
            property list<real> emphasizedAccel: [0.3, 0, 0.8, 0.15, 1, 1]
            property list<real> emphasizedDecel: [0.05, 0.7, 0.1, 1, 1, 1]
            property list<real> standard: [0.2, 0, 0, 1, 1, 1]
            property list<real> standardAccel: [0.3, 0, 1, 1, 1, 1]
            property list<real> standardDecel: [0, 0, 0, 1, 1, 1]
            property list<real> expressiveFastSpatial: [0.42, 1.67, 0.21, 0.9, 1, 1]
            property list<real> expressiveDefaultSpatial: [0.38, 1.21, 0.22, 1, 1, 1]
            property list<real> expressiveEffects: [0.34, 0.8, 0.34, 1, 1, 1]
        }

        property QtObject durations: QtObject {
            property real scale: 1
            property int small: 200 * scale
            property int normal: 400 * scale
            property int large: 600 * scale
            property int extraLarge: 1000 * scale
            property int expressiveFastSpatial: 350 * scale
            property int expressiveDefaultSpatial: 500 * scale
            property int expressiveEffects: 200 * scale
        }
    }
}
