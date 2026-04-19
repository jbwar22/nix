import QtQuick
import QtQuick.Layouts

Item {
  id: outer
  required property var frac
  required property var barwidth
  required property var screenSettings
  property var barcolor: "#FFFFFF"

  property var adjWidth: barwidth * screenSettings.wvwidth

  width: adjWidth

  Rectangle {
    height: parent.height
    width: ((outer.adjWidth - 1) * frac) + 1
    color: barcolor
  }
}
