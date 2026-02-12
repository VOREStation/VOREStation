#define GAME_PLAYING 1
#define GAME_LOST 2
#define GAME_WON 3
#define MAX_MINE_RATE 0.8

/obj/structure/casino_table/board_game/vore_sweeper
	name = GAME_SWEEPER
	desc = "A game about avoiding the mines"
	icon_state = "gamble_sweeper"
	game_ui = /datum/board_game/vore_sweeper

/datum/board_game/vore_sweeper
	name = GAME_SWEEPER
	table_icon = "gamble_sweeper"
	var/grid_size = 8
	var/mine_count = 10
	var/datum/weakref/dealer
	var/list/placed_mines = list()
	var/list/revealed_fields = list()
	var/list/placed_flags = list()

/datum/board_game/vore_sweeper/New(atom/holder)
	. = ..()
	parent = holder

/datum/board_game/vore_sweeper/Destroy(force)
	dealer = null
	parent = null
	. = ..()

/datum/board_game/vore_sweeper/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "VoreSweeper", name)
		ui.open()

/datum/board_game/vore_sweeper/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/mob/dealer_mob = dealer?.resolve()

	var/placed_mine_data = game_state > GAME_PLAYING || (ui.user == dealer_mob) ? placed_mines : null
	var/total_tiles = grid_size * grid_size
	return list(
		"grid_size" = grid_size,
		"mine_count" = mine_count,
		"max_mines" = round(total_tiles * MAX_MINE_RATE),
		"dealer" = dealer_mob,
		"placed_mines" = placed_mine_data,
		"revealed_fields" = revealed_fields,
		"placed_flags" = placed_flags,
		"game_state" = game_state,
		"is_dealer" = dealer_mob == ui.user
	)

/datum/board_game/vore_sweeper/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("be_dealer")
			if(game_state == GAME_PLAYING)
				return FALSE
			dealer = WEAKREF(ui.user)
			return TRUE
		if("clear_dealer")
			var/mob/dealer_mob = dealer?.resolve()
			if(!dealer_mob)
				return FALSE
			if(dealer_mob == ui.user)
				parent.atom_say("[ui.user] stopped dealing.")
				dealer = null
				return TRUE
			if(get_dist(ui.user, dealer_mob) > 3)
				parent.atom_say("Dealer has been cleared by [ui.user].")
				dealer = null
				return TRUE
			return FALSE
		if("restart_game")
			var/mob/dealer_mob = dealer?.resolve()
			if(game_state < GAME_PLAYING)
				return FALSE
			placed_mines.Cut()
			revealed_fields.Cut()
			placed_flags.Cut()
			if(!dealer_mob && game_state > GAME_PLAYING)
				auto_place_mines(ui.user, TRUE)
				return TRUE
			game_state = GAME_SETUP
			return TRUE
		if("game_action")
			if(player_actions(params["action"], params["data"], ui.user))
				return TRUE
			return FALSE
		if("setup_action")
			if(dealer_actions(params["action"], params["data"], ui.user))
				return TRUE
			return FALSE

/datum/board_game/vore_sweeper/proc/player_actions(action, list/params, mob/user)
	if(user == dealer?.resolve())
		return FALSE
	if(game_state != GAME_PLAYING)
		return FALSE
	switch(action)
		if("open_field")
			var/list/validated_data = validate_coords(params)
			if(!validated_data)
				return FALSE
			var/key = validated_data[1]
			if(placed_flags[key])
				return FALSE
			if(revealed_fields[key])
				return FALSE
			if(placed_mines[key])
				game_state = GAME_LOST
				revealed_fields[key] = "M"
				return TRUE
			var/mine_count = count_surrounding_mines(validated_data[2], validated_data[3])
			revealed_fields[key] = mine_count
			if(!mine_count)
				reveal_empty_area(validated_data[2], validated_data[3])
			validate_victory()
			return TRUE
		if("toggle_flag")
			var/list/validated_data = validate_coords(params)
			if(!validated_data)
				return FALSE
			var/key = validated_data[1]
			if(revealed_fields[key])
				return FALSE
			if(placed_flags[key])
				placed_flags -= key
				return TRUE
			placed_flags[key] = TRUE
			validate_flag_victory()
			return TRUE

/datum/board_game/vore_sweeper/proc/validate_victory()
	var/total_tiles = grid_size * grid_size
	var/safe_tiles = total_tiles - length(placed_mines)
	if(length(revealed_fields) >= safe_tiles)
		game_state = GAME_WON

/datum/board_game/vore_sweeper/proc/validate_flag_victory()
	var/all_flagged = TRUE

	for(var/mine_key in placed_mines)
		if(placed_mines[mine_key] && !placed_flags[mine_key])
			all_flagged = FALSE
			break

	for(var/flag_key in placed_flags)
		if(!placed_mines[flag_key])
			all_flagged = FALSE
			break

	if(!all_flagged)
		return

	for(var/x = 1 to grid_size)
		for(var/y = 1 to grid_size)
			var/key = "[x],[y]"

			if(placed_mines[key])
				continue

			revealed_fields[key] = count_surrounding_mines(x, y)

	game_state = GAME_WON

