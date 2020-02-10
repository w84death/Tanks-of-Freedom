extends Control

export var position_on_map = Vector2(0,0)
var group = 'waypoint'
var type  = 10
var subtype = null
var for_unit_type = [0, 1, 2]
var for_player = [0, 1]
var is_active = true
var point_of_interest = null # building or smth

const TYPE_LEVEL_1 = 1
const TYPE_LEVEL_2 = 2
const TYPE_LEVEL_3 = 3
const TYPE_BULDING_AREA = 10
const TYPE_SPAWN_POINT = 11

func _init(pos, subtype=self.TYPE_LEVEL_1):
	self.position_on_map = pos
	self.subtype = subtype

func get_pos_map():
	return position_on_map

func applicable_for_player(player):
	for value in self.for_player:
		if value == player:
			return true
	return false

func applicable_for_unit_type(unit_type):
	for value in self.for_unit_type:
		if value == unit_type:
			return true
	return false

func update_status(): #TODO needs better name
	if self.point_of_interest != null:
		if self.point_of_interest.player == -1:
			self.for_player = [0, 1]
		else:
			self.for_player = [(self.point_of_interest.player +1 ) % 2]

	self.for_unit_type = [0, 1, 2]

func mark_blocked():
	self.for_unit_type = [0]

func get_value():
	return self.subtype # TODO needs refactor

func _ready():
	add_to_group("waypoint")
