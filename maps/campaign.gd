
var maps = [
    {'label': 'MayDay Square', 'player': 0, 'file': preload("res://maps/campaign/maidan.gd").new()},
    {'label': 'Eastern city', 'player': 0, 'file': preload("res://maps/campaign/eastern_city.gd").new()},
    {'label': 'Riots', 'player': 1, 'file': preload("res://maps/campaign/administration_riot.gd").new()},
    {'label': 'Base Assault', 'player': 1, 'file': preload("res://maps/campaign/base_assault.gd").new()},
    {'label': 'Peninsula', 'player': 1, 'file': preload("res://maps/campaign/peninsula.gd").new()},
]

func get_map_data(map_name):
    return maps[map_name]['file']

func get_map_player(map_name):
    return maps[map_name]['player']