
var maps = [
    {'label': 'MayDay Square', 'player': 0, 'file': preload("res://maps/campaign/maidan.gd").new()},
    {'label': 'Eastern city', 'player': 0, 'file': preload("res://maps/campaign/eastern_city.gd").new()},
    {'label': 'Riots', 'player': 1, 'file': preload("res://maps/campaign/administration_riot.gd").new()},
    {'label': 'Border', 'player': 0, 'file': preload("res://maps/campaign/border.gd").new()},
    {'label': 'River', 'player': 0, 'file': preload("res://maps/campaign/river.gd").new()},
    {'label': 'City', 'player': 0, 'file': preload("res://maps/campaign/city.gd").new()},
    {'label': 'Country', 'player': 0, 'file': preload("res://maps/campaign/country.gd").new()}
]

func get_map_data(map_name):
    return maps[map_name]['file']

func get_map_player(map_name):
    return maps[map_name]['player']