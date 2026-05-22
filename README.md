- Preview: https://youtu.be/6T7Gre6mgH0
- Tebex Shop: https://r1-scripts.tebex.io/

# R1 Personal Menu

Personal menu for FiveM with player information, clothing toggles, vehicle options, car radio, clothing reload, animations, documents, and utilities.

## Installation

1. Place the `R1_PersonalMenu-main` folder in `resources`.

2. Rename the file from `R1_PersonalMenu-main` to `R1_PersonalMenu`.

3. Add in `server.cfg`:

```cfg
ensure R1_PersonalMenu
```
4. Run the sql.sql file on your database for identification and licensing.

## Quick setup

In `shared/config.lua`:

```lua
Config.Framework = 'esx' -- 'esx', 'qb', 'standalone'
Config.OpenKey = 'G'
Config.Command = 'personalmenu'
```

## Configurable systems

```lua
Config.Commands = {
    { command = 'carradio', label = 'Car Radio' },
    { command = 'reloadskin', label = 'Reiniciar Ped' },
    { command = 'hud', label = 'HUD' },
    { command = 'report', label = 'Reporte' }
}

Config.ServerNationality = 'R SCRIPTS'
```

Supported systems for reload skin:

- `illenium`
- `esx_skin`
- `fivem-appearance`
- `command`

## Notifications

```lua
Config.Notify = 'chat' -- 'chat', 'ox', 'r1', 'none'
```

<img width="1090" height="665" alt="image" src="https://github.com/user-attachments/assets/d2eacd37-0c0a-4fca-8b49-7581d200d25d" />
