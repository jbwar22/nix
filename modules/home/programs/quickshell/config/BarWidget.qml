import QtQuick
import QtQuick.Layouts

RowLayout {
  required property var frac
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

    Rectangle {
      anchors.left: parent.left
      height: ih
      width: ((iw - 1) * frac) + 1
      color: barcolor
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

