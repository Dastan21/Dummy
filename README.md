# DUMMY

DUMMY is an UNDERTALE fangame and battle engine, made with [LÖVE](https://love2d.org/).

## Download

Get the latest release [here](https://github.com/Dastan21/DUMMY/releases).

## Adding mods

Mods are located in the `mods` folder in the save directory (open the engine and select the option `Open mod folder`).

Folders and ZIP files are supported.

## Standalone

If you want to share your mod as a standalone:

1. Open `DUMMY.exe` as a ZIP archive ;
2. Copy your `assets` and `scripts` folders into the archive ;
   - Note: If your mod adds translations, you have to manually edit the engine's ones from `assets/langs/*.txt` and add your translations in the files, otherwise the engine's translations will be overwritten ;
3. Create a folder named `mods` in the archive ;
4. In `mod.lua`, set `standalone = true` in the mod constructor ;
5. Copy your `mod.lua` into the `mods` folder.

## Credits

Some assets are from [UNDERTALE](https://undertale.com) by Toby Fox.

Project inspired by [Kristal](https://github.com/KristalTeam/Kristal) and [CreateYourFrisk](https://github.com/RhenaudTheLukark/CreateYourFrisk).
