var workshop
var root
var bag
var menu_controller
var background_map_controller
var workshop_enabled = false

func init_root(root_node):
    self.root = root_node  
    self.bag = self.root.bag
    self.workshop = self.bag.workshop
    self.menu_controller = self.bag.controllers.menu_controller
    self.workshop_enabled = Globals.get('tof/enable_workshop')
    self.background_map_controller = self.bag.controllers.background_map_controller

func enter_workshop():
    if self.workshop_enabled:
        self.root.unload_map()
        self.bag.match_state.reset()
        self.workshop.is_working = true
        self.workshop.is_suspended = false
        self.show_workshop()

func show_workshop():
    if self.workshop_enabled:
        self.menu_controller.hide()
        self.root.toggle_menu()
        self.workshop.show()
        self.workshop.units.raise()
        self.background_map_controller.hide_background_map()
        self.workshop.camera.make_current()
        self.bag.controllers.workshop_gui_controller.navigation_panel.block_button.grab_focus()

func hide_workshop():
    if self.workshop_enabled:
        self.workshop.hide()
        self.workshop.camera.clear_current()
        self.bag.camera.camera.make_current()
        self.menu_controller.show()
        if not self.root.is_map_loaded:
            self.background_map_controller.show_background_map()
        self.menu_controller.workshop_button.grab_focus()

func suspend_workshop():
    if self.workshop_enabled:
        self.workshop.hide()
        self.workshop.is_working = false
        self.workshop.is_suspended = true

func resume_map():
    if self.bag.saving == null:
        return
    self.bag.saving.load_state()
    self.root.toggle_menu()
    self.menu_controller.hide_maps_menu()
    __show_workshop()

func __show_workshop():
    if self.workshop_enabled:
        workshop.hide()
        workshop.is_working = false
        workshop.is_suspended = true