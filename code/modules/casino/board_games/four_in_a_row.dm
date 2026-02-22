#define GAME_PLAYER_ONE 1
#define GAME_PLAYER_TWO 2
#define GAME_OVER 3
#define GAME_OVER_DRAW 4

/obj/structure/casino_table/board_game/four_row
	name = GAME_FOUR_ROW
	desc = "A game where two players need to connect their chips in a row."
	icon_state = "gamble_four"
	game_ui = /datum/board_game/four_row


/datum/board_game/four_row
	name = GAME_FOUR_ROW
	table_icon = "gamble_four"
	var/datum/weakref/player_one
	var/datum/weakref/player_two
	var/list/placed_chips_pone = list()
	var/list/placed_chips_ptwo = list()
	var/list/winning_tiles = list()
	var/grid_x_size = 7
	var/grid_y_size = 6
	var/win_count = 4
	var/player_one_color = "yellow"
	var/player_two_color = "red"
	var/winner
	var/static/list/possible_colors = list("red", "yellow", "green", "orange", "blue", "cyan")

/datum/board_game/four_row/Destroy(force)
	player_one = null
	player_two = null
	. = ..()

/datum/board_game/four_row/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "FourInARow", name)
		ui.open()

/datum/board_game/four_row/tgui_static_data(mob/user)
	return list(
		"colors" = possible_colors
	)

/datum/board_game/four_row/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/mob/player_one_mob = player_one?.resolve()
	var/mob/player_two_mob = player_two?.resolve()

	return list(
		"player_one" = player_one_mob,
		"player_two" = player_two_mob,
		"placed_chips_pone" = placed_chips_pone,
		"placed_chips_ptwo" = placed_chips_ptwo,
		"game_state" = game_state,
		"grid_x_size" = grid_x_size,
		"grid_y_size" = grid_y_size,
		"player_one_color" = player_one_color,
		"player_two_color" = player_two_color,
		"win_count" = win_count,
		"winner" = winner,
		"has_won" = winner == ui.user.name,
		"winning_tiles" = winning_tiles,
	)

/datum/board_game/four_row/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
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
		if("set_color_one")
			if(game_state != GAME_SETUP)
				return FALSE
			if(player_one?.resolve() != ui.user)
				return FALSE
			var/new_color = params["color"]
			if(new_color == player_two_color)
				return FALSE
			if(!(new_color in possible_colors))
				return FALSE
			player_one_color = new_color
			return TRUE
		if("set_color_two")
			if(game_state != GAME_SETUP)
				return FALSE
			if(player_two?.resolve() != ui.user)
				return FALSE
			var/new_color = params["color"]
			if(new_color == player_one_color)
				return FALSE
			if(!(new_color in possible_colors))
				return FALSE
			player_two_color = new_color
			return TRUE
		if("change_size")
			if(game_state != GAME_SETUP)
				return FALSE
			var/new_size = text2num(params["size"])
			return set_new_size(new_size)
		if("change_win")
			if(game_state != GAME_SETUP)
				return FALSE
			return change_win_count(text2num(params["count"]))
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
			return TRUE
		if("play_again")
			if(game_state < GAME_OVER)
				return FALSE
			if(!player_one?.resolve() || !player_two?.resolve())
				return FALSE
			reset()
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
			return TRUE
		if("game_action")
			if(ui.user == player_one?.resolve() && game_state == GAME_PLAYER_ONE)
				if(player_actions(params["action"], params["data"], ui.user))
					if(game_state < GAME_OVER)
						game_state = GAME_PLAYER_TWO
					return TRUE
			if(ui.user == player_two?.resolve() && game_state == GAME_PLAYER_TWO)
				if(player_actions(params["action"], params["data"], ui.user))
					if(game_state < GAME_OVER)
						game_state = GAME_PLAYER_ONE
					return TRUE
			return FALSE

/datum/board_game/four_row/proc/change_win_count(new_count)
	if(!isnum(new_count))
		return FALSE
	if(new_count < 4 || new_count > 5)
		return FALSE
	win_count = new_count
	return TRUE

/datum/board_game/four_row/proc/reset(full)
	placed_chips_pone.Cut()
	placed_chips_ptwo.Cut()
	winning_tiles.Cut()
	winner = null
	if(full)
		game_state = GAME_SETUP
		player_one = null
		player_two = null
	else
		game_state = GAME_PLAYER_ONE

