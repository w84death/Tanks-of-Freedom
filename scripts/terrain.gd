
extends Sprite
export var destructable = false
export var fence = false
var current_map
var position_on_map = Vector2(0,0)
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

func connect_with_neighbours():
	var neighbours = 0 # neibours in binary
	var all_fences = get_tree().get_nodes_in_group("terrain_fence")
	var x = self.position_on_map.x
	var y = self.position_on_map.y
	for fence in all_fences:
		if fence.get_pos_map() == Vector(x-1, y):
			neighbours += 1
		if fence.get_pos_map() == Vector(x+1, y):
			neighbours += 3
		if fence.get_pos_map() == Vector(x, y-1):
			neighbours += 7
		if fence.get_pos_map() == Vector(x, y+1):
			neighbours += 15
	if neighbours in [1,3,4]:
		self.set_frame(1)
	if neighbours in [7,15,22]:
		self.set_frame(0)
	if neighbours in [16]:
		self.set_frame(2)
	if neighbours in [18]:
		self.set_frame(3)
	if neighbours in [10]:
		self.set_frame(4)
	if neighbours in [8]:
		self.set_frame(5)

func _ready():
	add_to_group("terrain")
	if get_node("/root/game"):
		current_map = get_node("/root/game").current_map_terrain
	if self.fence:
		add_to_group("terrain_fence")
		self.connect_with_neighbours()
	pass



