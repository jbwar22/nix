import Quickshell
import Quickshell.Io
import QtQuick

Scope {
  id: root
  property string title

  Process {
    id: sway_title
    command: ["sh", "-c", "swaymsg -t get_tree | jq -r '.. | select(.focused? == true) | .name // empty'; swaymsg -t subscribe -m \"[\\\"window\\\"]\" | jq 'select(.change == \"focus\" or .change == \"title\") | .container | select(.focused? == true) | .name' -r --unbuffered"]
    running: true
    stdout: SplitParser {
      onRead: data => {
        root.title = data.trim()
      }
    }
  }
}

