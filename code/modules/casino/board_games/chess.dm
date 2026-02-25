#define GAME_PLAYER_ONE 1
#define GAME_PLAYER_TWO 2
#define GAME_OVER 3
#define GAME_OVER_DRAW 4
#define GRID_SIZE 8
#define GAME_FLAG_CHECK_PONE 0x1
#define GAME_FLAG_CHECK_PTWO 0x2
#define GAME_FLAG_CASTLING_USED_PONE 0x4
#define GAME_FLAG_CASTLING_USED_PTWO 0x8

#define GAME_ACTION_NONE 0
#define GAME_ACTION_SELECT 1
#define GAME_ACTION_END_TURN 2

/obj/structure/casino_table/board_game/chess
	name = GAME_CHESS
	desc = "A classic chess game."
	icon_state = "gamble_chess"
	game_ui = /datum/board_game/chess

/datum/board_game/chess
	name = GAME_CHESS
	table_icon = "gamble_chess"
	var/datum/weakref/player_one
	var/datum/weakref/player_two
	var/player_one_time = 0
	var/player_two_time = 0
	var/static/list/default_board = list(
		list("bR","bN","bB","bQ","bK","bB","bN","bR"),
		list("bP","bP","bP","bP","bP","bP","bP","bP"),
		list(null,null,null,null,null,null,null,null),
		list(null,null,null,null,null,null,null,null),
		list(null,null,null,null,null,null,null,null),
		list(null,null,null,null,null,null,null,null),
		list("wP","wP","wP","wP","wP","wP","wP","wP"),
		list("wR","wN","wB","wQ","wK","wB","wN","wR")
	)
	var/list/current_board = list()
	var/list/valid_moves = list()
	var/list/selected_figure = list()
	var/list/last_double_pawn_move = list()
	var/game_flags = NONE
	var/turn_start_time = 0
	var/winner

/datum/board_game/chess/Destroy(force)
	player_one = null
	player_two = null
	. = ..()

/datum/board_game/chess/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ChessCheckers", name)
		ui.open()

/datum/board_game/chess/tgui_static_data(mob/user)
	return list("game_type" = "chess")

/datum/board_game/chess/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
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
		"game_flags" = game_flags
	)

/datum/board_game/chess/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
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

/datum/board_game/chess/proc/reset(full)
	winner = null
	player_one_time = 0
	player_two_time = 0
	selected_figure.Cut()
	valid_moves.Cut()
	last_double_pawn_move.Cut()
	game_flags = NONE
	if(full)
		current_board.Cut()
		game_state = GAME_SETUP
		player_one = null
		player_two = null
	else
		current_board = get_defaultboard()
		game_state = GAME_PLAYER_ONE

/datum/board_game/chess/proc/player_actions(action, list/params, mob/user, active_color)
	switch(action)
		if("select_figure")
			var/list/validated_data = validate_coords(params)
			if(!validated_data)
				return GAME_ACTION_NONE

			var/piece = current_board[validated_data[2]][validated_data[1]]
			if(!piece)
				return GAME_ACTION_NONE

			if(piece[1] != active_color)
				return GAME_ACTION_NONE

			selected_figure = validated_data
			update_valid_moves()
			return GAME_ACTION_SELECT
		if("move_figure")
			var/list/coords = validate_coords(params)
			if(!coords || !selected_figure)
				return GAME_ACTION_NONE

			var/from_x = selected_figure[1]
			var/from_y = selected_figure[2]
			var/to_x = coords[1]
			var/to_y = coords[2]

			if(!valid_move(to_x, to_y))
				return GAME_ACTION_NONE

			var/moving_piece = current_board[from_y][from_x]
			var/target_piece = current_board[to_y][to_x]

			var/turn_duration = world.time - turn_start_time
			if(game_state == GAME_PLAYER_ONE)
				player_one_time += turn_duration
			else if(game_state == GAME_PLAYER_TWO)
				player_two_time += turn_duration

			if(moving_piece[2] == "K" && abs(to_x - from_x) == 2)
				if(!handle_castling(active_color, from_x, from_y, to_x, to_y))
					return GAME_ACTION_NONE
				do_castling(active_color, from_x, from_y, to_x, to_y)

			if(moving_piece[2] == "P" && abs(to_x - from_x) == 1 && !target_piece)
				if(can_en_passant(from_x, from_y, to_x, to_y))
					current_board[from_y][to_x] = null

			if(!(moving_piece[2] == "K" && abs(to_x - from_x) == 2))
				current_board[to_y][to_x] = moving_piece
				current_board[from_y][from_x] = null

			if(moving_piece[2] == "P" && abs(to_y - from_y) == 2)
				last_double_pawn_move = list(to_x, to_y, moving_piece[1])
			else
				last_double_pawn_move.Cut()

			if(moving_piece[2] == "P")
				if((moving_piece[1] == "w" && to_y == 1) || (moving_piece[1] == "b" && to_y == GRID_SIZE))
					var/promotion = params["promotion_choice"]
					if(!(promotion in list("Q", "R", "B", "N")))
						promotion = "Q"
					current_board[to_y][to_x] = moving_piece[1] + promotion

			selected_figure.Cut()
			update_valid_moves()
			validate_victory(active_color)

			return GAME_ACTION_END_TURN

