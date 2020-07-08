# An xmonad desktop for NixOS

Running xmonad on NixOS is not straightforward, at least, not for a NixOS newbie.

Here's a setup which works for me.

## Bootstrapping

Create a script `~/.xsession`, something like this:

```
#!/usr/bin/env sh

PATH=/path/to/nixos-xmonad-desktop/scripts:$PATH

case "$DESKTOP_SESSION" in
    xterm)
        exec xsession-helper xsession-start >$HOME/.xsession-errors 2>&1
        ;;
esac
```

Ensure the files and directories in `dotfiles` are symlinked into your home directory.

## System-wide configuration

You'll also need at least some basics in your `configuration.nix`

```
  networking.networkmanager.enable = true;

  services.xserver = {
    enable = true;

    displayManager = {
      gdm.enable = true;
    };

    desktopManager = {
      xterm.enable = true;
    };
  };

  # ensure the GNOME keyring daemon gets unlocked at login
  security.pam.services.gdm.enableGnomeKeyring = true;
```

It may be that my config also relies on

```
  services.xserver.desktopManager.gnome3.enable = true;
```

but I don't think so.
