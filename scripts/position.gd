func _ready():
    pass
        
func abstract_position(position, move_vector):
	var xs = position.x - 16
	var ys = position.y - 154
	
	var x = (2*xs - 0) / 32
	var y = (2*ys - 0) / 16
	var yt =  (y + x) / 2
	var xt =  (y - x) / 2

	
	print(xt, '-', yt)
