
/*
 * lbnesquik - Github
 * Provided massive components of this. Polaris PR #5720.
 */

//This is for the round end stats system.

//roundstat is used for easy finding of the variables, if you ever want to delete all of this,
//just search roundstat and you'll find everywhere this thing reaches into.
//It used to be bazinga but it only fly with microwaves.

GLOBAL_VAR_INIT(cans_opened_roundstat, 0)
GLOBAL_VAR_INIT(lights_switched_on_roundstat, 0)
GLOBAL_VAR_INIT(turbo_lift_floors_moved_roundstat, 0)
GLOBAL_VAR_INIT(lost_limbs_shift_roundstat, 0)
GLOBAL_VAR_INIT(seed_planted_shift_roundstat, 0)
GLOBAL_VAR_INIT(step_taken_shift_roundstat, 0)
GLOBAL_VAR_INIT(destroyed_research_items_roundstat, 0)
GLOBAL_VAR_INIT(items_sold_shift_roundstat, 0)
GLOBAL_VAR_INIT(disposals_flush_shift_roundstat, 0)
GLOBAL_VAR_INIT(rocks_drilled_roundstat, 0)
GLOBAL_VAR_INIT(mech_destroyed_roundstat, 0)
GLOBAL_VAR_INIT(prey_eaten_roundstat, 0)
GLOBAL_VAR_INIT(prey_absorbed_roundstat, 0)
GLOBAL_VAR_INIT(prey_digested_roundstat, 0)
GLOBAL_VAR_INIT(items_digested_roundstat, 0)
GLOBAL_LIST_EMPTY(security_printer_tickets)
GLOBAL_LIST_EMPTY(refined_chems_sold)


/datum/controller/subsystem/ticker/proc/PlayerStats()
	for(var/mob/Player in GLOB.player_list)
		if(Player.mind && !isnewplayer(Player))
			if(Player.stat != DEAD)
				var/turf/playerTurf = get_turf(Player)
				if(SSemergency_shuttle.departed && SSemergency_shuttle.evac)
					if(isNotAdminLevel(playerTurf.z))
						to_chat(Player, span_filter_system(span_blue(span_bold("You survived the round, but remained on [station_name()] as [Player.real_name]."))))
					else
						to_chat(Player, span_filter_system(span_green(span_bold("You managed to survive the events on [station_name()] as [Player.real_name]."))))
				else if(isAdminLevel(playerTurf.z))
					to_chat(Player, span_filter_system(span_green(span_bold("You successfully underwent crew transfer after events on [station_name()] as [Player.real_name]."))))
				else if(issilicon(Player))
					to_chat(Player, span_filter_system(span_green(span_bold("You remain operational after the events on [station_name()] as [Player.real_name]."))))
				else
					to_chat(Player, span_filter_system(span_blue(span_bold("You missed the crew transfer after the events on [station_name()] as [Player.real_name]."))))
			else
				if(isobserver(Player))
					var/mob/observer/dead/O = Player
					if(!O.started_as_observer)
						to_chat(Player, span_filter_system(span_red(span_bold("You did not survive the events on [station_name()]..."))))
				else
					to_chat(Player, span_filter_system(span_red(span_bold("You did not survive the events on [station_name()]..."))))
	to_chat(world, span_filter_system("<br>"))

	for (var/mob/living/silicon/ai/aiPlayer in GLOB.mob_list)
		if (aiPlayer.stat != 2)
			to_chat(world, span_filter_system(span_bold("[aiPlayer.name]'s laws at the end of the round were:")))
		else
			to_chat(world, span_filter_system(span_bold("[aiPlayer.name]'s laws when it was deactivated were:")))
		aiPlayer.show_laws(1)

		if (aiPlayer.connected_robots.len)
			var/robolist = span_bold("The AI's loyal minions were:") + " "
			for(var/mob/living/silicon/robot/robo in aiPlayer.connected_robots)
				robolist += "[robo.name][robo.stat?" (Deactivated), ":", "]"
			to_chat(world, span_filter_system("[robolist]"))

	var/dronecount = 0

	for (var/mob/living/silicon/robot/robo in GLOB.mob_list)

		if(istype(robo, /mob/living/silicon/robot/platform))
			var/mob/living/silicon/robot/platform/tank = robo
			if(!tank.has_had_player)
				continue

		if(istype(robo,/mob/living/silicon/robot/drone) && !istype(robo,/mob/living/silicon/robot/drone/swarm))
			dronecount++
			continue

		if (!robo.connected_ai)
			var/list/robot_stat_display = list()
			if (robo.stat != 2)
				robot_stat_display += span_filter_system(span_bold("[robo.name] survived as an AI-less stationbound synthetic! Its laws were:"))
			else
				robot_stat_display += span_filter_system(span_bold("[robo.name] was unable to survive the rigors of being a stationbound synthetic without an AI. Its laws were:"))

			robot_stat_display += robo.laws.get_formatted_laws()
			to_chat(world, robot_stat_display.Join("\n"))

	if(dronecount)
		to_chat(world, span_filter_system(span_bold("There [dronecount>1 ? "were" : "was"] [dronecount] industrious maintenance [dronecount>1 ? "drones" : "drone"] at the end of this round.")))

