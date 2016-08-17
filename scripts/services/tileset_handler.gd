var available_tilesets = {
    'summer' : preload("res://maps/tilesets/summer_tileset.xml"),
    'fall'   : preload("res://maps/tilesets/fall_tileset.xml"),
    'winter' : preload("res://maps/tilesets/winter_tileset.xml")
}
var bag

func _init_bag(bag):
    self.bag = bag

func get_current_tileset():
    return available_tilesets['summer']


func comp_dates(date1, date2):
    var result = 0
    var params = ['year', 'month', 'day']

    for param in params:
        result = comp(date1[param], date2[param])
        if result != 0:
            return result

func comp(a, b):
    return clamp(a - b , -1, 1)
