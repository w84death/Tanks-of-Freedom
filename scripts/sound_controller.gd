
var stream_player

func init(player):
	stream_player = player

func play_soundtrack():
	var stream = load("res://assets/sounds/soundtrack/aliens.ogg")
	stream_player.set_stream(stream)
	stream_player.set_loop(true)
	
	stream_player.play()
