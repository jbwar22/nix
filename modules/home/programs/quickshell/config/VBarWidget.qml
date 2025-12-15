import QtQuick
import QtQuick.Layouts

RowLayout {
  id: root
  required property var fracs
  required property var label
  property var barcolor: "#FFFFFF"


  property var oh: 16
  property var ih: 10
  property var cw: 5
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

  property var fracsa: JSON.parse(fracs || [])

  // bar
  Repeater {
    model: fracsa.length


    Item {
      height: ih
      width: cw

      Rectangle {
        property var ch: ((ih - 1) * fracsa[index]) + 1
        width: parent.width
        height: ch
        anchors.bottom: parent.bottom
        color: "#FFF"
      }
    }

    // ColumnLayout {
    //   function foo(x) {
    //     console.log(x)
    //     return x
    //   }
    //
    //   property var ch_1: ((ih - 1) * fracsa[index])
    //   property var ch: foo(Math.floor(parseInt(ch_1)) + 1)
    //
    //   spacing: 0
    //   Item {
    //     width: cw
    //     height: (oh - ih) / 2
    //   }
    //   Item {
    //     width: cw
    //     height: (ih - ch)
    //   }
    //   Rectangle {
    //     width: cw
    //     height: ch
    //     color: barcolor
    //   }
    //   Item {
    //     width: cw
    //     height: (oh - ih) / 2
    //   }
    // }
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

