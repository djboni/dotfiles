# My Dotfiles

This repository holds the configuration scripts that I use.

Feel free to check it out and use it.

You probably should not use them as they are:

- These scripts make irreversible changes to the system
- They may not be tested for your system and thinks ca break
- They are made for me

## Command Line Interface

For servers, containers, etc.

```sh
./cli.sh
```

## Graphical User Interface

For workstations.

```sh
./cli.sh
./gui.sh
```

# Issues with NeoVim

- clangd: failed to install, stylus: failed to install, etc.
  - Open `nvim` and check the command `:checkhealth`.
- nvim: /lib64/libm.so.6: version `GLIBC_2.29' not found (required by nvim)
  - NeoVim v0.10.0+ needs glibc 2.29+
  - For older distros install NeoVim v0.9.5
