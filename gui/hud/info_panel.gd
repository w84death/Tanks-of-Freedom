
var info_panel
var turn_info
var end_turn

var info_panel_end_button
var info_panel_blink_label
var info_panel_blink_led
var info_panel_blink_led_anim
var info_panel_turn
var info_panel_ap
var info_panel_pap
var info_panel_map_name

func bind(hud_panel):
    self.info_panel = hud_panel.get_node('info_panel')
    self.turn_info = self.info_panel.get_node('turn_info')
    self.end_turn = self.info_panel.get_node('end_turn')
    self.info_panel_turn = self.end_turn.get_node('turn')
    self.info_panel_end_button = self.end_turn.get_node('end_turn_button')
    self.info_panel_blink_label = self.end_turn.get_node('end_turn_text')
    self.info_panel_blink_led = self.end_turn.get_node('end_turn_led')
    self.info_panel_blink_led_anim = self.info_panel_blink_led.get_node('anim')
    self.info_panel_ap = self.turn_info.get_node('ap')
    self.info_panel_pap = self.turn_info.get_node('pap')
    self.info_panel_map_name = self.turn_info.get_node('map_name')

func bind_end_turn(controller, method_name):
    self.info_panel_end_button.connect('pressed', controller, method_name)

func show():
    self.info_panel.show()

func hide():
    self.info_panel.hide()

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
    self.info_panel_blink_message(false, 'PLAY')

func end_button_disable():
    self.info_panel_end_button.set_disabled(true)
    self.info_panel_blink_message(true, 'WAIT', 'blue')

func end_button_flash():
    info_panel_end_button.set_disabled(false)
    self.info_panel_blink_message(true, 'END', 'red')

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