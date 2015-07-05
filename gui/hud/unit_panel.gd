
var unit_panel

var unit_panel_extras
var unit_panel_extras_button
var unit_panel_name
var unit_panel_attack
var unit_panel_health
var unit_panel_action1
var unit_panel_action2

var unit = null

var background_extra_unit

func bind(hud_panel):
    self.unit_panel = hud_panel.get_node('unit_panel')

    self.unit_panel_extras = self.unit_panel.get_node('extras')
    self.unit_panel_extras_button = self.unit_panel.get_node('extras_button')
    self.unit_panel_name = self.unit_panel.get_node('name')
    self.unit_panel_attack = self.unit_panel.get_node('attack')
    self.unit_panel_health = self.unit_panel.get_node('health')

    self.background_extra_unit = hud_panel.get_node('background/unit_extra_panel')

    self.unit_panel_extras_button.connect('pressed', self, 'toggle_skills')

func bind_unit(unit_object):
    self.hide_skills()

    self.unit = unit_object
    self.update_hud()

func update_hud():
    self.set_attack(self.unit.attack)
    self.set_health(self.unit.life, self.unit.max_life)
    self.set_name(self.unit.type_name)

func unbind_unit():
    self.hide_skills()
    self.unit = null

func show():
    self.unit_panel.show()

func hide():
    self.unit_panel.hide()

func set_attack(value):
    self.unit_panel_attack.set_text(str(value))

func set_health(hp, max_hp):
    self.unit_panel_health.set_text(str(hp) + '/' + str(max_hp))

func set_name(value):
    self.unit_panel_name.set_text(value)

func toggle_skills():
    if self.unit_panel_extras.is_hidden():
        self.show_skills()
    else:
        self.hide_skills()

func show_skills():
    self.unit_panel_extras.show()
    self.background_extra_unit.show()

func hide_skills():
    self.unit_panel_extras.hide()
    self.background_extra_unit.hide()
