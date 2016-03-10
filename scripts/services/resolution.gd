
var root
var bag

const LOCKED_WIDTH = 1280
const MINIMAL_HEIGHT = 720

var locked_height
var native_resolution

var override_resolution
var resolution_override

const UNSET = 0
const LOCKED = 1
const UNLOCKED = 2

func _init_bag(bag):
    self.bag = bag
    self.root = bag.root
    self.native_resolution = OS.get_screen_size()
    self.override_resolution = Globals.get('tof/resolution_override')

    self.calculate_locked_height()
    self.check_initial_resolution()
    self.apply_resolution()

    #self.root.get_node("/root").connect("size_changed", self, "apply_resolution")

func calculate_locked_height():
    self.locked_height = Globals.get('display/height')

func check_initial_resolution():
    if self.root.settings['resolution'] != self.UNSET:
        return

    if self.native_resolution.y < self.MINIMAL_HEIGHT or self.native_resolution.x < self.LOCKED_WIDTH:
        self.root.settings['resolution'] = self.UNLOCKED
    else:
        self.root.settings['resolution'] = self.LOCKED

    self.root.write_settings_to_file()

func apply_resolution():
    var newsize
    var fullscreen = false

    if not self.override_resolution:
        #var width = Globals.get('display/width')
        #var height = Globals.get('display/height')
        #self.bag.hud_dead_zone.screen_size = Vector2(width, height)
        #self.bag.workshop_dead_zone.screen_size = Vector2(width, height)
        #OS.set_window_resizable(true)
        return

    if self.root.settings['resolution'] == self.UNLOCKED:
        newsize = self.native_resolution
        fullscreen = true
        if self.root.menu != null:
            self.root.menu.background_gradient.set_scale(Vector2(7, 7))
    else:
        newsize = Vector2(self.LOCKED_WIDTH, self.locked_height)
        if self.root.menu != null:
            self.root.menu.background_gradient.set_scale(Vector2(5, 5))

    OS.set_window_fullscreen(fullscreen)
    OS.set_video_mode(newsize, fullscreen, false)
    OS.set_window_size(newsize)

    self.bag.hud_dead_zone.screen_size = newsize
    self.bag.workshop_dead_zone.screen_size = newsize
    self.root.screen_size = newsize
    self.root.half_screen_size = newsize / 2

func toggle_resolution():
    if not self.override_resolution:
        return

    if self.root.settings['resolution'] == self.UNLOCKED:
        self.root.settings['resolution'] = self.LOCKED
    else:
        self.root.settings['resolution'] = self.UNLOCKED

    self.root.write_settings_to_file()
    self.apply_resolution()
