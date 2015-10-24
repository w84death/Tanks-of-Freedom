
extends Sprite

var sprite_list = [8,10,11,12,13,14,15]
var r

func _ready():
  r = randi() % sprite_list.size()
  self.set_frame(sprite_list[r])
  pass


