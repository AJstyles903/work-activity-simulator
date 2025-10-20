# Work Activity Simulator – Smart Idle Detection for AutoHotkey

<a name="top"></a>

[![AutoHotkey](https://img.shields.io/badge/AutoHotkey-2.0+-blue?logo=autohotkey&logoColor=white)](https://www.autohotkey.com/)
[![Language](https://img.shields.io/badge/language-AHK%20(v2)-33AA33)](https://www.autohotkey.com/docs/v2/)
[![OS](https://img.shields.io/badge/OS-Windows%207%2B-0078D4)](https://www.autohotkey.com/)
[![License](https://img.shields.io/badge/license-MIT-green)](https://opensource.org/licenses/MIT)
[![ChatGPT](https://img.shields.io/badge/ChatGPT-available-brightgreen.svg?logo=image/svg%2bxml;base64,PHN2ZyByb2xlPSJpbWciIHZpZXdCb3g9IjAgMCAyNCAyNCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48dGl0bGU+T3BlbkFJPC90aXRsZT48cGF0aCBmaWxsPSIjRkZGRkZGIiBkPSJNMjIuMjgxOSA5LjgyMTFhNS45ODQ3IDUuOTg0NyAwIDAgMC0uNTE1Ny00LjkxMDggNi4wNDYyIDYuMDQ2MiAwIDAgMC02LjUwOTgtMi45QTYuMDY1MSA2LjA2NTEgMCAwIDAgNC45ODA3IDQuMTgxOGE1Ljk4NDcgNS45ODQ3IDAgMCAwLTMuOTk3NyAyLjkgNi4wNDYyIDYuMDQ2MiAwIDAgMCAuNzQyNyA3LjA5NjYgNS45OCA1Ljk4IDAgMCAwIC41MTEgNC45MTA3IDYuMDUxIDYuMDUxIDAgMCAwIDYuNTE0NiAyLjkwMDFBNS45ODQ3IDUuOTg0NyAwIDAgMCAxMy4yNTk5IDI0YTYuMDU1NyA2LjA1NTcgMCAwIDAgNS43NzE4LTQuMjA1OCA1Ljk4OTQgNS45ODk0IDAgMCAwIDMuOTk3Ny0yLjkwMDEgNi4wNTU3IDYuMDU1NyAwIDAgMC0uNzQ3NS03LjA3Mjl6bS05LjAyMiAxMi42MDgxYTQuNDc1NSA0LjQ3NTUgMCAwIDEtMi44NzY0LTEuMDQwOGwuMTQxOS0uMDgwNCA0Ljc3ODMtMi43NTgyYS43OTQ4Ljc5NDggMCAwIDAgLjM5MjctLjY4MTN2LTYuNzM2OWwyLjAyIDEuMTY4NmEuMDcxLjA3MSAwIDAgMSAuMDM4LjA1MnY1LjU4MjZhNC41MDQgNC41MDQgMCAwIDEtNC40OTQ1IDQuNDk0NHptLTkuNjYwNy00LjEyNTRhNC40NzA4IDQuNDcwOCAwIDAgMS0uNTM0Ni0zLjAxMzdsLjE0Mi4wODUyIDQuNzgzIDIuNzU4MmEuNzcxMi43NzEyIDAgMCAwIC43ODA2IDBsNS44NDI4LTMuMzY4NXYyLjMzMjRhLjA4MDQuMDgwNCAwIDAgMS0uMDMzMi4wNjE1TDkuNzQgMTkuOTUwMmE0LjQ5OTIgNC40OTkyIDAgMCAxLTYuMTQwOC0xLjY0NjR6TTIuMzQwOCA3Ljg5NTZhNC40ODUgNC40ODUgMCAwIDEgMi4zNjU1LTEuOTcyOFYxMS42YS43NjY0Ljc2NjQgMCAwIDAgLjM4NzkuNjc2NWw1LjgxNDQgMy4zNTQzLTIuMDIwMSAxLjE2ODVhLjA3NTcuMDc1NyAwIDAgMS0uMDcxIDBsLTQuODMwMy0yLjc4NkE0LjUwNCA0LjUwNCAwIDAgMSAyLjM0MDggNy44NzJ6bTE2LjU5NjMgMy44NTU4TDEzLjEwMzggOC4zNjQgMTUuMTE5MiA3LjJhLjA3NTcuMDc1NyAwIDAgMSAuMDcxIDBsNC44MzAzIDIuNzkxM2E0LjQ5NDQgNC40OTQ0IDAgMCAxLS42NzY1IDguMTA0MnYtNS42NzcyYS43OS43OSAwIDAgMC0uNDA3LS42Njd6bTIuMDEwNy0zLjAyMzFsLS4xNDItLjA4NTItNC43NzM1LTIuNzgxOGEuNzc1OS43NzU5IDAgMCAwLS43ODU0IDBMOS40MDkgOS4yMjk3VjYuODk3NGEuMDY2Mi4wNjYyIDAgMCAxIC4wMjg0LS4wNjE1bDQuODMwMy0yLjc4NjZhNC40OTkyIDQuNDk5MiAwIDAgMSA2LjY4MDIgNC42NnpNOCAzMDY1IDEyLjg2M2wtMi4wMi0xLjE2MzhhLjA4MDQuMDgwNCAwIDAgMS0uMDM4LS4wNTY3VjYuMDc0MmE0LjQ5OTIgNC40OTkyIDAgMCAxIDcuMzc1Ny0zLjQ1MzdsLS4xNDIuMDgwNUw4LjcwNCA1LjQ1OWEuNzk0OC43OTQ4IDAgMCAwLS4zOTI3LjY4MTd6bTEuMDk3Ni0yLjM2NTRsMi42MDItMS40OTk4IDIuNjA2OSAxLjQ5OTh2Mi45OTk0bC0yLjU5NzQgMS40OTk3LTIuNjA2Ny0xLjQ5OTdaIi8+PC9zdmc+)](https://chatgpt.com/)

⭐ Star this script if it helps you stay "active" during remote work! 🙏

[![Share](https://img.shields.io/badge/share-000000?logo=x&logoColor=white)](https://x.com/intent/tweet?text=Check%20out%20this%20smart%20AutoHotkey%20script%20that%20simulates%20user%20activity%20to%20fool%20employee%20monitoring%20tools!%20%23AutoHotkey%20%23Productivity%20%23RemoteWork)
[![Share](https://img.shields.io/badge/share-1877F2?logo=facebook&logoColor=white)](https://www.facebook.com/sharer/sharer.php?u=https://github.com/ajstyles903/work-activity-simulator)
[![Share](https://img.shields.io/badge/share-0A66C2?logo=linkedin&logoColor=white)](https://www.linkedin.com/sharing/share-offsite/?url=https://github.com/ajstyles903/work-activity-simulator)

> ⚠️ **Disclaimer**: This tool is intended **for educational and testing purposes only**. Misusing it to deceive time-tracking or productivity-monitoring software may violate your organization’s policies or employment agreements. Use responsibly and ethically.

---

## Table of Contents
- [About](#-about)
- [Features](#-features)
- [Hotkeys](#-hotkeys)
- [How It Works](#-how-it-works)
- [Use Cases & Ethical Note](#-use-cases--ethical-note)
- [Requirements](#-requirements)
- [Installation & Usage](#-installation--usage)
- [Customization](#-customization)
- [Compilation (EXE)](#-compilation-exe)
- [Feedback & Contributions](#-feedback-and-contributions)

---

## 🚀 About

**Work Activity Simulator** is a smart AutoHotkey v2 script that mimics real user input (mouse movement, scrolling, and keyboard presses) to prevent systems from detecting idle time. It includes **manual control modes** and an **auto-detection mode** that activates only when you’ve been truly idle for a configurable duration.

Designed with realism in mind, the script:
- Uses natural mouse movement algorithms (easing, micro-jitters).
- Randomizes timing and actions to avoid detection by monitoring software.
- **Ignores its own generated input** to avoid false activity loops.
- Supports multiple activation strategies: mouse-only, keyboard-only, or combined.

Ideal for developers, remote workers, or testers who need to keep systems awake during legitimate breaks—without triggering “idle” flags in monitoring tools.

---

## ✨ Features

- **Manual Control**: Trigger specific activity types on demand.
- **Auto Idle Detection**: Automatically starts simulating activity after 30 seconds of real inactivity.
- **Smart Input Filtering**: Ignores self-generated events to avoid feedback loops.
- **Natural Movements**: Mouse moves with human-like acceleration and randomness.
- **Configurable Thresholds**: Adjust idle time, activity intervals, and more.
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
| `Ctrl + Alt + X` | Exit the script entirely |

> 💡 Tray notifications confirm each action.

---

## 🔍 How It Works

1. **Activity Tracking**: The script monitors real user input (mouse clicks, keypresses, etc.).
2. **Idle Detection**: If no real input is detected for **30 seconds** (configurable), auto-mode activates.
3. **Simulation**: Performs randomized, human-like actions:
   - Mouse moves within screen bounds.
   - Scroll wheel activity (up/down).
   - Keyboard inputs (F-keys, arrows, Ctrl/Alt combos).
4. **Self-Awareness**: Uses a counter (`g_ignore_next_input`) to skip events it generates.
5. **Auto-Stop**: If real user input resumes, simulation stops immediately.

---

## 🧪 Use Cases & Ethical Note

### ✅ Legitimate Uses:
- Preventing screen lock during long-running processes.
- Keeping remote desktop sessions alive.
- Testing idle-detection logic in your own software.
- Simulating user presence during automated demos.

### ❌ Not For:
- Circumventing workplace productivity monitoring dishonestly.
- Violating company IT policies.
- Falsifying work hours or activity reports.

> ⚖️ **Always comply with your employer’s acceptable use policy.** This script is **not** a tool for deception—it’s a utility for edge-case automation.

---

## 🖥️ Requirements

- **Windows 7 or later**
- [AutoHotkey v2.0+](https://www.autohotkey.com/) installed
- Administrative rights (not required, but some monitoring tools may interfere)

---

## 📥 Installation & Usage

1. **Install AutoHotkey**  
   → Download from: [https://www.autohotkey.com/](https://www.autohotkey.com/)

2. **Save the script**  
   Copy the provided `.ahk` code into a file named `WorkActivitySimulator.ahk`.

3. **Run it**  
   Double-click the `.ahk` file to launch.

4. **Use hotkeys** to control behavior (see [Hotkeys](#-hotkeys)).

> 📝 The script runs silently in the system tray. Right-click the icon to exit or pause.

---

## 🛠️ Customization

You can tweak behavior by editing these global variables at the top of the script:

```ahk
global g_idle_threshold := 30000      ; Idle time in ms (default: 30 sec)
global g_ignore_next_input := 0       ; Input ignore counter (do not change unless debugging)
```

- Adjust g_idle_threshold to change auto-activation delay.
- Modify Random() ranges in activity functions to alter frequency or intensity.
- Add more keys to the ~key:: list if your workflow uses special keys.

---

## 📦 Compilation (EXE)
To run without AutoHotkey installed:

1. Right-click your .ahk file.
2. Select "Compile Script" (requires AutoHotkey Compiler ).
3. An .exe file is generated in the same folder.
>🔗 Compiler Info: 

> - Included with AutoHotkey v2 installation.
> - Docs: https://www.autohotkey.com/docs/v2/Scripts.htm#ahk2exe

>🔒 Note: Some antivirus tools flag compiled AHK scripts as suspicious (false positive). Always scan before distribution. 

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