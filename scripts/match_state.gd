
const INITIAL_STATE = 'initial_state'
const MOVES = 'moves'
const FINAL_STATE = 'final_state'
const MATCH_STATE_ENDED = 2

var is_campaign_map = false
var is_workshop_map = false
var current_map_number = 0

var is_multiplayer = false
var current_loaded_multiplayer_state = {}

var actions_taken = []

func reset():
    self.is_campaign_map = false
    self.is_workshop_map = false
    self.current_map_number = 0
    self.is_multiplayer = false
    self.current_loaded_multiplayer_state = {}
    self.actions_taken = []

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





func is_multiplayer_game():
    return self.is_multiplayer

func is_replay_available():
    return self.is_state_component_available('moves')

func is_current_multiplayer_game_ended():
    if not self.current_loaded_multiplayer_state.has('match_status'):
        return false

    if self.current_loaded_multiplayer_state['match_status'] == self.MATCH_STATE_ENDED:
        return true

    return false

func is_initial_state_available():
    return self.is_state_component_available('initial_state')

func is_final_state_available():
    return self.is_state_component_available('final_state')

func is_state_component_available(component):
    if not self.current_loaded_multiplayer_state.has('data'):
        return false

    if not self.current_loaded_multiplayer_state['data'].has(component):
        return false

    if self.current_loaded_multiplayer_state['data'][component].size() > 0:
        return true

    return false


func get_initial_state():
    return self.get_state_component('initial_state')

func get_final_state():
    return self.get_state_component('final_state')

func get_replay_moves():
    return self.get_state_component('moves')

func get_state_component(component):
    if self.is_state_component_available(component):
        return self.current_loaded_multiplayer_state['data'][component]

    return {}



func reset_actions_taken():
    self.actions_taken = []

func register_action_taken(action):
    self.actions_taken.append(action)

    