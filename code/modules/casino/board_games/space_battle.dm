#define GAME_PLACE_SHIPS 1
#define GAME_PLAYER_ONE 2
#define GAME_PLAYER_TWO 3
#define GAME_OVER 4
#define GRID_SIZE 10
#define PLAYER_ONE_PLACED_SHIPS 0x1
#define PLAYER_TWO_PLACED_SHIPS 0x2

/obj/structure/casino_table/board_game/space_battle
	name = GAME_SPACE_BATTLE
	desc = "A game with the goal to destroy the opponent's ships."
	icon_state = "gamble_space"
	game_ui = /datum/board_game/space_battle

/datum/board_game/space_battle
	name = GAME_SPACE_BATTLE
	table_icon = "gamble_space"
	var/datum/weakref/player_one
	var/datum/weakref/player_two
	var/list/ship_count_pone = list()
	var/list/ship_count_ptwo = list()
	var/list/shots_fired_pone = list()
	var/list/shots_fired_ptwo = list()
	var/list/ships_placed_pone = list()
	var/list/ships_placed_ptwo = list()
	var/list/destroyed_ships_pone = list()
	var/list/destroyed_ships_ptwo = list()
	var/static/list/total_ships = list(
		"Carrier" = 1,
		"Cruiser" = 2,
		"Corvette" = 3,
		"Figher" = 4,
	)
	var/static/list/ship_sizes = list(
		"Carrier" = 6,
		"Cruiser" = 4,
		"Corvette" = 3,
		"Figher" = 2,
	)
	var/winner
	var/ships_have_been_placed = NONE

/datum/board_game/space_battle/Destroy(force)
	player_one = null
	player_two = null
	. = ..()

/datum/board_game/space_battle/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "SpaceBattle", name)
		ui.open()

/datum/board_game/space_battle/tgui_static_data(mob/user)
	return list(
		"ship_sizes" = ship_sizes,
		"total_ships" = total_ships
	)

/datum/board_game/space_battle/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/mob/player_one_mob = player_one?.resolve()
	var/mob/player_two_mob = player_two?.resolve()

	var/list/visible_ships = list()
	if(ui.user == player_one_mob || game_state == GAME_OVER)
		visible_ships += ships_placed_pone
	if(ui.user == player_two_mob || game_state == GAME_OVER)
		visible_ships += ships_placed_ptwo

	return list(
		"current_player" = ui.user,
		"player_one" = player_one_mob,
		"player_two" = player_two_mob,
		"all_placed" = ships_have_been_placed == (PLAYER_ONE_PLACED_SHIPS | PLAYER_TWO_PLACED_SHIPS),
		"shots_fired_pone" = shots_fired_pone,
		"shots_fired_ptwo" = shots_fired_ptwo,
		"destroyed_ships_pone" = destroyed_ships_pone,
		"destroyed_ships_ptwo" = destroyed_ships_ptwo,
		"visible_ships" = visible_ships,
		"ship_count_pone" = ship_count_pone,
		"ship_count_ptwo" = ship_count_ptwo,
		"game_state" = game_state,
		"winner" = winner,
		"has_won" = winner == ui.user.name
	)

