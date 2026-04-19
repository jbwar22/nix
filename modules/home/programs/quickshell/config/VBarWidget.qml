import QtQuick
import QtQuick.Layouts

Item {
  id: outer
  required property var screenSettings
  required property var fracs
  property var barcolor: "#FFFFFF"

  property var barwidth: screenSettings.wvwidth
  property var fracsa: JSON.parse(fracs || [])

  width: barwidth * fracsa.length

  // bar
  Repeater {
    model: fracsa.length

    Rectangle {
      property var ch: ((outer.height - 1) * fracsa[index]) + 1
      width: outer.barwidth
      x: index * outer.barwidth
      height: ch
      anchors.bottom: parent.bottom
      color: "#FFF"
    }
  }
}

