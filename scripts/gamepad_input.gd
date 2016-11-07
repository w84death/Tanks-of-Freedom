
var bag

var accumulated_time = 0
var axis_controll = Vector2(0, 0)

const INPUT_DELAY = 0.2
const AXIS_ANGLE_THRESHOLD = 0.2
const AXIS_OVERALL_THRESHOLD = 0.5

var gamepad_detected = false
var ouya_gamepad_detected = false
var painting = false
var erasing = false

var gamepad_icons_boxes = [
    'message_card/center/message/button/Sprite',
    'top_center/center/game_card/gamepad_buttons'
]

var gamepad_icons = [
    'message_card/center/message/button/Sprite',
    'top_center/center/game_card/gamepad_buttons/gamepad_button',
    'top_center/center/game_card/gamepad_buttons/gamepad_button2',
    'top_center/center/game_card/gamepad_buttons/gamepad_button3',
]


func _init_bag(bag):
    Input.add_joy_mapping("030000005e0400001907000000010000,X360 Wireless Controller,leftx:a0,lefty:a1,dpdown:h0.4,rightstick:b10,rightshoulder:b5,rightx:a3,start:b7,righty:a4,dpleft:h0.8,lefttrigger:a2,x:b2,dpup:h0.1,back:b6,leftstick:b9,leftshoulder:b4,y:b3,a:b0,dpright:h0.2,righttrigger:a5,b:b1,", true)
    self.bag = bag

func handle_input(event):
    if event.type == InputEvent.JOYSTICK_MOTION:
        self.handle_motion(event)
    elif event.type == InputEvent.JOYSTICK_BUTTON:
        self.handle_button(event)

    if not self.gamepad_detected:
        self.mark_gamepad(event)

func mark_gamepad(event):
    var pad_name = Input.get_joy_name(event.device)
    if self.is_ouya(pad_name):
        self.ouya_gamepad_detected = true
    self.gamepad_detected = true

func show_gamepad_icons():
    if not self.gamepad_detected:
        return

    if not self.bag.root.settings['seen_gamepad'] and not self.bag.root.is_pandora:
        self.bag.gamepad_popup.show()
        self.bag.root.settings['seen_gamepad'] = true
        self.bag.root.write_settings_to_file()

    if self.bag.root.hud == null:
        return

    var icon_node
    for icon in self.gamepad_icons_boxes:
        icon_node = self.bag.root.hud.get_node(icon)
        if icon_node != null:
            icon_node.show()
        else:
            print(icon)
    self.bag.controllers.hud_panel_controller.building_panel.build_card.deploy_button_icon.show()

    if self.ouya_gamepad_detected:
        self.switch_buttons_to_ouya()


func is_ouya(name):
    var validator = RegEx.new()
    validator.compile("(OUYA)")
    validator.find(name)
    var matches = validator.get_captures()

    if matches[1] == "OUYA":
        return true

    return false

func switch_buttons_to_ouya():
    var icon_sprite
    var offset = 4
    for icon in self.gamepad_icons:
        icon_sprite = self.bag.root.hud.get_node(icon)
        if icon_sprite != null:
            icon_sprite.set_frame(icon_sprite.get_frame() + offset)


func handle_motion(event):
    if event.axis == 0:
        self.axis_controll.x = event.value
    elif event.axis == 1:
        self.axis_controll.y = event.value


func handle_button(event):
    if self.bag.workshop.is_working and not self.bag.workshop.is_suspended:
        if event.button_index == JOY_BUTTON_2:
            if event.pressed:
                self.bag.root.sound_controller.play('menu')
                self.bag.workshop.paint(self.bag.workshop.selector_position)
            self.painting = event.pressed
        if event.button_index == JOY_BUTTON_3:
            if event.pressed:
                self.bag.root.sound_controller.play('menu')
                self.bag.workshop.paint(self.bag.workshop.selector_position, 'terrain', -1)
            self.erasing = event.pressed
    else:
        if Input.is_action_pressed('ui_accept'):
            if self.bag.root.selector_position != null:
                self.bag.root.action_controller.handle_action(self.bag.root.selector_position)
        if event.button_index == JOY_BUTTON_3 and event.pressed and not self.bag.root.hud_controller.hud_message_card_visible:
            self.bag.root.sound_controller.play('menu')
            self.bag.root.action_controller.end_turn()
        if event.button_index == JOY_BUTTON_2 and event.pressed:
            self.bag.root.sound_controller.play('menu')
            self.bag.root.action_controller.spawn_unit_from_active_building()
        if event.button_index == JOY_BUTTON_4 and event.pressed:
            self.bag.root.action_controller.switch_unit(self.bag.unit_switcher.BACK)
        if event.button_index == JOY_BUTTON_5 and event.pressed:
            self.bag.root.action_controller.switch_unit(self.bag.unit_switcher.NEXT)

func process(delta):
    var selector_move = Vector2(0, 0)
    self.accumulated_time = self.accumulated_time + delta

    if self.bag.root.is_locked_for_cpu:
        self.axis_controll = Vector2(0, 0)
        return

    if abs(axis_controll.x) < self.AXIS_ANGLE_THRESHOLD and abs(axis_controll.y) < self.AXIS_ANGLE_THRESHOLD:
        self.accumulated_time = 2*self.INPUT_DELAY
        return

    if not (abs(axis_controll.x) > self.AXIS_OVERALL_THRESHOLD or abs(axis_controll.y) > self.AXIS_OVERALL_THRESHOLD):
        return

    if self.accumulated_time > self.INPUT_DELAY:
        if self.axis_controll.x < -self.AXIS_ANGLE_THRESHOLD:
            selector_move = selector_move + Vector2(-1, 1)
        if self.axis_controll.x > self.AXIS_ANGLE_THRESHOLD:
            selector_move = selector_move + Vector2(1, -1)
        if self.axis_controll.y < -self.AXIS_ANGLE_THRESHOLD:
            selector_move = selector_move + Vector2(-1, -1)
        if self.axis_controll.y > self.AXIS_ANGLE_THRESHOLD:
            selector_move = selector_move + Vector2(1, 1)

        if selector_move.x > 1:
            selector_move.x = 1
        if selector_move.x < -1:
            selector_move.x = -1
        if selector_move.y > 1:
            selector_move.y = 1
        if selector_move.y < -1:
            selector_move.y = -1

        if selector_move.x != 0 or selector_move.y != 0:
            self.move_selector(selector_move)
        self.accumulated_time = 0

func move_selector(offset):
    var new_position

    if self.bag.workshop.is_working and not self.bag.workshop.is_suspended:
        new_position = self.bag.workshop.selector_position + offset
        self.bag.workshop.set_selector_map_pos(new_position)
        self.bag.workshop.set_camera_map_pos(new_position)
        if self.painting:
            self.bag.workshop.paint(new_position)
        if self.erasing:
            self.bag.workshop.paint(new_position, 'terrain', -1)
    else:
        var current_position = self.bag.root.selector_position
        if current_position != null:
            new_position = current_position + offset
            self.bag.root.move_selector_to_map_position(new_position)
            self.bag.camera.move_to_map(new_position)
