#define GAME_PLAYER_ONE 1
#define GAME_PLAYER_TWO 2
#define GAME_OVER 3
#define GAME_OVER_DRAW 4
#define GRID_SIZE 8

#define GAME_ACTION_NONE 0
#define GAME_ACTION_SELECT 1
#define GAME_ACTION_END_TURN 2

/obj/structure/casino_table/board_game/checkers
	name = GAME_CHECKERS
	desc = "A classic checkers game."
	icon_state = "gamble_chess"
	game_ui = /datum/board_game/checkers

/datum/board_game/checkers
	name = GAME_CHECKERS
	table_icon = "gamble_chess"
	var/datum/weakref/player_one
	var/datum/weakref/player_two
	var/player_one_time = 0
	var/player_two_time = 0
	var/static/list/default_board = list(
		list(null, "bM", null, "bM", null, "bM", null, "bM"),
		list("bM", null, "bM", null, "bM", null, "bM", null),
		list(null, "bM", null, "bM", null, "bM", null, "bM"),
		list(null, null, null, null, null, null, null, null),
		list(null, null, null, null, null, null, null, null),
		list("wM", null, "wM", null, "wM", null, "wM", null),
		list(null, "wM", null, "wM", null, "wM", null, "wM"),
		list("wM", null, "wM", null, "wM", null, "wM", null)
	)
	var/list/current_board = list()
	var/list/valid_moves = list()
	var/list/selected_figure = list()
	var/list/possible_jumps = list()
	var/turn_start_time = 0
	var/winner

/datum/board_game/checkers/Destroy(force)
	player_one = null
	player_two = null
	. = ..()

/datum/board_game/checkers/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ChessCheckers", name)
		ui.open()

/datum/board_game/checkers/tgui_static_data(mob/user)
	return list("game_type" = "checkers")

/datum/board_game/checkers/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/mob/player_one_mob = player_one?.resolve()
	var/mob/player_two_mob = player_two?.resolve()

	return list(
		"player_one" = player_one_mob,
		"player_two" = player_two_mob,
		"player_one_time" = player_one_time + (game_state == GAME_PLAYER_ONE ? world.time - turn_start_time : 0),
		"player_two_time" = player_two_time + (game_state == GAME_PLAYER_TWO ? world.time - turn_start_time : 0),
		"current_board" = current_board,
		"selected_figure" = selected_figure,
		"valid_moves" = valid_moves,
		"game_state" = game_state,
		"winner" = winner,
		"has_won" = winner == ui.user.name,
		"possible_jumps" = possible_jumps
	)

/datum/board_game/checkers/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
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
			current_board = get_defaultboard()
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

/datum/board_game/checkers/proc/reset(full)
	winner = null
	player_one_time = 0
	player_two_time = 0
	selected_figure.Cut()
	valid_moves.Cut()
	if(full)
		current_board.Cut()
		game_state = GAME_SETUP
		player_one = null
		player_two = null
	else
		current_board = get_defaultboard()
		game_state = GAME_PLAYER_ONE

/datum/board_game/checkers/proc/player_actions(action, list/params, mob/user, active_color)
	switch(action)
		if("select_figure")
			var/list/validated_data = validate_coords(params)
			if (!validated_data)
				return GAME_ACTION_NONE

			var/piece = current_board[validated_data[2]][validated_data[1]]
			if(!piece || piece[1] != active_color)
				return GAME_ACTION_NONE

			if(has_available_jumps(active_color))
				var/list/jumps = generate_valid_moves(validated_data[1], validated_data[2], TRUE)
				if (length(jumps) == 0)
					return GAME_ACTION_NONE

			selected_figure = validated_data
			update_valid_moves()
			return GAME_ACTION_SELECT

		if("move_figure")
			var/list/coords = validate_coords(params)
			if(!coords || !selected_figure)
				return GAME_ACTION_NONE

			var/to_x = coords[1]
			var/to_y = coords[2]

			if(!valid_move(to_x, to_y))
				return GAME_ACTION_NONE

			var/from_x = selected_figure[1]
			var/from_y = selected_figure[2]
			var/moving_piece = current_board[from_y][from_x]

			if(moving_piece[2] == "M" && ((moving_piece[1] == "w" && to_y == 1) || (moving_piece[1] == "b" && to_y == GRID_SIZE)))
				moving_piece = moving_piece[1] + "K"

			current_board[to_y][to_x] = moving_piece
			current_board[from_y][from_x] = null

			var/did_jump = FALSE
			if(abs(to_x - from_x) >= 2 && abs(to_y - from_y) >= 2)
				var/step_x = (to_x - from_x) / abs(to_x - from_x)
				var/step_y = (to_y - from_y) / abs(to_y - from_y)
				var/x = from_x + step_x
				var/y = from_y + step_y

				while(x != to_x && y != to_y)
					var/p = current_board[y][x]
					if(p && p[1] != moving_piece[1])
						current_board[y][x] = null
						did_jump = TRUE
						break
					x += step_x
					y += step_y

				if(did_jump && piece_can_jump_again(to_x, to_y))
					selected_figure = list(to_x, to_y)
					update_valid_moves()
					validate_victory(active_color)
					possible_jumps = get_mandatory_jumps(active_color)
					return GAME_ACTION_SELECT

			var/turn_duration = world.time - turn_start_time
			if(game_state == GAME_PLAYER_ONE)
				player_one_time += turn_duration
			else if(game_state == GAME_PLAYER_TWO)
				player_two_time += turn_duration

			selected_figure.Cut()
			update_valid_moves()
			validate_victory(active_color)
			if(game_state != GAME_OVER)
				possible_jumps = get_mandatory_jumps(active_color == "w" ? "b" : "w")
			else
				possible_jumps.Cut()
			return GAME_ACTION_END_TURN

