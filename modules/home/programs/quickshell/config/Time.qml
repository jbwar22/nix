import Quickshell
import Quickshell.Io
import QtQuick

Scope {
  id: root
  property string time

  Process {
    id: clonck
    command: ["clonck"]
    running: true
    stdout: SplitParser {
      onRead: data => {
        root.time = data
        clonck.running = true
      }
    }
  }
}

