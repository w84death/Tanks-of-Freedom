extends "res://scripts/ai/actions/types/base_action.gd"

var path

func _init(unit, path).(unit):
	self.path = path

func proceed():
	.proceed()
	self.path.pop_front()

func can_continue():
	if self.invalid:
		return false

	if self.path.size() == 1:
		return false

	if self.entity.ap == 0:
		return false

	if self.entity.ap == 1 and self.path.size() > 2:
		return false

	return true
