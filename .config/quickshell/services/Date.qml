pragma Singleton

import Quickshell

Singleton {
    readonly property alias date: clock.date
    readonly property string time: {
        Qt.formatDateTime(clock.date, 'ddd, MMM dd・HH:mm');
    }

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }
}
