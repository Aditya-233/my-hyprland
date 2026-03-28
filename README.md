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

* Mocha theme
* Built‑in Code Runner
* Ready for C++, Python, and JavaScript

## 🔋 Smart Power Management

Automatic power‑profile switching depending on whether the device is **charging or on battery**.

---

# 📦 Required Packages

Install required packages using **pacman** and **yay** (for AUR packages).

```bash
base 3-3
base-devel 1-2
bash-completion 2.17.0-3
bluetui 0.8.1-2
bluez 5.86-4
bluez-utils 5.86-4
brightnessctl 0.5.1-3
cliphist 1:0.7.0-2
dhcpcd 10.3.1-1
efibootmgr 18-3
foot 1.26.1-1
fzf 0.70.0-1
git 2.53.0-1
grim 1.5.0-2
helium-browser-bin 0.10.7.1-1
hyprland 0.54.3-1
impala 0.7.4-1
imv 5.0.1-1
intel-media-driver 25.4.6-1
intel-ucode 20260227-1
iwd 3.12-1
linux 6.19.9.arch1-1
linux-firmware 20260309-1
mako 1.10.0-1
mpv 1:0.41.0-3
nano 8.7.1-1
pipewire 1:1.6.2-1
pipewire-alsa 1:1.6.2-1
pipewire-audio 1:1.6.2-1
pipewire-jack 1:1.6.2-1
pipewire-pulse 1:1.6.2-1
power-profiles-daemon 0.30-1
rofi 2.0.0-1
slurp 1.5.0-1
sof-firmware 2025.12.2-1
sudo 1.9.17.p2-2
swaybg 1.2.2-1
thunar 4.20.7-1
ttf-jetbrains-mono-nerd 3.4.0-2
ttf-liberation 2.1.5-2
wireplumber 0.5.13-2
wl-clipboard 1:2.3.0-1
wpa_supplicant 2:2.11-5
xdg-utils 1.2.1-2
yay-bin 12.5.7-1
zed 0.229.0-1
zram-generator 1.2.1-1
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
