
extends Sprite

var positionVAR = self.get_pos()
var move_vector = Vector2(32,16)

func _input(event):
	if (Input.is_action_pressed('player1_up')):
		positionVAR -= Vector2(move_vector.x/2,move_vector.y/2)
		
	if (Input.is_action_pressed('player1_down')):
		positionVAR += Vector2(move_vector.x/2,move_vector.y/2)
		
	if (Input.is_action_pressed('player1_left')):
		positionVAR += Vector2(-move_vector.x/2,move_vector.y/2)
		
	if (Input.is_action_pressed('player1_right')):
		positionVAR += Vector2(move_vector.x/2,-move_vector.y/2)
		
	self.set_pos(positionVAR)
	
	#print ( 'selector pos: ',self.get_parent().get_parent().world_to_map(positionVAR) )
	#print(get_path())
	
func _ready():
	#set_process_input(true)
	pass


