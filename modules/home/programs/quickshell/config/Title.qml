import Quickshell
import Quickshell.Io
import QtQuick

Scope {
  id: root
  property string title

  Process {
    id: sway_title
    command: ["sh", "-c", "swaymsg -t get_tree | jq -r '.. | select(.focused? == true) | .name // empty'; swaymsg -t subscribe -m \"[\\\"window\\\",\\\"workspace\\\"]\" | jq 'select(.change == \"focus\" or .change == \"title\") | if has(\"container\") then (.container | select(.focused? == true) | .name) else \"\" end' -r --unbuffered"]
    running: true
    stdout: SplitParser {
      onRead: data => {
        root.title = data.trim()
      }
    }
  }
}

