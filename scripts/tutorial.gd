
var next_button
var prev_button

var current_card = 0

func _ready():
	next_button = get_node("control/menu_controls/next")
	prev_button = get_node("control/menu_controls/prev")
	
	next_button.connect("pressed", self, "next_card")
	prev_button.connect("pressed", self, "prev_card")
	
	prev_button.hide()
	
func next_card():
	self.switch_to_card(current_card + 1)
	
func prev_card():
	self.switch_to_card(current_card - 1)

func switch_to_card(number):
	var current = get_node("control/pages/" + str(current_card))
	var new_card = get_node("control/pages/" + str(number))
	var proceeding_card = get_node("control/pages/" + str(number + 1))
	if new_card == null || number < 0:
		return
	if number == 0:
		prev_button.hide()
	else:
		prev_button.show()
	if proceeding_card == null:
		next_button.hide()
	else:
		next_button.show()
	current.hide()
	new_card.show()
	current_card = number
	