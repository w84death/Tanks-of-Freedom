
var is_campaign_map = false
var is_workshop_map = false
var current_map_number = 0

func reset():
    self.is_campaign_map = false
    self.is_workshop_map = false
    self.current_map_number = 0

func is_campaign():
    return self.is_campaign_map

func is_workshop():
    return self.is_workshop_map

func get_map_number():
    return self.current_map_number

func set_campaign_map(map_number):
    self.is_campaign_map = true
    self.current_map_number = map_number

func set_workshop_map():
    self.is_workshop_map = true
