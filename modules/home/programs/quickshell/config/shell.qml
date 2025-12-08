import Quickshell
import Quickshell.I3
import QtQuick
import Quickshell.Io
import QtQuick.Layouts

Scope {
  id: root
  property string time

  Variants {
    model: Quickshell.screens

    PanelWindow {
      required property var modelData
      screen: modelData

      anchors {
        top: true
        left: true
        right: true
      }

      color: "#003300"

      implicitHeight: 16

      RowLayout {
        anchors.fill: parent

        Repeater {
          model: 10
          Text {
            text: "frog" + (index + 1)
            topPadding: -2
            color: "#FFFFFF"
            font {
              pixelSize: 13
              family: "Noto Sans Mono"
            }
          }
        }

        Text {
          text: root.time
          topPadding: -2
          color: "#FFFFFF"
          font {
            pixelSize: 13
            family: "Noto Sans Mono"
          }
        }

        Item { 
          Layout.fillWidth: true
        }
      }
    }
  }

  Process {
    id: dateproc
    command: ["clonck", "once"]
    running: true
    stdout: StdioCollector {
      onTextChanged: {
        root.time = text.split('\n')[0]
      }
      onStreamFinished: {
        dateproc.running = true
      }
    }
  }
}

