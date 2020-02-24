
var root
var stream_player
#var sample_player

var sound_volume = 0.5
var music_volume = 1.0

var currently_playing

const SOUND_SPAWN = 'spawn'
const SOUND_MOVE = 'move'
const SOUND_ATTACK = 'attack'
const SOUND_DAMAGE = 'damage'
const SOUND_DIE = 'die'

var stream
var samples = [
	['end_turn', load('res://assets/sounds/fx/end_turn.wav')],
	['explosion', load('res://assets/sounds/fx/explosion.wav')],
	['heli_attack', load('res://assets/sounds/fx/units/03.helicopter/helicopter_attack.wav')],
	['heli_damage', load('res://assets/sounds/fx/units/03.helicopter/helicopter_damage.wav')],
	['heli_die', load('res://assets/sounds/fx/units/03.helicopter/helicopter_die.wav')],
	['heli_move', load('res://assets/sounds/fx/units/03.helicopter/helicopter_move.wav')],
	['heli_spawn', load('res://assets/sounds/fx/units/03.helicopter/helicopter_spawn.wav')],
	['hurt', load('res://assets/sounds/fx/hurt.wav')],
	['menu', load('res://assets/sounds/fx/menu.wav')],
	['move', load('res://assets/sounds/fx/move.wav')],
	['no_attack', load('res://assets/sounds/fx/no_attack.wav')],
	['no_moves', load('res://assets/sounds/fx/no_moves.wav')],
	['not_dead', load('res://assets/sounds/fx/not_dead.wav')],
	['occupy_building', load('res://assets/sounds/fx/units/11.buildings/occupy_building.wav')],
	['passive_building_ap', load('res://assets/sounds/fx/units/11.buildings/passive_building_ap.wav')],
	['pickup_box', load('res://assets/sounds/fx/pickup_box.wav')],
	['powerup', load('res://assets/sounds/fx/powerup.wav')],
	['select', load('res://assets/sounds/fx/select.wav')],
	['soldier_attack', load('res://assets/sounds/fx/units/01.soldier/soldier_attack.wav')],
	['soldier_damage', load('res://assets/sounds/fx/units/01.soldier/soldier_damage.wav')],
	['soldier_die', load('res://assets/sounds/fx/units/01.soldier/soldier_die.wav')],
	['soldier_move', load('res://assets/sounds/fx/units/01.soldier/soldier_move.wav')],
	['soldier_spawn', load('res://assets/sounds/fx/units/01.soldier/soldier_spawn.wav')],
	['spawn', load('res://assets/sounds/fx/spawn.wav')],
	['tank_attack', load('res://assets/sounds/fx/units/02.tank/tank_attack.wav')],
	['tank_damage', load('res://assets/sounds/fx/units/02.tank/tank_damage.wav')],
	['tank_die', load('res://assets/sounds/fx/units/02.tank/tank_die.wav')],
	['tank_move', load('res://assets/sounds/fx/units/02.tank/tank_move.wav')],
	['tank_spawn', load('res://assets/sounds/fx/units/02.tank/tank_spawn.wav')],
]

var soundtracks = {
	'game1' : load("res://assets/sounds/soundtrack/map_soundtrack_1.ogg"),
	'game2' : load("res://assets/sounds/soundtrack/map_soundtrack_2.ogg"),
	'menu' :  load("res://assets/sounds/soundtrack/menu_soundtrack.ogg")
}

func init_root(root_node):
	root = root_node
	stream_player = root.get_node("StreamPlayer")
	stream_player.set_volume_db(self.music_volume)
#	sample_player = root.get_node("Node")
#	sample_player.set_volume_db(self.sound_volume)
	self.load_samples()

func play_soundtrack():
	self.stop_soundtrack()
	if root.settings['music_enabled']:
		if root.is_map_loaded:
			var tracks = [
				'game1',
				'game2'
			]
			randomize()
			var selected_track = tracks[randi() % tracks.size()]
			self.play_track(selected_track)
		else:
			self.play_track('menu')


func play_track(track_name):
	if root.settings['music_enabled']:
		if self.currently_playing == track_name:
			return
		self.stop_soundtrack()
		var track = self.soundtracks[track_name]
		stream_player.set_stream(track)
		#stream_player.set_loop(true)(
		stream_player.play()
		self.currently_playing = track_name

func stop_soundtrack():
	stream_player.stop()
	stream = null
	self.currently_playing = null

func play(sound):
	pass
#	if root.settings['sound_enabled']:
#		sample_player.play(sound)

func play_unit_sound(unit, sound):
	self.play(unit.type_name+'_'+sound)

func load_samples():
	pass
#	for sample in self.samples:
#		self.sample_player.get_sample_library().add_sample(sample[0], sample[1])