/datum/board_game/four_row/proc/player_actions(action, list/params, mob/user)
	switch(action)
		if("place_chip")
			var/list/validated_data = validate_coords(params)
			if(!validated_data)
				return FALSE
			var/x_loc = validated_data[2]

			var/target_y = 0
			for(var/y = grid_y_size; y >= 1; y--)
				var/key = "[x_loc],[y]"
				if(!placed_chips_pone[key] && !placed_chips_ptwo[key])
					target_y = y
					break

			if(target_y == 0)
				return FALSE

			var/key = "[x_loc],[target_y]"

			if(game_state == GAME_PLAYER_ONE)
				placed_chips_pone[key] = TRUE
			else
				placed_chips_ptwo[key] = TRUE

			validate_victory(x_loc, target_y, user.name)
			return TRUE


/datum/board_game/four_row/proc/has_chip(list/player_list, x, y)
	return player_list["[x],[y]"]

/datum/board_game/four_row/proc/collect_direction(list/player_list, start_x, start_y, dx, dy)
	var/list/tiles = list()
	var/x = start_x
	var/y = start_y

	while(field_check(x, y) && has_chip(player_list, x, y))
		tiles += "[x],[y]"
		x += dx
		y += dy

	return tiles

/datum/board_game/four_row/proc/validate_victory(x, y, user_name)
	var/list/current_list

	if(game_state == GAME_PLAYER_ONE)
		current_list = placed_chips_pone
	else
		current_list = placed_chips_ptwo

	var/list/h1 = collect_direction(current_list, x, y, 1, 0)
	var/list/h2 = collect_direction(current_list, x, y, -1, 0)
	var/list/horizontal = h1 + h2
	horizontal -= "[x],[y]"

	if(length(horizontal) >= win_count)
		winning_tiles = horizontal
		game_state = GAME_OVER
		winner = user_name
		return

	var/list/v1 = collect_direction(current_list, x, y, 0, 1)
	var/list/v2 = collect_direction(current_list, x, y, 0, -1)
	var/list/vertical = v1 + v2
	vertical -= "[x],[y]"

	if(length(vertical) >= win_count)
		winning_tiles = vertical
		game_state = GAME_OVER
		winner = user_name
		return

	var/list/d1 = collect_direction(current_list, x, y, 1, 1)
	var/list/d2 = collect_direction(current_list, x, y, -1, -1)
	var/list/diag1 = d1 + d2
	diag1 -= "[x],[y]"

	if(length(diag1) >= win_count)
		winning_tiles = diag1
		game_state = GAME_OVER
		winner = user_name
		return

	var/list/d3 = collect_direction(current_list, x, y, 1, -1)
	var/list/d4 = collect_direction(current_list, x, y, -1, 1)
	var/list/diag2 = d3 + d4
	diag2 -= "[x],[y]"

	if(length(diag2) >= win_count)
		winning_tiles = diag2
		game_state = GAME_OVER
		winner = user_name
		return
	check_draw()

/datum/board_game/four_row/proc/check_draw()
	for(var/x = 1 to grid_x_size)
		for(var/y = 1 to grid_y_size)
			var/key = "[x],[y]"
			if(!placed_chips_pone[key] && !placed_chips_ptwo[key])
				return FALSE

	winner = null
	game_state = GAME_OVER_DRAW
	return TRUE

/datum/board_game/four_row/proc/set_new_size(new_size)
	if(!isnum(new_size))
		return FALSE
	if(new_size < 5 || new_size > 10)
		return FALSE
	grid_x_size = new_size
	grid_y_size = new_size - 1
	return TRUE

/datum/board_game/four_row/proc/field_check(new_x_location, new_y_location)
	if(new_x_location < 1 || new_x_location > grid_x_size)
		return FALSE
	if(new_y_location < 1 || new_y_location > grid_y_size)
		return FALSE
	return TRUE

/datum/board_game/four_row/proc/validate_coords(list/params)
	var/x_loc = text2num(params["loc_x"])
	var/y_loc = text2num(params["loc_y"])

	if(!isnum(x_loc) || !isnum(y_loc))
		return null

	if(!field_check(x_loc, y_loc))
		return null

	var/key = "[x_loc],[y_loc]"
	return list(key, x_loc, y_loc)

#undef GAME_PLAYER_ONE
#undef GAME_PLAYER_TWO
#undef GAME_OVER
#undef GAME_OVER_DRAW