/datum/controller/subsystem/ticker/proc/RoundTrivia()//bazinga
	var/list/valid_stats_list = list() //This is to be populated with the good shit

	if(GLOB.lost_limbs_shift_roundstat > 1)
		valid_stats_list.Add("[GLOB.lost_limbs_shift_roundstat] limbs left their owners bodies this shift, oh no!")
	else if(GLOB.destroyed_research_items_roundstat > 13)
		valid_stats_list.Add("[GLOB.destroyed_research_items_roundstat] objects were destroyed in the name of Science! Keep it up!")
	else if(GLOB.mech_destroyed_roundstat > 1)
		valid_stats_list.Add("[GLOB.mech_destroyed_roundstat] mechs were destroyed this shift. What did you do?")
	else if(GLOB.seed_planted_shift_roundstat > 20)
		valid_stats_list.Add("[GLOB.seed_planted_shift_roundstat] seeds were planted according to our sensors this shift.")

	if(GLOB.rocks_drilled_roundstat > 80)
		valid_stats_list.Add("Our strong miners pulverized a whole [GLOB.rocks_drilled_roundstat] piles of pathetic rubble.")
	else if(GLOB.items_sold_shift_roundstat > 15)
		valid_stats_list.Add("The vending machines sold [GLOB.items_sold_shift_roundstat] items today.")
	else if(GLOB.step_taken_shift_roundstat > 900)
		valid_stats_list.Add("The employees walked a total of [GLOB.step_taken_shift_roundstat] steps for this shift! It should put them on the road to fitness!")

	if(GLOB.cans_opened_roundstat > 0)
		valid_stats_list.Add("[GLOB.cans_opened_roundstat] cans were drank today!")
	else if(GLOB.lights_switched_on_roundstat > 0)
		valid_stats_list.Add("[GLOB.lights_switched_on_roundstat] light switches were flipped today!")
	else if(GLOB.turbo_lift_floors_moved_roundstat > 20)
		valid_stats_list.Add("The elevator moved up [GLOB.turbo_lift_floors_moved_roundstat] floors today!")
	else if(GLOB.disposals_flush_shift_roundstat > 40)
		valid_stats_list.Add("The disposal system flushed a whole [GLOB.disposals_flush_shift_roundstat] times for this shift. We should really invest in waste treatement.")

	if(GLOB.security_printer_tickets.len)
		valid_stats_list.Add(span_danger("[GLOB.security_printer_tickets.len] unique security tickets were issued today!") + "<br>Examples include:")
		var/good_num = 5
		var/ourticket
		while(good_num > 0)
			ourticket = null
			if(GLOB.security_printer_tickets.len)
				ourticket = pick(GLOB.security_printer_tickets)
				GLOB.security_printer_tickets -= ourticket
				if(ourticket)
					valid_stats_list.Add(span_bold("-")+"\"[ourticket]\"")
				good_num--
			else
				good_num = 0

	if(GLOB.prey_eaten_roundstat > 0)
		valid_stats_list.Add("Individuals were eaten a total of [GLOB.prey_eaten_roundstat] times today!")
	if(GLOB.prey_digested_roundstat > 0)
		valid_stats_list.Add("A total of [GLOB.prey_digested_roundstat] individuals were digested today!")
	if(GLOB.prey_absorbed_roundstat > 0)
		valid_stats_list.Add("A total of [GLOB.prey_absorbed_roundstat] individuals were absorbed today!")
	if(GLOB.items_digested_roundstat > 0)
		valid_stats_list.Add("A total of [GLOB.items_digested_roundstat] items were digested today!")

	var/points = 0
	var/units = 0
	if(GLOB.refined_chems_sold && GLOB.refined_chems_sold.len > 0)
		valid_stats_list.Add(span_warning("The station exported:"))

		for(var/D in GLOB.refined_chems_sold)
			units += GLOB.refined_chems_sold[D]["units"]
			points += GLOB.refined_chems_sold[D]["value"]

			if(GLOB.refined_chems_sold[D]["units"] >= 1000) // Don't spam the list
				var/dols = GLOB.refined_chems_sold[D]["value"] * SSsupply.money_per_points
				dols = FLOOR(dols * 100,1) / 100 // Truncate decimals
				valid_stats_list.Add("[GLOB.refined_chems_sold[D]["units"]]u of [D], for [GLOB.refined_chems_sold[D]["value"]] points! A total of [dols] [dols > 1 ? "thalers" : "thaler"]")

		var/end_dols = points * SSsupply.money_per_points
		end_dols = FLOOR(end_dols * 100,1) / 100 // Truncate decimals
		valid_stats_list.Add("For a total of: [points] points, or [end_dols] [end_dols > 1 ? "thalers" : "thaler"]!")

	if(SSsupply.warheads_sold > 0)
		var/end_dols = SSsupply.warheads_value * SSsupply.money_per_points
		end_dols = FLOOR(end_dols * 100,1) / 100 // Truncate decimals
		valid_stats_list.Add("[SSsupply.warheads_sold] TTV warheads were sold! For a total of: [SSsupply.warheads_value] points, or [end_dols] [end_dols > 1 ? "thalers" : "thaler"]!")

	//NYI
	if(SSsupply.watts_sold >= 1 GIGAWATTS)
		var/gws = FLOOR(SSsupply.watts_sold / (1 GIGAWATTS),1) // Truncate decimals
		points = FLOOR(SSsupply.watts_sold / SSsupply.points_per_watt,1)
		var/end_dols = points * SSsupply.money_per_points
		end_dols = FLOOR(end_dols * 100,1) / 100 // Truncate decimals
		valid_stats_list.Add("[gws] gigawatt[gws > 1 ? "s" : ""] of power were sold! For a total of: [points] points, or [end_dols] [end_dols > 1 ? "thalers" : "thaler"]!")

	if(SSnerdle)
		var/word_export = "This shift's nerdle was: [SSnerdle.target_word]! <br>"
		word_export += "There were [SSnerdle.total_players] players this shift!<br>"
		var/list/splashes = list("We know what you are!", "That's how we do!", "Basically free!", "Hear them roar!", "The streak is alive!","Don't fall for them tricks!")
		for(var/i in 1 to SSnerdle.player_attempts.len)
			if(SSnerdle.player_attempts[i] > 0)
				if(i < 7)
					word_export += "There were [SSnerdle.player_attempts[i]] people who got it in [i]! [splashes[i]]<br>"
				else
					word_export += "And there were [SSnerdle.player_attempts[i]] losers who couldn't quite get it. You'll get em next time!<br>"

		valid_stats_list.Add(word_export)

	if(LAZYLEN(valid_stats_list))
		to_chat(world, span_world("Shift trivia!"))

		for(var/body in valid_stats_list)
			to_chat(world, span_filter_system("[body]"))
