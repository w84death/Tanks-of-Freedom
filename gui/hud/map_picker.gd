
var root
var bag

var picker = preload("res://gui/hud/skirmish_maps_panel.xscn").instance()
var block_template = preload("res://gui/hud/skirmish_maps_block.xscn")

var blocks_cache = []

var blocks_container
var delete_button
var next_button
var prev_button
var online_button
var online_button_label

var count_label
var page_label

var current_page = 1
var current_remote_page = 1
const PAGE_SIZE = 18
const OFFSET_X = 235
const OFFSET_Y = 30
const LABEL_LENGTH = 20

var current_container = null

var bound_object = null
var bound_method = null

var delete_mode_enabled = false
var remote_mode_enabled = false

func _init_bag(bag):
    self.bag = bag
    self.root = bag.root
    self.bind_hud()
    self.connect_buttons()
    self.fill_page()
    self.adjust_page_buttons()
    self.refresh_labels()

func bind_hud():
    self.blocks_container = self.picker.get_node("controls/blocks")
    self.delete_button = self.picker.get_node("controls/delete_mode")
    self.next_button = self.picker.get_node("controls/next")
    self.prev_button = self.picker.get_node("controls/prev")
    self.count_label = self.picker.get_node("controls/maps")
    self.page_label = self.picker.get_node("controls/page")
    self.online_button = self.picker.get_node("controls/online")
    self.online_button_label = self.online_button.get_node("Label")

    if not Globals.get('tof/online'):
        self.online_button.hide()

func connect_buttons():
    self.prev_button.connect("pressed", self, "_prev_button_pressed")
    self.next_button.connect("pressed", self, "_next_button_pressed")
    self.delete_button.connect("pressed", self, "_delete_button_pressed")
    self.online_button.connect("pressed", self, "_online_button_pressed")

func _prev_button_pressed():
    self.root.sound_controller.play('menu')
    self.prev_page()
func _next_button_pressed():
    self.root.sound_controller.play('menu')
    self.next_page()
func _delete_button_pressed():
    self.root.sound_controller.play('menu')
    self.delete_button_pressed()
func _online_button_pressed():
    self.root.sound_controller.play('menu')
    if self.remote_mode_enabled:
        self.switch_to_local_list()
    else:
        self.switch_to_remote_list()

func attach_panel(container_node):
    if self.current_container != null:
        self.detach_panel()
    self.current_container = container_node
    self.current_container.add_child(self.picker)
    self.fill_page()
    self.adjust_page_buttons()

func detach_panel():
    if self.current_container != null:
        self.current_container.remove_child(self.picker)
        self.current_container = null
    self.disconnect()
    self.disable_delete_mode()
    self.lock_delete_mode_button()
    self.enable_list_switch()
    self.picker.set_pos(Vector2(0, 0))

func fill_page():
    var maps_amount = self.get_maps_amount()
    var index
    var last_index
    var new_block
    var counter = 0

    if self.remote_mode_enabled:
        index = (self.current_remote_page - 1) * self.PAGE_SIZE
    else:
        index = (self.current_page - 1) * self.PAGE_SIZE
    last_index = index + self.PAGE_SIZE - 1

    if last_index > maps_amount - 1:
        last_index = maps_amount - 1

    self.clear_page()
    while index <= last_index:
        new_block = self.block_template.instance()
        self.blocks_cache.append(new_block)
        self.blocks_container.add_child(new_block)
        self.fill_block(new_block, self.get_map(index), counter)
        index = index + 1
        counter = counter + 1
    self.refresh_labels()


func clear_page():
    for block in self.blocks_cache:
        self.blocks_container.remove_child(block)
        block.queue_free()
    self.blocks_cache = []

func get_number_of_pages():
    var maps_amount = self.get_maps_amount()
    if maps_amount == 0:
        return 1
    var overflow = maps_amount % self.PAGE_SIZE
    var full_pages = (maps_amount - overflow) / self.PAGE_SIZE

    if overflow > 0:
        return full_pages + 1
    return full_pages

func get_maps_amount():
    if self.remote_mode_enabled:
        return self.bag.map_list.remote_maps.size()
    else:
        return self.bag.map_list.maps.size()

func get_map(index):
    var maps
    if self.remote_mode_enabled:
        maps = self.bag.map_list.remote_maps.keys()
    else:
        maps = self.bag.map_list.maps.keys()
    maps.sort()
    return maps[index]

