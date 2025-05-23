# GamesFlow Emulator - GIANT Cheats Guide

Welcome to the **GamesFlow Emulator Cheats Guide**!  
This document provides an extensive overview of cheat functionality, supported code types, cheat engine usage, advanced features, format examples, troubleshooting, and a massive catalog of community-contributed cheats for many systems.

---

## Table of Contents

1. [Introduction](#introduction)
2. [Cheat Engine Overview](#cheat-engine-overview)
3. [Supported Cheat Code Formats](#supported-cheat-code-formats)
    - [Game Genie](#game-genie)
    - [Pro Action Replay (PAR/AR/Action Replay)](#pro-action-replay-pararaction-replay)
    - [CodeBreaker](#codebreaker)
    - [GoldFinger](#goldfinger)
    - [GameShark](#gameshark)
    - [Xploder](#xploder)
    - [Hex Codes / Custom RAM Patches](#hex-codes--custom-ram-patches)
    - [Lua Scripts & Dynamic Cheats](#lua-scripts--dynamic-cheats)
    - [Built-in GamesFlow Format](#built-in-gamesflow-format)
4. [How to Add Cheats](#how-to-add-cheats)
    - [Via GUI](#via-gui)
    - [Via Console/CLI](#via-consolecli)
    - [Via Cheats Files](#via-cheats-files)
5. [Cheat Management](#cheat-management)
    - [Enabling, Disabling, and Deleting Cheats](#enabling-disabling-and-deleting-cheats)
    - [Cheat Groups and Presets](#cheat-groups-and-presets)
    - [Per-Game and Global Cheats](#per-game-and-global-cheats)
    - [Cheat Search and RAM Watch](#cheat-search-and-ram-watch)
6. [Scripting and Advanced Usage](#scripting-and-advanced-usage)
    - [Lua Cheat Scripts](#lua-cheat-scripts)
    - [PowerShell Cheat Automation](#powershell-cheat-automation)
    - [Real-Time Cheat Activation (Hotkeys)](#real-time-cheat-activation-hotkeys)
    - [Conditional Cheats and Events](#conditional-cheats-and-events)
7. [Cheat Code Examples](#cheat-code-examples)
    - [NES](#nes)
    - [SNES](#snes)
    - [Genesis/Mega Drive](#genesismega-drive)
    - [Game Boy / GBC / GBA](#game-boy--gbc--gba)
    - [PlayStation](#playstation)
    - [Nintendo 64](#nintendo-64)
    - [GameShark Advanced](#gameshark-advanced)
    - [Community Cheat Packs](#community-cheat-packs)
8. [Troubleshooting Cheats](#troubleshooting-cheats)
9. [Contributing Cheats](#contributing-cheats)
10. [Cheat Database Structure](#cheat-database-structure)
11. [Automated Cheat Download and Updates](#automated-cheat-download-and-updates)
12. [Legal Notice](#legal-notice)
13. [References & Cheat Resources](#references--cheat-resources)

---

## Introduction

Cheats in GamesFlow Emulator are powerful tools that allow you to modify game memory, unlock hidden features, enable developer/debugging options, and more. This system supports a wide array of cheat devices and code formats, with both manual entry and automated cheat database integration, plus advanced scripting.

---

## Cheat Engine Overview

**Features:**
- Supports multiple cheat code formats (see below)
- Real-time cheat toggling, hotkey assignment, cheat groups/presets
- Cheat search (RAM watch, value comparison, pointer tracing)
- Scripting engine for dynamic/conditional cheats (Lua, PowerShell)
- Cheat database with per-game, per-region, and global cheats
- Built-in cheat browser, editor, and import/export tools
- Support for complex cheats (multi-line, pointer-based, conditional, timer-based)
- Community cheat pack integration and auto-update

---

## Supported Cheat Code Formats

### Game Genie

- Common on NES, SNES, Genesis, Game Boy
- Format: Character-based codes (e.g. `GZUXNGEI`)
- Example (NES, Super Mario Bros):  
  ```
  SXIOPO
  Infinite Lives
  ```

### Pro Action Replay (PAR/AR/Action Replay)

- Hex-based memory patch codes (RAM/ROM)
- Format: `XXXXXX:YY` (address:value)
- Example (SNES, Super Metroid):  
  ```
  7E09C2:63
  Infinite Missiles
  ```

### CodeBreaker

- Used on PS2, GBA, Dreamcast, etc.
- Often numeric codes, sometimes with master codes
- Example (GBA):  
  ```
  83000E20 000F
  ```

### GoldFinger

- Used on SNES
- Format: `SSSAAA:VV` (subsystem:address:value)

### GameShark

- Multi-system device, supports complex and pointer-based codes
- Format: `XXXXXXXX YYYY`
- Example (N64, Ocarina of Time):  
  ```
  8011B9A4 0009
  ```

### Xploder

- Similar to Action Replay, used in Europe

### Hex Codes / Custom RAM Patches

- Direct memory editing, highly advanced
- Format: `address:value`
- Used for custom, system-specific cheats

### Lua Scripts & Dynamic Cheats

- Lua scripting support for dynamic cheats, conditional logic, auto-activation, etc.
- Example:
  ```lua
  if memory.readbyte(0x7E149C) < 5 then
    memory.writebyte(0x7E149C, 99)
  end
  ```

### Built-in GamesFlow Format

- JSON/YAML support for structured, multi-line, per-game cheats
- Example (JSON):
  ```json
  {
    "name": "Infinite Health",
    "codes": [
      { "type": "PAR", "address": "7E1234", "value": "99" }
    ],
    "hotkey": "F1",
    "enabled": true
  }
  ```

---

## How to Add Cheats

### Via GUI

1. Launch game, open Cheats menu.
2. Click "Add Cheat" or "Import Cheat File".
3. Enter code, description, optional hotkey, group, and enable/disable.
4. Save and activate.

### Via Console/CLI

- Use the command:
  ```
  cheats add --code "7E09C2:63" --desc "Infinite Missiles" --enable
  ```
- Or batch import:
  ```
  cheats import mycheats.txt
  ```

### Via Cheats Files

- Place `.cht`, `.xml`, `.json`, or `.lua` cheat files in the game’s `Cheats/` directory.
- Use menu or CLI to load.

---

## Cheat Management

### Enabling, Disabling, and Deleting Cheats

- Toggle cheats on/off in real time via GUI, hotkey, or CLI.
- Delete cheats via cheat editor or CLI.

### Cheat Groups and Presets

- Organize cheats by group (e.g., "Infinite", "Unlock", "Fun").
- Presets allow switching sets of cheats (e.g., "Speedrun", "Casual").

### Per-Game and Global Cheats

- Cheats are stored per-game, but global cheats (applied to all games) are supported for universal hacks (e.g., "Always 60Hz").

### Cheat Search and RAM Watch

- Search for values (exact, greater/less than, unknown initial).
- Watch RAM addresses and set auto-activation triggers.

---

## Scripting and Advanced Usage

### Lua Cheat Scripts

- Place Lua scripts in `Cheats/Scripts/`.
- Use `memory.readbyte`, `memory.writeword`, etc., in scripts for dynamic cheats.

### PowerShell Cheat Automation

- PowerShell scripts can automate cheat activation, batch operations, or complex workflows.
- Example:
  ```powershell
  ./activate-cheat.ps1 -Game "Super Mario World" -Cheat "Moon Jump"
  ```

### Real-Time Cheat Activation (Hotkeys)

- Assign hotkeys to enable/disable cheats instantly.
- GUI and CLI support for hotkey management.

### Conditional Cheats and Events

- Cheats can be set to trigger on specific game events, RAM conditions, or time intervals.
- Scripting API supports complex logic.

---

## Cheat Code Examples

### NES

| Game                   | Code                | Effect                | Format      |
|------------------------|---------------------|-----------------------|-------------|
| Super Mario Bros.      | SXIOPO              | Infinite Lives        | Game Genie  |
| Legend of Zelda        | AENKZGPA            | Start with 8 Hearts   | Game Genie  |
| Contra                 | SZNZIV              | Infinite Lives        | Game Genie  |

### SNES

| Game                   | Code                | Effect                | Format      |
|------------------------|---------------------|-----------------------|-------------|
| Super Mario World      | 7E149C:63           | Infinite Lives        | PAR         |
| Chrono Trigger         | 7E298C:63           | Max HP                | PAR         |
| Zelda: LTTP            | 7EF35A:01           | Always Have Sword     | PAR         |

### Genesis/Mega Drive

| Game                   | Code                | Effect                | Format      |
|------------------------|---------------------|-----------------------|-------------|
| Sonic 2                | FFCE0D:09           | Infinite Lives        | PAR         |
| Streets of Rage 2      | FFEF1B:09           | Infinite Health       | PAR         |

### Game Boy / GBC / GBA

| Game                   | Code                | Effect                | Format      |
|------------------------|---------------------|-----------------------|-------------|
| Pokémon Red            | 01FF13D1            | Infinite Money        | GameShark   |
| Zelda: Link's Awakening| 010152C8            | Infinite Health       | GameShark   |

### PlayStation

| Game                   | Code                | Effect                | Format      |
|------------------------|---------------------|-----------------------|-------------|
| Final Fantasy VII      | 8009C764 FFFF       | Max Gil               | GameShark   |
| Resident Evil 2        | 800C76CE 2400       | Infinite Ammo         | GameShark   |

### Nintendo 64

| Game                   | Code                | Effect                | Format      |
|------------------------|---------------------|-----------------------|-------------|
| Ocarina of Time        | 8011B9A4 0009       | Infinite Health       | GameShark   |
| Mario Kart 64          | 8009D6B7 0064       | Max Coins             | GameShark   |

### GameShark Advanced

| Game                   | Code                | Effect                | Format      |
|------------------------|---------------------|-----------------------|-------------|
| Pokémon Emerald        | 82005274 423F       | Master Ball           | GameShark   |
| Fire Emblem            | 8202B9EC 0063       | Infinite XP           | GameShark   |

### Community Cheat Packs

The GamesFlow community maintains a massive, auto-updating cheats database:
- **Location:** `Assets/Cheats/`
- **Formats:** `.cht`, `.json`, `.xml`, `.lua`
- **Contribution:** See [Contributing Cheats](#contributing-cheats)

---

## Troubleshooting Cheats

- **Cheats not working:** Double-check code format, region, and game version.
- **Game crashes/freezes:** Some cheats are incompatible; try disabling or batch testing.
- **Cheats not showing up:** Ensure cheats file is in correct directory (`Cheats/`).
- **Auto-activation not triggering:** Review script logic or RAM address accuracy.
- **GUI/CLI bugs:** File an issue on GitHub with logs and cheat details.

---

## Contributing Cheats

- Fork the repo, add cheats to `Assets/Cheats/`, and submit a pull request.
- Use clear descriptions, correct formats, and test on real ROMs.
- For scripting cheats, provide comments and compatibility notes.
- Use standard naming and grouping conventions.
- See `CONTRIBUTING.md` for guidelines.

---

## Cheat Database Structure

- **Per-game:** Grouped by ROM hash, title, and region.
- **Per-system:** All system-specific codes in subfolders.
- **Format:** Supports `.cht`, `.xml`, `.json`, `.lua`.
- **Meta:** Description, format type, group, hotkey, enabled/disabled state, author, source.

Example (JSON Entry):
```json
{
  "game": "Super Mario World",
  "region": "USA",
  "hash": "sha1:0123456789abcdef",
  "cheats": [
    {
      "name": "Infinite Lives",
      "type": "PAR",
      "address": "7E149C",
      "value": "63",
      "enabled": true,
      "hotkey": "F1"
    }
  ]
}
```

---

## Automated Cheat Download and Updates

- Use GamesFlow’s built-in cheat updater (GUI: “Update Cheats”, CLI: `cheats update`).
- Connects to official and community cheat databases.
- Automatically merges new/updated cheats.
- Manual import/export also supported.

---

## Legal Notice

- Use cheats and mods responsibly.
- Do not distribute copyrighted game code.
- Cheats are for preservation, fair use, and personal enjoyment.

---

## References & Cheat Resources

- [GameHacking.org](https://gamehacking.org/)
- [RetroAchievements](https://retroachievements.org/)
- [No-Intro Databases](https://datomatic.no-intro.org/)
- [CodeTwink](https://www.codetwink.com/)
- [GBATemp](https://gbatemp.net/)
- [Datel/Action Replay](https://datel.co.uk/)
- [TCRF - The Cutting Room Floor](https://tcrf.net/)
- [Reddit /r/GameCheats](https://www.reddit.com/r/GameCheats/)
- [Official GamesFlow Cheat Wiki](https://github.com/sugarypumpkin822/gamesflow-emulator-/wiki/Cheats)
- [GamesFlow Discord](https://discord.gg/YOUR_INVITE)

---

## Appendix: Advanced Cheat Scripting API

### Lua Cheat Engine API

- `memory.readbyte(address)`
- `memory.readword(address)`
- `memory.writebyte(address, value)`
- `memory.writeword(address, value)`
- `event.onframe(func)`
- `event.oncheat(func, cheat_name)`
- `gui.popup(text)`
- and more...

### PowerShell & Other Scripting

- Full access to GamesFlow cheat management via scripting.
- Example: Enable all "Infinite" cheats for loaded game:
  ```powershell
  Get-GamesFlowCheats | Where-Object { $_.Name -like "*Infinite*" } | Enable-GamesFlowCheat
  ```

---

**This is a living document! Contribute your codes and help build the world’s largest open-source cheat database!**
