
extends TextureButton

export var offset_x = 0
export var offset_y = 3

var label
var start_position

func press_label():
	label.set_pos(start_position + Vector2(offset_x,offset_y))

func release_label():
	label.set_pos(start_position)

func _ready():
	label = get_node("Label")
	start_position = label.get_pos()
	self.connect("pressed", self, "press_label")
	self.connect("released", self, "release_label")
	pass
	