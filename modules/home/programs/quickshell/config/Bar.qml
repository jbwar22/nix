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
      id: pw

      required property var modelData
      screen: modelData

      anchors {
        top: true
        left: true
        right: true
      }

      // color: "#900000"
      color: "#000000"

      property var screenSettings: {
        if (
          screen.devicePixelRatio == 1
          && (
            (screen.width == 2560 && screen.height == 1440)
            || (screen.width == 1440 && screen.height == 2560)
          )
        ) {
          // 1440p
          return {
            barHeight: 29,
            fontSize: 15,
            leftPadding: 0,
            wsWidth: 24,
            wsUnder: 3,
            baseline: 5,
            wbarHeight: 12,
            wbarBase: 4,
            wgap: 9,
            wvwidth: 7,
          }
        } else if (
          screen.devicePixelRatio == 2
          && (
            (screen.width == 2880 && screen.height == 1920)
            || (screen.width == 1920 && screen.height == 2880)
          )
        ) {
          // framework laptop
          return {
            barHeight: 16,
            fontSize: 12,
            // leftPadding: ["NE135A1M-NY1"].includes(screen.model) ? 8 : 0,
            leftPadding: 8, // tmp
            wsWidth: 20,
            wsUnder: 2,
            baseline: 2,
            wbarHeight: 10,
            wbarBase: 3,
            wgap: 10,
            wvwidth: 5,
          }
        } else if (
          screen.devicePixelRatio == 1
          && (
            (screen.width == 1366 && screen.height == 768)
            || (screen.width == 768 && screen.height == 1366)
          )
        ) {
          // T480
          return {
            barHeight: 20,
            fontSize: 15,
            leftPadding: 0,
            wsWidth: 22,
            wsUnder: 2,
            baseline: 2,
            wbarHeight: 12,
            wbarBase: 3,
            wgap: 10,
            wvwidth: 5,
          }
        } else {
          // default (optimize for 1080p)
          return {
            barHeight: 20,
            fontSize: 13,
            leftPadding: 0,
            wsWidth: 22,
            wsUnder: 2,
            baseline: 1,
            wbarHeight: 10,
            wbarBase: 3,
            wgap: 7,
            wvwidth: 5,
          }
        }
      }
      
      implicitHeight: screenSettings.barHeight

      RowLayout {
        id: bar
        anchors.fill: parent

        RowLayout {
          id: left_widgets
          height: parent.height

          Workspaces {
            screenSettings: pw.screenSettings
          }

          ClockWidget {
            time: timeSource.time
            screenSettings: pw.screenSettings
          }
        }

        Item {
          Layout.fillWidth: true
          height: parent.height

          Item {
            id: titlep

            implicitHeight: titletext.implicitHeight
            implicitWidth: parent.width


            y: parent.height - height - screenSettings.baseline

            Text {
              id: titletext
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
              width: titlep.width
              horizontalAlignment: contentWidth <= innerWidth ? Text.AlignHCenter : Text.AlignLeft
              rightPadding: paddings.right
              leftPadding: paddings.left
              topPadding: -2
              elide: Text.ElideRight

              font {
                pixelSize: screenSettings.fontSize
                family: "Noto Sans Mono"
              }
            }

          }
        }

        RowLayout {
          id: right_widgets


          BarWrapWidget {
            label: "R"
            screenSettings: pw.screenSettings
            BarWidget {
              screenSettings: pw.screenSettings
              frac: rootfsSource.frac
              barcolor: rootfsSource.barcolor
              barwidth: 4
            }
          }

          BarWrapWidget {
            label: "C"
            screenSettings: pw.screenSettings
            VBarWidget {
              screenSettings: pw.screenSettings
              fracs: cpuSource.fracs
            }
          }

          BarWrapWidget {
            label: "M"
            screenSettings: pw.screenSettings
            MemBarWidget {
              screenSettings: pw.screenSettings
              frac: memorySource.frac
              rfrac: memorySource.rfrac
              bfrac: memorySource.bfrac
              barcolor: memorySource.barcolor
              barwidth: 10
            }
          }

          Repeater {
            model: batterySource.batteries.length
            BarWrapWidget {
              label: "B"
              screenSettings: pw.screenSettings
              BarWidget {
                screenSettings: pw.screenSettings
                frac: batterySource.fracs[index]
                barcolor: batterySource.barcolors[index]
                barwidth: 20
              }
            }
          }
        }
      }
    }
  }
}

