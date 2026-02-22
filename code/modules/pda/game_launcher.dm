/datum/data/pda/app/game_launcher
	name = "Game Launcher"
	icon = "dice"
	notify_icon = "dice-d20"
	title = "Game Launcher V1.0"
	template = "pda_game_launcher"

	var/datum/board_game/vore_sweeper/voresweeper
	var/datum/board_game/four_row/fourrow
	var/datum/board_game/space_battle/spacebattle
	var/datum/board_game/rpg_dice/rpgdice
	var/datum/board_game/chess/chess
	var/datum/board_game/checkers/checkers
	var/datum/board_game/nine_mens/ninemens
	var/datum/board_game/four_row/tic_tac_toe/tictactoe

/datum/data/pda/app/game_launcher/update_ui(mob/user, list/data)
	data["available_games"] = list(GAME_SWEEPER = voresweeper, GAME_FOUR_ROW = fourrow, GAME_SPACE_BATTLE = spacebattle, GAME_RGP_DICE = rpgdice, GAME_CHESS = chess, GAME_CHECKERS = checkers, GAME_NINE_MENS_MORRIS = ninemens, GAME_TIC_TAC_TOE = tictactoe)

/datum/data/pda/app/game_launcher/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if(GAME_SWEEPER)
			if(params["close"])
				if(!voresweeper)
					return FALSE
				QDEL_NULL(voresweeper)
				return TRUE
			if(!voresweeper)
				voresweeper = new(pda)
			voresweeper.tgui_interact(ui.user)
			return TRUE
		if(GAME_FOUR_ROW)
			if(params["close"])
				if(!fourrow)
					return FALSE
				QDEL_NULL(fourrow)
				return TRUE
			if(!fourrow)
				fourrow = new(pda)
			fourrow.tgui_interact(ui.user)
			return TRUE
		if(GAME_SPACE_BATTLE)
			if(params["close"])
				if(!spacebattle)
					return FALSE
				QDEL_NULL(spacebattle)
				return TRUE
			if(!spacebattle)
				spacebattle = new(pda)
			spacebattle.tgui_interact(ui.user)
			return TRUE
		if(GAME_RGP_DICE)
			if(params["close"])
				if(!rpgdice)
					return FALSE
				QDEL_NULL(rpgdice)
				return TRUE
			if(!rpgdice)
				rpgdice = new(pda)
			rpgdice.tgui_interact(ui.user)
			return TRUE
		if(GAME_CHESS)
			if(params["close"])
				if(!chess)
					return FALSE
				QDEL_NULL(chess)
				return TRUE
			if(!chess)
				chess = new(pda)
			chess.tgui_interact(ui.user)
			return TRUE
		if(GAME_CHECKERS)
			if(params["close"])
				if(!checkers)
					return FALSE
				QDEL_NULL(checkers)
				return TRUE
			if(!checkers)
				checkers = new(pda)
			checkers.tgui_interact(ui.user)
			return TRUE
		if(GAME_NINE_MENS_MORRIS)
			if(params["close"])
				if(!ninemens)
					return FALSE
				QDEL_NULL(ninemens)
				return TRUE
			if(!ninemens)
				ninemens = new(pda)
			ninemens.tgui_interact(ui.user)
			return TRUE
		if(GAME_TIC_TAC_TOE)
			if(params["close"])
				if(!tictactoe)
					return FALSE
				QDEL_NULL(tictactoe)
				return TRUE
			if(!tictactoe)
				tictactoe = new(pda)
			tictactoe.tgui_interact(ui.user)
			return TRUE
	return TRUE

/datum/data/pda/app/game_launcher/Destroy()
	if(voresweeper)
		QDEL_NULL(voresweeper)
	if(fourrow)
		QDEL_NULL(fourrow)
	if(spacebattle)
		QDEL_NULL(spacebattle)
	if(rpgdice)
		QDEL_NULL(rpgdice)
	if(chess)
		QDEL_NULL(chess)
	if(checkers)
		QDEL_NULL(checkers)
	if(checkers)
		QDEL_NULL(ninemens)
	if(tictactoe)
		QDEL_NULL(tictactoe)
	. = ..()
