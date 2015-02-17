
func deal(attacker, defender):
	return 1

func deal_fortify(attacker, defender):
	print('test')

func calculate():
	print('calc')

func resolve_fight(attacker, defender):
	var attacker_stats = attacker.get_stats()
	var defender_stats = defender.get_stats()
	defender_stats.life = defender_stats.life - attacker_stats.attack
	defender.set_stats(defender_stats)
	print('Fight!')
	print(defender.get_stats())



#ludziki zajmuja budynki
#ludzik atakuje czolg z lasu
#czolgi biora ludzika na strzał
#helikopter rozpieprza wszystko na strzal