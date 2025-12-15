import Quickshell
import Quickshell.Io
import QtQuick

Scope {
  id: root
  property string fracs: JSON.stringify([0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0])
  property var cores: 16

  Process {
    id: proc_stat
    command: ["mpstat", "-P", "ALL", "1", "1"]
    running: true
    stdout: StdioCollector {
      onStreamFinished: {
        let lines = text.split('\n')
        let fracsNew = []
        for (let i = 0; i < cores; i++) {
          let col = i + 4
          let corestats = lines[col].trim().split(/\s+/)
          let user = parseFloat(corestats[3]) || 0
          let nice = parseFloat(corestats[4]) || 0
          let sys = parseFloat(corestats[5]) || 0
          // let iowait = parseFloat(corestats[6]) || 0
          let irq = parseFloat(corestats[7]) || 0
          let soft = parseFloat(corestats[8]) || 0
          let steal = parseFloat(corestats[9]) || 0
          let guest = parseFloat(corestats[10]) || 0
          let gnice = parseFloat(corestats[11]) || 0
          // let idle = parseFloat(corestats[12]) || 0

          let used = user + nice + sys + irq + soft + steal + guest + gnice
          fracsNew.push(used / 100)
        }

        root.fracs = JSON.stringify(fracsNew)
        proc_stat.running = true
      }
    }
    Component.onCompleted: running = true
  }
}

