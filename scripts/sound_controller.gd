
var root
var stream_player
var sample_player

const SOUND_SPAWN = 'spawn'
const SOUND_MOVE = 'move'
const SOUND_ATTACK = 'attack'
const SOUND_DAMAGE = 'damage'
const SOUND_DIE = 'die'

func init_root(root_node):
	root = root_node
	stream_player = root.get_node("StreamPlayer")
	sample_player = root.get_node("SamplePlayer")

func play_soundtrack():
	self.stop_soundtrack()
	if root.settings['music_enabled'] && root.is_map_loaded:
		var stream = load("res://assets/sounds/soundtrack/aliens.ogg")
		stream_player.set_stream(stream)
		stream_player.set_loop(true)
		stream_player.play()

func stop_soundtrack():
	stream_player.stop()

func play(sound):
	if root.settings['sound_enabled']:
		sample_player.play(sound)

func play_unit_sound(unit, sound):
	self.play(unit.type_name+'_'+sound)
