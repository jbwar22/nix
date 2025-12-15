import Quickshell
import Quickshell.I3
import QtQuick
import Quickshell.Io
import QtQuick.Layouts

Scope {
  id: root
  property string time

  Time { id: timeSource }
  Cpu { id: cpuSource }
  Memory { id: memorySource }
  Battery { id: batterySource }
  Title { id: titleSource }
  Rootfs { id: rootfsSource }

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
        id: bar
        anchors.fill: parent

        RowLayout {
          id: left_widgets
          Workspaces {}

          ClockWidget {
            time: timeSource.time
          }
        }

        Item {
          Layout.fillWidth: true
          height: 16

          Text {
            property var left_width: left_widgets.width + bar.spacing
            property var right_width: right_widgets.width + bar.spacing
            property var innerWidth: bar.width - (2 * Math.max(left_width, right_width))
            property var leftBias: left_widgets.width > right_widgets.width
            function getPaddings() {
              if (contentWidth > innerWidth) {
                return { left: 0, right: 0 }
              }
              if (leftBias) {
                  return { left: 0, right: left_width - right_width }
              } else {
                  return { left: right_width - left_width, right: 0 }
              }
            }
            property var paddings: getPaddings()
            color: "#FFF"
            // text: "################################################################################################"
            text: titleSource.title
            width: parent.width
            horizontalAlignment: contentWidth <= innerWidth ? Text.AlignHCenter : Text.AlignLeft
            rightPadding: paddings.right
            leftPadding: paddings.left
            elide: Text.ElideRight
          }

        }

        RowLayout {
          id: right_widgets

          BarWidget {
            frac: rootfsSource.frac
            label: "R"
            barwidth: 20
          }

          VBarWidget {
            fracs: cpuSource.fracs
            label: "C"
          }

          BarWidget {
            frac: memorySource.frac
            label: "M"
            barwidth: 50
          }

          BarWidget {
            frac: batterySource.frac
            barcolor: batterySource.barcolor
            label: "B"
            barwidth: 20
          }
        }
      }
    }
  }
}

