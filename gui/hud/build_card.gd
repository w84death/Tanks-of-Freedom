
var build_card

var deploy_button
var deploy_button_label
var deploy_button_icon

var name
var unit_sprite
var attack
var health
var unit_range
var price
var no_enough_ap
var no_enough_ap_label

func bind(build_card_node):
	self.build_card = build_card_node
	self.deploy_button = self.build_card.get_node('deploy_button')
	self.deploy_button_label = self.deploy_button.get_node('Label')
	self.deploy_button_icon = self.deploy_button.get_node('gamepad_button')

	self.name = self.build_card.get_node('unit_name')
	self.unit_sprite = self.build_card.get_node('unit_sprite')
	self.attack = self.build_card.get_node('attack')
	self.health = self.build_card.get_node('health')
	self.unit_range = self.build_card.get_node('range')
	self.price = self.build_card.get_node('price')
	self.no_enough_ap = self.build_card.get_node('no_ap')
	self.no_enough_ap_label = self.no_enough_ap.get_node('no_ap')

func show():
	self.build_card.show()

func hide():
	self.build_card.hide()

func fill_card(unit, cost, player_ap, spawn_field):
	self.set_unit_name(unit.get_type_name())
	self.set_unit_sprite(unit.type, unit.player)
	self.set_unit_price(cost)
	self.set_unit_stats(unit.attack, unit.life, unit.max_ap)
	self.check_block_conditions(cost,player_ap, spawn_field)

func check_block_conditions(cost, player_ap, spawn_field):
	self.enable_button()
	self.no_enough_ap.hide()

	if cost > player_ap:
		self.disable_button()
		self.no_enough_ap.show()
		self.no_enough_ap_label.set_text(tr('MSG_NO_ENOUGH_AP'))
	elif spawn_field != null and spawn_field.object != null:
		self.disable_button()
		self.no_enough_ap.show()
		self.no_enough_ap_label.set_text(tr('MSG_SPAWN_BLOCKED'))

func bind_spawn_unit(controller, method_name):
	if not self.deploy_button.is_connected("pressed", controller, method_name):
		self.deploy_button.connect("pressed", controller, method_name)

func set_unit_name(name):
	self.name.set_text(name)

func set_unit_sprite(id, team):
	var new_frame = 0

	if team == 0:
		if id == 1:
			new_frame = 6
		if id == 2:
			new_frame = 12
	else:
		if id == 0:
			new_frame = 3
		if id == 1:
			new_frame = 9
		if id == 2:
			new_frame = 16
	self.unit_sprite.set_frame(new_frame)

func set_unit_price(price):
	self.price.set_text(str(price) + "AP")

func set_unit_stats(attack, health, unit_range):
	self.attack.set_text(tr('LABEL_UNIT_ATTACK') + ": " + str(attack))
	self.health.set_text(tr('LABEL_UNIT_HEALTH') + ": " + str(health))
	self.unit_range.set_text(tr('LABEL_UNIT_RANGE') + ": " + str(unit_range))

func disable_button():
	self.deploy_button.set_disabled(true)
	self.deploy_button_label.hide()

func enable_button():
	self.deploy_button.set_disabled(false)
	self.deploy_button_label.show()