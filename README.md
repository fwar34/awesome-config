# Dotfiles
Awesome wm dotfiles

|Gruvbox|Nord|
|------|------|
|![](https://i.imgur.com/CjwqHwr.png)|![](https://i.imgur.com/KgH0D21.png)|

### **Aur(yay)**
```bash
$ sudo pacman -S base-devel git
$ git clone https://aur.archlinux.org/yay.git ~/Downloads/yay
$ cd ~/Downloads/yay
$ makepkg -sir
```
### **Window Manager**
```bash
$ yay -S awesome-git --noconfirm
```
### **Picom Fork**
```bash
$ git clone -b feat-animation-extra https://github.com/yaocccc/picom.git ~/Downloads/picom
$ cd ~/Downloads/picom
$ meson --buildtype=release . build
$ ninja -C build
$ sudo ninja -C build install
```
### **Network**
```bash
$ sudo pacman -S nm-connection-editor networkmanager network-manager-applet bluez-utils bluez blueman
```
### **Media**
```bash
$ sudo pacman -S ffmpeg mpv mpd mpc python-mutagen ncmpcpp playerctl
$ yay -S mpdris2 --noconfirm --removemake
```
### **Required**
```bash
$ yay -S i3lock-color lxappearance-gtk3 xidlehook-git --noconfirm
$ sudo pacman -S alacritty flameshot papirus-icon-theme redshift rofi jq
$ sudo pacman -S gnome-system-monitor polkit-gnome gnome-keyring qt5ct kvantum
```
### **File Manager**
```
# pacman -S dolphin dolphin-plugins
```
packages for generating thumbnails
```
# pacman -S kdegraphics-thumbnailers kimageformats qt5-imageformats kdesdk-thumbnailers ffmpegthumbs taglib
```
### **Audio**
```bash
$ sudo pacman -S pipewire pipewire-pulse pipewire-alsa pipewire-jack pipewire-zeroconf
```
### **Start Services**
```bash
$ sudo systemctl enable mpd
$ sudo systemctl enable --now bluetooth
$ sudo systemctl enable --now NetworkManager
```
### **Installation**
```bash
$ git clone --recurse-submodules https://github.com/sachnr/dotfiles.git ~/.config/awesome
$ mkdir -p ~/.config/rofi ~/.local/share
$ cp -r ~/.config/awesome/misc/fonts/ ~/.local/share/
$ cp -r ~/.config/awesome/misc/rofi/ ~/.local/share/
$ fc-cache -rv
```
### **THEMES**
|Theme|Gtk|Kvantum|
|------|------|------|
|**Nord:**|[link](https://www.gnome-look.org/p/1267246)|[link](https://www.gnome-look.org/p/1326272)|
|**Gruvbox:**|[link](https://www.gnome-look.org/p/1681313/)|[link](https://store.kde.org/p/1866041)|





