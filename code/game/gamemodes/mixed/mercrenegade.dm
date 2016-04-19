/datum/game_mode/mercren
	name = "Mercenaries & Renegades"
	round_description = "A mercenary team has invaded the station, as well as other having brought their own form protection."
	extended_round_description = "Mercenaries and traitors spawn during this round."
	config_tag = "mercren"
	required_players = 16			//What could possibly go wrong?
	required_players_secret = 15
	required_enemies = 8
	end_on_antag_death = 0
	antag_tags = list(MODE_MERCENARY, MODE_RENEGADE)
	require_all_templates = 1