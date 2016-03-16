
extends Sprite
export var destructable = false
export var fence = false
var current_map
var position_on_map = Vector2(0,0)
var group = 'terrain'
var particle_enabled = false
var snow_particles = []
var damage = 0
export var smoke_particles = 16
export var smoke_lifetime = 1
export var unique_type_id = -1

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
		self.set_region_rect(Rect2(Vector2(region.pos.x, region.pos.y + 64), Vector2(region.size.x, region.size.y)))
		self.show_explosion()

func show_explosion():
	explosion = explosion_big_template.instance()
	explosion.unit = self
	self.add_child(explosion)

func clear_explosion():
	self.remove_child(explosion)
	explosion.queue_free()

func connect_with_neighbours():
	var neighbours = 0 # neibours in binary
	var all_fences = get_tree().get_nodes_in_group("terrain_fence")
	var other_pos
	var this_pos

	this_pos = self.get_initial_pos()
	for fence in all_fences:
		other_pos = fence.get_initial_pos()
		if other_pos == this_pos + Vector2(-1, 0):
			neighbours += 2
		if other_pos == this_pos + Vector2(1, 0):
			neighbours += 4
		if other_pos == this_pos + Vector2(0, -1):
			neighbours += 8
		if other_pos == this_pos + Vector2(0, 1):
			neighbours += 16

	if neighbours in [2,4,6]:
		self.set_frame(1)
		return
	if neighbours in [8,16,24]:
		self.set_frame(0)
		return
	if neighbours in [10]:
		self.set_frame(2)
		return
	if neighbours in [12]:
		self.set_frame(3)
		return
	if neighbours in [20]:
		self.set_frame(4)
		return
	if neighbours in [18]:
		self.set_frame(5)
		return
	if neighbours in [26]:
		self.set_frame(6)
		return
	if neighbours in [14]:
		self.set_frame(7)
		return
	if neighbours in [28]:
		self.set_frame(8)
		return
	if neighbours in [22]:
		self.set_frame(9)
		return
	if neighbours in [30]:
		self.set_frame(10)
		return

func enable_snow_particle():
	for snow in self.snow_particles:
		snow.show()

func _ready():
	add_to_group("terrain")
	if get_node("/root/game"):
		current_map = get_node("/root/game").current_map_terrain

	if self.fence:
		add_to_group("terrain_fence")

	if self.particle_enabled:
		self.snow_particles.append(self.get_node("snow1"))
		self.snow_particles.append(self.get_node("snow2"))
		self.enable_snow_particle()
