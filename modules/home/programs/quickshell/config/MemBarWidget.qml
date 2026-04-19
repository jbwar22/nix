import QtQuick
import QtQuick.Layouts

Item {
  id: outer
  required property var screenSettings
  required property var frac
  required property var rfrac
  required property var bfrac
  required property var barwidth
  property var barcolor: "#FFFFFF"

  property var adjWidth: barwidth * screenSettings.wvwidth

  width: adjWidth

  // swap (underneath)
  Rectangle {
    anchors.bottom: parent.bottom
    height: 1 * parent.height / 4
    width: ((outer.adjWidth - 1) * bfrac) + 1
    color: barcolor
  }

  // normal memory
  Rectangle {
    height: parent.height
    width: ((outer.adjWidth - 1) * frac) + 1
    color: barcolor
  }

  // zswap
  Rectangle {
    height: parent.height
    width: ((outer.adjWidth - 1) * rfrac) + 1
    color: "#999"
  }

  // swap (black layer)
  Rectangle {
    anchors.bottom: parent.bottom
    height: 1 * parent.height / 4
    width: ((outer.adjWidth - 1) * (bfrac < frac ? bfrac : frac)) + 1
    color: "#000"
  }
}
