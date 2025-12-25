pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Services.UPower

Singleton {
    readonly property bool isLaptopBattery: UPower.displayDevice.isLaptopBattery
    readonly property string state: UPowerDeviceState.toString(UPower.displayDevice.state)
    readonly property int percentage: Math.round(UPower.displayDevice.percentage * 100)
    readonly property string icon: {
        const chargingIcons = ['󰢟', '󰢜', '󰂆', '󰂇', '󰂈', '󰢝', '󰂉', '󰢞', '󰂊', '󰂋', '󰂅'];

        const icons = {
            'Discharging': ['󰂎', '󰁺', '󰁻', '󰁼', '󰁽', '󰁾', '󰁿', '󰂀', '󰂁', '󰂂', '󰁹'],
            'Charging': chargingIcons,
            'Pending Charge': chargingIcons,
            'Pending Discharge': chargingIcons,
            'Fully Charged': ['󰂄']
        };

        const set = icons[state] ?? ['󱟨'];
        const idx = Math.round(UPower.displayDevice.percentage * (set.length - 1));

        return set[idx];
    }
}
