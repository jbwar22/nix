import Quickshell
import Quickshell.Io
import QtQuick
import Quickshell.Services.UPower

Scope {
  id: root
  property var battery: UPower.devices.values.filter(x => x.isLaptopBattery)[0]
  property string frac: battery.energy / battery.energyCapacity
  property string barcolor: battery.timeToEmpty == 0 ? "#0F0" : (frac < 0.2 ? "#F00" : "#FFF")
}

