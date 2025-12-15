import Quickshell.I3
import QtQuick
import QtQuick.Layouts

RowLayout {
  id: workspace_wrapper

  spacing: 0

  Repeater {
    id: workspace_repeater

    property var workspaces: I3.workspaces.values.filter(w => w.monitor.name == screen.name)

    model: workspaces.length

    ColumnLayout {
      id: workspace_selector

      property var ws_left_padding: [ "NE135A1M-NY1" ].includes(screen.model) ? 8 : 0
      property var ws_underline_width: 2
      property var workspace: workspace_repeater.workspaces[index]
      property bool isActive: I3.focusedWorkspace?.number === workspace.num

      spacing: 0
      width: 20 + (index == 0 ? ws_left_padding : 0)
      height: 16

      Rectangle {

        width: workspace_selector.width
        height: workspace_selector.height - workspace_selector.ws_underline_width
        color: workspace_selector.isActive ? "#772200" : "#000000"

        Text {
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
          width: workspace_selector.width
          horizontalAlignment: Text.AlignHCenter

          text: numToDisplay(workspace_selector.workspace.num)
          color: "#FFFFFF"

          topPadding: -2
          leftPadding: index == 0 ? workspace_selector.ws_left_padding : 0
          font {
            pixelSize: 12
            family: "Noto Sans Mono"
          }
        }
      }

      Rectangle {
        color: workspace_selector.isActive ? "#FB5000" : "#000000"
        width: workspace_selector.width
        height: workspace_selector.ws_underline_width
      }
    }
  }
}
