import Quickshell
import Quickshell.Io
import QtQuick

Scope {
  id: root
  property string frac

  Process {
    id: df
    command: ["df", "/"]
    running: true
    stdout: StdioCollector {
      onStreamFinished: {
        let lines = text.split('\n')
        let rootfs = lines[1].trim().split(/\s+/)
        let total = parseInt(rootfs[1])
        let used = parseInt(rootfs[2])
        root.frac = used / total
      }
    }
    Component.onCompleted: running = true
  }
  Timer {
    interval: 5000
    running: true
    repeat: true
    onTriggered: df.running = true
  }
}

