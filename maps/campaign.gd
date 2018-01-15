
var progress_file = File.new()
var campaign_progression = -1

var maps = []

func _init():
    self.reload_maps_definition()

func reload_maps_definition():
    self.maps = [
        {
            'label': tr('MISSION_TITLE_MAYDAY_SQUARE'),
            'player': 0,
            'file': preload("res://maps/campaign/maidan.gd").new(),
            'stories' : preload("res://maps/campaign/maidan_scripts.gd").new(),
            'description': tr('MISSION_DESR_MAYDAY_SQUARE'),
            'tileset' : 'summer'
        },
        {
            'label': tr('MISSION_TITLE_EASTERN_CITY'),
            'player': 0,
            'file': preload("res://maps/campaign/eastern_city.gd").new(),
            'stories' : preload("res://maps/campaign/eastern_city_scripts.gd").new(),
            'description': tr('MISSION_DESR_EASTERN_CITY'),
            'tileset' : 'fall'
        },
        {
            'label': tr('MISSION_TITLE_RIOTS'),
            'player': 1,
            'file': preload("res://maps/campaign/administration_riot.gd").new(),
            'stories' : preload("res://maps/campaign/administration_riot_scripts.gd").new(),
            'description': tr('MISSION_DESR_RIOTS'),
            'tileset' : 'winter'
        },
        {
            'label': tr('MISSION_TITLE_BASE_ASSAULT'),
            'player': 1,
            'file': preload("res://maps/campaign/base_assault.gd").new(),
            'stories' : preload("res://maps/campaign/base_assault_scripts.gd").new(),
            'description': tr('MISSION_DESR_BASE_ASSAULT'),
            'tileset' : 'winter'
        },
        {
            'label': tr('MISSION_TITLE_PENINSULA'),
            'player': 1,
            'file': preload("res://maps/campaign/peninsula.gd").new(),
            'stories' : preload("res://maps/campaign/peninsula_scripts.gd").new(),
            'description': tr('MISSION_DESR_PENINSULA'),
            'tileset' : 'winter'
        },
        {
            'label': tr('MISSION_TITLE_RECAPTURE'),
            'player': 0,
            'file': preload("res://maps/campaign/administration_recapture.gd").new(),
            'stories' : preload("res://maps/campaign/administration_recapture_scripts.gd").new(),
            'description': tr('MISSION_DESR_RECAPTURE'),
            'tileset' : 'winter'
        },
        {
            'label': tr('MISSION_TITLE_BASE_DEFENCE'),
            'player': 0,
            'file': preload("res://maps/campaign/base_defence.gd").new(),
            'stories' : preload("res://maps/campaign/base_defence_scripts.gd").new(),
            'description': tr('MISSION_DESR_BASE_DEFENCE'),
            'tileset' : 'summer'
        },
        {
            'label': tr('MISSION_TITLE_AIRPORT_PT_1'),
            'player': 1,
            'file': preload("res://maps/campaign/airport_part_1.gd").new(),
            'stories' : preload("res://maps/campaign/airport_part_1_scripts.gd").new(),
            'description': tr('MISSION_DESR_AIRPORT_PT_1'),
            'tileset' : 'summer'
        },
        {
            'label': tr('MISSION_TITLE_AIRPLANE'),
            'player': 1,
            'file': preload("res://maps/campaign/airplane.gd").new(),
            'stories' : preload("res://maps/campaign/airplane_scripts.gd").new(),
            'description': tr('MISSION_DESR_AIRPLANE'),
            'tileset' : 'summer'
        },
        {
            'label': tr('MISSION_TITLE_FIELD_COMMAND'),
            'player': 0,
            'file': preload("res://maps/campaign/field_command.gd").new(),
            'stories' : preload("res://maps/campaign/field_command_scripts.gd").new(),
            'description': tr('MISSION_DESR_FIELD_COMMAND'),
            'tileset' : 'summer'
        },
        {
            'label': tr('MISSION_TITLE_AIRPORT_PT_2'),
            'player': 0,
            'file': preload("res://maps/campaign/airport_part_2.gd").new(),
            'stories' : null,
            'description': tr('MISSION_DESR_AIRPORT_PT_2'),
            'tileset' : 'summer'
        },
        {
            'label': tr('MISSION_TITLE_CONVOY'),
            'player': 1,
            'file': preload("res://maps/campaign/convoy.gd").new(),
            'stories' : null,
            'description': tr('MISSION_DESR_CONVOY'),
            'tileset' : 'fall'
        },
        {
            'label': tr('MISSION_TITLE_CRASH_SITE'),
            'player': 1,
            'file': preload("res://maps/campaign/crash_site.gd").new(),
            'stories' : null,
            'description': tr('MISSION_DESR_CRASH_SITE'),
            'tileset' : 'fall'
        },
        {
            'label': tr('MISSION_TITLE_AIRPORT_PT_3'),
            'player': 1,
            'file': preload("res://maps/campaign/airport_part_3.gd").new(),
            'stories' : null,
            'description': tr('MISSION_DESR_AIRPORT_PT_3'),
            'tileset' : 'winter'
        },
    ]

func get_map_data(map_number):
    return maps[map_number]['file']

func get_map_player(map_number):
    return maps[map_number]['player']

func get_map_description(map_number):
    return maps[map_number]['description']

func get_map_name(map_number):
    return maps[map_number]['label']

func get_map_tileset(map_number):
    return maps[map_number]['tileset']

func get_map_stories(map_number):
    var stories
    if self.maps[map_number]['stories'] == null:
        stories = {
            'enabled' : false,
            'stories' : {},
            'triggers' : {}
        }
    else:
        stories = {
            'enabled' : true,
            'stories' : self.maps[map_number]['stories'].stories,
            'triggers' : self.maps[map_number]['stories'].triggers
        }
    return stories

func load_campaign_progress():
    if progress_file.file_exists("user://campaign_progress.tof"):
        progress_file.open("user://campaign_progress.tof",File.READ)
        self.campaign_progression = progress_file.get_var()
    else:
        self.update_campaign_progress(self.campaign_progression)

func get_campaign_progress():
    return self.campaign_progression

func get_completed_map_count():
    var completed_num = self.campaign_progression + 1
    if completed_num > self.maps.size():
        completed_num = self.maps.size()
    return completed_num

func update_campaign_progress(map_number):
    self.campaign_progression = map_number
    progress_file.open("user://campaign_progress.tof",File.WRITE)
    progress_file.store_var(map_number)
    progress_file.close()
