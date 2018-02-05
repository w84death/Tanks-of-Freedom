
# Tanks of Freedom
## Changelog

### 0.7.0-beta
- scripted map events in campaign
- integrated RU language
- updated AI for better performance
- updated Settings UI and UI graphics
- updated to Godot 2.1.4 (2.1.2 or newer required)
- added camera dragging with right mouse button
- added loading screen when map is being built
- added AI speed settings
- added camera speed settings
- camera going to HQ at the start of each turn now can be disabled
- tooltips at the start of each turn now can be disabled
- fixed a crash when unit had map boundary in movement range
- fixed accidental menu clicks when skipping intro
- fixed a bug where touching edge of screen would send the camera far away
- fixed huge amount of errors being printed into the console

### 0.6.3-beta
- added 'back' behaviour to most menus
- moved gamepad end-turn indicator, to end-turn button
- integrated JA language thanks to naofum
- fixed crash when pressing P in menus while game is paused
- fixed bad background on skirmish setup 'back' button
- fixed ui_accept button not working on android

### 0.6.2-beta
- fixed gamebreaking bug with theme timing
- you can now move camera in online multiplayer while waiting for opponent
- added visual distincion on tile edges for large bridges
- made map MayDay prettier
- added replay for online games that has been lost
- added link to online map browser in menu

### 0.6.1-beta
- game now download 6 stock maps in the background after player is registered
- workshop 'Play' changed to 'Test'
- currently picked block in workshop now has own panel to make it more readable
- testing map from workshop now removes fog
- updated Online menu Help
- fixed building spawn detection to pick empty tile if default one is empty
- updated translations docs
- reduced FPS for Android to 30 for battery conservation
- updated resources export settings to not pull not needed files


### 0.6.0-beta
- added online multiplayer
- fixed crash when pressing 'buy' button on gamepad without active field
- improved English translation
- added German translation
- campaign mission 3 now has tank factory and extra tank on start
- modified input prompt for Android to not be covered by keyboard
- added information about blocked building spawn
- fixed broken road pieces on Airplane and Recapture
- fixed a bug where user could not do anything when trying to upload a map with empty list
- fixed game crash when pressing 'end turn' with analog stick off-centre
- fixed gamepad controlls not working after entering workshop
- fixed broken paging on remote maps list
- disabled overscan for android
- enabled screen rotation for android

### 0.5.3-beta
- workshop fill now places plains
- improved French translation
- added more configuration options for server

### 0.5.2-beta
- added changing terrain and city tiles to seasons
- added SSL to all online communication
- added gamepad controls screen
- added theme selector to workshop toolbox
- modified menu timer to start Fall a month later
- modified Pandora layout to maximize map view
- translated campaign mission descriptions to Polish
- game should now not quit when using 'back' on android devices
- lowered resolution for Android to make game more eligible on phones
- camera movements are more dynamic
- fixed some labels in menus not having non-latin chars
- fixed some labels changing positions when too long text was set
- fixed many translation errors in PL and EN
- fixed background gradient not expanding when game starts in fullscreen
- fixed crash when trying to use Online Menu functions
- fixed map name not being shown correctly in-game
- fixed skirmish maps defaulting to Fall
- fixed replay not working on remote maps
- fixed crash caused by using gamepad
- fixed gamepad tooltips always showing as OUYA
- changed Player registration to not block rendering

### 0.5.1.1-beta
- hotfixed engine config for android not loading translations

### 0.5.1-beta
- ported project to Godot 2.1-stable
- added seasons to campaign missions
- added partial French and Polish language
- reworked all labels to use new font support
- added Overscan setting for TV setups
- OUYA style button help will show when using OUYA gamepad
- added clear indication which team won the battle
- re-added zoom buttons and mouse scroll zoom
- added specific gamepad binds for Pandora
- fixed Settings button not working correctly when playing from Workshop
- fixed ground damage not being preserved on save/resume
- fixed missing screenshake when units are destroyed
- fixed missing tips when list runs out and cycles back

### 0.5.0-beta
- engine updated to Godot 2.0.2
- added online map sharing
- added new skirmish map: split
- added new skirmish map: territorial
- added secondary map list for downloaded maps
- streamlined menu buttons for easier navigation with gamepad
- added new menu soundtrack
- added XBOX gamepad button indicators while in game
- updated in-game building card to be more readable
- updated map file format to add space for data other than tiles
- fixed a bug where AI would sometimes try to walk a tank/heli through a building
- fixed a bug where mouse had an offset when game resolution changed
- fixed a bug where cinematic bars were too short on higher resolutions
- fixed minor errors in few campaign maps
- fixed minor errors in few skirmish maps
- reduced a number of AI starting units in mission 8
- added feature toggles for online, workshop and save/resume
- added documentation for making community ports


### 0.4.2-beta
- ported game source to Godot 2.0
- added gamepad support
  - refer to README.md for details
  - not available in OSX version
- added battle stats to pause/resume
- added keyboard B hotkey to center camera on map
- fixed error message in workshop being trimmed
- fixed some river tiles not matching each other

### 0.4.1-beta
- native resolution mode (not available for android)
- settings for AI difficulty
- resume game (limited save/load)
- added click sounds to all buttons
- 'camera follow' is now always on in CPU vs CPU
- games started from Workshop now return to Workshop instead of Main Menu
- fixed clicking on 'change tile' button in workshop placing tiles underneath it
- fixed custom map list not refreshing when new map is saved
- fixed workshop popup showing 'Start turn' button
- removed export configs for Android with 1:1 screen ratio

### 0.4.0.3-beta
- fixed AI locking-up by tank or heli trying to capture building when there are no enemies nearby
- fixed AI-owned buildings not revealing fog of war in Demo mode

### 0.4.0.2-beta
- fixed menu background map positioning
- fixed movement tiles wrongly showing possible attack when there is not enough AP
- fixed data versioning file not recreating if it is removed
- improved waves
- fixed workshop land-fill tool
- fixed translations for tips not working after export
- fixed hud dead zone detection preventing units from entering certain parts of maps
- fixed camera zoom settings not being saved
- modified gui and menus to not overlap on low resolutions
- tuned down campaign difficulty
- added AI easy mode (not yet available)

### 0.4.0.1-beta
- fixed default zoom value

### 0.4.0-beta
- increased resolution of terrain tiles
- redesigned in-game gui
- fixed major AI locking issue
- many minor bugfixes and improvements
- reworked camera now using Godot camera funcionality
- added tips between turns

### 0.3.7-beta
- New units movement
  - units can move more tiles at once
  - valid path, no longer than range, must exist
- CPU turn progress bar
- New custom map picker for Skirmish and Workshop
- Human/CPU switches for Play option in Workshop
- Remove map option for Workshop
- Unit/Building deselect when clicking on empty tile
- Fixed building capture indicator showing under buildings
- Fixed clicks through HUD on Android devices
- Click/Drag threshold added to prevent accidental unit actions
- Fixed Human/CPU settings not saving after switch
- Updated mission briefings in campaign
- Fixed map saved popup in Workshop
- Fixed underground not showing correctly near bridges

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
