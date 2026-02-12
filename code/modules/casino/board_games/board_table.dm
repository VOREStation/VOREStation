/obj/structure/casino_table/board_game
	name = "board game table"
	desc = "A collection of various board games."
	icon_state = "gamble_preview"
	var/datum/board_game/game_ui
	var/static/list/possible_games = list(
		GAME_SWEEPER = /datum/board_game/four_row,
		GAME_FOUR_ROW = /datum/board_game/vore_sweeper,
		GAME_SPACE_BATTLE = /datum/board_game/space_battle,
		GAME_RGP_DICE = /datum/board_game/rpg_dice,
		GAME_CHESS = /datum/board_game/chess,
		GAME_CHECKERS = /datum/board_game/checkers,
		GAME_NINE_MENS_MORRIS = /datum/board_game/nine_mens,
		GAME_TIC_TAC_TOE = /datum/board_game/four_row/tic_tac_toe
	)

/obj/structure/casino_table/board_game/Initialize(mapload)
	. = ..()
	if(ispath(game_ui))
		game_ui = new game_ui(src)

/obj/structure/casino_table/board_game/Destroy()
	game_ui.parent = null
	if(game_ui)
		QDEL_NULL(game_ui)
	. = ..()

/obj/structure/casino_table/board_game/attack_hand(mob/user)
	. = ..()
	if(isliving(user))
		if(!game_ui)
			pick_game(user)
		game_ui.tgui_interact(user)

/obj/structure/casino_table/board_game/click_alt(mob/user)
	pick_game(user)

/obj/structure/casino_table/board_game/proc/pick_game(mob/user)
	if(game_ui?.game_state != GAME_SETUP)
		return
	var/datum/board_game/new_game = tgui_input_list(user, "Pick the game to play", "Choose Game", possible_games)
	if(!new_game)
		return
	new_game = possible_games[new_game]
	if(game_ui)
		QDEL_NULL(game_ui)
	game_ui = new new_game(src)
	icon_state = game_ui.table_icon

/datum/board_game
	var/name
	var/atom/parent
	var/game_state = GAME_SETUP
	var/table_icon = "gamble_preview"

/datum/board_game/tgui_state(mob/user)
	return GLOB.tgui_board_game_state

/datum/board_game/New(atom/holder)
	. = ..()
	parent = holder

/datum/board_game/Destroy(force)
	parent = null
	. = ..()

/datum/board_game/tgui_host(mob/user)
	return parent

/datum/board_game/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("invite_player")
			var/list/possible_mobs = ui.user.living_mobs_in_view(1, TRUE, TRUE)
			for(var/obj/belly/our_belly in ui.user.vore_organs)
				for(var/mob/living/prey in our_belly.contents)
					if(prey.client)
						possible_mobs += prey
			var/mob/living/new_player = tgui_input_list(ui.user, "Invite a nearby player to the game.", "Invite Player", possible_mobs)
			if(!new_player)
				return FALSE
			tgui_interact(new_player)
			return TRUE
	return FALSE
