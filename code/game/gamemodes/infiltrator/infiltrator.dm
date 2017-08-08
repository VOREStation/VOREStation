/datum/game_mode/infiltrator
	name = "Team Traitor"
	round_description = "There are a group of shadowy infiltrators onboard!  Be careful!"
	extended_round_description = "A team of secretative people have played the long con, and managed to obtain entry to \
	the facility.  What their goals are, who their employers are, and why the individuals would work for them is a mystery, \
	but perhaps you will outwit them, or perhaps that is all part of their plan?"
	config_tag = "infiltrator"
	required_players = 2
	required_players_secret = 5
	required_enemies = 2 // Bit pointless if there is only one, since its basically traitor.
	end_on_antag_death = 0
	antag_scaling_coeff = 5
	antag_tags = list(MODE_INFILTRATOR)