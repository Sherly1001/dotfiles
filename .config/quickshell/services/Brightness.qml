pragma Singleton

import Quickshell
import Quickshell.Io

Singleton {
    id: brightness

    property string value: ''

    function changeBrightness(value: string): void {
        getBrightnessProc.command = ['brightnessctl', 'set', value];
        getBrightnessProc.running = true;
    }

    Process {
        id: getBrightnessProc
        running: true
        command: ['brightnessctl']
        stdout: StdioCollector {
            onStreamFinished: {
                const matches = text.match(/Current brightness: (\d+) \((\d+%)\)/);
                brightness.value = matches[2] ?? '';
            }
        }
    }

    IpcHandler {
        target: 'brightness'

        function changeBrightness(value: string): void {
            brightness.changeBrightness(value);
        }
    }
}
