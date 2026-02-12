#define GAME_PLAYER_ONE 1
#define GAME_PLAYER_TWO 2
#define GAME_OVER 3
#define GAME_OVER_DRAW 4
#define NODE_COUNT 24

#define GAME_ACTION_NONE 0
#define GAME_ACTION_SELECT 1
#define GAME_ACTION_END_TURN 2

#define GAME_PHASE_PLACING 0
#define GAME_PHASE_MOVING 1
#define GAME_PHASE_REMOVING 2
#define GAME_PHASE_NONE 3

/obj/structure/casino_table/board_game/nine_mens
	name = GAME_NINE_MENS_MORRIS
	desc = "A classic nine_mens game."
	icon_state = "gamble_ninemen"
	game_ui = /datum/board_game/nine_mens

/datum/board_game/nine_mens
	name = GAME_NINE_MENS_MORRIS
	table_icon = "gamble_ninemen"
	var/datum/weakref/player_one
	var/datum/weakref/player_two
	var/player_one_time = 0
	var/player_two_time = 0
	var/list/current_board = list(
		null, null, null,
		null, null, null,
		null, null, null,
		null, null, null,
		null, null, null,
		null, null, null,
		null, null, null,
		null, null, null
	)
	var/static/list/adjacent = list(
		list(2, 10),
		list(1, 3, 5),
		list(2, 15),
		list(5, 11),
		list(2, 4, 6, 8),
		list(5, 14),
		list(8, 12),
		list(5, 7, 9),
		list(8, 13),
		list(1, 11, 22),
		list(4, 10, 12, 19),
		list(7, 11, 16),
		list(9, 14, 18),
		list(6, 13, 15, 21),
		list(3, 14, 24),
		list(12, 17),
		list(16, 18, 20),
		list(13, 17),
		list(11, 20),
		list(17, 19, 21, 23),
		list(14, 20),
		list(10, 23),
		list(20, 22, 24),
		list(15, 23)
	)
	var/static/list/mills = list(
		list(1,2,3),
		list(4,5,6),
		list(7,8,9),
		list(10,11,12),
		list(13,14,15),
		list(16,17,18),
		list(19,20,21),
		list(22,23,24),

		list(1,10,22),
		list(4,11,19),
		list(7,12,16),
		list(2,5,8),
		list(17,20,23),
		list(9,13,18),
		list(6,14,21),
		list(3,15,24)
	)
	var/list/valid_moves = list()
	var/list/valid_removes = list()
	var/selected_node
	var/turn_start_time = 0
	var/pone_pieces = 9
	var/ptwo_pieces = 9
	var/winner
	var/phase = GAME_PHASE_PLACING

/datum/board_game/nine_mens/Destroy(force)
	player_one = null
	player_two = null
	. = ..()

/datum/board_game/nine_mens/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "NineMen", name)
		ui.open()

/datum/board_game/nine_mens/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/mob/player_one_mob = player_one?.resolve()
	var/mob/player_two_mob = player_two?.resolve()

	return list(
		"player_one" = player_one_mob,
		"player_two" = player_two_mob,
		"player_one_time" = player_one_time + (game_state == GAME_PLAYER_ONE ? world.time - turn_start_time : 0),
		"player_two_time" = player_two_time + (game_state == GAME_PLAYER_TWO ? world.time - turn_start_time : 0),
		"current_board" = current_board,
		"selected_node" = selected_node,
		"valid_moves" = valid_moves,
		"valid_removes" = valid_removes,
		"game_state" = game_state,
		"winner" = winner,
		"has_won" = winner == ui.user.name,
		"phase" = phase,
		"pone_pieces" = pone_pieces,
		"ptwo_pieces" = ptwo_pieces
	)

