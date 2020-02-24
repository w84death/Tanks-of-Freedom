export var trans_key = 'LABEL_DEFAULT'

func _ready():
	add_to_group("translate_me")
	refresh_label()
	pass

func refresh_label():
	self.set_text(tr(self.trans_key))

func set_trans_key(new_key):
	self.trans_key = new_key
	refresh_label()