/datum/board_game/chess/proc/valid_move(to_x, to_y)
	for(var/list/move in valid_moves)
		if(move[1] == to_x && move[2] == to_y)
			return TRUE
	return FALSE

/datum/board_game/chess/proc/handle_castling(active_color, from_x, from_y, to_x, to_y)
	if(active_color == "w" && (game_flags & (GAME_FLAG_CASTLING_USED_PONE|GAME_FLAG_CHECK_PONE)))
		return FALSE
	if(active_color == "b" && (game_flags & (GAME_FLAG_CASTLING_USED_PTWO|GAME_FLAG_CHECK_PTWO)))
		return FALSE

	var/king = current_board[from_y][from_x]

	if(king != "wK" && king != "bK")
		return FALSE

	if(abs(to_x - from_x) != 2)
		return FALSE

	var/row = from_y
	var/rook_x
	var/rook
	var/col_start
	var/col_end

	if(to_x > from_x)
		rook_x = GRID_SIZE
		rook = current_board[row][rook_x]
		if(rook != "wR" && rook != "bR")
			return FALSE
		col_start = from_x + 1
		col_end = to_x
	else
		rook_x = 1
		rook = current_board[row][rook_x]
		if(rook != "wR" && rook != "bR")
			return FALSE
		col_start = to_x
		col_end = from_x - 1

	for(var/c = col_start to col_end)
		if(current_board[row][c] != null && c != from_x)
			return FALSE

	var/opponent_color = active_color == "w" ? "b" : "w"
	if(!opponent_color)
		return FALSE

	if(square_under_attack(opponent_color, from_x, from_y))
		return FALSE

	var/step = (to_x > from_x ? 1 : -1)
	var/x = from_x
	while(x != to_x + step)
		if(x != from_x && x != to_x && square_under_attack(opponent_color, x, row))
			return FALSE
		x += step
	return TRUE

/datum/board_game/chess/proc/do_castling(active_color, from_x, from_y, to_x, to_y)
	var/row = from_y
	var/king = current_board[from_y][from_x]
	var/rook_x
	var/rook
	var/rook_target_x

	if(to_x > from_x)
		rook_x = GRID_SIZE
		rook = current_board[row][rook_x]
		rook_target_x = to_x - 1
	else
		rook_x = 1
		rook = current_board[row][rook_x]
		rook_target_x = to_x + 1

	current_board[row][to_x] = king
	current_board[row][from_x] = null

	current_board[row][rook_target_x] = rook
	current_board[row][rook_x] = null

	if(active_color == "w")
		game_flags |= GAME_FLAG_CASTLING_USED_PONE
	else
		game_flags |= GAME_FLAG_CASTLING_USED_PTWO

	return TRUE

/datum/board_game/chess/proc/update_valid_moves()
	valid_moves.Cut()
	if(length(selected_figure))
		var/x = selected_figure[1]
		var/y = selected_figure[2]
		valid_moves = generate_valid_moves(x, y)

