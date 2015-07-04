
extends Control

var root
var background
var background_extra_unit
var background_extra_building

var default_panel

var unit_panel
var unit_panel_extras

var building_panel
var building_panel_extras

var info_panel
var info_panel_end_button
var info_panel_blink_text
var info_panel_blink_led
var info_panel_blink_led_anim
var info_panel_turn
var info_panel_ap
var info_panel_pap

var debug_button1
var debug_button2
var debug_button3
var debug_button4

#
# ---- INIT -----
#
func init_nodes(root_node):
	root = root_node
	
	#
	# INFO PANEL
	#
	info_panel = root.get_node('info_panel')
	info_panel_end_button = info_panel.get_node('end_turn_button')
	info_panel_blink_text = info_panel.get_node('end_turn_text')
	info_panel_blink_led = info_panel.get_node('end_turn_led')
	info_panel_blink_led_anim = info_panel_blink_led.get_node('anim')
	info_panel_end_button.connect('pressed',self,'end_button_pressed')
	info_panel_ap = info_panel.get_node('ap')
	info_panel_pap = info_panel.get_node('pap')
	info_panel_turn = info_panel.get_node('turn')
	
	#
	# BACKGROUNDS
	#
	background = root.get_node('background')
	background_extra_unit = background.get_node('unit_extra_panel')
	background_extra_building = background.get_node('building_extra_panel')
	
	
	#
	# DEFAULT PANEL
	#
	default_panel = root.get_node('default_panel')
	
	
	#
	# UNIT PANEL
	#
	unit_panel = root.get_node('unit_panel')

	#
	# BUILDING PANEL
	#
	building_panel = root.get_node('building_panel')
	
	#
	# DEBUG
	#
	debug_button1 = info_panel.get_node('debug_button1')
	debug_button2 = info_panel.get_node('debug_button2')
	debug_button3 = info_panel.get_node('debug_button3')
	debug_button4 = info_panel.get_node('debug_button4')
	debug_button1.connect('pressed',self,'debug_button1_pressed')
	debug_button2.connect('pressed',self,'debug_button2_pressed')
	debug_button3.connect('pressed',self,'debug_button3_pressed')
	debug_button4.connect('pressed',self,'debug_button4_pressed')
	
#
# ///// END OF INIT /////
#

#
# ---- HELPERS -----
#
#
# INFO PANEL
#
func init_info_panel():
	info_panel.show()
	self.end_button_enable(true)
	self.info_panel_set_turn('1/50')
	self.info_panel_set_ap('12')
	self.info_panel_set_pap('+4')

func info_panel_set_ap(ap):
	info_panel_ap.set_text(ap)

func info_panel_set_pap(pap):
	info_panel_pap.set_text(pap)

func info_panel_set_turn(turn):
	info_panel_turn.set_text(turn)
	
func end_button_pressed():
	info_panel_end_button.set_disabled(true)
	self.info_panel_blink_message(true,'WAIT')

func end_button_enable(unlock):
	if unlock:
		info_panel_end_button.set_disabled(false)
		self.info_panel_blink_message(false,'PLAY')

func info_panel_blink_message(blink,msg=false):
	if blink:
		self.end_button_blink_animation(true)
	else:
		self.end_button_blink_animation(false)
	
	if msg:
		info_panel_blink_text.set_text(msg)
	else:
		info_panel_blink_text.set_text('')

func end_button_blink_animation(run):
	if run:
		info_panel_blink_led_anim.play('blink')
	else:
		info_panel_blink_led_anim.stop()
		info_panel_blink_led.set_frame(0)

func default_panel_visible(show):
	if show:
		default_panel.show()
	else:
		default_panel.hide()

func unit_panel_visible(show):
	if show:
		unit_panel.show()
		background_extra_unit.show()
	else:
		unit_panel.hide()
		background_extra_unit.hide()
		
func building_panel_visible(show):
	if show:
		building_panel.show()
		background_extra_building.show()
	else:
		building_panel.hide()
		background_extra_building.hide()

#
# DEBUG
#
func debug_button1_pressed():
	self.end_button_enable(true)
	self.default_panel_visible(true)
	self.unit_panel_visible(false)
	self.building_panel_visible(false)
	self.info_panel_set_ap('12')

func debug_button2_pressed():
	self.default_panel_visible(false)
	self.unit_panel_visible(true)
	self.building_panel_visible(false)
	
func debug_button3_pressed():
	self.default_panel_visible(false)
	self.unit_panel_visible(false)
	self.building_panel_visible(true)

func debug_button4_pressed():
	self.info_panel_set_ap('0')
	self.info_panel_blink_message(true,'NO AP!')

#
# ///// END OF HELPERS /////
#

#
# ---- READY -----
#
func _ready():
	# Initialization here
	
	self.init_nodes(self)
	self.init_info_panel()
	pass

#
# ///// END OF READY /////
#

