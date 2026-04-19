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

    Scope {
      required property var modelData

      ScreenSettings {
        id: screenSettings
        screen: modelData
      }

      PanelWindow {
        id: barPanel

        screen: modelData

        exclusionMode: ExclusionMode.Normal
        exclusiveZone: screenSettings.barHeight

        anchors {
          top: true
          left: true
          right: true
        }

        // color: "#900000"
        color: "#000000"

        implicitHeight: bar.implicitHeight

        Item {
          
        }

        RowLayout {
          id: bar
          implicitHeight: screenSettings.barHeight

          anchors.top: barPanel.top
          width: parent.width

          RowLayout {
            id: left_widgets
            Layout.fillHeight: true

            Workspaces {
              screenSettings: screenSettings
              screen: barPanel.screen
            }

            ClockWidget {
              time: timeSource.time
              screenSettings: screenSettings
            }
          }

          Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

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
            Layout.fillHeight: true
            spacing: screenSettings.wgap

            VolumeWidget {
              screenSettings: screenSettings
            }

            BarWrapWidget {
              label: "R"
              screenSettings: screenSettings
              BarWidget {
                screenSettings: screenSettings
                frac: rootfsSource.frac
                barcolor: rootfsSource.barcolor
                barwidth: 4
              }
            }

            BarWrapWidget {
              label: "C"
              screenSettings: screenSettings
              VBarWidget {
                screenSettings: screenSettings
                fracs: cpuSource.fracs
              }
            }

            BarWrapWidget {
              label: "M"
              screenSettings: screenSettings
              MemBarWidget {
                screenSettings: screenSettings
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
                screenSettings: screenSettings
                BarWidget {
                  screenSettings: screenSettings
                  frac: batterySource.fracs[index]
                  barcolor: batterySource.barcolors[index]
                  barwidth: 20
                }
              }
            }

            // add a gap on the right
            Item {
              height: parent.height
              width: 0
            }
          }
        }
      }
    }
  }
}