/datum/board_game/nine_mens/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("be_player_one")
			if(game_state != GAME_SETUP)
				return FALSE
			if(player_one?.resolve() == ui.user)
				player_one = null
				return TRUE
			player_one = WEAKREF(ui.user)
			return TRUE
		if("be_player_two")
			if(game_state != GAME_SETUP)
				return FALSE
			if(player_two?.resolve() == ui.user)
				player_two = null
				return TRUE
			player_two = WEAKREF(ui.user)
			return TRUE
		if("swap_players")
			if(game_state != GAME_SETUP)
				return FALSE
			if(!player_one?.resolve() || !player_two?.resolve())
				return FALSE
			var/datum/weakref/temp_player = player_one
			player_one = player_two
			player_two = temp_player
		if("clear_game")
			if(game_state == GAME_SETUP)
				return FALSE
			reset(TRUE)
			return TRUE
		if("start_game")
			if(game_state != GAME_SETUP)
				return FALSE
			if(!player_one?.resolve() || !player_two?.resolve())
				return FALSE
			game_state = GAME_PLAYER_ONE
			turn_start_time = world.time
			return TRUE
		if("play_again")
			if(game_state < GAME_OVER)
				return FALSE
			if(!player_one?.resolve() || !player_two?.resolve())
				return FALSE
			reset()
			turn_start_time = world.time
			return TRUE
		if("play_again_swapped")
			if(game_state < GAME_OVER)
				return FALSE
			if(!player_one?.resolve() || !player_two?.resolve())
				return FALSE
			reset()
			var/datum/weakref/temp_player = player_one
			player_one = player_two
			player_two = temp_player
			turn_start_time = world.time
			return TRUE
		if("game_action")
			if(ui.user == player_one?.resolve() && game_state == GAME_PLAYER_ONE)
				var/game_action = player_actions(params["action"], params["data"], ui.user, "w")
				if(game_action)
					if(game_state < GAME_OVER && game_action == GAME_ACTION_END_TURN)
						game_state = GAME_PLAYER_TWO
						turn_start_time = world.time
					return TRUE
			if(ui.user == player_two?.resolve() && game_state == GAME_PLAYER_TWO)
				var/game_action = player_actions(params["action"], params["data"], ui.user, "b")
				if(game_action)
					if(game_state < GAME_OVER && game_action == GAME_ACTION_END_TURN)
						game_state = GAME_PLAYER_ONE
						turn_start_time = world.time
					return TRUE
			return FALSE

/datum/board_game/nine_mens/proc/reset(full)
	winner = null
	player_one_time = 0
	player_two_time = 0
	selected_node = null
	valid_moves.Cut()
	valid_removes.Cut()
	pone_pieces = 9
	ptwo_pieces = 9
	phase = GAME_PHASE_PLACING
	for(var/i = 1 to NODE_COUNT)
		current_board[i] = null
	if(full)
		game_state = GAME_SETUP
		player_one = null
		player_two = null
	else
		game_state = GAME_PLAYER_ONE

/datum/board_game/nine_mens/proc/player_actions(action, list/params, mob/user, active_color)
	switch(action)
		if("select_figure")
			var/node = validate_node(params)
			if(!node)
				return GAME_ACTION_NONE

			var/piece = current_board[node]
			if(!piece || piece[1] != active_color)
				return GAME_ACTION_NONE

			selected_node = node
			update_valid_moves()
			return GAME_ACTION_SELECT

		if("move_figure")
			var/target_node = validate_node(params)
			if(!target_node)
				return GAME_ACTION_NONE

			switch(phase)
				if(GAME_PHASE_PLACING)
					if(current_board[target_node])
						return GAME_ACTION_NONE

					current_board[target_node] = active_color

					if(active_color == "w")
						if(pone_pieces > 0)
							pone_pieces--
					else
						if(ptwo_pieces > 0)
							ptwo_pieces--

					if(check_for_mill(target_node, active_color))
						phase = GAME_PHASE_REMOVING
						update_valid_removals(active_color == "w" ? "b" : "w")
					else
						if((ptwo_pieces && active_color == "w") || (pone_pieces && active_color == "b"))
							phase = GAME_PHASE_PLACING
						else
							phase = GAME_PHASE_MOVING
					return phase == GAME_PHASE_REMOVING ? GAME_ACTION_SELECT : GAME_ACTION_END_TURN

				if(GAME_PHASE_MOVING)
					if(!selected_node)
						return GAME_ACTION_NONE
					if(!valid_move(active_color, selected_node, target_node))
						return GAME_ACTION_NONE

					current_board[target_node] = current_board[selected_node]
					current_board[selected_node] = null
					selected_node = null
					valid_moves.Cut()
					validate_victory(active_color)
					if(game_state < GAME_OVER)
						if(check_for_mill(target_node, active_color))
							phase = GAME_PHASE_REMOVING
							update_valid_removals(active_color == "w" ? "b" : "w")
						else
							phase = GAME_PHASE_MOVING
					else
						phase = GAME_PHASE_NONE

					return phase == GAME_PHASE_REMOVING ? GAME_ACTION_SELECT : GAME_ACTION_END_TURN

				if(GAME_PHASE_REMOVING)
					if(!valid_remove(target_node))
						return GAME_ACTION_NONE

					current_board[target_node] = null

					valid_removes.Cut()
					validate_victory(active_color)
					if(game_state < GAME_OVER)
						if((ptwo_pieces && active_color == "w") || (pone_pieces && active_color == "b"))
							phase = GAME_PHASE_PLACING
						else
							phase = GAME_PHASE_MOVING
					else
						phase = GAME_PHASE_NONE

					return GAME_ACTION_END_TURN

	return GAME_ACTION_NONE

