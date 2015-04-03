var terrain_type
var position
var object = null
var damage = null
var abstract_map = null

var destroyed_tile_template = preload("res://terrain/destroyed_tile.xscn")

func get_terrain_type():
	return terrain_type

func is_adjacent(field):
	var diff_x = self.position.x - field.position.x
	var diff_y = self.position.y - field.position.y
	if diff_x < 0:
		diff_x = -diff_x
	if diff_y < 0:
		diff_y = -diff_y
	if diff_x + diff_y == 1:
		return true
	return false

func add_damage(damage_layer):
	damage = destroyed_tile_template.instance()
	damage_layer.add_child(damage)
	var damage_position = abstract_map.tilemap.map_to_world(position)
	damage_position.y += 8
	damage.set_pos(damage_position)