/datum/board_game/space_battle/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
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
		if("prepare_game")
			if(game_state != GAME_SETUP)
				return FALSE
			var/mob/player_one_mob = player_one?.resolve()
			var/mob/player_two_mob = player_two?.resolve()
			if(!player_one_mob || !player_two_mob)
				return FALSE
			game_state = GAME_PLACE_SHIPS
			ship_count_pone = get_remaining_ships(1)
			ship_count_ptwo = get_remaining_ships(2)
			return TRUE
		if("start_game")
			if(game_state != GAME_PLACE_SHIPS)
				return FALSE
			if(!(ships_have_been_placed == (PLAYER_ONE_PLACED_SHIPS | PLAYER_TWO_PLACED_SHIPS)))
				return FALSE
			var/mob/player_one_mob = player_one?.resolve()
			var/mob/player_two_mob = player_two?.resolve()
			if(!player_one_mob || !player_two_mob)
				return FALSE
			ship_count_pone = get_alive_ships(1)
			ship_count_ptwo = get_alive_ships(2)
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
		if("place_ship")
			if(game_state != GAME_PLACE_SHIPS)
				return FALSE
			var/mob/player_one_mob = player_one?.resolve()
			var/mob/player_two_mob = player_two?.resolve()
			if(!player_one_mob || !player_two_mob)
				return FALSE

			var/list/ship_data = params["ship"]
			if(!ship_data["name"] || !ship_data["coords"])
				return FALSE

			var/player = ship_data["player"]
			if(!player)
				return FALSE

			if(player == 1 && ui.user != player_one_mob)
				return FALSE
			if(player == 2 && ui.user != player_two_mob)
				return FALSE

			var/allowed = total_ships[ship_data["name"]]
			if(!allowed)
				return FALSE

			var/list/current_ships
			if(player == 1)
				current_ships = ships_placed_pone
			else
				current_ships = ships_placed_ptwo

			var/count = 0
			for(var/list/existing in current_ships)
				if(existing["name"] == ship_data["name"])
					count++

			if(count >= allowed)
				return FALSE

			var/list/new_coords = ship_data["coords"]
			for(var/list/new_coord in new_coords)
				if(!isnum(new_coord[1]) || !isnum(new_coord[2]))
					return FALSE
				if(!field_check(new_coord[1], new_coord[2]))
					return FALSE

			for(var/list/existing_ship in current_ships)
				for(var/list/coord in existing_ship["coords"])
					for(var/list/new_coord in new_coords)
						if(coord[1] == new_coord[1] && coord[2] == new_coord[2])
							return FALSE

			UNTYPED_LIST_ADD(current_ships, ship_data)
			if(player == 1)
				ship_count_pone = get_remaining_ships(1)
			else
				ship_count_ptwo = get_remaining_ships(2)

			return TRUE
		if("remove_ship")
			if(game_state != GAME_PLACE_SHIPS)
				return FALSE
			var/mob/player_one_mob = player_one?.resolve()
			var/mob/player_two_mob = player_two?.resolve()
			if(!player_one_mob || !player_two_mob)
				return FALSE

			var/player = params["player"]
			if(player == 1 && ui.user != player_one_mob)
				return FALSE
			if(player == 2 && ui.user != player_two_mob)
				return FALSE

			var/list/ships
			if(player == 1)
				ships = ships_placed_pone
			else
				ships = ships_placed_ptwo

			var/loc_x = params["loc_x"]
			var/loc_y = params["loc_y"]
			for(var/i in length(ships) to 1 step -1)
				var/list/ship = ships[i]
				for(var/list/coord in ship["coords"])
					if(coord[1] == loc_x && coord[2] == loc_y)
						ships.Cut(i, i + 1)
						if(player == 1)
							ship_count_pone = get_remaining_ships(1)
						else
							ship_count_ptwo = get_remaining_ships(2)
						return TRUE
			return FALSE
		if("game_action")
			if(ui.user == player_one?.resolve() && game_state == GAME_PLAYER_ONE)
				if(params["data"]["player"] == 1)
					return FALSE
				if(player_actions(params["action"], params["data"], ui.user))
					if(game_state < GAME_OVER)
						game_state = GAME_PLAYER_TWO
					return TRUE
			if(ui.user == player_two?.resolve() && game_state == GAME_PLAYER_TWO)
				if(params["data"]["player"] == 2)
					return FALSE
				if(player_actions(params["action"], params["data"], ui.user))
					if(game_state < GAME_OVER)
						game_state = GAME_PLAYER_ONE
					return TRUE
			return FALSE

/datum/board_game/space_battle/proc/reset(full)
	ship_count_pone.Cut()
	ship_count_ptwo.Cut()
	shots_fired_pone.Cut()
	shots_fired_ptwo.Cut()
	ships_placed_pone.Cut()
	ships_placed_ptwo.Cut()
	destroyed_ships_pone.Cut()
	destroyed_ships_ptwo.Cut()
	winner = null
	ships_have_been_placed = NONE
	if(full)
		game_state = GAME_SETUP
		player_one = null
		player_two = null
	else
		game_state = GAME_PLACE_SHIPS

