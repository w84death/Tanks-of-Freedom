
var bag

var turn_info
var end_turn
var zoom_panel

var info_panel_end_button
var info_panel_blink_label
var info_panel_blink_led
var info_panel_blink_led_anim
var info_panel_turn
var info_panel_ap
var info_panel_pap
var info_panel_map_name
var info_panel_team_blue
var info_panel_team_red

var zoom_panel_zoom_in
var zoom_panel_zoom_out

const MAP_NAME_LENGTH = 17

func _init_bag(bag):
    self.bag = bag

func bind(end_turn_panel_scene, info_panel_scene, zoom_panel_scene):
    self.turn_info = info_panel_scene
    self.end_turn = end_turn_panel_scene
    self.zoom_panel = zoom_panel_scene
    self.info_panel_turn = self.end_turn.get_node('turn')
    self.info_panel_end_button = self.end_turn.get_node('end_turn_button')
    self.info_panel_blink_label = self.end_turn.get_node('end_turn_text')
    self.info_panel_blink_led = self.end_turn.get_node('end_turn_led')
    self.info_panel_blink_led_anim = self.info_panel_blink_led.get_node('anim')
    self.info_panel_ap = self.turn_info.get_node('ap')
    self.info_panel_pap = self.turn_info.get_node('pap')
    self.info_panel_map_name = self.turn_info.get_node('map_name')
    self.info_panel_team_blue = self.turn_info.get_node('current_blue')
    self.info_panel_team_red = self.turn_info.get_node('current_red')

    self.zoom_panel_zoom_in = self.zoom_panel.get_node('zoom_in')
    self.zoom_panel_zoom_in.connect('pressed', self.bag.camera, 'camera_zoom_in')
    self.zoom_panel_zoom_out = self.zoom_panel.get_node('zoom_out')
    self.zoom_panel_zoom_out.connect('pressed', self.bag.camera, 'camera_zoom_out')

func bind_end_turn(controller, method_name):
    self.info_panel_end_button.connect('pressed', controller, method_name)

func show():
    self.turn_info.show()
    self.end_turn.show()
    self.zoom_panel.show()

func hide():
    self.turn_info.hide()
    self.end_turn.hide()
    self.zoom_panel.hide()

func reset():
    self.end_button_enable()
    self.set_turn(1)
    self.set_ap(0)
    self.set_ap_gain(0)
    self.end_button_enable()

func set_ap(ap):
    self.info_panel_ap.set_text(str(ap))

func set_ap_gain(ap_gain):
    self.info_panel_pap.set_text('+' + str(ap_gain))

func set_map_name(name):
    if name.length() > self.MAP_NAME_LENGTH:
        name = name.substr(0, self.MAP_NAME_LENGTH - 3) + "..."
    self.info_panel_map_name.set_text(str(name))

func set_turn(turn, max_turn=null):
    var display = str(turn)
    if max_turn != null && max_turn > 0:
        display = display + '/' + str(max_turn)
    info_panel_turn.set_text(display)

func end_button_pressed():
    self.end_button_disable()

func end_button_toggle():
    if self.info_panel_end_button.is_disabled():
        self.end_button_enable()
    else:
        self.end_button_disable()

func end_button_enable():
    info_panel_end_button.set_disabled(false)
    self.info_panel_blink_message(false, tr('LABEL_PLAY'))

func end_button_disable():
    self.info_panel_end_button.set_disabled(true)
    self.info_panel_blink_message(true, tr('LABEL_WAIT'), 'blue')

func end_button_flash():
    info_panel_end_button.set_disabled(false)
    self.info_panel_blink_message(true, tr('LABEL_END'), 'red')

func info_panel_blink_message(blink, msg=false, colour=false):
    if blink:
        self.end_button_blink_animation(true, colour)
    else:
        self.end_button_blink_animation(false)

    if msg:
        self.info_panel_blink_label.set_text(msg)
    else:
        self.info_panel_blink_label.set_text('')

func end_button_blink_animation(run, colour=false):
    if run:
        if colour == 'red':
            self.info_panel_blink_led_anim.play('blink_red')
        elif colour == 'blue':
            self.info_panel_blink_led_anim.play('blink_blue')
        elif colour == 'green':
            self.info_panel_blink_led_anim.play('blink_green')
        else:
            self.info_panel_blink_led_anim.play('blink_red')
    else:
        self.info_panel_blink_led_anim.stop()
        self.info_panel_blink_led.set_frame(0)

func info_panel_set_current_team(team):
    if team == 0:
        self.info_panel_team_blue.show()
        self.info_panel_team_red.hide()
    if team == 1:
        self.info_panel_team_blue.hide()
        self.info_panel_team_red.show()