/datum/board_game/vore_sweeper/proc/dealer_actions(action, list/params, mob/user)
	if(user != dealer?.resolve())
		return FALSE
	if(game_state != GAME_SETUP)
		return FALSE
	switch(action)
		if("change_grid_size")
			var/new_grid_size = text2num(params["new_grid"])
			if(!new_grid_size)
				return FALSE
			if(new_grid_size < 4 || new_grid_size > 16)
				return FALSE
			validate_mine_count(mine_count, new_grid_size)
			grid_size = new_grid_size
			return TRUE
		if("change_mine_count")
			var/new_mine_count = text2num(params["new_mines"])
			if(!new_mine_count)
				return FALSE
			validate_mine_count(new_mine_count, grid_size)
			return TRUE
		if("place_mine")
			if(length(placed_mines) >= mine_count)
				return FALSE
			var/list/validated_data = validate_coords(params)
			if(!validated_data)
				return FALSE
			var/key = validated_data[1]
			if(placed_mines[key])
				return FALSE
			placed_mines[key] = TRUE
			return TRUE
		if("remove_mine")
			if(game_state != GAME_SETUP)
				return FALSE
			if(length(placed_mines) <= 0)
				return FALSE
			var/list/validated_data = validate_coords(params)
			if(!validated_data)
				return FALSE
			var/key = validated_data[1]
			placed_mines -= key
			return TRUE
		if("auto_place_mines")
			return auto_place_mines(user)
		if("auto_place_mines_self")
			return auto_place_mines(user, TRUE)
		if("clear_all_mines")
			placed_mines.Cut()
			return TRUE
		if("start_game")
			game_state = GAME_PLAYING
			return TRUE

/datum/board_game/vore_sweeper/proc/reveal_empty_area(x, y)
	var/list/to_check = list(list(x, y))
	var/list/checked = list()
	var/i = 1

	while(i <= length(to_check))
		var/current = to_check[i]
		i += 1
		var/cx = current[1]
		var/cy = current[2]
		var/key = "[cx],[cy]"

		if(checked[key])
			continue
		checked[key] = TRUE

		if(revealed_fields[key] || placed_flags[key])
			continue

		var/adjacent_mines = count_surrounding_mines(cx, cy)
		revealed_fields[key] = adjacent_mines

		if(adjacent_mines == 0)
			for(var/dx = -1 to 1)
				for(var/dy = -1 to 1)
					if(dx == 0 && dy == 0)
						continue
					var/nx = cx + dx
					var/ny = cy + dy
					if(field_check(nx, ny))
						to_check += list(list(nx, ny))

/datum/board_game/vore_sweeper/proc/auto_place_mines(mob/user, play)
	var/placed = length(placed_mines)
	if(placed && play)
		to_chat(user, span_warning("You can't do this while there are mines placed."))
	while(placed < mine_count)
		var/x = rand(1, grid_size)
		var/y = rand(1, grid_size)
		var/key = "[x],[y]"
		if(!placed_mines[key])
			placed_mines[key] = TRUE
			placed++
	if(play)
		dealer = null
		game_state = GAME_PLAYING
	return TRUE

/datum/board_game/vore_sweeper/proc/field_check(new_x_location, new_y_location)
	if(new_x_location < 1 || new_x_location > grid_size)
		return FALSE
	if(new_y_location < 1 || new_y_location > grid_size)
		return FALSE
	return TRUE

/datum/board_game/vore_sweeper/proc/count_surrounding_mines(x, y)
	var/count = 0

	for(var/dx = -1 to 1)
		for(var/dy = -1 to 1)
			if(dx == 0 && dy == 0)
				continue

			var/check_x = x + dx
			var/check_y = y + dy

			if(placed_mines["[check_x],[check_y]"])
				count++

	return count

/datum/board_game/vore_sweeper/proc/validate_mine_count(mines, size)
	var/total_tiles = size * size
	var/max_mines = round(total_tiles * MAX_MINE_RATE)
	if(mines <= max_mines)
		mine_count = mines
		return
	parent.atom_say("The grid with [total_tiles] tiles only supports a maximum of [max_mines] mines.")
	mine_count = max_mines

/datum/board_game/vore_sweeper/proc/validate_coords(list/params)
	var/x_loc = text2num(params["loc_x"])
	var/y_loc = text2num(params["loc_y"])

	if(!isnum(x_loc) || !isnum(y_loc))
		return null

	if(!field_check(x_loc, y_loc))
		return null

	var/key = "[x_loc],[y_loc]"
	return list(key, x_loc, y_loc)

#undef GAME_PLAYING
#undef GAME_LOST
#undef GAME_WON
#undef MAX_MINE_RATE
