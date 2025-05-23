# GamesFlow Emulator - Giant Build Instructions

---

## Table of Contents

1. [Introduction](#introduction)
2. [Prerequisites](#prerequisites)
   - [Operating Systems](#operating-systems)
   - [Required Software](#required-software)
   - [Optional Software and Tools](#optional-software-and-tools)
3. [Cloning the Repository](#cloning-the-repository)
4. [Directory Structure Overview](#directory-structure-overview)
5. [Environment Setup](#environment-setup)
   - [Cross-Platform Notes](#cross-platform-notes)
   - [Environment Variables](#environment-variables)
   - [Recommended Shell Configurations](#recommended-shell-configurations)
6. [Building from Source](#building-from-source)
   - [Standard Build (All Platforms)](#standard-build-all-platforms)
   - [Windows](#windows)
   - [macOS](#macos)
   - [Linux (Debian/Ubuntu/Fedora/Arch)](#linux-debianubuntufedoraarch)
   - [Mobile (Android/iOS)](#mobile-androidios)
   - [Web (WASM)](#web-wasm)
   - [VR](#vr)
7. [PowerShell & Scripting Tools](#powershell--scripting-tools)
8. [Custom Build Options](#custom-build-options)
   - [Enabling/Disabling Devices and Plugins](#enablingdisabling-devices-and-plugins)
   - [Feature Flags](#feature-flags)
   - [Build Profiles](#build-profiles)
9. [Running the Emulator](#running-the-emulator)
   - [Launching from CLI](#launching-from-cli)
   - [Running with GUI](#running-with-gui)
   - [Running on Mobile](#running-on-mobile)
   - [Running in Browser](#running-in-browser)
10. [Advanced Topics](#advanced-topics)
    - [Debug Builds](#debug-builds)
    - [Release Builds](#release-builds)
    - [Continuous Integration (CI)](#continuous-integration-ci)
    - [Custom Frontends](#custom-frontends)
    - [Adding New Devices/Plugins](#adding-new-devicesplugins)
    - [Localization and Custom Themes](#localization-and-custom-themes)
    - [Asset Bundling](#asset-bundling)
11. [Testing and QA](#testing-and-qa)
    - [Running Unit Tests](#running-unit-tests)
    - [Integration & Regression Testing](#integration--regression-testing)
    - [Performance Testing](#performance-testing)
    - [Fuzzing and Automation](#fuzzing-and-automation)
12. [Troubleshooting](#troubleshooting)
13. [FAQ](#faq)
14. [Contributing to the Build System](#contributing-to-the-build-system)
15. [References & Further Reading](#references--further-reading)

---

## Introduction

Welcome to the **GamesFlow Emulator** build guide! This document provides comprehensive, step-by-step instructions for building, configuring, and running the emulator on all supported platforms. Whether you're targeting Windows, Mac, Linux, web, or mobile, this guide covers everything from environment setup to advanced customizations and troubleshooting.

---

## Prerequisites

### Operating Systems

- **Windows**: Windows 8, 8.1, 10, 11 (x64)
- **macOS**: 10.15+ (Catalina and above, Intel & Apple Silicon)
- **Linux**: Ubuntu 20.04+/Debian/Fedora/Arch/Other (x64)
- **Android**: 8.0 Oreo and above
- **iOS**: 13 and above (for development, a Mac and Xcode are required)
- **Web**: Any modern browser supporting WebAssembly (WASM)
- **VR**: Windows/macOS/Linux with OpenXR, Oculus, or SteamVR runtime

### Required Software

- [.NET 8.0 SDK+](https://dotnet.microsoft.com/download)
- [Git](https://git-scm.com/downloads)
- [CMake](https://cmake.org/download/) (for native dependencies)
- [Python 3.7+](https://www.python.org/downloads/) (for some build scripts)
- [PowerShell 7+](https://github.com/PowerShell/PowerShell) (all platforms)
- [Node.js & npm](https://nodejs.org/) (for web frontend)
- [Java Development Kit (JDK) 11+](https://adoptopenjdk.net/) (Android)
- [Android Studio](https://developer.android.com/studio) (Android)
- [Xcode](https://developer.apple.com/xcode/) (iOS/macOS)
- [Visual Studio 2022+](https://visualstudio.microsoft.com/) (Windows, optional, for IDE)
- [Mono](https://www.mono-project.com/download/stable/) (Linux/macOS, optional for legacy support)

### Optional Software and Tools

- [Docker](https://www.docker.com/) (for CI/build automation)
- [Avalonia UI Designer](https://avaloniaui.net/)
- [FFMPEG](https://ffmpeg.org/download.html) (video/audio features)
- [SDL2](https://www.libsdl.org/download-2.0.php) (for some device modules)
- [OpenTK](https://opentk.net/)
- [Perl](https://www.perl.org/get.html) (for legacy scripts)
- [FLUX](https://fluxcd.io/) (for advanced build automation)
- [GTK+](https://www.gtk.org/) (Linux GUI)
- [Vulkan SDK](https://vulkan.lunarg.com/sdk/home)
- [GitHub CLI](https://cli.github.com/)

---

## Cloning the Repository

```bash
git clone https://github.com/sugarypumpkin822/gamesflow-emulator-.git
cd gamesflow-emulator-
```

If you require submodules (plugins, assets, etc.):

```bash
git submodule update --init --recursive
```

---

## Directory Structure Overview

Refer to `Architecture.md` for a detailed breakdown. Key directories:

- `Core/`: Main emulator logic and system orchestration
- `Devices/`: CPU, GPU, Audio, Input, Memory, Network, Peripherals, Storage modules
- `Frontends/`: Console, GUI, Web, Mobile, VR user interfaces
- `Plugins/`: Optional dynamically loaded modules (video filters, netplay, etc.)
- `Utilities/`: Tools like ROM manager, debugger, asset viewer
- `Tests/`: Unit, integration, system, performance, and fuzzing tests
- `Docs/`: Documentation and guides
- `Scripts/`: Build, test, and automation scripts (PowerShell, FLUX, Perl, Bash, Python)
- `Assets/`: BIOS, shaders, themes, overlays, localization files

---

## Environment Setup

### Cross-Platform Notes

- All primary build steps use `.NET 8+` and PowerShell Core, which run on Windows, macOS, and Linux.
- For device/GUI-specific or native code, ensure required toolchains (Visual Studio, Xcode, Android Studio, etc.) are installed.
- For mobile, web, or VR, additional SDKs and emulators may be required.

### Environment Variables

Set the following environment variables as needed:

- `GAMESFLOW_CONFIG_PATH` — Custom config directory
- `GAMESFLOW_ASSET_PATH` — Override asset location
- `DOTNET_CLI_TELEMETRY_OPTOUT` — Set to `1` to disable telemetry (recommended)
- `ANDROID_HOME` — Android SDK path (for mobile)
- `IOS_BUILD_DIR` — Custom build output for iOS
- `VULKAN_SDK` — Vulkan SDK root (for advanced GPU emulation)
- `PATH` — Ensure all required tool binaries are included

### Recommended Shell Configurations

- Add `dotnet`, `pwsh`, and `python` to your `PATH`.
- On Linux/macOS: For GUI builds, set `DISPLAY` and `GTK_PATH` as needed.
- On Windows: Use the "x64 Native Tools Command Prompt" for native code builds.

---

## Building from Source

### Standard Build (All Platforms)

```bash
pwsh Scripts/build.ps1
# OR, if PowerShell Core is not available:
./Scripts/build.sh
```

This will:
- Restore all .NET/NuGet dependencies
- Build all projects in the solution
- Copy binaries to the `bin/` directory
- Package plugins, frontends, and assets

#### To build only the core emulator:

```bash
dotnet build Core/GamesFlow.Core.csproj -c Release
```

#### To build everything (all platforms, all targets):

```bash
pwsh Scripts/build.ps1 --all
```

### Windows

- Open `GamesFlowEmulator.sln` in Visual Studio 2022+
- Select desired configuration (Debug/Release)
- Build Solution (`Ctrl+Shift+B`)
- Run from Visual Studio or via CLI:
  ```bash
  dotnet run --project Frontends/GUI/GamesFlowEmulator.GUI.csproj
  ```

### macOS

- Install Xcode and command-line tools
- Install .NET SDK and Mono
- Build using PowerShell or Bash scripts:
  ```bash
  pwsh Scripts/build.ps1
  # or
  ./Scripts/build.sh
  ```
- For GUI:
  ```bash
  dotnet run --project Frontends/GUI/GamesFlowEmulator.GUI.csproj
  ```

### Linux (Debian/Ubuntu/Fedora/Arch)

- Install .NET, Mono, GTK+, SDL2, Vulkan SDK as needed
- Build using:
  ```bash
  pwsh Scripts/build.ps1
  # or
  ./Scripts/build.sh
  ```

### Mobile (Android/iOS)

#### Android

- Install Android Studio and .NET MAUI workloads:
  ```bash
  dotnet workload install maui-android
  ```
- Open `Frontends/Mobile/Android` in Android Studio or VS
- Build and deploy using:
  ```bash
  dotnet build Frontends/Mobile/GamesFlowEmulator.Mobile.csproj -c Release -f:net8.0-android
  ```

#### iOS

- Install Xcode and .NET MAUI workloads:
  ```bash
  dotnet workload install maui-ios
  ```
- Use MacOS terminal:
  ```bash
  dotnet build Frontends/Mobile/GamesFlowEmulator.Mobile.csproj -c Release -f:net8.0-ios
  ```

### Web (WASM)

- Install Node.js, npm, and .NET WASM workload:
  ```bash
  dotnet workload install wasm-tools
  npm install -g serve
  ```
- Build:
  ```bash
  dotnet publish Frontends/Web/GamesFlowEmulator.Web.csproj -c Release -o bin/web
  ```
- Run:
  ```bash
  serve bin/web
  # Visit http://localhost:5000/
  ```

### VR

- Install OpenXR, Oculus or SteamVR SDKs as required.
- Build and run the VR frontend:
  ```bash
  dotnet build Frontends/VR/GamesFlowEmulator.VR.csproj -c Release
  dotnet run --project Frontends/VR/GamesFlowEmulator.VR.csproj
  ```

---

## PowerShell & Scripting Tools

- **PowerShell scripts** are in `Scripts/PowerShell/`, usable cross-platform via [PowerShell 7+](https://github.com/PowerShell/PowerShell).
- **FLUX scripts** automate advanced build/deployment workflows.
- **Perl/Bash/Python** scripts support legacy and niche build tasks.

To list available scripts and options:

```bash
pwsh Scripts/help.ps1
```

To clean build artifacts:

```bash
pwsh Scripts/clean.ps1
```

To update dependencies:

```bash
pwsh Scripts/update-deps.ps1
```

---

## Custom Build Options

### Enabling/Disabling Devices and Plugins

- Edit `GamesFlow.Core/Configuration/Modules.json` to include/exclude device modules.
- Use the `--with-plugins` or `--without-plugins` flags in build scripts.

### Feature Flags

- Pass feature flags via environment variables or as CLI arguments:
  ```bash
  pwsh Scripts/build.ps1 --enable-netplay --disable-audio
  ```

### Build Profiles

- Supported profiles: `Debug`, `Release`, `Performance`, `Minimal`
- Set profile in scripts or with `-c`:
  ```bash
  dotnet build -c Release
  ```

---

## Running the Emulator

### Launching from CLI

```bash
dotnet run --project Frontends/Console/GamesFlowEmulator.Console.csproj -- --rom path/to/romfile.rom
```

### Running with GUI

```bash
dotnet run --project Frontends/GUI/GamesFlowEmulator.GUI.csproj
```

### Running on Mobile

- Deploy to emulator or device using IDE or CLI.
- For Android:
  ```bash
  dotnet build -t:Install -f:net8.0-android
  ```
- For iOS (on Mac):
  ```bash
  dotnet build -t:Run -f:net8.0-ios
  ```

### Running in Browser

```bash
dotnet publish Frontends/Web/GamesFlowEmulator.Web.csproj -c Release -o bin/web
serve bin/web
```

---

## Advanced Topics

### Debug Builds

- Use `-c Debug` for debug symbols and extra logging.
- Launch with a debugger attached (Visual Studio, Rider, VS Code).

### Release Builds

- Use `-c Release` for optimized binaries.
- Artifact packaging and signing (if configured).

### Continuous Integration (CI)

- CI workflows are in `.github/workflows/`.
- Builds run on PR, push, and release tags for all major OSes.
- Results visible on the GitHub Actions tab.

### Custom Frontends

- Create new projects in `Frontends/`.
- Register new frontend in `GamesFlowEmulator.sln`.
- Reference the `Core` project and implement required interfaces.

### Adding New Devices/Plugins

- Create new module/plugin in `Devices/` or `Plugins/`.
- Register in `Modules.json` and/or the plugin loader config.
- Implement `IEmulatedDevice` or appropriate plugin interface.

### Localization and Custom Themes

- Place language files in `Assets/Localization/`.
- Add new theme folders to `Assets/Themes/`.
- Edit configuration or use GUI to switch.

### Asset Bundling

- Assets (BIOS, shaders, overlays) go in `Assets/`.
- Update asset manifest as needed.

---

## Testing and QA

### Running Unit Tests

```bash
dotnet test Tests/Unit/
```

### Integration & Regression Testing

```bash
dotnet test Tests/Integration/
dotnet test Tests/Regression/
```

### Performance Testing

```bash
dotnet test Tests/Performance/
```

### Fuzzing and Automation

- See `Scripts/fuzz.ps1` for fuzzing tests.
- Automated via CI.

---

## Troubleshooting

- **Build fails:** Ensure all prerequisites are installed and path variables are set.
- **Native dependencies:** Check SDL2, Vulkan, OpenTK, etc. are installed and on your system path.
- **Permission errors:** Try running with `sudo` (Linux/macOS) or as Administrator (Windows).
- **Outdated submodules:** Run `git submodule update --init --recursive`.
- **Missing assets:** Double check `Assets/` and update asset manifests.

For more, see `Docs/Troubleshooting.md`.

---

## FAQ

**Q: Do I need BIOS files?**  
A: Some systems require BIOS. Place them in `Assets/Bios/` as detailed in `Docs/Bios.md`.

**Q: Can I use my own shaders/themes?**  
A: Yes, copy your files into `Assets/Shaders/` or `Assets/Themes/`.

**Q: What if my ROM doesn't run?**  
A: Check compatibility in `Docs/Compatibility.md` and verify ROM hashes.

**Q: How can I add a new system?**  
A: Implement new device modules in `Devices/`, register in `Modules.json`, and contribute tests.

**Q: Where can I get help?**  
A: Open a GitHub issue, check Discussions, or join our community chat.

---

## Contributing to the Build System

- Propose changes in Issues/Discussions for major updates.
- Follow `.editorconfig` and CI formatting rules.
- Add/modify build scripts in `Scripts/` as needed.
- Document new build options in this file!

---

## References & Further Reading

- [Official .NET Documentation](https://docs.microsoft.com/dotnet/)
- [CMake Documentation](https://cmake.org/cmake/help/latest/)
- [PowerShell Documentation](https://docs.microsoft.com/powershell/)
- [Avalonia UI Docs](https://docs.avaloniaui.net/)
- [SDL2 Docs](https://wiki.libsdl.org/)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [GamesFlow Emulator Architecture](Architecture.md)
- [GamesFlow Emulator Docs](/Docs)

---

**Happy Building! If you run into trouble, open an issue or reach out to the community at the discord server.** 
