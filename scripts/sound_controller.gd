
var root
var stream_player
var sample_player

const SOUND_SPAWN = 'spawn'
const SOUND_MOVE = 'move'
const SOUND_ATTACK = 'attack'
const SOUND_DAMAGE = 'damage'
const SOUND_DIE = 'die'

var stream
var soundtracks = [
	'map_soundtrack_1',
	'map_soundtrack_2',
	'map_soundtrack_3',
	'map_soundtrack_4']

func init_root(root_node):
	root = root_node
	stream_player = root.get_node("StreamPlayer")
	sample_player = root.get_node("SamplePlayer")
	sample_player.set_default_volume(root.settings['sound_volume'])
	stream_player.set_volume(root.settings['music_volume'])

func play_soundtrack():
	self.stop_soundtrack()
	if root.settings['music_enabled'] && root.is_map_loaded:
		var selected_track = self.soundtracks[randi() % self.soundtracks.size()]
		stream = load("res://assets/sounds/soundtrack/"+selected_track+".ogg")
		stream_player.set_stream(stream)
		stream_player.set_loop(true)
		stream_player.play()

func stop_soundtrack():
	stream_player.stop()
	stream = null

func play(sound):
	if root.settings['sound_enabled']:
		sample_player.play(sound)

func play_unit_sound(unit, sound):
	self.play(unit.type_name+'_'+sound)
