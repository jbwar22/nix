import Quickshell
import Quickshell.Io
import QtQuick
import Quickshell.Services.UPower

Scope {
  id: root
  property var batteries: UPower.devices.values.filter(x => x.isLaptopBattery)
  property var fracs: batteries.map(battery => battery.percentage)
  property var barcolor: batteries.map(battery => battery.state == 1 ? "#0F0" : (battery.percentage < 0.2 ? "#F00" : "#FFF"))
}

