
var root
var stream_player
var sample_player

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
