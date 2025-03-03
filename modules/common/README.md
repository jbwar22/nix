# Common Modules

These modules are imported by both nixos and home-manager. On independent home-manager hosts, the
home-manager user/host specific module (modules/home/users/username/hostname) must import/set them.
On nixos hosts, the host specific module (modules/nixos/host/hostname) must import/set them, and
they are automatically passed along to home-manager.

These points represent the philosophy behind this (opt/hardware as an example)
- A user on any system is aware of the hardware on that system
- A user on a nixos system shouldn't have to re-define hardware that the host knows

