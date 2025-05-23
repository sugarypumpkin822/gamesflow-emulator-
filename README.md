# GamesFlow

**GamesFlow** is a modular, cross-platform, open-source emulator written in C#. GamesFlow aims to provide a single, unified platform for emulating and playing games from many classic systems, including Nintendo, PlayStation, Xbox, and classic Windows environments. The project is designed for extensibility, performance, and ease of use, with a focus on community contributions and transparency.

---

## Table of Contents

- [Features](#features)
- [Supported Systems](#supported-systems)
- [Screenshots](#screenshots)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Building from Source](#building-from-source)
  - [Running the Emulator](#running-the-emulator)
- [Configuration](#configuration)
- [Plugin System](#plugin-system)
- [User Interface](#user-interface)
- [Localization](#localization)
- [Contributing](#contributing)
- [Testing](#testing)
- [FAQ](#faq)
- [License](#license)
- [Disclaimer](#disclaimer)
- [Contact](#contact)
- [Acknowledgements](#acknowledgements)

---

## Features

- **Multi-System Emulation**: Play games from Nintendo, PlayStation, Xbox, and Windows classic platforms.
- **Plugin Architecture**: Flexible system for video, audio, input, and network plugins.
- **Save States**: Save/load game state at any time.
- **Modern GUI**: Intuitive, themed user interface with game library, configuration panels, and more.
- **Cross-Platform**: Runs on Windows, Linux, and macOS.
- **Configuration Profiles**: Save and switch between different system/game settings.
- **Localization**: Multi-language support using .resx resource files.
- **Cheat Support**: Load and manage cheats for supported systems.
- **Automatic Updates**: (Planned) Built-in update checker for new releases.
- **Community Driven**: Open to contributions from all emulator enthusiasts.

---

## Supported Systems

**Nintendo**
- NES, SNES, N64, GameCube, Wii

**PlayStation**
- PS1, PS2, PS3, PSP

**Xbox**
- Xbox Classic, Xbox 360, Xbox One (partial/experimental)

**Windows**
- Windows 9x, Windows XP, Windows 7 (classic games/ISOs)

---

## Screenshots

<!-- Add screenshots here -->
![Main UI Screenshot](docs/screenshots/main_ui.png)
![Settings Dialog](docs/screenshots/settings.png)

---

## Getting Started

### Prerequisites

- [.NET 8+ SDK](https://dotnet.microsoft.com/download)
- Visual Studio 2022+ or VS Code
- For Linux: SDL2, OpenAL, Vulkan (for respective plugins)
- BIOS files for certain systems (not included)

### Building from Source

1. **Clone the repository**:
    ```bash
    git clone https://github.com/sugarypumpkin822/gamesflow.git
    cd gamesflow
    ```

2. **Run the structure script (optional for new projects)**:
    ```powershell
    ./create_gamesflow_structure.ps1
    ```

3. **Restore dependencies and build**:
    ```bash
    dotnet restore
    dotnet build GamesFlow.sln
    ```

4. **Run the emulator**:
    ```bash
    dotnet run --project GamesFlow.GUI
    ```

### Running the Emulator

- Place required BIOS files in `GamesFlow.Resources/Bios/`.
- Add your legal game ROMs/ISOs to the desired location.
- Launch and configure via the GUI.

---

## Configuration

All user configuration is stored in the `GamesFlow.Core/Config/` directory.
- **VideoConfig.cs**: Graphics settings, scaling, shaders, full screen options.
- **AudioConfig.cs**: Audio backend, buffer size, latency.
- **InputConfig.cs**: Controller mapping, keyboard shortcuts.
- **SystemProfiles.cs**: Presets for each emulated system.

Configuration can be edited via the GUI or by hand in the respective files.

---

## Plugin System

GamesFlow supports dynamic loading of external plugins for:
- Video (OpenGL, Vulkan, DirectX, Software)
- Audio (OpenAL, XAudio2, SDL)
- Input (SDL, XInput, DualShock)
- Network (Netplay, Online Services)

Write your own plugins by implementing the provided interfaces in `GamesFlow.Plugins/`.

---

## User Interface

- **MainWindow**: Game browser, quick launch, recent games.
- **SettingsDialog**: Tweak all emulator options.
- **AboutDialog**: Version info and credits.
- **RomBrowser**: Add, remove, and organize ROMs.
- **Themes**: Light and dark modes (`Themes/` directory).

---

## Localization

GamesFlow supports multiple languages out of the box.
- Language files are in `GamesFlow.GUI/Resources/lang/`.
- Contribute new translations by adding `.resx` files.

---

## Contributing

We welcome all forms of contribution!
- Bug reports and feature requests via GitHub Issues.
- Pull requests for code, documentation, tests, or translations.
- Discussion and help in our [community forum](https://github.com/sugarypumpkin822/gamesflow/discussions).

Read `CONTRIBUTING.md` for full guidelines.

---

## Testing

- Automated tests are in `GamesFlow.Tests/`.
- Run all tests:
    ```bash
    dotnet test GamesFlow.Tests
    ```

---

## FAQ

**Q:** Does GamesFlow provide ROMs or BIOS files?<br>
**A:** No. You must provide your own legally acquired game files and system BIOS.

**Q:** What systems are supported?<br>
**A:** See [Supported Systems](#supported-systems). More may be added with community help!

**Q:** Can I use my gamepad?<br>
**A:** Yes! Most major controllers are supported via plugin.

**Q:** How do I report a bug?<br>
**A:** Open a GitHub issue and include system details, logs, and reproduction steps.

---

## License

- If you download GamesFlow from GitHub, it is available under the MIT License (see [LICENSE](LICENSE)).
- **If you obtain GamesFlow from any other source, the project and all its files are copyright © 2025 sugarypumpkin822. All rights reserved.**
- See full license in [LICENSE](LICENSE).

---

## Disclaimer

GamesFlow is an educational project. It does **not** condone piracy and does **not** include copyrighted ROMs, ISOs, or BIOS.
You are responsible for the legality of any files you use with this emulator.

---

## Contact

- GitHub: [sugarypumpkin822/gamesflow](https://github.com/sugarypumpkin822/gamesflow)
- Email: [Contact via GitHub profile](https://github.com/sugarypumpkin822)

---

## Acknowledgements

- Thanks to the open-source emulation community.
- Inspired by projects such as RetroArch, Dolphin, PCSX2, and others.
- Icon and art assets by contributors (see `docs/Contributors.md`).

---

*Happy Gaming!*
