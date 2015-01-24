
var terrain_type
var position
var object = null

func is_adjacent(field):
	var diff_x = self.position.x - field.position.x
	var diff_y = self.position.y - field.position.y
	if diff_x < 0:
		diff_x = -diff_x
	if diff_y < 0:
		diff_y = -diff_y
	if diff_x + diff_y == 1:
		return true
	return false
