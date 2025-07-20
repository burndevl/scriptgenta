# 🔍 Growtopia World Hunting Assistant (GentaHax Lua Script)

`testerhunting.lua` is a Lua-based script designed for use with GentaHax (v5.23 or newer). It provides an automated solution for finding Growtopia worlds, detecting key tiles such as Vaults and Path Makers, and interacting with dropped items—all through a simple and user-friendly interface.

---

## ✨ Features

- **Automated World Finder**  
  Automatically joins worlds based on customizable naming patterns (letters, numbers, or combinations).

- **Pause on Item Detection**  
  Automatically pauses the search when specific item IDs are found.

- **Vault & Path Maker Scanner**  
  Scans for Vault tiles (ID: 8878) and Path Maker tiles (ID: 1684, 4482).

- **Item Magnet**  
  Lists and allows you to collect dropped items from the current world.

- **Quick Warp Commands**  
  Instantly warp to a world or a specific object ID.

- **Interactive Dialog UI**  
  Configure search behavior and settings using a clean in-game menu.

---

## 🧪 Available Commands

| Command           | Description                                                                 |
|-------------------|-----------------------------------------------------------------------------|
| `/set`            | Opens the configuration menu for world hunting.                            |
| `/manual`         | Performs a one-time world join based on current settings.                   |
| `/next`           | Continues the search after a pause due to item detection.                   |
| `/stop`           | Stops the auto-finder process.                                              |
| `/menu`           | Opens the main helper menu.                                                 |
| `/bypass`         | Scans for and displays Vault tiles in the current world.                    |
| `/pscan`          | Scans for Path Maker tiles.                                                 |
| `/magnet`         | Lists dropped items and provides buttons to collect them.                   |
| `/w <world>`      | Warps directly to the specified world.                                      |
| `/id <objectID>`  | Warps to a specific object ID within the current world.                     |

---

## ⚙️ Configuration (`/set`)

- **World Length** – Number of random characters in the world name.
- **World Type** –  
  - `n` → Numbers only  
  - `nn` → Letters only  
  - `wn` → Alphanumeric
- **Base Name** – The base or fixed portion of the world name.
- **Position** – Placement of the random string (`front`, `mid`, or `end`).
- **Delay** – Delay between world joins, in milliseconds.
- **Auto Search** – Toggle to enable or disable automated looping.

---

## 🚀 Getting Started

1. Place `testerhunting.lua` in your GentaHax script directory.
2. Launch Growtopia using GentaHax v5.23 or higher.
3. Use `/set` to configure your search preferences.
4. Run `/manual` to perform a single search, or enable Auto Search for continuous mode.
5. Use `/magnet`, `/bypass`, or `/pscan` as needed while in a world.

---

## 📌 Notes

- Item IDs for auto-pause detection can be modified in the `itemDropped` variable.
- Script uses `OnTextPacket` and `OnDialogReturn` hooks to handle user input and in-game dialogs.
- Best used on the latest GentaHax version with a stable connection.

---

## ⚠️ Disclaimer

This script is provided for educational and research purposes only.  
Usage is at your own risk. The developer is not responsible for misuse or violations of third-party terms.

---

## 👨‍💻 Author

**BurnDevL**  
GitHub: [@burndevl](https://github.com/burndevl)

---

## 📄 License

**MIT License**  
You are free to use, modify, and distribute this script with proper attribution.

---

> If you find this project helpful, consider giving the repository a ⭐ star.
