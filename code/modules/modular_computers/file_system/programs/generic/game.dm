// This file is used as a reference for Modular Computers Development guide on the wiki. It contains a lot of excess comments, as it is intended as explanation
// for someone who may not be as experienced in coding. When making changes, please try to keep it this way.

/datum/computer_file/program/game
	filename = "dsarcade"				// File name, as shown in the file browser program.
	filedesc = "Donksoft Micro Arcade"	// User-Friendly name.
	program_icon_state = "arcade"		// Icon state of this program's screen.
	extended_desc = "This is a port of the classic game 'Outbomb Cuban Pete', redesigned to run on tablets; Now with thrilling graphics and chilling storytelling."	// A nice description.
	size = 6							// Size in GQ. Integers only. Smaller sizes should be used for utility/low use programs (like this one), while large sizes are for important programs.
	requires_ntnet = FALSE				// This particular program does not require NTNet network conectivity...
	available_on_ntnet = TRUE			// ... but we want it to be available for download.
	tgui_id = "NtosArcade"				// Path of relevant tgui template.js file.

	///Returns TRUE if the game is being played.
	var/game_active = TRUE
	///This disables buttom actions from having any impact if TRUE. Resets to FALSE when the player is allowed to make an action again.
	var/pause_state = FALSE
	var/boss_hp = 45
	var/boss_mp = 15
	var/player_hp = 30
	var/player_mp = 10
	var/ticket_count = 0
	///Shows what text is shown on the app, usually showing the log of combat actions taken by the player.
	var/heads_up = "Nanotrasen says, winners make us money."
	var/boss_name = "Cuban Pete's Minion"
	///Determines which boss image to use on the UI.
	var/boss_id = 1

	usage_flags = PROGRAM_ALL

// This is the primary game loop, which handles the logic of being defeated or winning.
/datum/computer_file/program/game/proc/game_check(mob/user)
	sleep(5)
	if(boss_hp <= 0)
		heads_up = "You have crushed [boss_name]! Rejoice!"
		playsound(computer.loc, 'sound/arcade/win.ogg', 50, TRUE, extrarange = -3, falloff = 0.1)
		game_active = FALSE
		program_icon_state = "arcade_off"
		if(istype(computer))
			computer.update_icon()
		ticket_count += 1
		// user?.mind?.adjust_experience(/datum/skill/gaming, 50)
		sleep(10)
	else if(player_hp <= 0 || player_mp <= 0)
		heads_up = "You have been defeated... how will the station survive?"
		playsound(computer.loc, 'sound/arcade/lose.ogg', 50, TRUE, extrarange = -3, falloff = 0.1)
		game_active = FALSE
		program_icon_state = "arcade_off"
		if(istype(computer))
			computer.update_icon()
		// user?.mind?.adjust_experience(/datum/skill/gaming, 10)
		sleep(10)

// This handles the boss "AI".
/datum/computer_file/program/game/proc/enemy_check(mob/user)
	var/boss_attackamt = 0 //Spam protection from boss attacks as well.
	var/boss_mpamt = 0
	var/bossheal = 0
	if(pause_state == TRUE)
		boss_attackamt = rand(3,6)
		boss_mpamt = rand (2,4)
		bossheal = rand (4,6)
	if(game_active == FALSE)
		return
	if(boss_mp <= 5)
		heads_up = "[boss_mpamt] magic power has been stolen from you!"
		playsound(computer.loc, 'sound/arcade/steal.ogg', 50, TRUE, extrarange = -3, falloff = 0.1)
		player_mp -= boss_mpamt
		boss_mp += boss_mpamt
	else if(boss_mp > 5 && boss_hp <12)
		heads_up = "[boss_name] heals for [bossheal] health!"
		playsound(computer.loc, 'sound/arcade/heal.ogg', 50, TRUE, extrarange = -3, falloff = 0.1)
		boss_hp += bossheal
		boss_mp -= boss_mpamt
	else
		heads_up = "[boss_name] attacks you for [boss_attackamt] damage!"
		playsound(computer.loc, 'sound/arcade/hit.ogg', 50, TRUE, extrarange = -3, falloff = 0.1)
		player_hp -= boss_attackamt

	pause_state = FALSE
	game_check()

