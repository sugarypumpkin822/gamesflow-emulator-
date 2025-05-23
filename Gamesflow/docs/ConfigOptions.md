# GamesFlow Emulator - GIANT Configuration Options Guide

This document serves as the comprehensive, detailed, and authoritative reference for all configuration options available in the GamesFlow Emulator.  
It covers every aspect of setup, customization, optimization, and advanced tweaking, including global, per-system, per-user, and per-game settings.

---

## Table of Contents

1. [Introduction](#introduction)
2. [Configuration File Locations and Formats](#configuration-file-locations-and-formats)
3. [Global Configuration Structure](#global-configuration-structure)
4. [Core Options](#core-options)
5. [System & Device Options](#system--device-options)
6. [Frontend (UI) Options](#frontend-ui-options)
7. [Audio Options](#audio-options)
8. [Video & Graphics Options](#video--graphics-options)
9. [Input & Controller Options](#input--controller-options)
10. [Save State & Storage Options](#save-state--storage-options)
11. [Network & Netplay Options](#network--netplay-options)
12. [Cheat & Scripting Options](#cheat--scripting-options)
13. [Asset, Theme, & Localization Options](#asset-theme--localization-options)
14. [Accessibility Options](#accessibility-options)
15. [Performance & Advanced Tweaks](#performance--advanced-tweaks)
16. [Cloud & Online Options](#cloud--online-options)
17. [Logging & Diagnostics](#logging--diagnostics)
18. [Security & Privacy](#security--privacy)
19. [Configuration Examples (YAML, JSON, CLI)](#configuration-examples-yaml-json-cli)
20. [Troubleshooting Configuration](#troubleshooting-configuration)
21. [Extending & Modding the Config System](#extending--modding-the-config-system)
22. [FAQ](#faq)
23. [References](#references)

---

## Introduction

GamesFlow Emulator’s configuration system is designed for ultimate flexibility.  
You can configure nearly every aspect of emulation, UI, device behavior, and more at a global, per-system, per-user, or per-game level.  
Settings can be managed via GUI, CLI, direct file editing (YAML/JSON/TOML/XML), or even programmatically through plugins and scripts.

---

## Configuration File Locations and Formats

- **Global Config:**  
  - Windows: `%APPDATA%\GamesFlow\config.yaml`  
  - Linux: `~/.config/gamesflow/config.yaml`  
  - macOS: `~/Library/Application Support/GamesFlow/config.yaml`  
- **Per-User:**  
  - `Users/<username>/GamesFlow/config.yaml`  
- **Per-System:**  
  - `Configs/<system>.yaml` (e.g. `Configs/snes.yaml`)  
- **Per-Game:**  
  - `Configs/games/<gamehash>.yaml` or `<romdir>/<romname>.gamesflow.yaml`  
- **Portable Mode:**  
  - `./config.yaml` in emulator directory  
- **Supported Formats:**  
  - YAML (default), JSON, TOML, XML  
- **Auto-Detection:**  
  - The emulator auto-detects config files and merges them with proper priority (per-game > per-system > user > global > defaults).

---

## Global Configuration Structure

```yaml
core:
  language: "en-US"
  bios_path: "Assets/Bios/"
  autosave: true
  theme: "dark"
  logging_level: "info"
systems:
  nes:
    region: "NTSC"
    cpu_overclock: 1.0
  snes:
    video_mode: "NTSC"
    enhancement_chips: true
frontend:
  gui:
    scale: 1.5
    theme: "neon"
audio:
  volume: 80
  driver: "auto"
video:
  renderer: "OpenGL"
  vsync: true
input:
  controller_1: "Xbox360"
  hotkeys:
    save_state: "F5"
    load_state: "F8"
saves:
  auto_save_slot: true
  max_slots: 20
network:
  netplay_enabled: false
  server: "auto"
cheats:
  enabled: true
  auto_load: true
assets:
  shaders: "Assets/Shaders/"
  overlays: "Assets/Overlays/"
accessibility:
  screen_reader: false
  font_size: 16
performance:
  multithreading: true
  frame_skip: 0
cloud:
  sync_enabled: true
  provider: "dropbox"
privacy:
  telemetry: false
  crash_reports: true
```

---

## Core Options

- `language`: UI language/locale code (e.g., "en-US", "fr-FR")
- `bios_path`: Path to BIOS files
- `autosave`: Enable automatic save states
- `theme`: Default UI theme (e.g., "dark", "light", custom)
- `logging_level`: "debug", "info", "warn", "error", "fatal"
- `portable_mode`: true/false (store config locally)
- `default_rom_path`: Directory for opening ROMs

---

## System & Device Options

- **General:**
  - `region`: "NTSC", "PAL", "JP", "Auto"
  - `cpu_overclock`: 1.0 = normal, 2.0 = double speed, etc.
  - `gpu_enhancements`: true/false (extra layers, HD packs)
  - `ram_size`: override system RAM size
  - `bios_override`: path to custom BIOS
  - `video_mode`: "NTSC", "PAL", "Auto"
  - `audio_filter`: "off", "lowpass", "highpass"
  - `peripheral_support`: e.g., "Super Scope", "Barcode Reader"
  - `expansion_device`: e.g., "Sega CD", "32X", "Super FX"
- **Per-System Example:**
  ```yaml
  systems:
    snes:
      region: "NTSC"
      enhancement_chips: true
      cpu_overclock: 1.2
      video_mode: "NTSC"
      input_device: "SNES Controller"
    genesis:
      region: "PAL"
      expansion_device: "Sega CD"
      vdp_mode: "normal"
  ```

---

## Frontend (UI) Options

- `frontend.gui.scale`: UI scale factor (1.0 = 100%)
- `frontend.gui.theme`: Theme name (custom themes supported)
- `frontend.gui.overlay_opacity`: Overlay transparency (0-1)
- `frontend.web.pwa_enabled`: Enable Progressive Web App on browser
- `frontend.mobile.orientation`: "auto", "portrait", "landscape"
- `frontend.vr.environment`: "living_room", "theater", "arcade"
- `frontend.input.hud_enabled`: Show input display overlay
- `frontend.hotkeys`: Map emulator functions to keys/buttons

---

## Audio Options

- `audio.volume`: Master volume (0-100)
- `audio.driver`: "auto", "alsa", "pulse", "directsound", "coreaudio", "wasapi"
- `audio.latency`: Buffer size in ms (lower = less lag, more risk of stutter)
- `audio.resampler`: "sinc", "linear", "nearest", "cubic"
- `audio.mute_on_unfocus`: true/false
- `audio.enable_dsp`: Enable audio DSP plugins
- `audio.balance`: Stereo balance (-1.0 to 1.0)
- `audio.enhanced_chip_emulation`: true/false

---

## Video & Graphics Options

- `video.renderer`: "OpenGL", "Vulkan", "DirectX", "Metal", "Software"
- `video.vsync`: true/false
- `video.resolution`: "auto", "native", "4K", "1080p", custom WxH
- `video.aspect_ratio`: "auto", "4:3", "16:9", "1:1", "full"
- `video.scaling`: "integer", "smooth", "sharp"
- `video.shaders`: List of active shaders, order, parameters
- `video.scanlines`: true/false
- `video.crt_filter`: true/false
- `video.frame_blending`: true/false
- `video.fullscreen`: true/false
- `video.overlay`: Path to overlay image
- `video.fps_display`: true/false
- `video.brightness`, `video.contrast`, `video.saturation`: (0-100)
- `video.frame_skip`: Number of frames to skip (0 for none)
- `video.hardware_acceleration`: true/false

---

## Input & Controller Options

- `input.controller_1` through `input.controller_8`: Controller mapping (e.g., "Xbox", "PS4", "SNES", "Keyboard")
- `input.turbo_buttons`: Map for turbo (rapid fire) buttons
- `input.deadzone`: Analog stick deadzone (0-1)
- `input.rumble`: Enable controller vibration
- `input.hotkeys`: Assign shortcuts for save/load state, pause, fast forward, slow motion, screenshot, etc.
- `input.motion_support`: Enable motion controls (mobile/VR)
- `input.accessibility`: On-screen controls, remapping, macros
- `input.multi_device`: Allow multiple input devices simultaneously
- `input.touch_overlay`: Enable/disable/position touch overlays

---

## Save State & Storage Options

- `saves.auto_save_slot`: Enable automatic save states
- `saves.max_slots`: Maximum save state slots per game
- `saves.save_path`: Custom directory for saves
- `saves.compression`: "off", "lz4", "zstd"
- `saves.cloud_sync`: true/false
- `saves.save_on_exit`: true/false
- `saves.backup_copies`: Number of backup slots to keep

---

## Network & Netplay Options

- `network.netplay_enabled`: true/false
- `network.server`: "auto", IP/hostname
- `network.port`: Port number (default: 12345)
- `network.nat_traversal`: true/false
- `network.lobby_service`: "official", "custom", "direct"
- `network.rollback`: true/false (enable rollback netcode)
- `network.chat_overlay`: true/false
- `network.voice_chat`: true/false
- `network.spectator_mode`: true/false
- `network.sync_saves`: true/false
- `network.bandwidth_limit`: kB/s

---

## Cheat & Scripting Options

- `cheats.enabled`: true/false
- `cheats.auto_load`: true/false
- `cheats.directory`: Path to cheat files
- `cheats.master_code`: For GameShark/CodeBreaker
- `cheats.hotkeys`: Map cheats to hotkeys
- `cheats.scripting_enabled`: true/false
- `cheats.script_directory`: Path for Lua/PowerShell scripts
- `cheats.show_notifications`: true/false
- `cheats.cheat_database_url`: Remote/community database

---

## Asset, Theme, & Localization Options

- `assets.shaders`: Directory for shader files
- `assets.overlays`: Directory for overlays
- `assets.bios`: Directory for BIOS
- `assets.themes`: Directory for UI themes
- `assets.fonts`: Directory for fonts
- `assets.localization`: Directory for language packs
- `assets.auto_update`: true/false (download new assets/themes/cheats)
- `assets.custom_asset_paths`: List of additional search paths

---

## Accessibility Options

- `accessibility.screen_reader`: true/false
- `accessibility.font_size`: Integer px
- `accessibility.high_contrast`: true/false
- `accessibility.colorblind_mode`: "off", "protanopia", "deuteranopia", "tritanopia"
- `accessibility.haptic_feedback`: true/false
- `accessibility.large_ui`: true/false
- `accessibility.voice_commands`: true/false
- `accessibility.rtl_layout`: true/false (right-to-left support)
- `accessibility.subtitle_overlay`: true/false

---

## Performance & Advanced Tweaks

- `performance.multithreading`: true/false
- `performance.frame_skip`: Integer (0-5)
- `performance.jit_enabled`: true/false
- `performance.cpu_affinity`: List of CPU cores to use
- `performance.gpu_priority`: "auto", "high", "low"
- `performance.energy_saver`: true/false
- `performance.max_fps`: Integer (0 = unlimited)
- `performance.profiling_enabled`: true/false
- `performance.debug_overlays`: true/false
- `performance.low_latency_mode`: true/false
- `performance.simd_acceleration`: true/false

---

## Cloud & Online Options

- `cloud.sync_enabled`: true/false
- `cloud.provider`: "dropbox", "gdrive", "onedrive", "custom"
- `cloud.account`: User login/email
- `cloud.sync_games`: List of games to sync
- `cloud.sync_saves`: true/false
- `cloud.sync_settings`: true/false
- `cloud.auto_update`: true/false
- `cloud.max_bandwidth`: kB/s

---

## Logging & Diagnostics

- `logging.level`: "debug", "info", "warn", "error", "fatal"
- `logging.file`: Path to log file
- `logging.stdout`: true/false
- `logging.max_file_size`: MB
- `logging.rotation`: "daily", "weekly", "size"
- `logging.include_stacktrace`: true/false
- `diagnostics.crash_reporting`: true/false
- `diagnostics.telemetry`: true/false
- `diagnostics.profile_output`: Path for profiler dumps
- `diagnostics.diagnostic_overlays`: true/false

---

## Security & Privacy

- `privacy.telemetry`: true/false
- `privacy.crash_reports`: true/false
- `privacy.opt_out_ads`: true/false
- `privacy.secure_plugins_only`: true/false
- `security.plugin_sandboxing`: true/false
- `security.rom_hash_check`: true/false
- `security.asset_validation`: true/false
- `security.online_encryption`: true/false
- `security.block_unknown_networks`: true/false

---

## Configuration Examples (YAML, JSON, CLI)

### YAML (Recommended)
```yaml
core:
  language: "es-ES"
  autosave: true
  theme: "neon"
systems:
  genesis:
    region: "NTSC"
    cpu_overclock: 1.5
frontend:
  gui:
    scale: 2.0
audio:
  latency: 40
  resampler: "sinc"
video:
  renderer: "Vulkan"
  shaders:
    - "crt"
    - "scanlines"
input:
  controller_1: "PS4"
  turbo_buttons:
    A: true
    B: false
saves:
  auto_save_slot: true
  max_slots: 15
network:
  netplay_enabled: true
  server: "gamesflow.community"
```

### JSON
```json
{
  "core": { "language": "fr-FR", "theme": "retro" },
  "systems": { "snes": { "region": "PAL", "cpu_overclock": 1.2 } },
  "frontend": { "gui": { "scale": 1.2 } },
  "audio": { "mute_on_unfocus": true },
  "video": { "renderer": "OpenGL", "fullscreen": true }
}
```

### CLI
```bash
gamesflow --config ./mycustom.yaml --video.renderer Vulkan --audio.latency 30 --cheats.enabled true
```

---

## Troubleshooting Configuration

- **Config changes not applying**: Restart emulator, or use “Reload Config” in GUI.
- **Wrong config file loaded**: Check config file paths and priority order.
- **Syntax errors**: Use YAML/JSON linters; check for tabs in YAML.
- **New options missing**: Update emulator to latest version.
- **Overrides not working**: Per-game > per-system > user > global > defaults.

---

## Extending & Modding the Config System

- Plugins can register new config sections and options.
- Custom config UIs can be created via the plugin API.
- Use scripts to auto-update or batch-edit settings.
- Advanced: Write config generators (PowerShell, FLUX, Python).

---

## FAQ

**Q: Can I have different settings for different games?**  
A: Yes, use per-game configs or the GUI’s “Game Profile” feature.

**Q: How do I reset all configs to default?**  
A: Delete config files or use `gamesflow --reset-config`.

**Q: How do I share my config?**  
A: Export via GUI, or copy config file to another system.

**Q: Are there hidden/experimental options?**  
A: Yes, see `Docs/ExperimentalOptions.md` for developer/experimental settings.

---

## References

- [GamesFlow Docs](https://github.com/sugarypumpkin822/gamesflow-emulator-/wiki)
- [YAML Spec](https://yaml.org/spec/)
- [JSON Spec](https://www.json.org/json-en.html)
- [PowerShell Docs](https://docs.microsoft.com/powershell/)
- [Config Examples](https://github.com/sugarypumpkin822/gamesflow-emulator-/tree/main/Configs)
- [Community Forums](https://discord.gg/YOUR_INVITE)
- [Open Issues for Config](https://github.com/sugarypumpkin822/gamesflow-emulator-/issues?q=config)

---

*This document is a living resource. PRs for clarifications, new examples, and community best practices are welcome!*
