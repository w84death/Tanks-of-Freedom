var defender_stats
var attacker_stats

func deal(attacker, defender):
	return 1

func deal_fortify(attacker, defender):
	print('test')

func calculate():
	print('calc')

func resolve_fight(attacker, defender):
	attacker_stats = attacker.get_stats()
	defender_stats = defender.get_stats()
		
	defender_stats.life = defender_stats.life - attacker_stats.attack
	defender.set_stats(defender_stats)
	defender.show_floating_damage(attacker_stats.attack)
	
	attacker_stats.ap = attacker_stats.ap - attacker_stats.attack_ap
	attacker_stats.attacks_number = attacker_stats.attacks_number - 1
	attacker.set_stats(attacker_stats)
	
	#handle
	if (defender_stats.life <= 0):
		defender.die()
		return true
	else:
		return false

func resolve_defend(attacker, defender):
	attacker_stats = attacker.get_stats()
	defender_stats = defender.get_stats()

	attacker_stats.life = attacker_stats.life - defender_stats.attack
	attacker.set_stats(attacker_stats)
	attacker.show_floating_damage(defender_stats.attack)

	#handle
	if (attacker_stats.life <= 0):
		attacker.die()
		return true
	else:
		return false

func can_attack(attacker, defender):
	if attacker.type == 1 && defender.type == 2:
		return false

	if attacker.can_attack():
		return true

	print('Not enough AP')
	return false

func can_defend(attacker, defender):
	if defender.type == 1 && attacker.type == 2:
		return false
	return true