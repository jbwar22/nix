import Quickshell
import Quickshell.I3
import QtQuick
import Quickshell.Io
import QtQuick.Layouts

Scope {
  id: root
  property string time

  Time { id: timeSource }

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
          id: workspace_repeater
          property var workspaces: I3.workspaces.values.filter(w => w.monitor.name == screen.name)
          model: workspaces.length

          Text {
            property var workspace: workspace_repeater.workspaces[index]
            property bool isActive: I3.focusedWorkspace?.number === workspace.num

            function numToDisplay(num) {
              switch (num) {
                case 1:  return "一";
                case 2:  return "二";
                case 3:  return "三";
                case 4:  return "四";
                case 5:  return "五";
                case 6:  return "六";
                case 7:  return "七";
                case 8:  return "八";
                case 9:  return "九";
                case 10: return "十";
              }
            }

            text: numToDisplay(workspace.num)
            color: isActive ? "#FB5000" : "#FFFFFF"

            topPadding: -2
            leftPadding: index == 0 ? 10 : 0
            font {
              pixelSize: 12
              family: "Noto Sans Mono"
            }
          }
        }

        Text {
          // text: "count:" + workspace_repeater.workspaces[4].num
          color: "#FFFFFF"

          topPadding: -2
          font {
            pixelSize: 12
            family: "Noto Sans Mono"
          }
        }

        Text {
          text: root.time
          color: "#FFFFFF"

          topPadding: -2
          font {
            pixelSize: 12
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
    id: clonck
    command: ["clonck", "once"]
    running: true
    stdout: StdioCollector {
      onTextChanged: {
        root.time = text.split('\n')[0]
      }
      onStreamFinished: {
        clonck.running = true
      }
    }
  }
}

