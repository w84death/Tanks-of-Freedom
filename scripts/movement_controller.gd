var tile_types = [
	'plain',
	'road',
	'road',
	'road',
	'road',
	'road',
	'road',
	'road',
	'river',
	'river',
	'river',
	'river',
	'river',
	'river',
	'river',
	'river',
	'road',
	'road'
]

func move_object(active_field, field):
	var action_cost = self.get_terrain_cost(from, self.get_terrain_type(to))
	var player_stats = from.object.get_stats()
	
	if (player_stats.ap >= action_cost):
		player_stats.ap = player_stats.ap - action_cost
		active_field.object.set_stats(player_stats)
		print ('AP:')
		print(player_stats.ap)
		
		to.object = from.object
		from.object = null
		to.object.set_pos_map(field.position)
		
		return true
	else:
		return false
		
func get_terrain_type(to):
	return tile_types[to.terrain_type]
	
func get_terrain_cost(from, terrain_type):
	var stats = from.object.get_stats()
	return stats[terrain_type]