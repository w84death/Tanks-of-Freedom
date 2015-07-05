
extends Control

var root
var background
var background_extra_unit
var background_extra_building_units
var background_extra_building_upgrades

var default_panel

var unit_panel
var unit_panel_extras
var unit_panel_extras_button
var unit_panel_name
var unit_panel_attack
var unit_panel_health
var unit_panel_action1
var unit_panel_action2

var building_panel
var building_panel_open_button
var building_panel_open_button_label
var building_panel_units_panel
var building_panel_upgrades_panel
var building_panel_units_panel_button
var building_panel_upgrades_panel_button

var info_panel
var info_panel_end_button
var info_panel_blink_label
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
	info_panel_blink_label = info_panel.get_node('end_turn_text')
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
	background_extra_building_units = background.get_node('building_extra_panel/units')
	background_extra_building_upgrades = background.get_node('building_extra_panel/upgrades')
	
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
	building_panel_units_panel = building_panel.get_node('extras/units')
	building_panel_upgrades_panel = building_panel.get_node('extras/upgrades')
	building_panel_units_panel_button = building_panel.get_node('units_button')
	building_panel_units_panel_button.connect('pressed',self,'building_panel_units_switch')
	building_panel_upgrades_panel_button = building_panel.get_node('upgrades_button')
	building_panel_upgrades_panel_button.connect('pressed',self,'building_panel_upgrades_switch')	
	
	#
	# UNIT PANEL
	#
	unit_panel = root.get_node('unit_panel')
	unit_panel_extras = unit_panel.get_node('extras')
	unit_panel_extras_button = unit_panel.get_node('extras_button')
	unit_panel_extras_button.connect('pressed',self,'unit_panel_extras_switch')
	unit_panel_name = unit_panel.get_node('name')
	unit_panel_attack = unit_panel.get_node('attack')
	unit_panel_health = unit_panel.get_node('health')
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
	self.info_panel_blink_message('WAIT','blue')

func end_button_enable(unlock):
	if unlock:
		info_panel_end_button.set_disabled(false)
		self.info_panel_blink_message('PLAY')

func info_panel_blink_message(msg=false, colour=false):
	if colour:
		self.end_button_blink_animation(true,colour)
	else:
		self.end_button_blink_animation(false)
	
	if msg:
		info_panel_blink_label.set_text(msg)
	else:
		info_panel_blink_label.set_text('')

func end_button_blink_animation(run, colour=false):
	if run:
		if colour=='red':
			info_panel_blink_led_anim.play('blink_red')
		elif colour=='blue':
			info_panel_blink_led_anim.play('blink_blue')
		elif colour=='green':
			info_panel_blink_led_anim.play('blink_green')
		else:
			info_panel_blink_led_anim.play('blink_red')
	else:
		info_panel_blink_led_anim.stop()
		info_panel_blink_led.set_frame(0)

func default_panel_visible(show):
	if show:
		default_panel.show()
	else:
		default_panel.hide()

#
# BUILDING PANEL
#
func building_panel_visible(show):
	self.building_panel_units_visible(false)
	self.building_panel_upgrades_visible(false)
	if show:
		building_panel.show()
	else:
		building_panel.hide()

func building_panel_units_visible(show):
	if show:
		building_panel_units_panel.show()
		background_extra_building_units.show()
	else:
		building_panel_units_panel.hide()
		background_extra_building_units.hide()

func building_panel_upgrades_visible(show):
	if show:
		building_panel_upgrades_panel.show()
		background_extra_building_upgrades.show()
	else:
		building_panel_upgrades_panel.hide()
		background_extra_building_upgrades.hide()
		
func building_panel_units_switch():
	if building_panel_units_panel.is_visible():
		self.building_panel_units_visible(false)
	else:
		self.building_panel_units_visible(true)

func building_panel_upgrades_switch():
	if building_panel_upgrades_panel.is_visible():
		self.building_panel_upgrades_visible(false)
	else:
		self.building_panel_upgrades_visible(true)


#
# UNIT PANEL
#
func unit_panel_init():
	self.unit_panel_set_attack('5')
	self.unit_panel_set_health('3','8')
	self.unit_panel_set_name('INANTRY')

func unit_panel_visible(show):
	if show:
		unit_panel.show()
		self.unit_panel_extras_visible(false)
	else:
		unit_panel.hide()
		self.unit_panel_extras_visible(false)
		
func unit_panel_extras_visible(show):
	if show:
		unit_panel_extras.show()
		background_extra_unit.show()
	else:
		unit_panel_extras.hide()
		background_extra_unit.hide()
		
func unit_panel_extras_switch():
	if unit_panel_extras.is_visible():
		self.unit_panel_extras_visible(false)
	else:
		self.unit_panel_extras_visible(true)

func unit_panel_set_attack(value):
	unit_panel_attack.set_text(value)

func unit_panel_set_health(hp,max_hp):
	unit_panel_health.set_text(hp+'/'+max_hp)

func unit_panel_set_name(value):
	unit_panel_name.set_text(value)


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
	self.info_panel_blink_message('NO AP','red')

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
	self.unit_panel_init()
	pass

#
# ///// END OF READY /////
#

