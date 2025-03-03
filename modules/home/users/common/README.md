# COMMON USER HOME MANAGER OPTIONS

Options that are enabled for all users regardless of host.

For home-manager only hosts, there is a folder labeled for that host within this folder. Note that
it is a deliberate choice that nixos hosts do not have folders in here. This limitation is due to
the nature of what should be included in these host files. Any options set in a non-nixos host
module within this folder should be set by a given host or the common host on a nixos system. For
example, the number of CPU cores for a specific host should be set here, but normally a host would
configure that and pass it to home-manager via common opts.

TODO Note to self: investigate custom.home.opts.hardware.nvidia. Maybe that should be a common opt?
Maybe everything that needs to get set on this side should be a common opt?
