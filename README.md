# Hyprland Dotfiles — Minimalist & Performance‑First 🚀

A clean, fast, and keyboard‑driven Linux setup built around **Hyprland** on **Arch Linux**. These dotfiles are designed for users who want a minimal system with a cohesive aesthetic and excellent performance.

The configuration focuses on:

* Speed
* Minimal resource usage
* Consistent Catppuccin Mocha / OLED theme
* Wayland‑native applications
* Keyboard‑centric workflow

---

# ✨ Features

## ⚡ Performance‑Focused

Animations and blur are disabled to keep the system extremely responsive and lightweight.

## 🎨 Unified Theme

A consistent **Catppuccin Mocha / OLED palette** is applied across the system:

* Foot terminal
* Rofi launcher
* Mako notifications
* Zed editor

## 🖥 Terminal

**Foot** terminal configured with **JetBrainsMono Nerd Font** for a clean developer‑friendly experience.

## 📝 Code Editor

**Zed** editor with:

* Custom OLED theme
* Built‑in Code Runner
* Ready for C++, Python, and JavaScript

## 🔋 Smart Power Management

Automatic power‑profile switching depending on whether the device is **charging or on battery**.

---

# 📦 Required Packages

Install required packages using **pacman** and **yay** (for AUR packages).

```bash
ani-cli-git
base
base-devel
bash-completion
bluetui
bluez
bluez-utils
brightnessctl
cliphist
dhcpcd
efibootmgr
fastfetch
foot
git
grim
gst-plugin-pipewire
helium-browser-bin
hyprland
impala
imv
intel-media-driver
intel-ucode
iwd
libpulse
linux
linux-firmware
mako
mpv
nano
ncdu
pipewire
pipewire-alsa
pipewire-jack
pipewire-pulse
power-profiles-daemon
python-gobject
rofi
slurp
sof-firmware
sudo
swaybg
thunar
ttf-jetbrains-mono-nerd
wireplumber
wpa_supplicant
xdg-utils
yay-bin
zed
zram-generator
```

---

# 🚀 Getting Started

## 1️⃣ Wallpaper Setup

Create a symlink so scripts can always find your wallpaper.

```bash
ln -sf ~path/to/wallpaper_folder/random_wallpaper.jpg/png ~/.config/hypr/current_wallpaper
```

---

## 2️⃣ Wayland Environment Variables

Add these to your environment for better Wayland compatibility.

```bash
ELECTRON_OZONE_PLATFORM_HINT=wayland
GDK_BACKEND=wayland
```

---

# ⌨️ Keybindings

Essential shortcuts for navigating the system.

| Action                   | Keybinding        |
| ------------------------ | ----------------- |
| Open Terminal            | SUPER + RETURN    |
| Open Browser (Helium)    | SUPER + B         |
| Open App Launcher        | SUPER + SPACE     |
| Open Code Editor         | SUPER + Z         |
| Close Window             | SUPER + W         |
| Clipboard History        | SUPER + V         |
| Screenshot (Select Area) | SUPER + SHIFT + S |
| Power Menu               | SUPER + ESCAPE    |

---

# 🧠 Workflow Philosophy

This setup follows a few simple principles:

* Everything should be **keyboard accessible**.
* The system should remain **minimal and distraction‑free**.
* Applications should be **Wayland‑native whenever possible**.
* Visual consistency matters.

---

# 🤝 Contributing

Feel free to open issues or submit pull requests if you have improvements or ideas.

---

# 📜 License

MIT License