/datum/board_game/chess/proc/square_under_attack(opponent_color, x, y)
	for(var/row = 1; row <= GRID_SIZE; row++)
		for(var/col = 1; col <= GRID_SIZE; col++)
			var/piece = current_board[row][col]
			if(!piece)
				continue

			if(piece[1] != opponent_color)
				continue

			var/dx = x - col
			var/dy = y - row

			switch(piece[2])
				if("P")
					var/dir = (piece[1] == "w" ? -1 : 1)
					if(dy == dir && abs(dx) == 1)
						return TRUE
				if("N")
					if(abs(dx) == 2 && abs(dy) == 1 || abs(dx) == 1 && abs(dy) == 2)
						return TRUE
				if("B")
					if(abs(dx) == abs(dy) && path_clear(col, row, x, y))
						return TRUE
				if("R")
					if((dx == 0 || dy == 0) && path_clear(col, row, x, y))
						return TRUE
				if("Q")
					if((dx == 0 || dy == 0 || abs(dx) == abs(dy)) && path_clear(col, row, x, y))
						return TRUE
				if("K")
					if(abs(dx) <= 1 && abs(dy) <= 1)
						return TRUE
	return FALSE

/datum/board_game/chess/proc/path_clear(from_x, from_y, to_x, to_y)
	var/dx = to_x - from_x
	var/dy = to_y - from_y
	var/step_x = dx == 0 ? 0 : (dx / abs(dx))
	var/step_y = dy == 0 ? 0 : (dy / abs(dy))
	var/x = from_x + step_x
	var/y = from_y + step_y

	while(x != to_x || y != to_y)
		if(!field_check(x, y))
			return FALSE
		if(current_board[y][x] != null)
			return FALSE
		x += step_x
		y += step_y

	return TRUE

/datum/board_game/chess/proc/validate_victory(active_color)
	var/opponent_color = active_color == "w" ? "b" : "w"

	var/king_pos = locate_king(opponent_color)
	if(!king_pos)
		var/mob/winning_player = (active_color == "w" ? player_two?.resolve() : player_one?.resolve())
		winner = winning_player?.name
		game_state = GAME_OVER
		return

	var/in_check = square_under_attack(active_color, king_pos[1], king_pos[2])

	if(in_check)
		game_flags |= (opponent_color == "w" ? GAME_FLAG_CHECK_PONE : GAME_FLAG_CHECK_PTWO)
	else
		game_flags &= ~(opponent_color == "w" ? GAME_FLAG_CHECK_PONE : GAME_FLAG_CHECK_PTWO)

	var/no_moves = TRUE
	for(var/row = 1 to GRID_SIZE)
		for(var/col = 1 to GRID_SIZE)
			var/piece = current_board[row][col]
			if(!piece)
				continue
			if(piece[1] != opponent_color)
				continue
			var/list/moves = generate_valid_moves(col, row)
			if(length(moves) > 0)
				no_moves = FALSE

	if(in_check && no_moves)
		var/mob/winning_player = active_color == "w" ? player_one?.resolve() : player_two?.resolve()
		winner = winning_player?.name
		game_state = GAME_OVER
		return
	if(!in_check && no_moves)
		winner = null
		game_state = GAME_OVER_DRAW

/datum/board_game/chess/proc/locate_king(color)
	var/king_symbol = color + "K"
	for(var/row = 1 to GRID_SIZE)
		for(var/col = 1 to GRID_SIZE)
			if(current_board[row][col] == king_symbol)
				return list(col, row)
	return null

/datum/board_game/chess/proc/generate_valid_moves(x, y)
	var/piece = current_board[y][x]
	var/moves = list()
	if(!piece)
		return moves

	for(var/row = 1 to GRID_SIZE)
		for(var/col = 1 to GRID_SIZE)
			if(row == y && col == x)
				continue
			if(can_move_piece(x, y, col, row))
				UNTYPED_LIST_ADD(moves, list(col, row))
	return moves

