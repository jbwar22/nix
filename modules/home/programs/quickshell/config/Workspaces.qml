import Quickshell.I3
import QtQuick
import QtQuick.Layouts

RowLayout {
  required property var screenSettings
  required property var screen

  id: root

  spacing: 0

  height: screenSettings.barHeight

  Repeater {
    id: workspace_repeater

    property var workspaces: I3.workspaces.values.filter(w => w.monitor.name == screen.name)

    model: workspaces.length

    Item {
      id: workspace_selector
      property var workspace: workspace_repeater.workspaces[index]
      property bool isActive: I3.focusedWorkspace?.number === workspace.num
      property bool isHovered: false
      property int extraLeft: index == 0 ? screenSettings.leftPadding : 0

      width: screenSettings.wsWidth + extraLeft
      height: screenSettings.barHeight

      MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        hoverEnabled: true
        onEntered: () => workspace_selector.isHovered = true
        onExited: () => workspace_selector.isHovered = false
        onPressed: () => I3.dispatch("workspace number " + workspace.number)
      }

      Rectangle {
        anchors.fill: parent
        color: workspace_selector.isActive ? "#772200" : (workspace_selector.isHovered ? "#441100" : "#000000")
      }

      Rectangle {
        anchors.bottom: parent.bottom
        width: parent.width
        height: screenSettings.wsUnder
        color: workspace_selector.isActive ? "#FB5000" : (workspace_selector.isHovered ? "#772200" : "#000000")
      }

      Item {
        implicitHeight: text.implicitHeight
        width: parent.width - extraLeft

        x: extraLeft
        y: parent.height - height - screenSettings.baseline


        Text {
          id: text
          text: {
            switch (workspace_selector.workspace.num) {
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

          width: parent.width
          horizontalAlignment: Text.AlignHCenter

          color: "#FFFFFF"
          font {
            pixelSize: screenSettings.fontSize
            family: "Noto Sans Mono"
          }
        }
      }
    }
  }
}
