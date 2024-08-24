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

# NeoVim

On Linux install `sudo` and `git` then run `./cli.sh`, which takes care of the
rest. Some distros also need you to install `which`, `xz`, and `bash`.

On Windows install the applications below and clone the configuration repository.

- [Git](https://git-scm.com/downloads)
- [Microsoft Visual C++ Redistributable](https://learn.microsoft.com/en-us/cpp/windows/latest-supported-vc-redist)
- A C compiler like [Zig](https://ziglang.org/download/) Add to the path manually
- [NeoVim](https://github.com/neovim/neovim/releases) Add to the path manually
- [fd](https://github.com/sharkdp/fd/releases) Add to the path manually
- [ripgrep](https://github.com/BurntSushi/ripgrep/releases) Add to the path manually

```sh
# win cmd
git clone https://github.com/djboni/kickstart.nvim %LocalAppData%/nvim
```

## Issues with NeoVim

- zls: failed to install, etc
  - Some tools installation depend on python3/pip or node/npm installed
- pyright: failed to install, zls: failed to install, etc
  - Some tools installation depend on node/npm installed
- clangd: failed to install, stylus: failed to install, etc
  - Open `nvim` and check the command `:checkhealth`.
- nvim: /lib64/libm.so.6: version `GLIBC_2.29' not found (required by nvim)
  - NeoVim v0.10.0+ needs glibc 2.29+
  - For older distros install NeoVim v0.9.5
