extends "res://scripts/bag_aware.gd"

var available_tilesets = {
	'summer' : load("res://maps/tilesets/summer_tileset.tres"),
	'fall'   : load("res://maps/tilesets/fall_tileset.tres"),
	'winter' : load("res://maps/tilesets/winter_tileset.tres")
}

var available_objects = {
	'summer' : {
		'movable' : load('res://terrain/tilesets/summer_movable.tscn'),
		'non-movable' : load('res://terrain/tilesets/summer_non_movable.tscn')
	},
	'fall' : {
		'movable' : load('res://terrain/tilesets/fall_movable.tscn'),
		'non-movable' : load('res://terrain/tilesets/fall_non_movable.tscn')
	},
	'winter' : {
		'movable' : load('res://terrain/tilesets/winter_movable.tscn'),
		'non-movable' : load('res://terrain/tilesets/winter_non_movable.tscn')
	}
}

var available_city = {
	'summer' : {
		'small' : [
			load('res://terrain/city/summer/city_small_1.tscn'),
			load('res://terrain/city/summer/city_small_2.tscn'),
			load('res://terrain/city/summer/city_small_3.tscn'),
			load('res://terrain/city/summer/city_small_4.tscn'),
			load('res://terrain/city/summer/city_small_5.tscn'),
			load('res://terrain/city/summer/city_small_6.tscn')
		],
		'large' : [
			load('res://terrain/city/summer/city_big_1.tscn'),
			load('res://terrain/city/summer/city_big_2.tscn'),
			load('res://terrain/city/summer/city_big_3.tscn'),
			load('res://terrain/city/summer/city_big_4.tscn')
		],
		'statue' : load('res://terrain/city/summer/city_statue.tscn')
	},
	'fall' : {
		'small' : [
			load('res://terrain/city/fall/city_small_1.tscn'),
			load('res://terrain/city/fall/city_small_2.tscn'),
			load('res://terrain/city/fall/city_small_3.tscn'),
			load('res://terrain/city/fall/city_small_4.tscn'),
			load('res://terrain/city/fall/city_small_5.tscn'),
			load('res://terrain/city/fall/city_small_6.tscn')
		],
		'large' : [
			load('res://terrain/city/fall/city_big_1.tscn'),
			load('res://terrain/city/fall/city_big_2.tscn'),
			load('res://terrain/city/fall/city_big_3.tscn'),
			load('res://terrain/city/fall/city_big_4.tscn')
		],
		'statue' : load('res://terrain/city/fall/city_statue.tscn')
	},
	'winter' : {
		'small' : [
			load('res://terrain/city/winter/city_small_1.tscn'),
			load('res://terrain/city/winter/city_small_2.tscn'),
			load('res://terrain/city/winter/city_small_3.tscn'),
			load('res://terrain/city/winter/city_small_4.tscn'),
			load('res://terrain/city/winter/city_small_5.tscn'),
			load('res://terrain/city/winter/city_small_6.tscn')
		],
		'large' : [
			load('res://terrain/city/winter/city_big_1.tscn'),
			load('res://terrain/city/winter/city_big_2.tscn'),
			load('res://terrain/city/winter/city_big_3.tscn'),
			load('res://terrain/city/winter/city_big_4.tscn')
		],
		'statue' : load('res://terrain/city/winter/city_statue.tscn')
	}
}

var seasons = {
	'summer' : {'day' : 21, 'month': 4},
	'fall' : {'day' : 21, 'month': 9},
	'winter' : {'day' : 21, 'month': 12}
}

func get_current_tileset():
	for themeVAR in self.seasons:
		if self.bag.helpers.comp_days(self.seasons[themeVAR], OS.get_date()) != 1:
			return themeVAR
	return 'winter'


