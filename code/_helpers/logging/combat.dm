/proc/log_attack(attacker, defender, message)
	if (config.log_attack)
		WRITE_LOG(diary, "ATTACK: [attacker] against [defender]: [message]")
