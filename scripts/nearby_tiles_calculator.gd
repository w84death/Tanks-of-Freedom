const MAX_RANGE = 10

func get_calculated_nearby_tiles():
	for distance in range(1, MAX_RANGE):

		var max_distance = distance *2 -1
		var tiles = []

		for x in range(-distance, distance + 1):
			for y in range(-distance, distance  + 1):
				# we are skipping current tile
				if (!(x == 0 && y == 0) && !(abs(x) + abs(y) > max_distance)):
					tiles.append(Vector2(x, y))

		#print(tiles)

	return [[[]]]
