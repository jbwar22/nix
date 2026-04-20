import Quickshell

Scope {
  required property var screen
  property var barHeight: screenSettings.barHeight
  property var fontSize: screenSettings.fontSize
  property var leftPadding: screenSettings.leftPadding
  property var wsWidth: screenSettings.wsWidth
  property var wsUnder: screenSettings.wsUnder
  property var baseline: screenSettings.baseline
  property var wbarHeight: screenSettings.wbarHeight
  property var wbarBase: screenSettings.wbarBase
  property var wgap: screenSettings.wgap
  property var wvwidth: screenSettings.wvwidth
  property var screenSettings: {
    if (
      screen.devicePixelRatio == 1
      && (
        (screen.width == 2560 && screen.height == 1440)
        || (screen.width == 1440 && screen.height == 2560)
      )
    ) {
      // 1440p
      return {
        barHeight: 29,
        fontSize: 15,
        leftPadding: 0,
        wsWidth: 24,
        wsUnder: 3,
        baseline: 5,
        wbarHeight: 12,
        wbarBase: 4,
        wgap: 12,
        wvwidth: 7,
      }
    } else if (
      screen.devicePixelRatio == 2
      && (
        (screen.width == 1440 && screen.height == 960)
        || (screen.width == 960 && screen.height == 1440)
      )
    ) {
      // framework laptop
      return {
        barHeight: 16,
        fontSize: 12,
        // leftPadding: ["NE135A1M-NY1"].includes(screen.model) ? 8 : 0,
        leftPadding: 8, // tmp
        wsWidth: 20,
        wsUnder: 2,
        baseline: 0,
        wbarHeight: 10,
        wbarBase: 3,
        wgap: 12,
        wvwidth: 5,
      }
    } else if (
      screen.devicePixelRatio == 1
      && (
        (screen.width == 1366 && screen.height == 768)
        || (screen.width == 768 && screen.height == 1366)
      )
    ) {
      // T480
      return {
        barHeight: 20,
        fontSize: 15,
        leftPadding: 0,
        wsWidth: 22,
        wsUnder: 2,
        baseline: 2,
        wbarHeight: 12,
        wbarBase: 3,
        wgap: 10,
        wvwidth: 5,
      }
    } else {
      // default (optimize for 1080p)
      return {
        barHeight: 20,
        fontSize: 13,
        leftPadding: 0,
        wsWidth: 22,
        wsUnder: 2,
        baseline: 1,
        wbarHeight: 10,
        wbarBase: 3,
        wgap: 10,
        wvwidth: 5,
      }
    }
  }
}
