import QtQuick
import QtQuick.Layouts

import qs.config

Text {
    renderType: Text.NativeRendering
    verticalAlignment: Text.AlignVCenter
    font {
        family: Appearance.fonts.families.sans
        hintingPreference: Font.PreferFullHinting
        pixelSize: Appearance.fonts.pixelSize.normal ?? 16
    }
    color: Appearance.colors.white ?? "white"
}
