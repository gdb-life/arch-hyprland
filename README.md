# Hyprland Configuration and Installation

This repository contains configurations and installation scripts for setting up a Hyprland-based environment. It includes packages, configurations for various tools, and utilities to enhance the Hyprland desktop experience.

## Project Structure

- **modules**: Contains installation scripts and configuration files for Hyprland, Hyprlock, Hyprpaper, Waybar, and various other programs.
- **scripts**: Contains bash scripts to support installation of the modules.

## Installation

The `./intsall.sh` will install all the required packages for the Hyprland environment and its configs.

You can also install the modules individually by running the scripts in the `modules` directory.

!!! For another lib32 packages you need multilib repository, pleasy uncomment it in /etc/pacman.conf

When installing bradwarden, chose keepassppc
When installing sddm, chose noto-fonts
When installing phonon-qt6-backend, chose phonon-qt6-mpv
When installing qt6-multimedia-gstreamer, chose qt6-multimedia-ffmpeg

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