/**
 * UI assets define a list of asset datums to be sent with the UI.
 * In this case, it's a bunch of cute enemy sprites.
 */
/datum/computer_file/program/game/ui_assets(mob/user)
	return list(
		get_asset_datum(/datum/asset/simple/arcade),
	)

/**
 * This provides all of the relevant data to the UI in a list().
 */
/datum/computer_file/program/game/tgui_data(mob/user)
	var/list/data = get_header_data()
	data["Hitpoints"] = boss_hp
	data["PlayerHitpoints"] = player_hp
	data["PlayerMP"] = player_mp
	data["TicketCount"] = ticket_count
	data["GameActive"] = game_active
	data["PauseState"] = pause_state
	data["Status"] = heads_up
	data["BossID"] = "boss[boss_id].gif"
	return data

/**
 * This is tgui's replacement for Topic(). It handles any user input from the UI.
 */
/datum/computer_file/program/game/tgui_act(action, list/params)
	if(..()) // Always call parent in tgui_act, it handles making sure the user is allowed to interact with the UI.
		return TRUE

	var/obj/item/weapon/computer_hardware/nano_printer/printer
	if(computer)
		printer = computer.nano_printer

	// var/gamerSkillLevel = usr.mind?.get_skill_level(/datum/skill/gaming)
	// var/gamerSkill = usr.mind?.get_skill_modifier(/datum/skill/gaming, SKILL_RANDS_MODIFIER)
	switch(action)
		if("Attack")
			var/attackamt = 0 //Spam prevention.
			if(pause_state == FALSE)
				attackamt = rand(2,6) // + rand(0, gamerSkill)
			pause_state = TRUE
			heads_up = "You attack for [attackamt] damage."
			playsound(computer.loc, 'sound/arcade/hit.ogg', 50, TRUE, extrarange = -3, falloff = 0.1)
			boss_hp -= attackamt
			sleep(10)
			game_check()
			enemy_check()
			return TRUE
		if("Heal")
			var/healamt = 0 //More Spam Prevention.
			var/healcost = 0
			if(pause_state == FALSE)
				healamt = rand(6,8) // + rand(0, gamerSkill)
				var/maxPointCost = 3
				// if(gamerSkillLevel >= SKILL_LEVEL_JOURNEYMAN)
				// 	maxPointCost = 2
				healcost = rand(1, maxPointCost)
			pause_state = TRUE
			heads_up = "You heal for [healamt] damage."
			playsound(computer.loc, 'sound/arcade/heal.ogg', 50, TRUE, extrarange = -3, falloff = 0.1)
			player_hp += healamt
			player_mp -= healcost
			sleep(10)
			game_check()
			enemy_check()
			return TRUE
		if("Recharge_Power")
			var/rechargeamt = 0 //As above.
			if(pause_state == FALSE)
				rechargeamt = rand(4,7) // + rand(0, gamerSkill)
			pause_state = TRUE
			heads_up = "You regain [rechargeamt] magic power."
			playsound(computer.loc, 'sound/arcade/mana.ogg', 50, TRUE, extrarange = -3, falloff = 0.1)
			player_mp += rechargeamt
			sleep(10)
			game_check()
			enemy_check()
			return TRUE
		if("Dispense_Tickets")
			if(!printer)
				to_chat(usr, "<span class='notice'>Hardware error: A printer is required to redeem tickets.</span>")
				return
			if(printer.stored_paper <= 0)
				to_chat(usr, "<span class='notice'>Hardware error: Printer is out of paper.</span>")
				return
			else
				computer.visible_message("<b>\The [computer]</b> prints out paper.")
				if(ticket_count >= 1)
					new /obj/item/stack/arcadeticket((get_turf(computer)), 1)
					to_chat(usr, "<span class='notice'>[src] dispenses a ticket!</span>")
					ticket_count -= 1
					printer.stored_paper -= 1
				else
					to_chat(usr, "<span class='notice'>You don't have any stored tickets!</span>")
				return TRUE
		if("Start_Game")
			game_active = TRUE
			boss_hp = 45
			player_hp = 30
			player_mp = 10
			heads_up = "You stand before [boss_name]! Prepare for battle!"
			program_icon_state = "arcade"
			boss_id = rand(1,6)
			pause_state = FALSE
			if(istype(computer))
				computer.update_icon()
