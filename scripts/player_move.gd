
extends Sprite

var position = Vector2(16,154)
var move_vector = Vector2(32,16)

func _input(event):
	if (Input.is_action_pressed('player1_up')):
		position -= Vector2(move_vector.x/2,move_vector.y/2)
		
	if (Input.is_action_pressed('player1_down')):
		position += Vector2(move_vector.x/2,move_vector.y/2)
		
	if (Input.is_action_pressed('player1_left')):
		position += Vector2(-move_vector.x/2,move_vector.y/2)
		
	if (Input.is_action_pressed('player1_right')):
		position += Vector2(move_vector.x/2,-move_vector.y/2)
		
	self.set_pos(position)
	
func _ready():
	set_process_input(true)
	pass


