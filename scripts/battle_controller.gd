
func deal(attacker, defender):
	return 1

func deal_fortify(attacker, defender):
	print('test')

func calculate():
	print('calc')

func resolve_fight(attacker, defender):
	
	if (self.can_attack(attacker, defender)):
		print('Fight!')
	else:
		return false
		
	var attacker_stats = attacker.get_stats()
	var defender_stats = defender.get_stats()
		
	defender_stats.life = defender_stats.life - attacker_stats.attack
	defender.set_stats(defender_stats)
	
	attacker_stats.ap = attacker_stats.ap - attacker_stats.attack_ap
	attacker.set_stats(attacker_stats)
	
	#handle
	if (defender_stats.life <= 0):
		defender.die()
		return true
	else:
		return false

func can_attack(attacker, defender):
	var attacker_stats = attacker.get_stats()
	if attacker_stats.ap < attacker_stats.attack_ap:
		print('Not enough AP')
		return false

	if attacker.type == 1 && defender.type == 2:
		return false
	return true