/datum/board_game/chess/proc/can_move_piece(from_x, from_y, to_x, to_y)
	var/piece = current_board[from_y][from_x]
	if(!piece)
		return FALSE

	var/dx = to_x - from_x
	var/dy = to_y - from_y
	var/abs_dx = abs(dx)
	var/abs_dy = abs(dy)

	if(dx == 0 && dy == 0)
		return FALSE

	var/color = piece[1]
	var/target = current_board[to_y][to_x]
	if(target && target[1] == color)
		return FALSE

	var/can_move = FALSE

	switch(piece[2])
		if("P")
			var/dir = (color == "w" ? -1 : 1)
			if(dx == 0 && dy == dir && !target)
				can_move = TRUE
			else if(dx == 0 && dy == 2*dir && !target && current_board[from_y + dir][from_x] == null && ((color == "w" && from_y == 7) || (color == "b" && from_y == 2)))
				can_move = TRUE
			else if(abs_dx == 1 && dy == dir && target)
				can_move = TRUE
			else if(abs_dx == 1 && dy == dir && !target && length(last_double_pawn_move))
				if(last_double_pawn_move[1] == to_x && last_double_pawn_move[2] == from_y && last_double_pawn_move[3] == (color == "w" ? "b" : "w"))
					can_move = TRUE
		if("N")
			if((abs_dx == 2 && abs_dy == 1) || (abs_dx == 1 && abs_dy == 2))
				can_move = TRUE
		if("B")
			if(abs_dx == abs_dy && path_clear(from_x, from_y, to_x, to_y))
				can_move = TRUE
		if("R")
			if((dx == 0 || dy == 0) && path_clear(from_x, from_y, to_x, to_y))
				can_move = TRUE
		if("Q")
			if((dx == 0 || dy == 0 || abs_dx == abs_dy) && path_clear(from_x, from_y, to_x, to_y))
				can_move = TRUE
		if("K")
			if(abs_dx <= 1 && abs_dy <= 1)
				can_move = TRUE
			else if(abs_dx == 2 && dy == 0)
				can_move = handle_castling(color, from_x, from_y, to_x, to_y)

	if(!can_move)
		return FALSE

	var/orig_piece = current_board[to_y][to_x]
	current_board[to_y][to_x] = piece
	current_board[from_y][from_x] = null

	var/king_pos = locate_king(color)
	if(!king_pos)
		current_board[from_y][from_x] = piece
		current_board[to_y][to_x] = orig_piece
		return FALSE

	var/in_check = square_under_attack(color == "w" ? "b" : "w", king_pos[1], king_pos[2])

	current_board[from_y][from_x] = piece
	current_board[to_y][to_x] = orig_piece

	return !in_check

/datum/board_game/chess/proc/can_en_passant(from_x, from_y, to_x, to_y)
	if(!last_double_pawn_move)
		return FALSE
	return last_double_pawn_move[1] == to_x && last_double_pawn_move[2] == from_y && last_double_pawn_move[3] == (current_board[from_y][from_x][1] == "w" ? "b" : "w")

/datum/board_game/chess/proc/field_check(new_x_location, new_y_location)
	if(new_x_location < 1 || new_x_location > GRID_SIZE)
		return FALSE
	if(new_y_location < 1 || new_y_location > GRID_SIZE)
		return FALSE
	return TRUE

/datum/board_game/chess/proc/validate_coords(list/params)
	var/x_loc = text2num(params["loc_x"])
	var/y_loc = text2num(params["loc_y"])

	if(!isnum(x_loc) || !isnum(y_loc))
		return null

	if(!field_check(x_loc, y_loc))
		return null

	return list(x_loc, y_loc)

/datum/board_game/chess/proc/get_defaultboard()
	var/list/deep_copy = list()
	for(var/list/row in default_board)
		UNTYPED_LIST_ADD(deep_copy, row.Copy())
	return deep_copy

#undef GAME_PLAYER_ONE
#undef GAME_PLAYER_TWO
#undef GAME_OVER
#undef GAME_OVER_DRAW
#undef GRID_SIZE
#undef GAME_FLAG_CHECK_PONE
#undef GAME_FLAG_CHECK_PTWO
#undef GAME_FLAG_CASTLING_USED_PONE
#undef GAME_FLAG_CASTLING_USED_PTWO

#undef GAME_ACTION_NONE
#undef GAME_ACTION_SELECT
#undef GAME_ACTION_END_TURN
