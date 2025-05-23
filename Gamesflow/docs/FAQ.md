# GamesFlow Emulator - GIANT Frequently Asked Questions (FAQ)

Welcome to the **GamesFlow Emulator FAQ**!  
This document is your go-to resource for answers to the most common (and uncommon!) questions about GamesFlow Emulator—covering installation, setup, supported platforms, advanced features, troubleshooting, development, and more.

---

## Table of Contents

1. [General Information](#general-information)
2. [Installation & Setup](#installation--setup)
3. [Supported Platforms & Systems](#supported-platforms--systems)
4. [BIOS, ROMs & Legal Questions](#bios-roms--legal-questions)
5. [Frontend & User Interface](#frontend--user-interface)
6. [Controllers & Input](#controllers--input)
7. [Audio & Video](#audio--video)
8. [Saves, Save States & Memory Cards](#saves-save-states--memory-cards)
9. [Cheats & Codes](#cheats--codes)
10. [Netplay & Online Play](#netplay--online-play)
11. [Performance & Optimization](#performance--optimization)
12. [Plugins, Scripting, & Extensions](#plugins-scripting--extensions)
13. [Customization, Themes & Localization](#customization-themes--localization)
14. [Accessibility & Special Features](#accessibility--special-features)
15. [Troubleshooting & Error Messages](#troubleshooting--error-messages)
16. [Development, Building & Contribution](#development-building--contribution)
17. [Security & Privacy](#security--privacy)
18. [Cloud & Cross-Device Sync](#cloud--cross-device-sync)
19. [Advanced & Experimental Features](#advanced--experimental-features)
20. [Other Questions](#other-questions)
21. [Contact & Community](#contact--community)

---

## General Information

**Q1: What is GamesFlow Emulator?**  
A: GamesFlow Emulator is a modern, modular, multi-system emulator designed for compatibility with Windows (down to Windows 8), macOS, Linux, and all major phones (Android, iOS), as well as web/VR. It aims to emulate the widest range of systems with a focus on portability, customization, accessibility, and community-driven features.

**Q2: What languages is it written in?**  
A: Mostly C#, with PowerShell, FLUX, and some Perl for scripting, automation, and build tools.

**Q3: Is GamesFlow open source?**  
A: Yes! It’s released under an open-source license (see LICENSE file).

**Q4: Does it cost money?**  
A: No, GamesFlow Emulator is free and open source.

---

## Installation & Setup

**Q5: How do I install GamesFlow Emulator?**  
A: Download the latest release for your platform from the [GitHub Releases](https://github.com/sugarypumpkin822/gamesflow-emulator-/releases), or build from source (see BuildInstructions.md). Extract and run—no installation required for portable mode.

**Q6: What are the minimum requirements?**  
A:  
- Windows 8 or later (x64)
- macOS 10.15+ (Intel/Apple Silicon)
- Linux (recent distributions)
- Android 8.0+/iOS 13+
- .NET 8+ runtime (included or auto-installed)
- At least 2GB RAM (more recommended for advanced systems)

**Q7: How do I update GamesFlow?**  
A: Use the built-in updater, re-download from GitHub, or use your package manager if available.

**Q8: Can I run it as a portable app?**  
A: Yes! Place `config.yaml` in the emulator directory or use the `--portable` CLI flag.

---

## Supported Platforms & Systems

**Q9: Does GamesFlow run on my Mac/Linux/Android/iOS/Web/VR/etc.?**  
A: Yes! It supports Windows, macOS, Linux, Android, iOS, web (via WASM), and VR platforms.

**Q10: What systems/consoles are emulated?**  
A: Hundreds, including: NES, SNES, Genesis, Master System, Game Boy/GBC/GBA, PlayStation/PS2/PSP, N64, Saturn, Dreamcast, Neo Geo, TurboGrafx-16, Atari 2600/5200/7800/Jaguar/Lynx, MSX, Wonderswan, 3DO, DS, and many more (see Changelog.md).

**Q11: Is there a full list of supported systems and compatibility?**  
A: Yes! See [Docs/Compatibility.md](Docs/Compatibility.md) or the in-app system browser.

**Q12: Are arcade and handheld systems supported?**  
A: Yes, both classic arcade boards and handhelds are supported.

---

## BIOS, ROMs & Legal Questions

**Q13: Where do I put my BIOS files?**  
A: Place BIOS files in the directory set by `bios_path` in ConfigOptions.md (default: `Assets/Bios/`). Some systems require specific BIOS files for full compatibility.

**Q14: Does GamesFlow come with ROMs or BIOS?**  
A: No, for legal reasons you must provide your own BIOS/ROMs. Only open-source, homebrew, or public domain ROMs may be bundled.

**Q15: Where can I get ROMs?**  
A: Only use legal sources—homebrew, public domain, or your own legally dumped cartridges/discs.

**Q16: Why does my game not boot?**  
A: Check BIOS placement and filename, ROM integrity (use No-Intro/Redump sets), and compatibility.

---

## Frontend & User Interface

**Q17: What frontends are available?**  
A: GUI (Avalonia, WPF, GTK, Qt), CLI, Web (Blazor/WASM), Mobile (MAUI/Xamarin/Uno), VR.

**Q18: How do I change the theme?**  
A: Use the GUI’s Appearance settings or edit your config file (`theme:` option).

**Q19: Is dark mode supported?**  
A: Yes! Multiple themes, including dark, light, neon, retro, and custom.

**Q20: Can I use multiple windows or monitors?**  
A: Yes, multi-window and multi-monitor support is built in.

---

## Controllers & Input

**Q21: What controllers are supported?**  
A: Most USB/Bluetooth gamepads, Xbox, PlayStation, Switch Pro, generic HID, keyboard/mouse, arcade sticks, touch, motion, and more.

**Q22: How do I remap controls?**  
A: Use the GUI Input menu, the controller wizard, or edit the config directly.

**Q23: Can I use turbo, macros, or accessibility features?**  
A: Yes! Turbo buttons, macros, on-screen overlays, and accessibility mapping are supported.

**Q24: How do I connect dance pads, lightguns, or specialty hardware?**  
A: Through plugin adapters—see CorePlugins.md and Input documentation.

---

## Audio & Video

**Q25: Why is my audio crackling or delayed?**  
A: Adjust audio latency and driver settings in the configuration. Try a different audio backend.

**Q26: Can I use shaders, scanlines, or CRT filters?**  
A: Yes! Enable in Video Settings or via the Shader/Video Filter plugin.

**Q27: Can I play in 4K, ultrawide, or full-screen?**  
A: Yes, all major resolutions and aspect ratios are supported.

**Q28: How do I record or stream my gameplay?**  
A: Use the built-in recorder or connect to OBS/XSplit via plugin.

---

## Saves, Save States & Memory Cards

**Q29: Where are my saves located?**  
A: Default saves are in the `Saves/` folder or as specified in the config.

**Q30: How do I make/save/load/save states?**  
A: Use hotkeys (default: F5/F8), GUI buttons, or the CLI.

**Q31: Can I use real memory cards or import saves from other emulators?**  
A: Yes! Import/export and memory card emulation are supported.

**Q32: Is autosave supported?**  
A: Yes, with customizable slot management.

---

## Cheats & Codes

**Q33: What cheat formats are supported?**  
A: Game Genie, Pro Action Replay, GameShark, CodeBreaker, GoldFinger, Xploder, custom RAM codes, Lua scripts, and more.

**Q34: How do I add or manage cheats?**  
A: Use the GUI Cheats menu, CLI commands, or place cheat files in the Cheats directory.

**Q35: Can I use and share community cheat packs?**  
A: Yes! Download from the built-in updater or contribute your own.

**Q36: Can I write dynamic/scripting cheats?**  
A: Yes, via Lua, PowerShell, or Python scripting.

---

## Netplay & Online Play

**Q37: Does GamesFlow support online multiplayer?**  
A: Yes, via Netplay plugins—supports rollback, P2P, lobbies, spectators, chat, and even tournaments.

**Q38: How do I join or host a netplay session?**  
A: Use the Netplay menu or CLI (`netplay host` / `netplay join <IP>`).

**Q39: How do I set up port forwarding or NAT traversal?**  
A: GamesFlow supports auto-NAT traversal, but manual port forwarding may help with strict networks.

**Q40: Is my save data synced in netplay?**  
A: Yes, with save sync and host migration.

---

## Performance & Optimization

**Q41: How can I make the emulator run faster?**  
A: Lower video resolution, disable heavy shaders, ensure multithreading is on, close background apps, update drivers.

**Q42: What platforms are best for performance?**  
A: Windows, Linux, and macOS all perform well, but hardware matters most.

**Q43: Does GamesFlow support multi-core CPUs and GPUs?**  
A: Yes, full SMP/multithreading and hardware acceleration are supported.

**Q44: Why is my game running too fast or slow?**  
A: Check frame limiter, VSync, or frame skip settings.

---

## Plugins, Scripting, & Extensions

**Q45: What are plugins?**  
A: Modular add-ons for video filters, audio effects, netplay, scripting, achievements, accessibility, localization, and more.

**Q46: How do I install or update plugins?**  
A: Use the Plugin Manager in GUI or CLI, or copy plugin DLLs/scripts to the Plugins directory.

**Q47: How do I write my own plugins?**  
A: See CorePlugins.md and PluginDevelopment.md for templates and API docs.

**Q48: Can I use Lua, PowerShell, or Python scripts?**  
A: Yes! Full scripting engine support.

---

## Customization, Themes & Localization

**Q49: Can I customize the look of the emulator?**  
A: Yes! Skins, themes, overlays, color schemes, and even custom fonts are supported.

**Q50: How do I change languages?**  
A: Use the Language selector in GUI or set the `language` option in the config.

**Q51: Can I create my own themes?**  
A: Yes, see Asset and Theme documentation.

**Q52: How do I contribute a translation?**  
A: Submit language files in the Localization directory or via GitHub PR.

---

## Accessibility & Special Features

**Q53: Does GamesFlow offer accessibility features?**  
A: Yes—screen reader support, colorblind modes, large UI, remappable controls, subtitle overlays, voice commands, haptics, and more.

**Q54: Is there a high-contrast mode?**  
A: Yes, toggle in Accessibility settings.

**Q55: Can I use voice commands?**  
A: Yes, if enabled in accessibility options.

---

## Troubleshooting & Error Messages

**Q56: The emulator won’t start or crashes. What do I do?**  
A: Check logs in the Logs directory, update .NET, update drivers, or try a clean config. See Troubleshooting.md.

**Q57: My controller isn’t working.**  
A: Try re-binding, update drivers, check for OS/gamepad compatibility, or report an issue.

**Q58: Video/audio is stuttering or laggy.**  
A: Lower settings, update plugins, and check hardware requirements.

**Q59: Save states aren’t loading.**  
A: Make sure they’re from the same ROM/version and emulator version.

**Q60: I get “Missing BIOS” or “File Not Found” errors.**  
A: Verify correct BIOS files in the right directory and ROM integrity.

---

## Development, Building & Contribution

**Q61: How do I build GamesFlow from source?**  
A: See BuildInstructions.md. Install prerequisites (.NET 8+, git, etc.), clone repo, and run the build scripts.

**Q62: How do I contribute code, docs, cheats, or assets?**  
A: Fork the repo, make changes, and open a Pull Request! See Contributors.md and Contributing.md.

**Q63: What coding standards should I follow?**  
A: Use the provided .editorconfig and follow style guidelines in the docs.

**Q64: How can I add support for a new system or plugin?**  
A: See Architecture.md and PluginDevelopment.md for integration guides.

---

## Security & Privacy

**Q65: Does GamesFlow collect data or telemetry?**  
A: Telemetry and crash reporting are opt-in only and anonymized. See Privacy options in ConfigOptions.md.

**Q66: Are plugins sandboxed?**  
A: Yes, plugins are isolated and require declared permissions.

**Q67: Is network traffic encrypted?**  
A: Yes, for all netplay, cloud, and update functions.

---

## Cloud & Cross-Device Sync

**Q68: Does GamesFlow support cloud saves?**  
A: Yes! Sync with Dropbox, Google Drive, OneDrive, or custom providers.

**Q69: Can I sync my settings and saves across devices?**  
A: Yes—enable the option in your config or through the GUI.

---

## Advanced & Experimental Features

**Q70: What are experimental options?**  
A: Features in development—enable via CLI or ExperimentalOptions.md.

**Q71: Can I enable debugging/profiling or developer overlays?**  
A: Yes, via config or CLI (`--debug`, `--profiling`, etc.).

**Q72: How do I use the scripting engine for automation?**  
A: See the Scripting section in Cheats.md and CorePlugins.md.

---

## Other Questions

**Q73: Is there a mobile version?**  
A: Yes! Android and iOS versions are available.

**Q74: Can I run GamesFlow in a browser?**  
A: Yes, via WebAssembly (WASM) frontend.

**Q75: What’s the best way to report bugs or request features?**  
A: Open a GitHub Issue or start a Discussion.

**Q76: How can I support the project?**  
A: Contribute code, docs, cheats, themes, translations—or just spread the word!

---

## Contact & Community

- **GitHub Issues/Discussions:** [https://github.com/sugarypumpkin822/gamesflow-emulator-/issues](https://github.com/sugarypumpkin822/gamesflow-emulator-/issues)
- **Discord:** [Join the Community](https://discord.gg/YSu8YPa8Bb)
- **Reddit:** [r/gamesflow](https://www.reddit.com/r/gamesflow)
- **Wiki:** [Project Wiki](https://github.com/sugarypumpkin822/gamesflow-emulator-/wiki)
- **Email:** gamesflow@protonmail.com

---

*Is your question missing? Open an issue or PR to help grow this FAQ and help the next user!*
