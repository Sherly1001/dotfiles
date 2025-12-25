pragma Singleton

import Quickshell
import Quickshell.Io
import Quickshell.Services.Pipewire

Singleton {
    readonly property PwNode sink: Pipewire.defaultAudioSink
    readonly property PwNode source: Pipewire.defaultAudioSource

    readonly property bool muted: sink?.audio?.muted ?? false
    readonly property int volume: Math.round((sink?.audio?.volume ?? 0) * 100)

    function setVolume(volume: real): void {
        if (sink?.ready && sink?.audio) {
            sink.audio.muted = false;
            sink.audio.volume = volume;
        }
    }

    function setMuted(muted: bool): void {
        if (sink?.ready && sink?.audio) {
            sink.audio.muted = muted;
        }
    }

    function openPwvucontrol(): void {
        pwvucontrolProc.running = true;
    }

    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink, Pipewire.defaultAudioSource]
    }

    Process {
        id: pwvucontrolProc
        running: false
        command: ['pwvucontrol']
    }
}
