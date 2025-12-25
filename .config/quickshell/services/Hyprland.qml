pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Hyprland

Singleton {
    id: hyprland

    readonly property var submap: submap.text() ?? ''
    readonly property var monitors: Hyprland.monitors
    readonly property var workspaces: Hyprland.workspaces
    readonly property HyprlandMonitor focusedMonitor: Hyprland.focusedMonitor
    readonly property HyprlandWorkspace focusedWorkspace: Hyprland.focusedWorkspace
    readonly property list<string> icons: ['', '', '', '', '', '󰀟', '󰃥', '', '', '󰗃', '']
    readonly property string specialIcon: '󱎃'

    function dispatch(request: string): void {
        Hyprland.dispatch(request);
    }

    Connections {
        target: Hyprland

        function onRawEvent(event: HyprlandEvent): void {
            if (event.name.endsWith("v2"))
                return;
            if (event.name.includes("mon"))
                Hyprland.refreshMonitors();
            else if (event.name.includes("workspace"))
                Hyprland.refreshWorkspaces();
            else
                Hyprland.refreshToplevels();
        }
    }

    FileView {
        id: submap
        path: '/tmp/hyprland.submap'
        printErrors: false
        blockLoading: true
        watchChanges: true
        onFileChanged: this.reload()
    }

    function resetSubmap() {
        resetSubmap.running = true;
    }

    Process {
        id: resetSubmap
        running: true
        command: ['sh', '-c', 'hyprctl dispatch submap reset && echo > /tmp/hyprland.submap']
    }

    function setSubmap(value: string) {
        setSubmap.command = ['sh', '-c', `hyprctl dispatch submap ${value}_submap && echo ${value} > /tmp/hyprland.submap`];
        setSubmap.running = true;
    }

    Process {
        id: setSubmap
        running: false
    }

    IpcHandler {
        target: 'hyprland'

        function resetSubmap(): void {
            hyprland.resetSubmap();
        }

        function setSubmap(value: string): void {
            hyprland.setSubmap(value);
        }
    }
}