func adjust_page_buttons():
    var pages = self.get_number_of_pages()
    var focus_next_button = false
    var current_mode_page

    if self.remote_mode_enabled:
        current_mode_page = self.current_remote_page
    else:
        current_mode_page = self.current_page

    if current_mode_page == 1:
        if self.prev_button.has_focus():
            focus_next_button = true
        self.button_enable_switch(self.prev_button, false)
    else:
        self.button_enable_switch(self.prev_button, true)

    if current_mode_page == pages:
        if self.next_button.has_focus() and not self.prev_button.is_disabled():
            self.prev_button.grab_focus()
        self.button_enable_switch(self.next_button, false)
    else:
        self.button_enable_switch(self.next_button, true)
        if focus_next_button:
            self.next_button.grab_focus()

    if self.remote_mode_enabled:
        self.online_button_label.set_text(tr('LABEL_REMOTE'))
    else:
        self.online_button_label.set_text(tr('LABEL_LOCAL'))

    self.prev_button.get_node('Label').set_text('LABEL_PREVIOUS')
    self.next_button.get_node('Label').set_text('LABEL_NEXT')

func next_page():
    var pages = self.get_number_of_pages()
    if self.current_page < pages:
        if self.remote_mode_enabled:
            self.current_remote_page = self.current_remote_page + 1
        else:
            self.current_page = self.current_page + 1
        self.adjust_page_buttons()
        self.fill_page()

func prev_page():
    if self.current_page > 1:
        if self.remote_mode_enabled:
            self.current_remote_page = self.current_remote_page - 1
        else:
            self.current_page = self.current_page - 1
        self.adjust_page_buttons()
        self.fill_page()

func button_enable_switch(button, show):
    if show:
        button.set_disabled(false)
        button.get_node('Label').show()
    else:
        button.set_disabled(true)
        button.get_node('Label').hide()

func fill_block(block, map, counter):
    var button = block.get_node("TextureButton")
    var label = str(map)
    if label.length() > self.LABEL_LENGTH:
        label = label.substr(0, self.LABEL_LENGTH - 3) + "..."
    button.get_node("title").set_text(label)
    button.connect("pressed", self, "map_selected", [map])

    var position = button.get_pos()
    if counter % 2 == 1:
        position.x = self.OFFSET_X
    position.y = 15 + ((counter - (counter % 2)) / 2) * self.OFFSET_Y
    block.set_pos(position)

func map_selected(name):
    self.root.sound_controller.play('menu')
    self.call_bound_object(name)

func connect(object, method):
    self.bound_object = object
    self.bound_method = method

func disconnect():
    self.bound_object = null
    self.bound_method = null

func call_bound_object(map_name):
    if self.bound_object != null:
        if not self.delete_mode_enabled:
            self.bound_object.call(self.bound_method, map_name, self.remote_mode_enabled)
        else:
            self.delete_map(map_name)

func refresh_labels():
    var maps_count = self.get_maps_amount()
    var max_pages = self.get_number_of_pages()
    self.count_label.set_text(str(maps_count))
    self.page_label.set_text(str(self.current_page) + '/' + str(max_pages))

func enable_delete_mode():
    self.delete_mode_enabled = true

func disable_delete_mode():
    self.delete_mode_enabled = false

func toggle_delete_mode():
    if self.delete_mode_enabled:
        self.disable_delete_mode()
    else:
        self.enable_delete_mode()

func unlock_delete_mode_button():
    self.button_enable_switch(self.delete_button, true)

func lock_delete_mode_button():
    self.button_enable_switch(self.delete_button, false)
    self.delete_button.set_pressed(false)

func is_attached_to(container_node):
    return self.current_container == container_node

func delete_map(map_name):
    if self.remote_mode_enabled:
        self.bag.map_list.remove_remote_map(map_name)
    else:
        self.bag.map_list.remove_map(map_name)
    self.fill_page()
    self.refresh_labels()
    self.adjust_page_buttons()

func delete_button_pressed():
    self.toggle_delete_mode()

func switch_to_remote_list():
    self.remote_mode_enabled = true
    self.fill_page()
    self.online_button_label.set_text(tr('LABEL_REMOTE'))
    self.adjust_page_buttons()

func switch_to_local_list():
    self.remote_mode_enabled = false
    self.fill_page()
    self.online_button_label.set_text(tr('LABEL_LOCAL'))
    self.adjust_page_buttons()

func disable_list_switch():
    self.button_enable_switch(self.online_button, false)

func enable_list_switch():
    self.button_enable_switch(self.online_button, true)
