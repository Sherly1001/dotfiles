pragma Singleton

import Quickshell
import Quickshell.Io

Singleton {
    id: powerprofile

    property list<var> options: []
    readonly property var icons: ({
            'power-saver': '󰌪',
            'balanced': '󰗑',
            'performance': ''
        })

    function changeProfile(value: string): void {
        setProfileProc.command = ['powerprofilesctl', 'set', value];
        setProfileProc.running = true;
    }

    Process {
        id: getProfileProc
        running: true
        command: ['powerprofilesctl', 'list']
        stdout: StdioCollector {
            onStreamFinished: {
                options = text.split('\n\n').map(o => o.split('\n')[0].match(/(\*?)\s*(.*):/)).map(m => ({
                            selected: !!m[1],
                            label: m[2],
                            icon: icons[m[2]] ?? ''
                        }));
            }
        }
    }

    Process {
        id: setProfileProc
        running: false
        command: ['powerprofilesctl', 'set']
        onExited: {
            getProfileProc.running = true;
        }
    }

    IpcHandler {
        target: 'powerprofile'

        function getProfile(): string {
            return options.find(o => o.selected)?.label || '';
        }

        function changeProfile(value: string): void {
            powerprofile.changeProfile(value);
        }
    }
}
