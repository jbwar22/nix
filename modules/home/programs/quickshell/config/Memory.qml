import Quickshell
import Quickshell.Io
import QtQuick

Scope {
  id: root
  property string frac
  property string rfrac
  property string bfrac
  property string barcolor

  Process {
    id: free
    command: ["cat", "/proc/meminfo"]
    running: true
    stdout: StdioCollector {
      onStreamFinished: {
        let meminfo = {}
        let lines = text.trim().split('\n')
        for (let line of lines) {
          let linedata = line.trim().split(/:\s*/)
          meminfo[linedata[0]] = parseInt(linedata[1].split(/\s/)[0])
        }

        let anonPages = meminfo['AnonPages']
        let memAvailable = meminfo['MemAvailable']
        let userMemTotal = memAvailable + anonPages // as described by earlyoom
        let memTotal = meminfo['MemTotal']
        let memUsed = memTotal - memAvailable
        let zswap = meminfo['Zswap']
        let swapTotal = meminfo['SwapTotal']
        let swapFree = meminfo['SwapFree']


        // only program memory
        // root.frac = anonPages / memTotal

        // normal
        root.frac = memUsed / memTotal

        // non user mem
        // root.rfrac = (memTotal - userMemTotal) / memTotal

        // zswap usage
        root.rfrac = zswap / memTotal

        // swap usage
        root.bfrac = swapTotal == 0 ? 0 : ((swapTotal - swapFree) / swapTotal)

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