/datum/board_game/checkers/proc/get_mandatory_jumps(active_color)
	var/list/jumping_pieces = list()
	if(!has_available_jumps(active_color))
		return jumping_pieces

	for(var/row = 1 to GRID_SIZE)
		for(var/col = 1 to GRID_SIZE)
			var/piece = current_board[row][col]
			if(piece && piece[1] == active_color)
				var/list/jumps = generate_valid_moves(col, row, TRUE)
				if(length(jumps) > 0)
					UNTYPED_LIST_ADD(jumping_pieces, list(col, row))
	return jumping_pieces

/datum/board_game/checkers/proc/update_valid_moves()
	valid_moves.Cut()
	if(length(selected_figure))
		var/x = selected_figure[1]
		var/y = selected_figure[2]
		valid_moves = generate_valid_moves(x, y)

/datum/board_game/checkers/proc/piece_can_jump_again(x, y)
	var/piece = current_board[y][x]
	if(!piece)
		return FALSE

	for(var/list/move in generate_valid_moves(x, y, TRUE))
		if(abs(move[1] - x) >= 2 && abs(move[2] - y) >= 2)
			return TRUE
	return FALSE

/datum/board_game/checkers/proc/valid_move(to_x, to_y)
	for(var/list/move in valid_moves)
		if(move[1] == to_x && move[2] == to_y)
			return TRUE
	return FALSE

/datum/board_game/checkers/proc/validate_victory(active_color)
	var/opponent_color = active_color == "w" ? "b" : "w"
	var/any_opponent_pieces = FALSE
	var/opponent_has_moves = FALSE

	var/opponent_has_jumps = has_available_jumps(opponent_color)

	for(var/row = 1 to GRID_SIZE)
		for(var/col = 1 to GRID_SIZE)
			var/piece = current_board[row][col]
			if(piece && piece[1] == opponent_color)
				any_opponent_pieces = TRUE

				var/list/moves
				if(opponent_has_jumps)
					moves = generate_valid_moves(col, row, TRUE)
				else
					moves = generate_valid_moves(col, row)

				if(length(moves) > 0)
					opponent_has_moves = TRUE
					break
		if(opponent_has_moves)
			break

	if(!any_opponent_pieces)
		var/mob/player_one_mob = player_one?.resolve()
		var/mob/player_two_mob = player_two?.resolve()
		winner = active_color == "w" ? player_one_mob?.name : player_two_mob?.name
		game_state = GAME_OVER
		return

	if(!opponent_has_moves)
		if(any_opponent_pieces)
			winner = null
			game_state = GAME_OVER_DRAW
			return

		var/mob/player_one_mob = player_one?.resolve()
		var/mob/player_two_mob = player_two?.resolve()
		winner = active_color == "w" ? player_one_mob?.name : player_two_mob?.name
		game_state = GAME_OVER

/datum/board_game/checkers/proc/generate_valid_moves(x, y, jump_only)
	var/piece = current_board[y][x]
	var/list/moves = list()

	if (!piece)
		return moves

	var/directions = list()

	switch(piece[2])
		if("M")
			if(piece[1] == "w")
				directions = list(list(1, -1), list(-1, -1))
			else
				directions = list(list(1, 1), list(-1, 1))
		if("K")
			directions = list(list(1, 1), list(-1, 1), list(1, -1), list(-1, -1))

	var/list/jump_moves = list()
	add_jumps(directions, x, y, jump_moves)

	if(length(jump_moves) || jump_only)
		return jump_moves

	switch(piece[2])
		if("M")
			for(var/list/direction in directions)
				var/new_x = x + direction[1]
				var/new_y = y + direction[2]
				if(field_check(new_x, new_y) && current_board[new_y][new_x] == null)
					UNTYPED_LIST_ADD(moves, list(new_x, new_y))
		if("K")
			for(var/list/direction in directions)
				var/step = 1
				while(TRUE)
					var/new_x = x + direction[1] * step
					var/new_y = y + direction[2] * step
					if(!field_check(new_x, new_y))
						break
					if(current_board[new_y][new_x])
						break
					UNTYPED_LIST_ADD(moves, list(new_x, new_y))
					step += 1
	return moves

