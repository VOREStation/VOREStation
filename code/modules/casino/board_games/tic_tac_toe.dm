#define GAME_PLAYER_ONE 1
#define GRID_SIZE 3

/obj/structure/casino_table/board_game/tic_tac_toe
	name = GAME_TIC_TAC_TOE
	desc = "A small tic-tac-toe board."
	icon_state = "gamble_toe"
	game_ui = /datum/board_game/four_row/tic_tac_toe

/datum/board_game/four_row/tic_tac_toe
	name = GAME_TIC_TAC_TOE
	table_icon = "gamble_toe"
	grid_x_size = GRID_SIZE
	grid_y_size = GRID_SIZE
	win_count = GRID_SIZE

/datum/board_game/four_row/tic_tac_toe/tgui_static_data(mob/user)
	return list(
		"colors" = possible_colors - "blue"
	)

/datum/board_game/four_row/tic_tac_toe/player_actions(action, list/params, mob/user)
	switch(action)
		if("place_chip")
			var/list/validated_data = validate_coords(params)
			if(!validated_data)
				return FALSE

			var/key = validated_data[1]
			if(placed_chips_pone[key] || placed_chips_ptwo[key])
				return FALSE

			var/x_loc = validated_data[2]
			var/y_loc = validated_data[3]

			if(game_state == GAME_PLAYER_ONE)
				placed_chips_pone[key] = TRUE
			else
				placed_chips_ptwo[key] = TRUE

			validate_victory(x_loc, y_loc, user.name)
			return TRUE

/datum/board_game/four_row/tic_tac_toe/set_new_size(new_size)
	return FALSE

/datum/board_game/four_row/change_win_count(new_count)
	return FALSE

#undef GAME_PLAYER_ONE
#undef GRID_SIZE
