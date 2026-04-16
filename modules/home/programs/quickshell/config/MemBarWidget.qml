import QtQuick
import QtQuick.Layouts

RowLayout {
  required property var frac
  required property var rfrac
  required property var bfrac
  required property var label
  required property var barwidth
  property var barcolor: "#FFFFFF"


  property var oh: 16
  property var ih: 10
  property var iw: barwidth
  property var extra: 10

  spacing: 0

  Text {
    text: label
    color: "#FFF"
    topPadding: -2
    font {
      pixelSize: 12
      family: "Noto Sans Mono"
    }
  }

  Item {
    width: 1
    height: oh
  }

  ColumnLayout {
    spacing: 0
    Item {
      width: 1
      height: (oh - ih) / 2
    }
    Rectangle {
      width: 1
      height: ih
      color: "#FFF"
    }
    Item {
      width: 1
      height: (oh - ih) / 2
    }
  }
  ColumnLayout {
    spacing: 0
    Item {
      width: 2
      height: (oh - ih) / 2
    }
    Rectangle {
      width: 2
      height: 1
      color: "#FFF"
    }
    Item {
      width: 2
      height: ih - 2 
    }
    Rectangle {
      width: 2
      height: 1 
      color: "#FFF"
    }
    Item {
      width: 2
      height: (oh - ih) / 2
    }
  }

  Item {
    width: 1
    height: oh
  }

  // bar
  
  Item {
    height: ih
    width: iw

    // swap (underneath)
    Rectangle {
      anchors.left: parent.left
      anchors.bottom: parent.bottom
      height: (1 * ih / 4)
      width: ((iw - 1) * bfrac) + 1
      color: barcolor
    }

    // normal memory
    Rectangle {
      anchors.left: parent.left
      anchors.top: parent.top
      height: ih
      width: ((iw - 1) * frac) + 1
      color: barcolor
    }

    // zswap
    Rectangle {
      anchors.left: parent.left
      anchors.top: parent.top
      height: ih
      width: ((iw - 1) * rfrac) + 1
      color: "#999"
    }

    // swap (black layer)
    Rectangle {
      anchors.left: parent.left
      anchors.bottom: parent.bottom
      height: (1 * ih / 4)
      width: ((iw - 1) * (bfrac < frac ? bfrac : frac)) + 1
      color: "#000"
    }


  }

  // end bar

  Item {
    width: 1
    height: oh
  }

  ColumnLayout {
    spacing: 0
    Item {
      width: 2
      height: (oh - ih) / 2
    }
    Rectangle {
      width: 2
      height: 1
      color: "#FFF"
    }
    Item {
      width: 2
      height: ih - 2 
    }
    Rectangle {
      width: 2
      height: 1 
      color: "#FFF"
    }
    Item {
      width: 2
      height: (oh - ih) / 2
    }
  }

  ColumnLayout {
    spacing: 0
    Item {
      width: 1
      height: (oh - ih) / 2
    }
    Rectangle {
      width: 1
      height: ih
      color: "#FFF"
    }
    Item {
      width: 1
      height: (oh - ih) / 2
    }
  }
  Item {
    width: extra
    height: oh
  }
}

