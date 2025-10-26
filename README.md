# 🚔 Police Badge
FiveM QB-Core script that allows police officers to show their badge to an NPC driver and receive the car keys.

## Installation
1. Place `police-badge` into your `resources` folder.
2. Add `ensure police-badge` to your `server.cfg`.
3. Add this item to `qb-core/shared/items.lua`:
```lua
police_badge = { name = 'police_badge', label = 'Police Badge', weight = 0, type = 'item', image = 'police_badge.png', unique = true, useable = true, shouldClose = true, description = 'An official badge identifying you as a police officer.' },
```
4. Add `police_badge.png` into `qb-inventory/html/images/`. or  `qs-inventory/html/images/`

## Usage
- Must be a police officer.
- Use the `police_badge` item in front of an NPC-driven vehicle.
- NPC exits, hands over keys, and flees.

## Dependencies
- qb-core
- qb-vehiclekeys

## 📦 Features
✅ Police-only item (`police_badge`)  
✅ NPCs exit and hand over keys to the player  
✅ Integration with `qb-vehiclekeys` for key ownership  
✅ Realistic animations and distance checks  
✅ Safe for production servers (with sanity checks and job validation)

## 🪪 Credits

Script by Yooshy
Built for QB-Core Framework
Optimized and secured for RP environments.

## 📜 License

This resource is free for personal and RP server use.
Redistribution or resale is completly prohibited.