/datum/board_game/checkers/proc/has_available_jumps(active_color)
	for (var/row = 1 to GRID_SIZE)
		for (var/col = 1 to GRID_SIZE)
			var/piece = current_board[row][col]
			if (piece && piece[1] == active_color)
				var/list/jumps = generate_valid_moves(col, row, TRUE)
				if (length(jumps) > 0)
					return TRUE
	return FALSE

/datum/board_game/checkers/proc/already_visited(x, y, list/visited_list)
	for(var/list/coord in visited_list)
		if(coord[1] == x && coord[2] == y)
			return TRUE
	return FALSE

/datum/board_game/checkers/proc/add_jumps(var/list/directions, start_x, start_y, list/jump_moves, list/visited = list())
	var/piece = current_board[start_y][start_x]
	if(!piece)
		return

	for(var/list/direction in directions)
		switch(piece[2])
			if("M")
				var/tx = start_x + direction[1] * 2
				var/ty = start_y + direction[2] * 2

				if(!field_check(tx, ty) || already_visited(tx, ty, visited))
					continue

				if(can_jump_piece(start_x, start_y, tx, ty))
					var/list/new_visited = visited.Copy()
					UNTYPED_LIST_ADD(new_visited, list(tx, ty))
					UNTYPED_LIST_ADD(jump_moves, list(tx, ty))
					add_jumps(directions, tx, ty, jump_moves, new_visited)
			if("K")
				var/step = 1
				while(TRUE)
					var/tx = start_x + direction[1] * step
					var/ty = start_y + direction[2] * step

					if(!field_check(tx, ty))
						break

					if(already_visited(tx, ty, visited))
						step++
						continue

					if(can_jump_piece(start_x, start_y, tx, ty))
						var/list/new_visited = visited.Copy()
						UNTYPED_LIST_ADD(new_visited, list(tx, ty))
						UNTYPED_LIST_ADD(jump_moves, list(tx, ty))
						add_jumps(directions, tx, ty, jump_moves, new_visited)

					step++

/datum/board_game/checkers/proc/can_jump_piece(from_x, from_y, to_x, to_y)
	var/piece = current_board[from_y][from_x]
	if(!piece)
		return FALSE

	var/dx = to_x - from_x
	var/dy = to_y - from_y
	var/color = piece[1]

	switch(piece[2])
		if("M")
			if(abs(dx) != 2 || abs(dy) != 2)
				return FALSE
			var/mid_x = from_x + dx / 2
			var/mid_y = from_y + dy / 2
			var/mid_piece = current_board[mid_y][mid_x]
			if(mid_piece && mid_piece[1] != color && current_board[to_y][to_x] == null)
				return TRUE
			return FALSE
		if("K")
			if(abs(dx) != abs(dy))
				return FALSE

			var/step_x = dx / abs(dx)
			var/step_y = dy / abs(dy)
			var/x = from_x + step_x
			var/y = from_y + step_y

			var/jumped_piece_found = FALSE
			var/jumped_x = 0
			var/jumped_y = 0

			while(x != to_x && y != to_y)
				var/piece_at_square = current_board[y][x]
				if(piece_at_square)
					if(piece_at_square[1] == color)
						return FALSE
					if(jumped_piece_found)
						return FALSE
					jumped_piece_found = TRUE
					jumped_x = x
					jumped_y = y
				x += step_x
				y += step_y

			if(!jumped_piece_found)
				return FALSE

			if(current_board[to_y][to_x] != null)
				return FALSE

			x = jumped_x + step_x
			y = jumped_y + step_y

			while(x != to_x || y != to_y)
				if(current_board[y][x] != null)
					return FALSE
				x += step_x
				y += step_y

			return TRUE

/datum/board_game/checkers/proc/field_check(new_x_location, new_y_location)
	if(new_x_location < 1 || new_x_location > GRID_SIZE)
		return FALSE
	if(new_y_location < 1 || new_y_location > GRID_SIZE)
		return FALSE
	return TRUE

/datum/board_game/checkers/proc/validate_coords(list/params)
	var/x_loc = text2num(params["loc_x"])
	var/y_loc = text2num(params["loc_y"])

	if(!isnum(x_loc) || !isnum(y_loc))
		return null

	if(!field_check(x_loc, y_loc))
		return null

	return list(x_loc, y_loc)

/datum/board_game/checkers/proc/get_defaultboard()
	var/list/deep_copy = list()
	for(var/list/row in default_board)
		UNTYPED_LIST_ADD(deep_copy, row.Copy())
	return deep_copy

#undef GAME_PLAYER_ONE
#undef GAME_PLAYER_TWO
#undef GAME_OVER
#undef GAME_OVER_DRAW
#undef GRID_SIZE

#undef GAME_ACTION_NONE
#undef GAME_ACTION_SELECT
#undef GAME_ACTION_END_TURN
