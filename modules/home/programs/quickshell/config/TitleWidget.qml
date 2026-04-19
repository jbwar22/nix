import QtQuick
import QtQuick.Layouts

Item {
  id: wrap
  required property var screenSettings
  required property int left_width
  required property int right_width
  required property int bar_width
  required property var title

  Layout.fillWidth: true

  height: screenSettings.barHeight

  Rectangle {
    anchors.fill: parent
    color: "#909000"
  }

  Item {
    implicitHeight: text.implicitHeight
    width: parent.width
    y: parent.height - height - screenSettings.baseline

    Rectangle {
      anchors.fill: parent
      color: "#009000"
    }

    Text {
      id: text
      text: title

      elide: Text.ElideRight
      width: parent.width

      property var innerWidth: bar_width - (2 * Math.max(left_width, right_width))
      property var leftBias: left_widgets.width > right_widgets.width

      property var paddings: {
        if (contentWidth > innerWidth) {
          return { left: 0, right: 0 }
        }
        if (leftBias) {
            return { left: 0, right: left_width - right_width }
        } else {
            return { left: right_width - left_width, right: 0 }
        }
      }

      horizontalAlignment: contentWidth <= innerWidth ? Text.AlignHCenter : Text.AlignLeft
      rightPadding: paddings.right
      leftPadding: paddings.left

      color: "#FFFFFF"
      font {
        pixelSize: screenSettings.fontSize
        family: "Noto Sans Mono"
      }
    }
  }
}
