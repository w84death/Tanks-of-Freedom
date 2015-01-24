
func deal(attacker, defender):
	return 1

func deal_fortify(attacker, defender):
	print('test')

func calculate():
	print('calc')

func resolve_fight(attacker, defender):
	print('Fight!')
	var attacker_stats = attacker.get_stats()
	var defender_stats = defender.get_stats()
	defender_stats.life = defender_stats.life - attacker_stats.attack

	defender.set_stats(defender_stats)
	#handle
	if (defender_stats.life <= 0):
		defender.die()
		return true
	else:
		return false

