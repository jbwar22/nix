mkselect: colorscheme: ''

* {
    border: none;
    border-radius: 0;
    font-family: monospace;
    min-height: 0;
}

#waybar {
    background: ${colorscheme.wm.background};
    color: ${colorscheme.wm.text};
}

${mkselect "bar768" ""} {
    font-size: 11px;
}

${mkselect "bar1440" ""} {
  font-size: 15px;
}

${mkselect "bar1080" ""} {
  font-size: 13px;
}

${mkselect "bar1920_2x" ""} {
  font-size: 12px;
}

/* all modules */
.modules-right > * > *, .modules-center > * > *, .modules-left > * > * {
    padding-left: 5px;
    padding-right: 5px;
}

/* bracket modules */
#battery > span, #memory > span, #cpu > span, #custom-extras > span {
  padding-bottom: 2px;
}


/* individual module config */
#workspaces { 
    padding-left: 0px;
}

#workspaces button {
    background: transparent;
    color: ${colorscheme.wm.text};
    border-bottom: 2px solid transparent;
    border-top: 1px solid transparent;
    transition-duration: 0s;
}

${mkselect "bar768" "#workspaces button"} {
    padding: 0px 2px;
}

${mkselect "bar1440" "#workspaces button"} {
    padding: 0px 4px;
}

${mkselect "bar1080" "#workspaces button"} {
    padding: 0px 3px;
}

${mkselect "bar1920_2x" "#workspaces button"} {
    padding: 0px 3px;
}

/* compensate for rounded screen */
${mkselect "bar1920_2x" "#workspaces button:first-child"} {
    padding-left: 8px;
}

#workspaces > button:hover {
    text-shadow: unset;
    box-shadow: unset;
    border-top-color: ${colorscheme.wm.foreground-normal};
    background: ${colorscheme.wm.bg-select-dim};
}

#workspaces > button.focused {
    background: ${colorscheme.wm.bg-select-normal};
    border-bottom-color: ${colorscheme.wm.foreground-normal};
}

#workspaces > button.focused:active {
    background: ${colorscheme.wm.bg-select-bright};
}

#workspaces > button.hover {
    border-top: none;
}

#workspaces > button.urgent {
    background: ${colorscheme.wm.bg-select-alert};
}



#mode {
    background: ${colorscheme.wm.bg-select-alt-normal};
    border-bottom: 3px solid ${colorscheme.wm.foreground-alt-normal};
}

#battery {

}

#battery.critical {
    color: #CC0000;
}

#battery.charging {
    background-color: #0B321B;
}

#batter.critical.charging {
    background-color: #0B321B;
}

@keyframes blink {
    to {
        color: #FFFFFF;
        background-color: #330000;
    }
}

#battery.critical:not(.charging) {
    color: #CC0000;
    background-color: #330000;
    animation-name: blink;
    animation-duration: 0.5s;
    animation-timing-function: linear;
    animation-iteration-count: infinite;
    animation-direction: alternate;
}

#window {
    margin-left: 10px;
    margin-right: 10px;
}

''
