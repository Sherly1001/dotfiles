pragma Singleton

import Quickshell
import Quickshell.Bluetooth as QsBT
import Quickshell.Io

Singleton {
    id: root

    readonly property var adapter: QsBT.Bluetooth.defaultAdapter
    readonly property bool powered: adapter?.enabled ?? false
    readonly property bool scanning: adapter?.discovering ?? false
    readonly property var devices: adapter?.devices

    readonly property string icon: {
        if (!powered) return '󰂲';
        if (devices?.values?.some(d => d.connected)) return '󰂱';
        return '󰂯';
    }

    function isTransitioning(device): bool {
        return device?.pairing
            || device?.state === QsBT.BluetoothDeviceState.Connecting
            || device?.state === QsBT.BluetoothDeviceState.Disconnecting;
    }

    function togglePower(): void {
        if (adapter) adapter.enabled = !adapter.enabled;
    }

    function toggleScan(): void {
        if (adapter) adapter.discovering = !scanning;
    }
}
