
var build_card

var deploy_button
var deploy_button_label

var name
var attack
var health
var unit_range
var price
var no_enough_ap

func bind(build_card_node):
    self.build_card = build_card_node
    self.deploy_button = self.build_card.get_node('deploy_button')
    self.deploy_button_label = self.deploy_button.get_node('Label')

    self.name = self.build_card.get_node('unit_name')
    self.attack = self.build_card.get_node('attack')
    self.health = self.build_card.get_node('health')
    self.unit_range = self.build_card.get_node('range')
    self.price = self.build_card.get_node('price')
    self.no_enough_ap = self.build_card.get_node('no_ap')

func show():
    self.build_card.show()

func hide():
    self.build_card.hide()

func fill_card(unit, cost, player_ap):
    self.set_unit_name(unit.type_name)
    self.set_unit_price(cost)
    self.set_unit_stats(unit.attack, unit.life, unit.max_ap)
    if cost > player_ap:
        self.disable_button()
        self.no_enough_ap.show()
    else:
        self.enable_button()
        self.no_enough_ap.hide()

func bind_spawn_unit(controller, method_name):
    self.deploy_button.connect("pressed", controller, method_name)

func set_unit_name(name):
    self.name.set_text(name)

func set_unit_price(price):
    self.price.set_text("PRICE: "+ str(price) + "AP")

func set_unit_stats(attack, health, unit_range):
    self.attack.set_text("attack: " + str(attack))
    self.health.set_text("health: " + str(health))
    self.unit_range.set_text("range: " + str(unit_range))

func disable_button():
    self.deploy_button.set_disabled(true)
    self.deploy_button_label.hide()

func enable_button():
    self.deploy_button.set_disabled(false)
    self.deploy_button_label.show()