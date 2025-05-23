# GamesFlow Emulator - GIANT Core Plugins Guide

Welcome to the **Core Plugins Guide** for GamesFlow Emulator!  
This document details all official and essential plugins shipped with the emulator, their features, configuration, architecture, extension points, and how to create or extend core plugins.  
GamesFlow’s plugin architecture is designed for extensibility, modularity, and cross-platform compatibility—making it easy to add new features, device support, enhancements, and third-party integrations.

---

## Table of Contents

1. [Introduction](#introduction)
2. [What are Core Plugins?](#what-are-core-plugins)
3. [Plugin Architecture Overview](#plugin-architecture-overview)
4. [Core Plugin Directory Structure](#core-plugin-directory-structure)
5. [List of Core Plugins](#list-of-core-plugins)
    - [Video Filters](#video-filters)
    - [Audio Effects](#audio-effects)
    - [Netplay](#netplay)
    - [Input & Controller](#input--controller)
    - [Cheat Engine](#cheat-engine)
    - [Achievements](#achievements)
    - [Localization](#localization)
    - [Accessibility](#accessibility)
    - [Scripting](#scripting)
    - [ROM Manager Extensions](#rom-manager-extensions)
    - [Profiler & Telemetry](#profiler--telemetry)
    - [Updater](#updater)
    - [Crash Reporter](#crash-reporter)
6. [Plugin Management](#plugin-management)
7. [Plugin Configuration & Customization](#plugin-configuration--customization)
8. [Developing Custom Core Plugins](#developing-custom-core-plugins)
9. [Security & Sandboxing](#security--sandboxing)
10. [Plugin API Reference](#plugin-api-reference)
11. [Plugin Troubleshooting](#plugin-troubleshooting)
12. [Core Plugin Roadmap](#core-plugin-roadmap)
13. [References](#references)

---

## Introduction

Plugins are at the heart of GamesFlow’s flexibility.  
Core plugins are officially maintained, deeply integrated modules that provide essential, advanced, and platform-specific functionality.  
This guide covers their purpose, capabilities, configuration, extension points, and how to build or extend them.

---

## What are Core Plugins?

- **Definition:**  
  Core plugins are key, first-party modules providing video, audio, input, netplay, cheats, achievements, accessibility, localization, scripting, and more.
- **Purpose:**  
  - Encapsulate features that benefit from modularity (e.g. video filters, audio effects, netplay protocols)
  - Enable/disable functionality per user/system/game/platform
  - Serve as extension points for community/third-party plugins
  - Allow for hot-swapping/updating without rebuilding the emulator

---

## Plugin Architecture Overview

- **Language:** C# (primary), with scripting bindings (PowerShell, Python, Lua)
- **Loading:** Dynamic discovery at runtime (DLLs, scripts, config manifests)
- **Isolation:** Sandboxed, permissioned APIs, optional process isolation
- **Extension Points:** Video, audio, input, netplay, scripting, achievements, asset management, UI overlays, localization, accessibility
- **Interoperability:** Plugins communicate via the core event bus, plugin registry, and service locator
- **Hot-Reload:** Update plugins without restarting emulator (where safe)

---

## Core Plugin Directory Structure

```
Plugins/
  VideoFilters/
    CRT.dll
    Scanline.dll
    xBRZ.dll
    HQ2X.dll
    Custom/
  AudioEffects/
    Reverb.dll
    Echo.dll
    Equalizer.dll
    Surround.dll
    Custom/
  Netplay/
    Rollback.dll
    P2P.dll
    Lobby.dll
    Spectator.dll
    Custom/
  Input/
    Accessibility.dll
    DancePad.dll
    TouchOverlay.dll
    Custom/
  CheatEngine/
    GameGenie.dll
    ActionReplay.dll
    GameShark.dll
    Scripting/
  Achievements/
    RetroAchievements.dll
    Custom/
  Localization/
    en-US.dll
    fr-FR.dll
    es-ES.dll
    zh-CN.dll
    Custom/
  Accessibility/
    ScreenReader.dll
    HighContrast.dll
    Colorblind.dll
    Haptics.dll
    VoiceCommands.dll
    Custom/
  Scripting/
    LuaEngine.dll
    PowerShellEngine.dll
    PythonEngine.dll
  Profiler/
    PerfGraph.dll
    Bottleneck.dll
  Updater/
    PluginUpdater.dll
  CrashReporter/
    CrashReporter.dll
```

---

## List of Core Plugins

### Video Filters

- **CRT Filter:** Emulates CRT scanlines, curvature, phosphor glow
- **Scanline:** Adds horizontal scanlines for retro feel
- **xBRZ/HQ2X:** Pixel upscaling for smooth or sharp edges
- **Bloom/Glow:** Simulate screen bloom or soft glow
- **Custom Shaders:** User-definable GLSL/HLSL/SkiaSharp shader pipelines

**Key Features:**
- Toggle per-game/system
- Configurable shader parameters via GUI/CLI
- Hot-reload and stackable filter chains

---

### Audio Effects

- **Reverb:** Simulate room ambiance
- **Echo:** Adds echo/repeat effects
- **Equalizer:** Adjustable frequency bands
- **Surround:** Virtual surround sound
- **Custom DSP:** For advanced chip emulation or sound shaping

**Key Features:**
- Configurable per-game/system
- Toggle/stack multiple effects
- Minimal latency, optimized for real-time

---

### Netplay

- **Rollback:** Robust, low-latency netplay with rollback for fighting/racing games
- **P2P:** Peer-to-peer network play
- **Lobby:** Centralized match-making, chat, and session management
- **Spectator:** Allow users to watch live games

**Key Features:**
- NAT traversal, bandwidth control
- In-game chat overlays
- Save sync, host migration, cloud backup

---

### Input & Controller

- **Accessibility:** Remapping, macros, on-screen overlays, one-handed mode
- **DancePad:** Support for rhythm game mats/pads
- **TouchOverlay:** Mobile/Tablet/Touch controls, custom layouts
- **Controller Adapters:** Exotic hardware (e.g., Guitar Hero, light guns, flight sticks)
- **Hotkey Manager:** Map actions to keys/buttons, macros

---

### Cheat Engine

- **Game Genie, Action Replay, GameShark:** Code parsing, patching, hotkey support
- **Scripting Cheats:** Lua, PowerShell, Python for dynamic cheats
- **RAM Watch/Search:** Find RAM values, auto-generate codes
- **Cheat Presets:** Organize by group, hotkey, or game event

---

### Achievements

- **RetroAchievements Integration:** Unlock badges, sync progress online
- **Custom Achievements:** Community/user-definable, mod support
- **In-game Notifications:** Popups, badges, overlays, sound cues

---

### Localization

- **Language Packs:** UI, help, cheat descriptions, themes
- **Live Switching:** Change language at runtime
- **Community Translations:** Pull from crowd-sourced databases

---

### Accessibility

- **Screen Reader:** Narrate UI and gameplay events
- **High Contrast:** Enhanced color schemes for visibility
- **Colorblind Modes:** Protanopia, deuteranopia, tritanopia
- **Haptics:** Vibration feedback for events
- **Voice Commands:** Voice-activated emulator controls

---

### Scripting

- **Lua Engine:** Bindings for emulator state, memory, input, video, and audio
- **PowerShell Engine:** Automate emulator tasks, batch operations, cheat activation
- **Python Engine:** Advanced scripting, machine learning, data analysis

---

### ROM Manager Extensions

- **Auto-Scraper:** Fetch metadata, screenshots, compatibility info
- **Patch Manager:** Apply IPS/UPS/BPS patches
- **ROM Renamer:** Batch rename to match DB standards

---

### Profiler & Telemetry

- **PerfGraph:** Real-time CPU/GPU/memory stats, frame timing, bottleneck detection
- **Session Logger:** Save performance logs for analysis

---

### Updater

- **PluginUpdater:** Check for and apply plugin/core updates
- **Self-Update:** Support for core plugin hot-swap and rollback

---

### Crash Reporter

- **CrashReporter:** Auto-capture logs, state, and stack traces
- **Opt-in telemetry:** Privacy-respecting, user-controlled

---

## Plugin Management

- **Enable/disable plugins** via GUI, CLI, or config file
- **Plugin browser**: View, search, and update plugins
- **Auto-update**: Check for new versions and update in-place
- **Dependency management:** Plugins can require/suggest others

---

## Plugin Configuration & Customization

- **Config files** per plugin: `Plugins/<PluginName>/config.yaml`
- **GUI/CLI options** for tuning parameters
- **Hotkeys, overlays, and per-game settings** supported
- **Global and per-system/plugin defaults**

---

## Developing Custom Core Plugins

1. **Start from the plugin template** in `Docs/PluginTemplate/` or use the `pwsh Scripts/new-plugin.ps1` script.
2. **Implement required interfaces** (`ICorePlugin`, `IPluginExtensionPoint`, etc.).
3. **Describe metadata** in `plugin.json` (name, author, version, permissions).
4. **Register extension points** (event bus, input hooks, video/audio pipelines).
5. **Write config and UI integration** as needed.
6. **Test with emulator and submit PR or distribute!**

See `Docs/PluginDevelopment.md` for more.

---

## Security & Sandboxing

- Plugins run in isolated domains with permissioned APIs.
- Core plugins reviewed for security, stability, and privacy.
- Process isolation for risky plugins (optional).
- Plugins must declare permissions (e.g., filesystem, network).
- Signed plugins preferred; unsigned require user approval.
- All network plugins require explicit opt-in.

---

## Plugin API Reference

**Core Interfaces:**
- `ICorePlugin`
- `IVideoFilterPlugin`
- `IAudioEffectPlugin`
- `INetplayPlugin`
- `IInputPlugin`
- `ICheatEnginePlugin`
- `IAchievementPlugin`
- `ILocalizationPlugin`
- `IAccessibilityPlugin`
- `IScriptingPlugin`
- `IRomManagerExtensionPlugin`
- `IProfilerPlugin`
- `IUpdaterPlugin`
- `ICrashReporterPlugin`

**Event Bus:**
- Plugins can subscribe/publish to emulator events (frame, state change, input, network, etc.)

**Config API:**
- Read/write plugin-specific or global settings

**UI API:**
- Inject overlays, dialogs, settings panels

See `Docs/PluginAPI.md` for in-depth usage.

---

## Plugin Troubleshooting

- **Plugin fails to load:** Check for missing dependencies, permission issues, or API version mismatch.
- **Crashes/Instability:** Disable third-party plugins, check logs in `Logs/`.
- **Performance Drop:** Profile with Profiler plugin, disable heavy filters/effects.
- **Conflicting Plugins:** Use dependency manager to resolve or disable as needed.
- **Update Issues:** Use PluginUpdater to refresh to latest versions.

---

## Core Plugin Roadmap

- **Upcoming:** AI-powered video filters, real-time translation, cloud-based netplay relay, machine learning input remapping, voice recognition, community plugin marketplace, WASM plugin sandboxing, hot-swap scripting, live plugin debugging.
- **Community Suggestions:** Open plugin RFCs in [Discussions](https://github.com/sugarypumpkin822/gamesflow-emulator-/discussions).

---

## References

- [Plugin API Docs](https://github.com/sugarypumpkin822/gamesflow-emulator-/wiki/Plugins)
- [Plugin Development Guide](Docs/PluginDevelopment.md)
- [C# Plugin Patterns](https://docs.microsoft.com/en-us/dotnet/standard/assembly)
- [GamesFlow Discord](https://discord.gg/YSu8YPa8Bb)
- [.NET Assembly Loading](https://learn.microsoft.com/en-us/dotnet/standard/assembly/assembly-loading)
- [Open Source Emulator Plugins](https://github.com/topics/emulator-plugin)
- [Plugin Security](https://owasp.org/www-community/attacks/Plugin-Security)

---

*Contributions and ideas for new plugins are always welcome! PRs for new core or extension plugins can be proposed through the standard workflow described in [Contributors.md](Contributors.md).*
