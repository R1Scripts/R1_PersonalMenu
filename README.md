Preview: https://youtu.be/6T7Gre6mgH0

# R1 Personal Menu

Personal menu for FiveM with player information, clothing toggles, vehicle options, car radio, clothing reload, animations, documents, and utilities.

## Installation

1. Place the `R1_PersonalMenu` folder in `resources`.

2. Add in `server.cfg`:

```cfg
ensure R1_PersonalMenu
```

## Quick setup

In `shared/config.lua`:

```lua
Config.Framework = 'esx' -- 'esx', 'qb', 'standalone'
Config.OpenKey = 'G'
Config.Command = 'personalmenu'
```

## Use

- Configured key: `G`
- Command: `/personalmenu`

## Configurable systems

```lua
Config.CarRadio.command = 'carradio'
Config.ReloadSkin.system = 'illenium'
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
