import Quickshell
import Quickshell.Io
import QtQuick

Scope {
  id: root
  property string time

  Process {
    id: clonck
    command: ["clonck", "once"]
    running: true
    stdout: StdioCollector {
      onStreamFinished: {
        root.time = text.split('\n')[0]
        clonck.running = true
      }
    }
  }
}

