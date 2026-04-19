import Quickshell
import Quickshell.Services.Pipewire
import QtQuick


Item {
  id: root
  required property var screenSettings

  PwObjectTracker {
    objects: [ Pipewire.defaultAudioSink ]
  }

  Connections {
    target: Pipewire.defaultAudioSink?.audio
  }

  height: root.screenSettings.barHeight
  implicitWidth: twrap.implicitWidth

  MouseArea {
    acceptedButtons: Qt.LeftButton | Qt.RightButton
    anchors.fill: parent
    cursorShape: Qt.PointingHandCursor
    hoverEnabled: true
    onClicked: (e) => {
      if (e.button == Qt.RightButton) {
        if (Pipewire.defaultAudioSink) {
          Pipewire.defaultAudioSink.audio.muted = !Pipewire.defaultAudioSink.audio.muted
        }
      }
    }

    function changeVolume(num) {
      if (Pipewire.defaultAudioSink) {
        let vol = Math.round(Pipewire.defaultAudioSink.audio.volume * 100)
        vol += num
        vol = Math.max(0, Math.min(100, vol))
        Pipewire.defaultAudioSink.audio.volume = vol / 100
      }
    }

    onWheel: (e) => {
      if (e.angleDelta.y > 0) changeVolume(5)
      if (e.angleDelta.y < 0) changeVolume(-5)
    }
  }

  Item {
    id: twrap
    implicitHeight: text.implicitHeight
    implicitWidth: text.implicitWidth

    y: parent.height - height - root.screenSettings.baseline

    Text {
      id: text
      text: {
        let volume = '' + Math.round((Pipewire.defaultAudioSink?.audio.volume ?? 0) * 100)
        let muted = Pipewire.defaultAudioSink?.audio.muted
        if (muted) {
          volume = '-M'
        } else if (volume == '100') {
          volume = 'XX'
        } else if (volume.length == 1) {
          volume = '0' + volume
        }
        return "V" + volume
      }

      color: "#FFFFFF"
      font {
        pixelSize: root.screenSettings.fontSize
        family: "Noto Sans Mono"
      }
    }
  }
}
