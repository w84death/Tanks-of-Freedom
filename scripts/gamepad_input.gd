
var bag

var accumulated_time = 0
var axis_controll = Vector2(0, 0)

const INPUT_DELAY = 0.2
const AXIS_ANGLE_THRESHOLD = 0.2
const AXIS_OVERALL_THRESHOLD = 0.5

var gamepad_detected = false
var painting = false
var erasing = false


func _init_bag(bag):
    self.bag = bag

func handle_input(event):
    if event.type == InputEvent.JOYSTICK_MOTION:
        self.handle_motion(event)
    elif event.type == InputEvent.JOYSTICK_BUTTON:
        self.handle_button(event)

    self.gamepad_detected = true

func handle_motion(event):
    if event.axis == 0:
        self.axis_controll.x = event.value
    elif event.axis == 1:
        self.axis_controll.y = event.value


func handle_button(event):
    if self.bag.workshop.is_working:
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

func process(delta):
    var selector_move = Vector2(0, 0)
    self.accumulated_time = self.accumulated_time + delta

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

    if self.bag.workshop.is_working:
        new_position = self.bag.workshop.selector_position + offset
        self.bag.workshop.set_selector_map_pos(new_position)
        self.bag.workshop.set_camera_map_pos(new_position)
        if self.painting:
            self.bag.workshop.paint(new_position)
        if self.erasing:
            self.bag.workshop.paint(new_position, 'terrain', -1)
    else:
        new_position = self.bag.root.selector_position + offset
        self.bag.root.move_selector_to_map_position(new_position)
        self.bag.camera.move_to_map(new_position)
