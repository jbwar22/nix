# Reactive-by-home Modules
These modules describe options that should be enabled depending on the users that are on the system.
For example, a home-manager instance enabling swaylock should enable enable necessary system 
features required for it to work. Common reactive modules are enabled on all systems and should be
used for safe things, whereas other reactive modules can be enabled on a per-host level.

These points represent the philosophy behind this
- Any nixos system should be aware of its users and the settings set in their home-manager instances

