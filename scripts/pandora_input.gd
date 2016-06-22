
var bag

var accumulated_time = 0

var painting = false
var erasing = false

func _init_bag(bag):
    self.bag = bag

func handle_input(event):
    self.handle_button(event)

func handle_button(event):
    if self.bag.workshop.is_working:
        if event.scancode == KEY_HOME:
            if event.pressed:
                self.bag.root.sound_controller.play('menu')
                self.bag.workshop.paint(self.bag.workshop.selector_position)
            self.painting = event.pressed
        if event.scancode == KEY_PAGEUP:
            if event.pressed:
                self.bag.root.sound_controller.play('menu')
                self.bag.workshop.paint(self.bag.workshop.selector_position, 'terrain', -1)
            self.erasing = event.pressed
    else:
        if event.scancode == KEY_PAGEUP and event.pressed and not self.bag.root.hud_controller.hud_message_card_visible:
            self.bag.root.sound_controller.play('menu')
            self.bag.root.action_controller.end_turn()
        if event.scancode == KEY_HOME and event.pressed:
            self.bag.root.sound_controller.play('menu')
            self.bag.root.action_controller.spawn_unit_from_active_building()
        if event.scancode == KEY_SHIFT and event.pressed:
            self.bag.root.action_controller.switch_unit(self.bag.unit_switcher.BACK)
        if event.scancode == KEY_CONTROL and event.pressed:
            self.bag.root.action_controller.switch_unit(self.bag.unit_switcher.NEXT)