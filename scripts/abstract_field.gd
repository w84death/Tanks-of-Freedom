var terrain_type
var positionVAR
var object = null
var damage = null
var abstract_map = null
var waypoint = null

var destroyed_tile_template = load("res://terrain/destroyed_tile.tscn")

func is_adjacent(field):
	var diff_x = abs(self.positionVAR.x - field.positionVAR.x)
	var diff_y = abs(self.positionVAR.y - field.positionVAR.y)

	return (diff_x + diff_y) == 1

func add_damage(damage_layer):
	self.damage = destroyed_tile_template.instance()
	var damage_frames = self.damage.get_vframes() * self.damage.get_hframes()
	var damage_frame = randi() % damage_frames

	self.add_damage_frame(damage_layer, damage_frame)

func add_damage_frame(damage_layer, damage_frame):
	self.damage = destroyed_tile_template.instance()
	damage_layer.add_child(damage)
	var damage_position = abstract_map.tilemap.map_to_world(self.positionVAR)
	damage_position.y += 8
	self.damage.set_position(damage_position)
	self.damage.set_frame(damage_frame)

func is_empty():
	return self.terrain_type < 0

func has_unit():
	if self.object == null:
		return false

	return self.object.group == 'unit'

func has_building():
	if self.object == null:
		return false

	return self.object.group == 'building'

func has_terrain():
	if self.object == null:
		return false

	return self.object.group == 'terrain'

func has_waypoint():
	return self.waypoint != null

func is_passable():
	if self.is_empty():
		return false
	if self.object != null:
		return false

	return true

func has_attackable_enemy(unit):
	if unit == null:
		return false

	if self.object != null and self.has_unit() and self.object.player != unit.player:
		if unit.can_attack() and unit.can_attack_unit_type(self.object):
			return true

	return false

func has_capturable_building(unit):
	if unit == null:
		return false

	if self.object != null and self.has_building() and self.object.player != unit.player:
		if unit.can_capture_building(self.object):
			return true

	return false

func get_neighbours():
	return [
		self.abstract_map.get_field(self.positionVAR + Vector2(0, -1)),
		self.abstract_map.get_field(self.positionVAR + Vector2(0, 1)),
		self.abstract_map.get_field(self.positionVAR + Vector2(-1, 0)),
		self.abstract_map.get_field(self.positionVAR + Vector2(1, 0))
	]

