import Quickshell
import Quickshell.Io
import QtQuick

Scope {
  id: root
  property string frac
  property string barcolor

  Process {
    id: acpi
    command: ["acpi"]
    running: true
    stdout: StdioCollector {
      onStreamFinished: {
        let d1 = text.split(':')
        let d2 = d1[1].split(',')
        let charging = d2[0].trim() == "Charging"
        let percentage = d2[1].slice(0, -1)
        root.frac = parseInt(percentage) / 100
        root.barcolor = charging ? '#00FF00' : (percentage < 20 ? '#FF0000' : '#FFFFFF')
      }
    }
    Component.onCompleted: running = true
  }

  Timer {
    interval: 15000
    running: true
    repeat: true
    onTriggered: acpi.running = true
  }
}

