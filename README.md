# FiboPlasma - KDE Plasma 6 Wallpaper Plugin

<img width="2880" height="1800" alt="image" src="https://github.com/user-attachments/assets/b4ee1a72-ff59-4cec-a762-bbfa2293b830" />


A Fibonacci clock wallpaper plugin for KDE Plasma 6. Uses Fibonacci numbers (1, 1, 2, 3, 5) to display the current time in a unique visual way.

## Features

- Fibonacci clock algorithm - represents time using colored blocks
- 4-color system: base (off), minute-only, hour-only, and both
- Multi-monitor support - displays a clock on each screen
- Customizable colors and gap spacing
- Works on both Wayland and X11
- Dynamic monitor hotplug support

## Requirements

- KDE Plasma 6.0 or later
- Qt 6.6 or later

## Installation

Install the plugin using kpackagetool6 assuming you are in the cloned directory:

```bash
kpackagetool6 --install . --type Plasma/Wallpaper
```

## Usage

1. Right-click on your desktop
2. Select "Configure Desktop and Wallpaper..."
3. In the wallpaper dropdown, select "FiboPlasma"
4. Customize the settings:
   - **Background Color**: The background color
   - **Base Color**: Color for unused blocks
   - **Minute Color**: Color for blocks representing minutes (×5)
   - **Hour Color**: Color for blocks representing hours
   - **Both Color**: Color for blocks representing both hours and minutes
   - **Gap Size**: Space between the Fibonacci blocks (0-20px)
   - **Clock Size**: How much of the screen the clock occupies (10-100%)

## How to Read the Clock

The clock uses 5 Fibonacci blocks (sizes 1, 1, 2, 3, 5) arranged in a specific pattern:
- Each block can show one of four states via color
- Red = minutes only (multiply by 5)
- Blue = hours only
- Green = both hours and minutes
- Gray = not used for current time

Time updates every 5 minutes. For example, if the 5-block is green, the 2-block is blue, and the 1-block is red, that's 5 hours + 5 minutes + 2 hours + 5 minutes = 7:10.

## Uninstallation

```bash
kpackagetool6 --remove com.example.fiboplasma --type Plasma/Wallpaper
```

## Development

You can customize the plugin by editing:
- `contents/ui/main.qml` - Main wallpaper and clock algorithm
- `contents/ui/config.qml` - Configuration UI
- `contents/config/config.xml` - Configuration schema
- `metadata.json` - Plugin metadata

The original C implementation using X11/Cairo can be found at https://github.com/hollorol/fiboBG

## License

GPL-3.0+
