<img src="h4WK_EYe_ghidra.png" width="700" alt="H4WK EYe">

# H4WK EYe

An Android emulator for Windows, purpose-built for competitive mobile shooters.

H4WK EYe is not a stock emulator with a settings preset on top. The performance
work is done at the binary and DLL level, so the frame pacing, the input path,
and the render path are modified rather than merely configured. Install it, pick
a version of Android, and play.

## Download

Get the latest setup from [Releases](../../releases/latest). Extract the archive,
keep the files together, then run `Install H4WK EYe.cmd` and approve the
administrator prompt. It stages the engine images and starts the installer,
where you choose an install folder and the Android version.

Windows 10 64-bit or newer, plus a GPU with Vulkan support. Setup does not need
an internet connection - both engine images are bundled with the installer.

## Android versions

The installer lets you choose during setup:

- **Android 13** - the default, and the one to use for current titles.
- **Android 9** - a lighter image for lower-end machines.

## Features

### Performance
- Deep binary-level and DLL-level performance patches, not a settings preset.
- Smoothness pushed to the maximum, with the frame cap raised to 240 and a live
  FPS HUD.
- Vulkan rendering with software ASTC decoding.

### Aim and input
- Dedicated X and Y mouse sensitivity adjuster, with an MSI 4 sensitivity port.
- Aim shake and jitter corrected, and the auto sensitivity-high problem fixed.
- Stable aim holds up under sustained tracking.

### Tools (in-game overlay and sidebar)
- DLL injection and loader.
- Automatic registry applier: registry changes take effect without a restart.
- Enigma: a graphics, colour, and visual overhaul.
- Performance overlays and readouts.
- Key mapping, macros, and native gamepad mode.
- One-tap APK install from the sidebar.
- Bundled home screen and wallpaper.

## Updates

New versions are published under [Releases](../../releases/latest). Download the
new setup and run it over your existing install.

## Credits

Developed by Blaze-X and Romulus. The full list lives on the emulator's Credits
page and is driven by [special_thanks.json](special_thanks.json), so names can be
added or removed without shipping a new build.

## Support

Discord: [discord.gg/PzKAG83V7T](https://discord.gg/PzKAG83V7T)

## License

Proprietary. See [LICENSE](LICENSE).
