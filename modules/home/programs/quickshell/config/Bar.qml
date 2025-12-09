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

      color: "#000000"

      implicitHeight: 16

      RowLayout {
        anchors.fill: parent

        Workspaces {}

        ClockWidget {
          time: timeSource.time
        }

        Item { 
          Layout.fillWidth: true
        }
      }
    }
  }
}

