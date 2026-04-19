import QtQuick

Item {
  id: outer
  required property var label
  required property var screenSettings

  required default property Item child

  height: screenSettings.barHeight
  implicitWidth: bwrap.implicitWidth + screenSettings.wgap

  Item {
    id: bwrap
    implicitHeight: text.implicitHeight

    property var tw: Math.ceil(text.implicitWidth)
    implicitWidth: tw + 8 + outer.child.width
    width: parent.width - outer.screenSettings.wgap

    y: parent.height - height - screenSettings.baseline

    Item {
      implicitWidth: outer.child.implicitWidth
      height: screenSettings.wbarHeight
      x: bwrap.tw + 4
      y: parent.height - height - screenSettings.wbarBase

      children: outer.child
      Binding { outer.child.height: screenSettings.wbarHeight }
    }

    // label

    Text {
      id: text
      text: label

      color: "#FFFFFF"
      font {
        pixelSize: screenSettings.fontSize
        family: "Noto Sans Mono"
      }
    }

    // left boundry

    Rectangle {
      height: screenSettings.wbarHeight
      width: 1
      x: bwrap.tw
      y: parent.height - height - screenSettings.wbarBase
      color: "#FFFFFF"
    }

    Rectangle {
      height: 1
      width: 3
      x: bwrap.tw
      y: parent.height - height - screenSettings.wbarBase
      color: "#FFFFFF"
    }

    Rectangle {
      height: 1
      width: 3
      x: bwrap.tw
      y: parent.height - height - screenSettings.wbarBase - screenSettings.wbarHeight + 1
      color: "#FFFFFF"
    }

    // right boundry

    Rectangle {
      height: screenSettings.wbarHeight
      width: 1
      x: bwrap.width - 1
      y: parent.height - height - screenSettings.wbarBase
      color: "#FFFFFF"
    }

    Rectangle {
      height: 1
      width: 3
      x: bwrap.width - 3
      y: parent.height - height - screenSettings.wbarBase
      color: "#FFFFFF"
    }

    Rectangle {
      height: 1
      width: 3
      x: bwrap.width - 3
      y: parent.height - height - screenSettings.wbarBase - screenSettings.wbarHeight + 1
      color: "#FFFFFF"
    }
  }
}

