# GamesFlow Emulator - Massive Usage Guide

Welcome to the **GamesFlow Emulator Usage Guide**!  
This guide is your complete reference for running, configuring, and mastering GamesFlow Emulator across all supported platforms (Windows, macOS, Linux, Android, iOS, Web, VR).  
It covers everything from first launch to advanced automation, scripting, troubleshooting, and community features.

---

## Table of Contents

1. [Getting Started](#getting-started)
2. [Installation & Setup](#installation--setup)
3. [Running GamesFlow](#running-gamesflow)
4. [Adding & Managing ROMs](#adding--managing-roms)
5. [BIOS Management](#bios-management)
6. [Frontend Options](#frontend-options)
7. [Input & Controller Setup](#input--controller-setup)
8. [Audio & Video Configuration](#audio--video-configuration)
9. [Save States & Memory Cards](#save-states--memory-cards)
10. [Cheats & Codes](#cheats--codes)
11. [Netplay & Online Features](#netplay--online-features)
12. [Cloud Sync & Cross-Device Play](#cloud-sync--cross-device-play)
13. [Plugins & Extensions](#plugins--extensions)
14. [Themes, Skins & Localization](#themes-skins--localization)
15. [Accessibility Features](#accessibility-features)
16. [Scripting & Automation](#scripting--automation)
17. [Advanced Usage](#advanced-usage)
18. [Troubleshooting & FAQ](#troubleshooting--faq)
19. [Community & Support](#community--support)

---

## Getting Started

1. **Download** the latest release for your platform from [GitHub Releases](https://github.com/sugarypumpkin822/gamesflow-emulator-/releases).
2. **Extract** the archive to your preferred directory.
3. **(Optional) Install Dependencies:** On Linux/macOS, ensure .NET 8+ is installed.
4. **Run the Emulator:**  
   - On Windows: Double-click `GamesFlowEmulator.exe`
   - On Linux/macOS: Run `./GamesFlowEmulator`
   - On Android/iOS: Install the APK/IPA or sideload as described in Mobile.md
   - On Web: Go to [GamesFlow Web](https://gamesflow-web.example.com)

---

## Installation & Setup

### Windows

- **Portable Mode:** Extract anywhere, configs are stored locally.
- **Installer Mode:** Use the provided installer for Start Menu integration.
- **Dependencies:** .NET 8+ (bundled or auto-installed).

### macOS

- **App Bundle:** Drag-and-drop into Applications.
- **Gatekeeper:** Right-click and select ‘Open’ if prompted.
- **Dependencies:** .NET 8+ (brew install dotnet-sdk if needed).

### Linux

- **AppImage:** `chmod +x GamesFlowEmulator.AppImage && ./GamesFlowEmulator.AppImage`
- **Flatpak:** `flatpak install flathub com.gamesflow.Emulator`
- **Manual:** `dotnet run` in source directory.

### Android/iOS

- **Android:** Sideload APK or install via Play Store (if available).
- **iOS:** TestFlight or sideload using AltStore.

### Web

- Go to [GamesFlow Web](https://gamesflow-web.example.com) and load ROMs via drag-and-drop.

---

## Running GamesFlow

### Command Line Usage

```bash
GamesFlowEmulator.exe [options] [romfile]
```
**Common options:**
- `--config <path>`: Use a specific config file.
- `--portable`: Run in portable mode.
- `--fullscreen`: Start in fullscreen.
- `--system <name>`: Force system detection.
- `--bios <path>`: Override BIOS path.
- `--netplay host|join <ip>`: Launch netplay session.
- `--help`: Show all options.

### Example:

```bash
GamesFlowEmulator.exe --fullscreen --config "./mycustom.yaml" "ROMs/SuperMarioWorld.sfc"
```

---

## Adding & Managing ROMs

1. **ROM Directory:** Place ROMs in your preferred folder (`ROMs/` by default).
2. **Supported Formats:** `.nes`, `.sfc`, `.smc`, `.bin`, `.gb`, `.gba`, `.iso`, `.cue`, `.img`, `.zip`, `.7z`, etc.
3. **Importing ROMs:**
   - **GUI:** File > Open ROM or drag-and-drop into window.
   - **CLI:** Pass ROM path as argument.
   - **Web:** Drag-and-drop files onto the browser window.
4. **ROM Browser:** Use the built-in browser to organize, search, and launch games.
5. **ROM Metadata:** Auto-scraping of box art, game info, region, compatibility, etc.
6. **Multi-disc Games:** Use the "Swap Disc" option during gameplay.

---

## BIOS Management

- Some systems require BIOS files (e.g., PlayStation, Sega CD, NeoGeo).
- **BIOS Directory:** Set in config (`bios_path`, default: `Assets/Bios/`).
- **BIOS Naming:** Use accurate filenames (MD5/SHA1 matching recommended).
- **BIOS Checker:** Tools > BIOS Checker verifies presence and validity.
- **Community BIOS Packs:** See documentation for legal sources.

---

## Frontend Options

- **GUI:** (Avalonia, WPF, GTK, Qt)  
  - Multi-window, high-DPI, theming, overlays, drag-and-drop, controller navigation.
- **Web:**  
  - Browser-based, save states, multiplayer lobbies, PWA/offline support.
- **Mobile:**  
  - Touch overlays, haptics, orientation lock, notification integration.
- **CLI:**  
  - Headless mode, batch automation, scripting, netplay server.
- **VR:**  
  - 3D overlays, immersive environments, virtual screen, controller mapping.

**Switch between frontends** in settings or via the `--frontend` CLI flag.

---

## Input & Controller Setup

1. **Supported Devices:**  
   - Xbox, PlayStation, Switch Pro, generic gamepads, keyboard/mouse, arcade sticks, touch, motion, accessibility controllers.
2. **Auto-Detect:**  
   - Plug in and the emulator prompts for mapping.
3. **Input Mapping:**
   - GUI: Settings > Input > Configure
   - Remap buttons, analog, triggers, macros, turbo, motion.
   - Save multiple profiles (per-game/system/global).
4. **Accessibility:**  
   - One-handed mode, remappable overlays, on-screen controls.
5. **Hotkeys:**  
   - Save/load state, pause, reset, fast-forward, slow motion, screenshot, cheat activation.
6. **Exotic Hardware:**  
   - Plugins for dance pads, lightguns, steering wheels, VR controllers.

---

## Audio & Video Configuration

**Audio:**
- Change backend (DirectSound, WASAPI, ALSA, Pulse, CoreAudio)
- Adjust latency, buffer size, volume, balance, resampler
- Enable/disable DSP/audio plugins (reverb, equalizer, surround)

**Video:**
- Select renderer (OpenGL, Vulkan, DirectX, Metal, Software)
- Resolution, aspect ratio, scaling (integer, smooth, sharp)
- Enable shaders/filters (CRT, scanlines, xBRZ, HQ2X, bloom)
- Fullscreen/windowed, multi-monitor, overlays
- Adjust brightness, contrast, color, frame blending, vsync
- Show/hide FPS, frame advance, screen capture/recording

---

## Save States & Memory Cards

- **Manual Save/Load:**  
  - GUI: Save/Load State buttons or hotkeys (default: F5/F8)
  - CLI: `savestate save/load <slot>`
- **Auto-Save:**  
  - Enable in config or GUI for automatic save on exit/load.
- **Slots:**  
  - Unlimited slots per game, visual previews, slot manager.
- **Cloud Sync:**  
  - Enable for automatic backup/restoration.
- **Memory Card Emulation:**  
  - For PlayStation, Saturn, etc., supports importing/exporting saves from real hardware and other emulators.

---

## Cheats & Codes

- **Add Cheats:**  
  - GUI: Cheats > Add, import from file, or use community packs.
  - CLI: `cheats add/import/list/enable/disable`
- **Supported Formats:**  
  - Game Genie, Action Replay, GameShark, CodeBreaker, GoldFinger, custom RAM codes, Lua/PowerShell/Python scripting.
- **Cheat Browser:**  
  - Search, group, hotkey, enable/disable, real-time toggling.
- **Cheat Search/RAM Watch:**  
  - Find addresses for new cheats, memory modification, pointer tracing.
- **Dynamic/Scripting Cheats:**  
  - Use scripts for conditional or event-driven cheats.

---

## Netplay & Online Features

- **Host/Join Sessions:**  
  - GUI: Netplay > Host/Join
  - CLI: `netplay host`, `netplay join <ip>`
- **Lobby System:**  
  - Multiplayer matchmaking, chat, friend invites.
- **Rollback Netcode:**  
  - Low-latency, auto sync, save state recovery.
- **Spectator Mode:**  
  - Watch live games, interact in chat.
- **Voice & Text Chat:**  
  - In-game overlays, Discord integration.
- **Cloud Save Sync:**  
  - Automatic save sharing and host migration.

---

## Cloud Sync & Cross-Device Play

- **Supported Providers:**  
  - Dropbox, Google Drive, OneDrive, custom (WebDAV, S3)
- **Sync Options:**  
  - Saves, configs, assets, screenshots, cheat packs.
- **Setup:**  
  - GUI: Cloud > Connect
  - CLI: `cloud connect <provider>`
- **Conflict Resolution:**  
  - Automatic or manual merge.

---

## Plugins & Extensions

- **Plugin Browser:**  
  - GUI: Plugins > Manage, install, update, remove
  - CLI: `plugins list/install/update/remove`
- **Core Plugins:**  
  - Video filters, audio effects, netplay, scripting, accessibility, localization, achievements, cheat engines
- **Community Plugins:**  
  - Download from Marketplace or GitHub.
- **Develop Your Own:**  
  - Follow PluginDevelopment.md, C# or scripting bindings available.

---

## Themes, Skins & Localization

- **Themes:**  
  - GUI: Appearance > Theme, or drop new themes in `Assets/Themes/`
- **Skins/Overlays:**  
  - Customize on-screen controls, bezels, backgrounds.
- **Localization:**  
  - 30+ languages, live switching, contribute via GitHub or translation portal.

---

## Accessibility Features

- **Screen Reader Support:**  
  - Narrates UI and gameplay events.
- **Colorblind Modes/High Contrast:**  
  - Toggle in Accessibility menu.
- **Font Scaling/Large UI:**  
  - Adjust in settings.
- **Voice Commands:**  
  - Enable and configure for core actions.
- **Haptic Feedback:**  
  - For compatible controllers.
- **Subtitle/Caption Overlays:**  
  - For in-game audio/dialogue.

---

## Scripting & Automation

- **Supported Languages:**  
  - Lua, PowerShell, Python, FLUX, Perl
- **Use Cases:**  
  - Cheat scripting, batch automation, asset management, testing, custom macros
- **Running Scripts:**  
  - GUI: Scripting > Run/New
  - CLI: `script run <scriptfile>`
- **API:**  
  - Access emulator state, memory, input, video, audio, UI, plugins

---

## Advanced Usage

- **Headless Mode:**  
  - Automated batch runs, server deployment, regression testing.
- **Profile/Benchmark:**  
  - Tools > Profiler or enable `--profiling`.
- **Debugging:**  
  - Advanced debugger, breakpoints, memory viewer, trace log.
- **Asset Extraction:**  
  - Extract sprites, music, overlays, BIOS, themes.
- **Custom Asset Packs:**  
  - Bundle and share mods, cheats, skins.

---

## Troubleshooting & FAQ

- **Logs:**  
  - Located in `Logs/`, configurable via Logging options.
- **Crash Reports & Telemetry:**  
  - Opt-in, privacy-respecting. Submit via GUI or Issues.
- **Common Problems:**  
  - See FAQ.md and Troubleshooting.md for solutions to the most common issues.
- **Community Support:**  
  - GitHub Issues, Wiki, Discord, Reddit.

---

## Community & Support

- **GitHub:** [https://github.com/sugarypumpkin822/gamesflow-emulator-](https://github.com/sugarypumpkin822/gamesflow-emulator-)
- **Wiki:** [Project Wiki](https://github.com/sugarypumpkin822/gamesflow-emulator-/wiki)
- **Discord:** [Join the Community](https://discord.gg/YSu8YPa8Bb)
- **Reddit:** [r/gamesflow](https://www.reddit.com/r/gamesflow)
- **Docs:**  
  - [FAQ.md](FAQ.md)
  - [ConfigOptions.md](ConfigOptions.md)
  - [Cheats.md](Cheats.md)
  - [CorePlugins.md](CorePlugins.md)
  - [Roadmap.md](Roadmap.md)
  - [Contributors.md](Contributors.md)
- **Contact:** gamesflow@protonmail.com

---

*This usage guide is always expanding! PRs for new tips, tutorials, or clarifications are welcome.*
