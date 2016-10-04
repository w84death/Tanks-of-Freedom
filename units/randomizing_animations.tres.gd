func _ready():
	for unit in self.get_children():
		unit.get_node("anim").seek(randf())