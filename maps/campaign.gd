
var progress_file = File.new()
var campaign_progression = -1

var maps = [
    {
        'label': tr('MISSION_TITLE_MAYDAY_SQUARE'), #'MayDay Square'
        'player': 0,
        'file': preload("res://maps/campaign/maidan.gd").new(),
        'description': tr('MISSION_DESR_MAYDAY_SQUARE')
    },
    {
        'label': tr('MISSION_TITLE_EASTERN_CITY'), #'Eastern city'
        'player': 0,
        'file': preload("res://maps/campaign/eastern_city.gd").new(),
        'description': tr('MISSION_DESR_EASTERN_CITY')
    },
    {
        'label': tr('MISSION_TITLE_RIOTS'), #'Riots'
        'player': 1,
        'file': preload("res://maps/campaign/administration_riot.gd").new(),
        'description': tr('MISSION_DESR_RIOTS')
    },
    {
        'label': tr('MISSION_TITLE_BASE_ASSAULT'), #'Base Assault'
        'player': 1,
        'file': preload("res://maps/campaign/base_assault.gd").new(),
        'description': tr('MISSION_DESR_BASE_ASSAULT')
    },
    {
        'label': tr('MISSION_TITLE_PENINSULA'), #'Peninsula'
        'player': 1,
        'file': preload("res://maps/campaign/peninsula.gd").new(),
        'description': tr('MISSION_DESR_PENINSULA')
    },
    {
        'label': tr('MISSION_TITLE_RECAPTURE'), #'Recapture'
        'player': 0,
        'file': preload("res://maps/campaign/administration_recapture.gd").new(),
        'description': tr('MISSION_DESR_RECAPTURE')
    },
    {
        'label': tr('MISSION_TITLE_BASE_DEFENCE'), #'Base Defence'
        'player': 0,
        'file': preload("res://maps/campaign/base_defence.gd").new(),
        'description': tr('MISSION_DESR_BASE_DEFENCE')
    },
    {
        'label': tr('MISSION_TITLE_AIRPORT_PT_1'), #'Airport Pt.1'
        'player': 1,
        'file': preload("res://maps/campaign/airport_part_1.gd").new(),
        'description': tr('MISSION_DESR_AIRPORT_PT_1')
    },
    {
        'label': tr('MISSION_TITLE_AIRPLANE'), #'Airplane'
        'player': 1,
        'file': preload("res://maps/campaign/airplane.gd").new(),
        'description': tr('MISSION_DESR_AIRPLANE')
    },
    {
        'label': tr('MISSION_TITLE_FIELD_COMMAND'), #'Field Command'
        'player': 0,
        'file': preload("res://maps/campaign/field_command.gd").new(),
        'description': tr('MISSION_DESR_FIELD_COMMAND')
    },
    {
        'label': tr('MISSION_TITLE_AIRPORT_PT_2'), #'Airport Pt.2'
        'player': 0,
        'file': preload("res://maps/campaign/airport_part_2.gd").new(),
        'description': tr('MISSION_DESR_AIRPORT_PT_2')
    },
    {
        'label': tr('MISSION_TITLE_CONVOY'), #'Convoy'
        'player': 1,
        'file': preload("res://maps/campaign/convoy.gd").new(),
        'description': tr('MISSION_DESR_CONVOY')
    },
    {
        'label': tr('MISSION_TITLE_CRASH_SITE'), #'Crash Site'
        'player': 1,
        'file': preload("res://maps/campaign/crash_site.gd").new(),
        'description': tr('MISSION_DESR_CRASH_SITE')
    },
    {
        'label': tr('MISSION_TITLE_AIRPORT_PT_3'), #'Airport Pt.3'
        'player': 1,
        'file': preload("res://maps/campaign/airport_part_3.gd").new(),
        'description': tr('MISSION_DESR_AIRPORT_PT_3')
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
