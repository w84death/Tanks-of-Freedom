
var maps = {
    'border' : preload("res://maps/campaign/border.gd").new(),
    'river' : preload("res://maps/campaign/river.gd").new(),
    'city' : preload("res://maps/campaign/city.gd").new(),
    'country' : preload("res://maps/campaign/country.gd").new()
}

func get_map_data(map_name):
    return maps[map_name]