/datum/board_game/nine_mens/proc/update_valid_moves()
	valid_moves.Cut()
	if(selected_node)
		valid_moves = generate_valid_moves(selected_node)

/datum/board_game/nine_mens/proc/update_valid_removals(opponent_color)
	valid_removes.Cut()
	for(var/i = 1 to NODE_COUNT)
		if(current_board[i] && current_board[i][1] == opponent_color)
			if(!check_for_mill(i, opponent_color))
				valid_removes += i
	if(!length(valid_removes))
		for(var/i = 1 to NODE_COUNT)
			if(current_board[i] && current_board[i][1] == opponent_color)
				valid_removes += i

/datum/board_game/nine_mens/proc/valid_remove(picked_node)
	if(!picked_node || !current_board[picked_node] || !(picked_node in valid_removes))
		return FALSE
	return TRUE

/datum/board_game/nine_mens/proc/check_for_mill(node, color)
	for(var/mill in mills)
		if(node in mill)
			var/mill_complete = TRUE
			for(var/mill_node in mill)
				if(!current_board[mill_node] || current_board[mill_node][1] != color)
					mill_complete = FALSE
					break
			if(mill_complete)
				return TRUE
	return FALSE

/datum/board_game/nine_mens/proc/valid_move(active_color, from_node, to_node)
	if(current_board[to_node])
		return FALSE

	if(count_pieces(active_color) == 3)
		return TRUE

	for(var/adj in adjacent[from_node])
		if(adj == to_node)
			return TRUE

	return FALSE

/datum/board_game/nine_mens/proc/validate_victory(active_color)
	var/opponent = (active_color == "w") ? "b" : "w"

	if(count_pieces(opponent) < 3 || !has_moves(opponent))
		var/mob/winning_player = (active_color == "w" ? player_one?.resolve() : player_two?.resolve())
		winner = winning_player?.name
		game_state = GAME_OVER

/datum/board_game/nine_mens/proc/generate_valid_moves(node)
	var/list/moves = list()

	if(!current_board[node])
		return moves

	var/color = current_board[node][1]

	if(count_pieces(color) == 3)
		for(var/i = 1 to NODE_COUNT)
			if(!current_board[i])
				moves += i
		return moves

	for(var/adj in adjacent[node])
		if(!current_board[adj])
			moves += adj

	return moves

/datum/board_game/nine_mens/proc/count_pieces(color)
	var/count = color == "w" ? pone_pieces : ptwo_pieces
	for(var/i = 1 to NODE_COUNT)
		if(current_board[i] && current_board[i][1] == color)
			count++
	return count

/datum/board_game/nine_mens/proc/has_moves(color)
	for(var/i = 1 to NODE_COUNT)
		if(current_board[i] && current_board[i][1] == color)
			if(length(generate_valid_moves(i)))
				return TRUE
	return FALSE

/datum/board_game/nine_mens/proc/validate_node(list/params)
	var/node = text2num(params["node_number"])

	if(!isnum(node))
		return null

	if(node < 1 || node > 24)
		return null

	return node

#undef GAME_PLAYER_ONE
#undef GAME_PLAYER_TWO
#undef GAME_OVER
#undef GAME_OVER_DRAW
#undef NODE_COUNT

#undef GAME_ACTION_NONE
#undef GAME_ACTION_SELECT
#undef GAME_ACTION_END_TURN

#undef GAME_PHASE_PLACING
#undef GAME_PHASE_MOVING
#undef GAME_PHASE_REMOVING
