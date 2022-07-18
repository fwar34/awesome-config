# Dotfiles
Awesome wm dotfiles

|Gruvbox|Nord|
|------|------|
|![](https://i.imgur.com/CjwqHwr.png)|![](https://i.imgur.com/KgH0D21.png)|

## Archlinux

### yay
```bash
$ sudo pacman -S base-devel git
$ git clone https://aur.archlinux.org/yay.git ~/Downloads/yay
$ cd ~/Downloads/yay
$ makepkg -sir
```
### window manager
```bash
$ yay -S awesome-git --removemake --noconfirm
```
### picom
```bash
$ git clone -b feat-animation-exclude https://github.com/yaocccc/picom.git ~/Downloads/picom
$ cd ~/Downloads/picom
$ git submodule update --init --recursive
$ meson --buildtype=release . build
$ ninja -C build
$ sudo ninja -C build install
```
### Laptop
```bash
$ sudo pacman -S acpi acpid acpi_call brightnessctl upower
```
### Network
```bash
$ sudo pacman -S nm-connection-editor networkmanager network-manager-applet bluez-utils bluez blueman
```
### Media
```bash
$ sudo pacman -S ffmpeg mpv mpd mpc python-mutagen ncmpcpp playerctl
$ yay -S mpdris2 --noconfirm --removemake
```
### packages
```bash
$ yay -S i3lock-color caffeine-ng lxappearance-gtk3 --noconfirm --removemake
$ sudo pacman -S alacritty flameshot papirus-icon-theme redshift rofi nemo
$ sudo pacman -S gnome-system-monitor xfce4-power-manager polkit-gnome gnome-keyring
```
### Pipewire
```bash
$ sudo pacman -S pipewire pipewire-pulse pipewire-alsa pipewire-jack pipewire-zeroconf
```
### Systemd
```bash
$ sudo systemctl enable mpd
$ sudo systemctl enable --now bluetooth
$ sudo systemctl enable --now NetworkManager
```
### install config
```bash
$ git clone --recurse-submodules https://github.com/sachnr/dotfiles.git ~/.config/awesome
$ cd ~/.config/awesome
$ git submodule update --remote --merge
$ cp -r ~/.config/awesome/misc/fonts/ ~/.local/share/
$ cp -r ~/.config/awesome/misc/themes/gtk/themes/ ~/.local/share/
$ cp -r ~/.config/awesome/misc/themes/kde/color-schemes/ ~/.local/share/
$ fc-cache -rv
```


