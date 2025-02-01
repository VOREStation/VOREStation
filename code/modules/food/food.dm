#define CELLS 8
#define CELLSIZE (32/CELLS)

////////////////////////////////////////////////////////////////////////////////
/// Food.
////////////////////////////////////////////////////////////////////////////////
/obj/item/reagent_containers/food
	possible_transfer_amounts = null
	volume = 50 //Sets the default container amount for all food items.
	description_info = "Food can use the Rename Food verb in the Object Tab to rename it."
	var/filling_color = "#FFFFFF" //Used by sandwiches and custom food.
	drop_sound = 'sound/items/drop/food.ogg'
	pickup_sound = 'sound/items/pickup/food.ogg'

	var/food_can_insert_micro = FALSE
	var/list/food_inserted_micros

/obj/item/reagent_containers/food/verb/change_name()
	set name = "Rename Food"
	set category = "Object"
	set src in view(0)

	handle_name_change(usr)

/obj/item/reagent_containers/food/proc/handle_name_change(var/mob/living/user)
	if(user.stat == DEAD || !(ishuman(user) || isrobot(user)))
		to_chat(user, span_warning("You can't cook!"))
		return
	var/n_name = sanitizeSafe(tgui_input_text(user, "What would you like to name \the [src]? Leave blank to reset.", "Food Naming", initial(name), MAX_NAME_LEN))
	if(!n_name)
		n_name = initial(name)

	name = n_name

/obj/item/reagent_containers/food/Initialize()
	. = ..()
	if (center_of_mass.len && !pixel_x && !pixel_y)
		src.pixel_x = rand(-6.0, 6) //Randomizes postion
		src.pixel_y = rand(-6.0, 6)

/obj/item/reagent_containers/food/afterattack(atom/A, mob/user, proximity, params)
	if(center_of_mass.len && proximity && params && istype(A, /obj/structure/table))
		//Places the item on a grid
		var/list/mouse_control = params2list(params)

		var/mouse_x = text2num(mouse_control["icon-x"])
		var/mouse_y = text2num(mouse_control["icon-y"])

		if(!isnum(mouse_x) || !isnum(mouse_y))
			return

		var/cell_x = max(0, min(CELLS-1, round(mouse_x/CELLSIZE)))
		var/cell_y = max(0, min(CELLS-1, round(mouse_y/CELLSIZE)))

		pixel_x = (CELLSIZE * (0.5 + cell_x)) - center_of_mass["x"]
		pixel_y = (CELLSIZE * (0.5 + cell_y)) - center_of_mass["y"]

/obj/item/reagent_containers/food/container_resist(mob/living/M)
	if(food_inserted_micros)
		food_inserted_micros -= M
	M.forceMove(get_turf(src))
	to_chat(M, span_warning("You climb out of \the [src]."))

#undef CELLS
#undef CELLSIZE
