import Quickshell
import Quickshell.Io
import QtQuick

Scope {
  id: root
  property string frac
  property string barcolor

  Process {
    id: free
    command: ["free"]
    running: true
    stdout: StdioCollector {
      onStreamFinished: {
        let items = text.split('\n')[1].split(/\s+/)
        let total = parseInt(items[1])
        let used = parseInt(items[2])
        root.frac = used / total
        root.barcolor = root.frac > 0.9 ? '#FF0000' : '#FFFFFF'
      }
    }
    Component.onCompleted: running = true
  }

  Timer {
    interval: 1000
    running: true
    repeat: true
    onTriggered: free.running = true
  }
}

