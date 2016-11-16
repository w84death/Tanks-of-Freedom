extends Sprite

export var damaged = false
var max_frames

func check_destruction():
	if damaged:
		self.set_frame(randi() % max_frames)
	else:
		self.set_frame(0)

func set_damage():
	damaged = true

func _ready():
	randomize()
	max_frames = self.get_vframes() * self.get_hframes()
	check_destruction()
	pass


