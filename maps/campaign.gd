
var maps = [
    {'label': 'Border', 'file': preload("res://maps/campaign/border.gd").new()},
    {'label': 'River', 'file': preload("res://maps/campaign/river.gd").new()},
    {'label': 'City', 'file': preload("res://maps/campaign/city.gd").new()},
    {'label': 'Country', 'file': preload("res://maps/campaign/country.gd").new()}
]

func get_map_data(map_name):
    return maps[map_name]['file']