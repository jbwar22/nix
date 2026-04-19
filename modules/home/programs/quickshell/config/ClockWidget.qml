import QtQuick

Item {
  required property string time
  required property var screenSettings

  height: screenSettings.barHeight
  implicitWidth: bwrap.implicitWidth

  // Rectangle {
  //   anchors.fill: parent
  //   color: "#909000"
  // }

  Item {
    id: bwrap
    implicitHeight: text.implicitHeight
    implicitWidth: text.implicitWidth

    y: parent.height - height - screenSettings.baseline

    // Rectangle {
    //   anchors.fill: parent
    //   color: "#009000"
    // }

    Text {
      id: text
      text: time

      color: "#FFFFFF"
      font {
        pixelSize: screenSettings.fontSize
        family: "Noto Sans Mono"
      }
    }
  }
}
