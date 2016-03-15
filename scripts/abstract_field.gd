var terrain_type
var position
var object = null
var damage = null
var abstract_map = null

var destroyed_tile_template = preload("res://terrain/destroyed_tile.xscn")

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
	var damage_position = abstract_map.tilemap.map_to_world(self.position)
	damage_position.y += 8
	damage.set_pos(damage_position)

	var damage_frames = damage.get_vframes() * damage.get_hframes()
	var damage_frame = randi() % damage_frames
	damage.set_frame(damage_frame)

func is_passable():
	if self.terrain_type < 0:
		return false
	if self.object != null:
		return false

	return true

func has_attackable_enemy(unit):
	if unit == null:
		return false

	if self.object != null and self.object.group == 'unit' and self.object.player != unit.player:
		if unit.can_attack() and unit.can_attack_unit_type(self.object):
			return true

	return false

func has_capturable_building(unit):
	if unit == null:
		return false

	if self.object != null and self.object.group == 'building' and self.object.player != unit.player:
		if unit.can_capture_building(self.object):
			return true

	return false

func get_neighbours():
	return [
		self.abstract_map.get_field(Vector2(self.position.x, self.position.y - 1)),
		self.abstract_map.get_field(Vector2(self.position.x, self.position.y + 1)),
		self.abstract_map.get_field(Vector2(self.position.x - 1, self.position.y)),
		self.abstract_map.get_field(Vector2(self.position.x + 1, self.position.y))
	]
