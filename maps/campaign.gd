
var maps = [
    {'label': 'MayDay Square', 'player': 0, 'file': preload("res://maps/campaign/maidan.gd").new()},
    {'label': 'Eastern city', 'player': 0, 'file': preload("res://maps/campaign/eastern_city.gd").new()},
    {'label': 'Riots', 'player': 1, 'file': preload("res://maps/campaign/administration_riot.gd").new()},
    {'label': 'Base Assault', 'player': 1, 'file': preload("res://maps/campaign/base_assault.gd").new()},
    {'label': 'Peninsula', 'player': 1, 'file': preload("res://maps/campaign/peninsula.gd").new()},
    {'label': 'Recapture', 'player': 0, 'file': preload("res://maps/campaign/administration_recapture.gd").new()},
    {'label': 'Base Defence', 'player': 0, 'file': preload("res://maps/campaign/base_defence.gd").new()},
    {'label': 'Airport Pt.1', 'player': 1, 'file': preload("res://maps/campaign/airport_part_1.gd").new()},
    {'label': 'Airplane', 'player': 1, 'file': preload("res://maps/campaign/airplane.gd").new()},
]

func get_map_data(map_name):
    return maps[map_name]['file']

func get_map_player(map_name):
    return maps[map_name]['player']