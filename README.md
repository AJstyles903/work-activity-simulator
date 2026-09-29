# Work Activity Simulator – Smart Idle Detection & Dashboard

<a name="top"></a>

[![AutoHotkey](https://img.shields.io/badge/AutoHotkey-2.0+-blue?logo=autohotkey&logoColor=white)](https://www.autohotkey.com/)
[![Language](https://img.shields.io/badge/language-AHK%20(v2)-33AA33)](https://www.autohotkey.com/docs/v2/)
[![OS](https://img.shields.io/badge/OS-Windows%207%2B-0078D4)](https://www.autohotkey.com/)
[![License](https://img.shields.io/badge/license-MIT-green)](https://opensource.org/licenses/MIT)

⭐ Star this script if it helps you stay "active" during remote work! 🙏

[![Share](https://img.shields.io/badge/share-000000?logo=x&logoColor=white)](https://x.com/intent/tweet?text=Check%20out%20this%20smart%20AutoHotkey%20script%20that%20simulates%20user%20activity%20to%20fool%20employee%20monitoring%20tools!%20%23AutoHotkey%20%23Productivity%20%23RemoteWork)
[![Share](https://img.shields.io/badge/share-1877F2?logo=facebook&logoColor=white)](https://www.facebook.com/sharer/sharer.php?u=https://github.com/ajstyles903/work-activity-simulator)
[![Share](https://img.shields.io/badge/share-0A66C2?logo=linkedin&logoColor=white)](https://www.linkedin.com/sharing/share-offsite/?url=https://github.com/ajstyles903/work-activity-simulator)

> ⚠️ **Disclaimer**: This tool is intended **for educational and testing purposes only**. Misusing it to deceive time-tracking or productivity-monitoring software may violate your organization’s policies or employment agreements. Use responsibly and ethically.

---

## Table of Contents
- [🚀 About](#-about)
- [✨ Features](#-features)
- [⌨️ Hotkeys](#-hotkeys)
- [🖥️ The Dashboard & Tray Icon](#-the-dashboard--tray-icon)
- [🔍 How It Works](#-how-it-works)
- [🧪 Use Cases & Ethical Note](#-use-cases--ethical-note)
- [📥 Installation & Usage](#-installation--usage)
- [🛠️ Customization & Custom Icons](#-customization--custom-icons)
- [📦 Compilation (EXE)](#-compilation-exe)
- [🤝 Feedback and Contributions](#-feedback-and-contributions)

---

## 🚀 About

**Work Activity Simulator** is a smart AutoHotkey v2 script that mimics real user input (mouse movement, scrolling, and keyboard presses) to prevent systems from detecting idle time. 

Unlike older scripts that pop up annoying windows on startup, this version is **background-first**. It runs silently in your system tray and features a **beautiful live dashboard** that you can summon only when you need it. It uses native Windows APIs to track your real activity, ensuring zero hotkey-flood errors and perfect auto-detection.

---

## ✨ Features

- **Background-First Design**: Starts completely hidden in the system tray. No intrusive windows on launch.
- **Live Dashboard GUI**: A clean, grouped dashboard showing real-time State, Mode, Uptime, Auto-Idle status, and exact Idle timers.
- **Rich Tray Integration**: 
  - **Hover** the tray icon to see live status (Running/Stopped, Mode, Uptime).
  - **Right-click** for a full control menu.
  - **Double-click** to open the dashboard.
- **System-Wide Input Detection**: Uses the Windows API (`GetLastInputInfo`) instead of fragile hotkey hooks. Detects *all* system input flawlessly without triggering "hotkey flood" warnings.
- **Smart Self-Awareness**: Flags its own simulated input so it never accidentally counts its own mouse moves as "user activity" (preventing auto-mode from instantly stopping itself).
- **Custom Tray Icons**: Supports optional custom `.ico` files to visually change the tray icon when Running vs. Stopped.
- **Natural Movements**: Mouse moves with human-like acceleration, easing, and micro-jitters.
- **Emergency Stop**: Instantly halt all simulated activity.

---

## ⌨️ Hotkeys

| Hotkey | Action |
|--------|--------|
| `Ctrl + Alt + Shift + M` | Start **Mouse Scroll + Keyboard** |
| `Ctrl + Alt + Shift + K` | Start **Mouse Only** (movement + scroll) |
| `Ctrl + Alt + Shift + L` | Start **Keyboard Only** |
| `Ctrl + Alt + Shift + C` | Start **All Combined** |
| `Ctrl + Alt + Shift + A` | **Toggle Auto Idle Detection** ON/OFF |
| `Ctrl + Alt + Shift + Z` | **Emergency Stop** (kill all activity) |
| `Ctrl + Alt + Shift + G` | **Toggle Dashboard** (Show/Hide GUI) |
| `Ctrl + Alt + X` | Exit the script entirely |

> 💡 Tray notifications and the Dashboard will confirm each action instantly.

---

## 🖥️ The Dashboard & Tray Icon

Because the script starts hidden, all interaction happens through the System Tray (bottom right of your taskbar) or the Dashboard.

### 1. The System Tray
- **Hover**: Simply move your mouse over the tray icon to see a tooltip with: `RUNNING/STOPPED`, `Current Mode`, `Uptime`, and `Idle Time`.
- **Right-Click**: Opens a menu to start specific modes, toggle auto-detection, open the dashboard, or exit.
- **Double-Click**: Instantly opens the Dashboard.

### 2. The Dashboard
Open it via `Ctrl+Alt+Shift+G` or the tray menu. It provides a deep dive into the script's state:
- **Current Status**: Mode, State (Green RUNNING / Red STOPPED), Uptime (`HH:MM:SS`), Auto-arm status, and exact seconds idle.
- **Start Activity**: Clickable buttons for all manual modes.
- **Controls**: Quick access to Auto-Detection and Emergency Stop.

---

## 🔍 How It Works

1. **API Activity Tracking**: Instead of using dozens of `~key::` hooks (which cause hotkey-flood warnings when you type fast), the script polls the Windows API `GetLastInputInfo` every 500ms. This detects *any* real system input (mouse moves, clicks, keys) natively.
2. **Idle Detection**: If no real input is detected for **30 seconds** (configurable), auto-mode activates.
3. **Simulation**: Performs randomized, human-like actions (mouse moves within screen bounds, scroll wheel, F-keys, arrows).
4. **Self-Awareness Flag**: While the script is generating an action, it sets `g_self_input_active := true`. This ensures the Windows API doesn't count the script's *own* simulated mouse moves as "user activity", which prevents the auto-mode from instantly shutting itself off.
5. **Auto-Stop**: The moment *real* user input resumes, simulation stops immediately so it never fights you while you work.

---

## 🧪 Use Cases & Ethical Note

### ✅ Legitimate Uses:
- Preventing screen lock during long-running processes or reading documentation.
- Keeping remote desktop (RDP) or SSH sessions alive.
- Testing idle-detection logic in your own software.
- Simulating user presence during automated demos.

### ❌ Not For:
- Circumventing workplace productivity monitoring dishonestly.
- Violating company IT policies.
- Falsifying work hours or activity reports.

> ⚖️ **Always comply with your employer’s acceptable use policy.** 

---

## 📥 Installation & Usage

1. **Install AutoHotkey v2**  
   → Download from: [https://www.autohotkey.com/](https://www.autohotkey.com/)

2. **Save the script**  
   Copy the provided `.ahk` code into a file named `WorkActivitySimulator.ahk`.

3. **Run it**  
   Double-click the `.ahk` file. **Note:** No window will appear! Look at your system tray (bottom right, near the clock) for the AHK icon.

4. **Interact**  
   - Hover the tray icon to check status.
   - Press `Ctrl + Alt + Shift + G` to open the Dashboard.
   - Use hotkeys or the tray right-click menu to start modes.

---

## 🛠️ Customization & Custom Icons

### 1. Custom Tray Icons (Visual Feedback)
You can make the tray icon change color/shape based on whether the script is running or stopped. 

Create an `icons` folder next to your script/exe and add two files:
```text
WorkActivitySimulator.ahk (or .exe)
└── icons/
    ├── running.ico   (e.g., a green play icon)
    └── stopped.ico   (e.g., a gray stop icon)
```

The script will automatically detect these files and swap the tray icon dynamically!

### 2. Code Tweaks
You can tweak behavior by editing these global variables at the top of the script:

```ahk
   global g_idle_threshold := 30000      ; Idle time in ms (default: 30 sec)
```
* Adjust g_idle_threshold to change auto-activation delay.
* Modify Random() ranges inside PerformMouseMove() or PerformMouseScroll() to alter frequency or intensity.

## 📦 Compilation (EXE)
To run without AutoHotkey installed, or to distribute to others:

   1. Right-click your .ahk file.
   2. Select "Compile Script" (requires AutoHotkey Compiler, included in v2 installation).
   3. An .exe file is generated in the same folder.

   > 🔒 Note: If you use Custom Icons, make sure to keep the icons/ folder in the exact same directory as your compiled .exe.
   
   > 🛡️ Antivirus Note: Some AV tools flag compiled AHK scripts as suspicious (false positive). You may need to add an exception.

--- 

## 🤝 Feedback and Contributions
Found a bug? Have an idea for improvement?
> Open an [Issue](https://github.com/ajstyles903/work-activity-simulator/issues) or submit a PR!

Your feedback helps make this script more robust and useful for everyone.

---

## 🗨️ Contacts
Questions or suggestions? Reach out via:

- Email: aryanjay903@gmail.com
- GitHub: ajstyles903/work-activity-simulator
- LinkedIn: linkedin.com/in/aryan-prajapati-qa