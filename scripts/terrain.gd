
extends Sprite
export var position_on_map = Vector2(0,0)
export var destructable = false
var current_map

var group = 'terrain'
var type
var damage = 0
export var smoke_particles = 16
export var smoke_lifetime = 1

var explosion_big_template = preload('res://particle/explosion_big.xscn')
var explosion

func get_pos_map():
	return position_on_map

func get_initial_pos():
	position_on_map = current_map.world_to_map(self.get_pos())
	return position_on_map

func set_pos_map(new_position):
	self.set_pos(current_map.map_to_world(new_position))
	position_on_map = new_position

func set_damage():
	if destructable and damage < 2:
		damage += 1
		var smoke = self.get_node("smoke")
		if smoke:
			smoke.show()
			smoke.set_lifetime(smoke_lifetime)
			smoke.set_amount(smoke_particles * damage)
			smoke.set_emitting(true)

		var region = self.get_region_rect()
		self.set_region_rect(Rect2(Vector2(region.pos.x, region.pos.y + 32), Vector2(region.size.x, region.size.y)))
		self.show_explosion()

func show_explosion():
	explosion = explosion_big_template.instance()
	explosion.unit = self
	self.add_child(explosion)

func clear_explosion():
	self.remove_child(explosion)
	explosion.queue_free()

func _ready():
	add_to_group("terrain")
	if get_node("/root/game"):
		current_map = get_node("/root/game").current_map_terrain
	pass



