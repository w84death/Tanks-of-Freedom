
# Tanks of Freedom
## Changelog

### 0.3.6-beta
- Reworked Workshop, now for touch screens
  - more tiles available
  - LMB/touch dragging
  - undo shortcut: Z
  - camera centered
  - camera zoom same as in-game
  - placing fences/walls
  - new terrain type: dirt
- New Soundtrack, reworked units sounds
- Stats screen now shows different buttons depending on game type
- Extended colour palette to 32
- Reworked campaign difficulty levels
- Bridges
- Preventing clicks on map/workshop through HUD
- Cinematic camera for AI turn
- Camera follow toggle
- Game available in Google Play as Beta Access
- Modified units healthbars, removed ready indicator
- Better AI performance, not choking main thread as much
- Main menu background is now a custom map

### 0.3.5-beta

- removed terrain movement costs
- capturing tower now deplets unit AP
- redesigned main menu
- redesigned campaign menu
- redesigned in-game HUD
- redesigned stats screen
- introduced campaign progression - need to beat maps to unlock next
- fixed AI not being aggresive
- fixed AI mostly moving into bottom-right
- added scripts for automated builds
- added three starting custom maps
- demo mode now uses only custom maps
- added demo mode button to menu
- balanced units stats and field of view
- increased AP gain and units cost
- hidden AP gain under fog
- hidden HUD on CPU turn
- renamed Local Multiplayer to Skirmish
- code cleanup
- added CHANGELOG file

### 0.3.4-beta

- new main menu graphics
- moved human/cpu switches and campaign to the Local Multiplayer menu
- capturing towers no longer despawns soldier
- added new campaign maps
- added simple background stories to each campaign map
- moved old campaign maps out of the 0,0 corner
- modified position of barracks on campaign maps to be cost-effective
- modified edges of some maps for better road behaviour
- migrated game to Godot 1.1 version
- due to a problem in Godot 1.1, OUYA is not supported until further notice
- buildings next to the roads now only spawn small versions

### 0.3.3-beta

- added new campaign maps
- added surrounding water
- added fog of war
- ammended camera movements on cpu turn to account fog of war
- added possibility to place spawn point around the building
- locked resolution to 1280x720 and 720x720 (android only)