/datum/board_game/space_battle/proc/player_actions(action, list/params, mob/user)
	switch(action)
		if("fire_shot")
			var/list/validated_data = validate_coords(params)
			if(!validated_data)
				return FALSE

			var/key = validated_data[1]

			var/list/opponent_ships
			var/list/current_shots

			if(game_state == GAME_PLAYER_ONE)
				current_shots = shots_fired_pone
				opponent_ships = ships_placed_ptwo
			else
				current_shots = shots_fired_ptwo
				opponent_ships = ships_placed_pone

			if(!isnull(current_shots[key]))
				return FALSE

			var/hit = 0
			for(var/list/ship in opponent_ships)
				for(var/coord in ship["coords"])
					if(coord[1] == validated_data[2] && coord[2] == validated_data[3])
						hit = 1
						break
				if(hit)
					break

			current_shots[key] = hit

			if(hit)
				validate_victory(opponent_ships, current_shots, user)

			return TRUE

/datum/board_game/space_battle/proc/validate_victory(list/opponent_ships, list/current_shots, mob/user)
	for(var/list/ship in opponent_ships)
		var/ship_destroyed = TRUE
		for(var/coord in ship["coords"])
			var/key = "[coord[1]],[coord[2]]"
			if(!current_shots[key])
				ship_destroyed = FALSE
				break

		if(ship_destroyed)
			if(game_state == GAME_PLAYER_ONE)
				if(!(destroyed_ships_pone.Find(ship)))
					UNTYPED_LIST_ADD(destroyed_ships_pone, ship)
					ship_count_pone = get_alive_ships(1)
			else
				if(!(destroyed_ships_ptwo.Find(ship)))
					UNTYPED_LIST_ADD(destroyed_ships_ptwo, ship)
					ship_count_ptwo = get_alive_ships(2)

	for(var/list/ship in opponent_ships)
		var/key
		for(var/coord in ship["coords"])
			key = "[coord[1]],[coord[2]]"
			if(!current_shots[key])
				return

	winner = user.name
	game_state = GAME_OVER

/datum/board_game/space_battle/proc/field_check(new_x_location, new_y_location)
	if(new_x_location < 1 || new_x_location > GRID_SIZE)
		return FALSE
	if(new_y_location < 1 || new_y_location > GRID_SIZE)
		return FALSE
	return TRUE

/datum/board_game/space_battle/proc/validate_coords(list/params)
	var/x_loc = text2num(params["loc_x"])
	var/y_loc = text2num(params["loc_y"])

	if(!isnum(x_loc) || !isnum(y_loc))
		return null

	if(!field_check(x_loc, y_loc))
		return null

	var/key = "[x_loc],[y_loc]"
	return list(key, x_loc, y_loc)

/datum/board_game/space_battle/proc/get_remaining_ships(player)
	var/list/remaining_ships = list()
	var/list/placed_ships
	var/ship_placed_flag

	if(player == 1)
		placed_ships = ships_placed_pone
		ship_placed_flag = PLAYER_ONE_PLACED_SHIPS
	else if(player == 2)
		placed_ships = ships_placed_ptwo
		ship_placed_flag = PLAYER_TWO_PLACED_SHIPS
	else
		return remaining_ships

	for(var/ship_name in ship_sizes)
		var/allowed_count = total_ships[ship_name]
		var/placed_count = 0

		for(var/list/placed_ship in placed_ships)
			if(placed_ship["name"] == ship_name)
				placed_count++

		var/remaining_count = allowed_count - placed_count
		if(remaining_count > 0)
			remaining_ships[ship_name] = remaining_count

	if(length(remaining_ships))
		ships_have_been_placed &= ~ship_placed_flag
	else
		ships_have_been_placed |= ship_placed_flag

	return remaining_ships

/datum/board_game/space_battle/proc/get_alive_ships(player)
	var/list/alive_ships = list()
	var/list/ships

	if(player == 1)
		ships = ships_placed_pone
	else if(player == 2)
		ships = ships_placed_ptwo
	else
		return alive_ships

	for(var/list/ship in ships)
		if(game_state == GAME_PLAYER_ONE && !(destroyed_ships_pone.Find(ship)))
			alive_ships[ship["name"]] = length(alive_ships) ? alive_ships[ship["name"]] + 1 : 1

		if(game_state == GAME_PLAYER_TWO && !(destroyed_ships_ptwo.Find(ship)))
			alive_ships[ship["name"]] = length(alive_ships) ? alive_ships[ship["name"]] + 1 : 1

	return alive_ships

#undef GAME_PLACE_SHIPS
#undef GAME_PLAYER_ONE
#undef GAME_PLAYER_TWO
#undef GAME_OVER
#undef GRID_SIZE
#undef PLAYER_ONE_PLACED_SHIPS
#undef PLAYER_TWO_PLACED_SHIPS
