#define MICROWAVE_FLAGS (OPENCONTAINER | NOREACT)
#define MICROWAVE_NORMAL 0
#define MICROWAVE_MUCK 1
#define MICROWAVE_PRE 2

#define NOT_BROKEN 0
#define KINDA_BROKEN 1
#define REALLY_BROKEN 2

#define MAX_MICROWAVE_DIRTINESS 100

/obj/machinery/microwave
	name = "microwave"
	desc = "Studies are inconclusive on whether pressing your face against the glass is harmful."
	icon = 'icons/obj/kitchen.dmi'
	icon_state = "mw"
	layer = 2.9
	density = TRUE
	anchored = TRUE
	unacidable = TRUE
	use_power = USE_POWER_IDLE
	idle_power_usage = 5
	active_power_usage = 2000
	clicksound = "button"
	clickvol = 30
	flags = MICROWAVE_FLAGS
	circuit = /obj/item/circuitboard/microwave
	var/operating = FALSE
	var/dirty = 0 // = {0..100} Does it need cleaning?
	var/broken = NOT_BROKEN // ={0,1,2} How broken is it???
	var/advanced_microwave = FALSE // is this an advanced microwave?
	var/always_advanced = FALSE // is this advanced no matter what?
	var/efficiency = 0

	var/item_capacity = 20
	var/appliancetype = MICROWAVE
	var/datum/looping_sound/microwave/soundloop

	var/visible_action = "turns on"
	var/audible_action = null

/obj/machinery/microwave/advanced
	name = "deluxe microwave"
	icon = 'icons/obj/deluxemicrowave.dmi'
	always_advanced = TRUE
	advanced_microwave = TRUE

//see code/modules/food/recipes_microwave.dm for recipes

/*******************
*   Initialising
********************/

/obj/machinery/microwave/RefreshParts()
	efficiency = 0
	advanced_microwave = FALSE
	name = "microwave"
	icon = 'icons/obj/kitchen.dmi'
	for(var/obj/item/stock_parts/scanning_module/scanning_module in component_parts)
		if(scanning_module.rating >= 3 || always_advanced)
			advanced_microwave = TRUE
			name = "deluxe microwave"
			icon = 'icons/obj/deluxemicrowave.dmi'
		break
	for(var/obj/item/stock_parts/matter_bin/matter_bin in component_parts)
		item_capacity = (advanced_microwave ? 80 : 20) * matter_bin.rating
		reagents.maximum_volume = (advanced_microwave ? 400 : 80) * matter_bin.rating
		break
	for(var/obj/item/stock_parts/micro_laser/micro_laser in component_parts)
		efficiency += micro_laser.rating
	for(var/obj/item/stock_parts/capacitor/capacitor in component_parts)
		active_power_usage = max(100, 2000 / capacitor.rating)

/obj/machinery/microwave/Initialize(mapload)
	. = ..()

	reagents = new/datum/reagents(100)
	reagents.my_atom = src

	default_apply_parts()

	if(!LAZYLEN(GLOB.available_recipes))
		for(var/datum/recipe/typepath as anything in subtypesof(/datum/recipe))
			if((initial(typepath.appliance) & appliancetype))
				GLOB.available_recipes += new typepath

		for (var/datum/recipe/recipe in GLOB.available_recipes)
			for (var/item in recipe.items)
				GLOB.acceptable_items |= item
			for (var/reagent in recipe.reagents)
				GLOB.acceptable_reagents |= reagent
		// This will do until I can think of a fun recipe to use dionaea in -
		// will also allow anything using the holder item to be microwaved into
		// impure carbon. ~Z
		GLOB.acceptable_items |= /obj/item/holder
		GLOB.acceptable_items |= /obj/item/reagent_containers/food/snacks/grown
		GLOB.acceptable_items |= /obj/item/soulstone
		GLOB.acceptable_items |= /obj/item/fuel_assembly/supermatter

	soundloop = new(list(src), FALSE)
	update_icon()

/obj/machinery/microwave/Destroy()
	dispose(FALSE)
	if(paicard)
		ejectpai() // Lets not delete the pAI.
	QDEL_NULL(soundloop)
	return ..()

/*******************
*   Item Adding
********************/

/obj/machinery/microwave/update_icon()
	if(broken)
		icon_state = "mwb"
		return TRUE
	if(dirty >= MAX_MICROWAVE_DIRTINESS)
		if(operating)
			icon_state = "mwbloody1"
		else
			icon_state = "mwbloody0"
		return TRUE
	if(operating)
		icon_state = "mw1"
	else
		icon_state = "mw"
	return TRUE

/obj/machinery/microwave/proc/post_state_change()
	update_static_data_for_all_viewers()
	update_icon()
	SStgui.update_uis(src)

/obj/machinery/microwave/attackby(obj/item/O, mob/user)
	if(handle_broken(O, user)) return TRUE
	if(handle_dirty(O, user)) return TRUE
	if(handle_deconstruction(O, user)) return TRUE
	if(try_insert_item(O, user)) return TRUE
	if(istype(O,/obj/item/grab))
		var/obj/item/grab/G = O
		to_chat(user, span_warning("Unfortunately, the laws of physics prevent you from inserting \the [G.affecting] into \the [src]."))
		return TRUE
	if(istype(O, /obj/item/paicard))
		if(!paicard)
			insertpai(user, O)
			return TRUE
		to_chat(user, span_warning("There is already a pAI inserted, and you don't feel like cooking \the [O]."))
		return TRUE
	to_chat(user, span_warning("You have no idea what you can cook with \the [O]."))
	..()
	post_state_change()
	return FALSE

/obj/machinery/microwave/proc/handle_broken(obj/item/O, mob/user)
	if(src.broken <= NOT_BROKEN)
		return FALSE

	if(src.broken == REALLY_BROKEN && O.has_tool_quality(TOOL_SCREWDRIVER)) // If it's broken and they're using a screwdriver
		return do_repair_step(user, O, FALSE)

	if(src.broken == KINDA_BROKEN && O.has_tool_quality(TOOL_WRENCH)) // If it's broken and they're doing the wrench
		return do_repair_step(user, O, TRUE)

	to_chat(user, span_warning("It's broken!"))
	return TRUE

/obj/machinery/microwave/proc/do_repair_step(mob/user, obj/item/tool, full_repair = FALSE)
	user.visible_message(
		span_infoplain(span_bold("\The [user]") + " starts to fix part of \the [src]."),
		span_notice("You start to fix part of \the [src].")
	)
	playsound(src, tool.usesound, 50, 1)

	if(!do_after(user, 2 SECONDS * tool.toolspeed, target = src))
		return TRUE

	user.visible_message(
		span_infoplain(span_bold("\The [user]") + (full_repair ? " fixes \the [src]." : " fixes part of \the [src].")),
		span_notice(full_repair ? "You have fixed \the [src]." : "You have fixed part of \the [src].")
	)

	broken = full_repair ? NOT_BROKEN : KINDA_BROKEN
	flags |= MICROWAVE_FLAGS

	post_state_change()
	return TRUE

/obj/machinery/microwave/proc/handle_dirty(obj/item/O, mob/user)
	if(dirty < MAX_MICROWAVE_DIRTINESS)
		return FALSE

	if(!is_type_in_list(O, list(/obj/item/soap, /obj/item/reagent_containers/spray/cleaner, /obj/item/reagent_containers/glass/rag)))
		to_chat(user, span_warning("It's dirty!"))
		return TRUE

	user.visible_message( \
		span_infoplain(span_bold("\The [user]") + " starts to clean \the [src]."),
		span_notice("You start to clean \the [src].") \
	)

	if(!do_after(user, 2 SECONDS, target = src))
		return TRUE

	user.visible_message( \
		span_infoplain(span_bold("\The [user]") + " has cleaned \the [src]."),
		span_notice("You have cleaned \the [src].") \
	)

	dirty = 0
	flags |= MICROWAVE_FLAGS
	post_state_change()
	return TRUE

/obj/machinery/microwave/proc/try_insert_item(obj/item/O, mob/user)
	if(is_type_in_list(O, GLOB.acceptable_items))
		if(length(cookingContents()) >= (item_capacity))
			to_chat(user, span_warning("\The [src] is full of ingredients, you cannot put more."))
			return TRUE
		var/obj/item/stack/our_stack = O
		if(istype(our_stack) && our_stack.get_amount() > 0)
			var/obj/item/stack/St = our_stack.split(1)
			St.forceMove(src)
			user.visible_message( \
				span_notice(span_bold("\The [user]") + " has added one [O] to \the [src]."), \
				span_notice("You add one [O] to \the [src]."))
			return TRUE
		user.drop_from_inventory(O, src)
		user.visible_message(
			span_infoplain(span_bold("\The [user]") + " has added \the [O] to \the [src]."), \
			span_notice("You add \the [O] to \the [src].")
		)
		return TRUE
	if(istype(O, /obj/item/storage/bag/plants)) // There might be a better way about making plant bags dump their contents into a microwave, but it works.
		var/obj/item/storage/bag/plants/bag = O
		var/failed = 1
		for(var/obj/item/G in O.contents)
			if(!G.reagents || !G.reagents.total_volume)
				continue
			failed = 0
			if(length(cookingContents()) >= (item_capacity))
				to_chat(user, span_warning("\The [src] is full of ingredients, you cannot put more."))
				return TRUE
			bag.remove_from_storage(G, src)
			if(length(cookingContents()) >= (item_capacity))
				break

		if(failed)
			to_chat(user, "Nothing in \the [O] can be used for cooking.")
			return TRUE

		to_chat(user, !length(O.contents) ? "You empty \the [O] into \the [src]." : "You fill \the [src] from \the [O].")
		return TRUE

	if(is_type_in_list(O, list(/obj/item/reagent_containers/glass, /obj/item/reagent_containers/food/drinks, /obj/item/reagent_containers/food/condiment)))
		if (!O.reagents)
			to_chat(user, span_warning("\The [O] is empty!"))
			return TRUE
		for (var/datum/reagent/R in O.reagents.reagent_list)
			if (!(R.id in GLOB.acceptable_reagents))
				to_chat(user, span_warning("\The [O] contains components unsuitable for cooking."))
				return TRUE
		// gotta let afterattack resolve
		addtimer(CALLBACK(src, TYPE_PROC_REF(/datum, update_static_data_for_all_viewers)), 1 SECOND)
		return TRUE
	return FALSE

/obj/machinery/microwave/proc/handle_deconstruction(obj/item/O, mob/user)
	if(O.has_tool_quality(TOOL_SCREWDRIVER))
		default_deconstruction_screwdriver(user, O)
		return TRUE
	if(O.has_tool_quality(TOOL_CROWBAR))
		if(default_deconstruction_crowbar(user, O))
			return TRUE
		else
			user.visible_message( \
				span_notice("\The [user] begins [src.anchored ? "unsecuring" : "securing"] \the [src]."), \
				span_notice("You attempt to [src.anchored ? "unsecure" : "secure"] \the [src].")
				)
			if (do_after(user, (2 SECONDS)/O.toolspeed, target = src))
				user.visible_message( \
				span_notice("\The [user] [src.anchored ? "unsecures" : "secures"] \the [src]."), \
				span_notice("You [src.anchored ? "unsecure" : "secure"] \the [src].")
				)
				src.anchored = !src.anchored
			else
				to_chat(user, span_notice("You decide not to do that."))
			return TRUE
	if(default_part_replacement(user, O))
		return TRUE
	return FALSE

/obj/machinery/microwave/tgui_status(mob/user)
	if(user == paicard?.pai)
		return STATUS_INTERACTIVE
	. = ..()

/obj/machinery/microwave/attack_hand(mob/user as mob)
	if(user.a_intent == I_GRAB)
		if(paicard)
			ejectpai(user)
			return
	tgui_interact(user)

/*******************
*   Microwave Menu
********************/
/obj/machinery/microwave/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Microwave", name)
		ui.open()

/obj/machinery/microwave/ui_assets(mob/user)
	return list(
		get_asset_datum(/datum/asset/spritesheet_batched/kitchen_recipes),
		get_asset_datum(/datum/asset/simple/microwave)
	)

/obj/machinery/microwave/tgui_static_data(mob/user)
	var/list/data = ..()

	var/datum/recipe/recipe = select_recipe(GLOB.available_recipes, src)
	data["recipe"] = recipe ? sanitize_css_class_name("[recipe.type]") : null
	data["recipe_name"] = recipe ? initial(recipe.result:name) : null

	return data

/obj/machinery/microwave/tgui_data(mob/user, datum/tgui/ui, datum/tgui_state/state)
	var/list/data = ..()

	data["broken"] = broken
	data["operating"] = operating
	data["dirty"] = dirty == MAX_MICROWAVE_DIRTINESS
	data["items"] = get_items_list()

	var/list/reagents_data = list()
	for(var/datum/reagent/R in reagents.reagent_list)
		var/display_name = R.name
		if(R.id == REAGENT_ID_CAPSAICIN)
			display_name = "Hotsauce"
		if(R.id == REAGENT_ID_FROSTOIL)
			display_name = "Coldsauce"
		UNTYPED_LIST_ADD(reagents_data, list(
			"name" = display_name,
			"amt" = R.volume,
			"extra" = "unit[R.volume > 1 ? "s" : ""]",
			"color" = R.color,
		))
	data["reagents"] = reagents_data

	return data

/obj/machinery/microwave/proc/get_items_list()
	var/list/data = list()

	var/list/item_count = list()
	var/list/icons = list()

	for(var/obj/ingredient in cookingContents())
		item_count[ingredient.name]++
		if(!icons[ingredient.name])
			icons[ingredient.name] = list("icon" = ingredient.icon, "icon_state" = ingredient.icon_state)

	for(var/item in item_count)
		var/display_name = item
		var/plural_name = display_name + plural_s(display_name)
		var/ingredient_amt = item_count[item]
		data.Add(list(list(
			"name" = capitalize(display_name),
			"amt" = ingredient_amt,
			"extra" = ingredient_amt == 1 ? display_name : plural_name,
			"icon" = icons[item],
		)))

	return data

/obj/machinery/microwave/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	if(..())
		return TRUE

	if(operating)
		return TRUE

	switch(action)
		if("cook")
			cook()
			return TRUE

		if("dispose")
			dispose()
			return TRUE

/***********************************
*   Microwave Menu Handling/Cooking
************************************/

/obj/machinery/microwave/proc/cook()
	if(inoperable())
		return

	if(operating || broken > NOT_BROKEN || panel_open || !anchored || dirty >= MAX_MICROWAVE_DIRTINESS)
		return

	if(prob(max((5 / efficiency) - 5, dirty * 5)))
		muck()
		return

	if(prob(min(dirty * 5, 100)))
		start_can_fail()

	start()

/obj/machinery/microwave/proc/start()
	wzhzhzh()
	cook_loop()

/obj/machinery/microwave/proc/start_can_fail()
	wzhzhzh()
	cook_loop(type = MICROWAVE_PRE, cycles = 4)

/obj/machinery/microwave/proc/muck()
	wzhzhzh()
	playsound(src, 'sound/effects/splat.ogg', 50, 1) // Play a splat sound
	src.dirty = MAX_MICROWAVE_DIRTINESS // Make it dirty so it can't be used util cleaned
	post_state_change()
	cook_loop(type = MICROWAVE_MUCK, cycles = 4)

/obj/machinery/microwave/proc/cook_loop(type = MICROWAVE_NORMAL, cycles = 10, wait = max(12 - 2 * efficiency, 2))
	if((stat & BROKEN) && type == MICROWAVE_PRE)
		broke()
		return

	if(cycles <= 0 || !length(cookingContents()))
		switch(type)
			if(MICROWAVE_NORMAL)
				loop_finish()
			if(MICROWAVE_MUCK)
				muck_finish()
				stop(FALSE)
			if(MICROWAVE_PRE)
				cook_loop(type = MICROWAVE_NORMAL, cycles = 10)
		return

	cycles--
	addtimer(CALLBACK(src, PROC_REF(cook_loop), type, cycles, wait), wait)

/obj/machinery/microwave/power_change()
	. = ..()
	if((stat & NOPOWER) && operating)
		broke()
		dispose(FALSE)

/obj/machinery/microwave/proc/loop_finish()
	var/datum/recipe/recipe = select_recipe(GLOB.available_recipes, src)
	if(!recipe)
		if(length(cookingContents()) >= 1)
			dirty += 1
			var/obj/item/cooked = fail()
			cooked.forceMove(loc)
			if(prob(max(10,dirty*5)))
				muck()
			if(has_extra_item())
				broke()
		stop()
		return

	var/result = recipe.result
	var/valid = TRUE
	var/list/cooked_items = list()
	var/obj/temp = new /obj(src) //To prevent infinite loops, all results will be moved into a temporary location so they're not considered as inputs for other recipes
	while(valid)
		var/list/things = list()
		things.Add(recipe.make_food(src))
		cooked_items += things
		//Move cooked things to the buffer so they're not considered as ingredients
		for(var/atom/movable/AM in things)
			AM.forceMove(temp)

		valid = FALSE
		recipe.after_cook(src)
		recipe = select_recipe(GLOB.available_recipes, src)
		if(recipe && recipe.result == result)
			valid = TRUE

	for(var/atom/movable/R as anything in cooked_items)
		R.forceMove(src) //Move everything from the buffer back to the container

	QDEL_NULL(temp)//Delete buffer object

	//Any leftover reagents are divided amongst the foods
	var/total = reagents.total_volume
	for(var/obj/item/reagent_containers/food/snacks/S in cooked_items)
		reagents.trans_to_holder(S.reagents, total/cooked_items.len)

	for(var/obj/item/reagent_containers/food/snacks/S in cookingContents())
		S.cook()

	dispose(FALSE) //clear out anything left
	stop(TRUE)

	return

/obj/machinery/microwave/proc/wzhzhzh() // Whoever named this proc is fucking literally Satan. ~ Z
	visible_message(span_notice("\The [src] " + visible_action + "."), span_notice("You hear a " + audible_action ? audible_action : "[src]" + "."))
	operating = TRUE
	update_use_power(USE_POWER_ACTIVE)
	post_state_change()
	soundloop.start()

/obj/machinery/microwave/proc/has_extra_item() //- coded to have different microwaves be able to handle different items
	var/basic_microwave_types = list(/obj/item/reagent_containers/food, /obj/item/grown)
	var/advanced_microwave_types = list(/obj/item/slime_extract, /obj/item/organ, /obj/item/stack/material)
	for (var/obj/O in cookingContents())
		if(!is_type_in_list(O, basic_microwave_types) && (!advanced_microwave || !is_type_in_list(O, advanced_microwave_types)))
			return TRUE
	return FALSE

/obj/machinery/microwave/proc/stop(var/success = TRUE)
	if(success)
		playsound(src.loc, 'sound/machines/ding.ogg', 50, 1)
	operating = FALSE // Turn it off again aferwards
	if(broken)
		update_use_power(USE_POWER_OFF)
	else
		update_use_power(USE_POWER_IDLE)
	post_state_change()
	soundloop.stop()

/obj/machinery/microwave/proc/dispose(var/message = TRUE)
	for (var/atom/movable/A in cookingContents())
		A.forceMove(loc)
	if (src.reagents.total_volume)
		src.dirty++
	src.reagents.clear_reagents()
	if(message)
		to_chat(usr, span_notice("You dispose of \the [src]'s contents."))
	SStgui.update_uis(src)

/obj/machinery/microwave/proc/muck_finish()
	src.visible_message(span_warning("\The [src] gets covered in muck!"))
	src.flags &= ~MICROWAVE_FLAGS //So you can't add condiments

/obj/machinery/microwave/proc/broke(var/spark = TRUE)
	if(spark)
		var/datum/effect/effect/system/spark_spread/s = new
		s.set_up(2, 1, src)
		s.start()
	src.visible_message(span_warning("\The [src] breaks!")) //Let them know they're stupid
	src.broken = REALLY_BROKEN // Make it broken so it can't be used util fixed
	src.flags &= ~MICROWAVE_FLAGS //So you can't add condiments
	src.ejectpai() // If it broke, time to yeet the PAI.

/obj/machinery/microwave/proc/fail()
	var/obj/item/reagent_containers/food/snacks/badrecipe/ffuu = new(src)
	var/amount = 0
	for (var/obj/O in cookingContents() - ffuu)
		amount++
		if(O.reagents)
			var/id = O.reagents.get_master_reagent_id()
			if(id)
				amount+=O.reagents.get_reagent_amount(id)
		if(istype(O, /obj/item/holder))
			var/obj/item/holder/H = O
			if(H.held_mob)
				qdel(H.held_mob)
		qdel(O)
	src.reagents.clear_reagents()
	ffuu.reagents.add_reagent(REAGENT_ID_CARBON, amount)
	ffuu.reagents.add_reagent(REAGENT_ID_TOXIN, amount/10)
	return ffuu

/obj/machinery/microwave/verb/Eject()
	set src in oview(1)
	set category = "Object"
	set name = "Eject content"
	usr.visible_message(
	span_notice("[usr] tries to open [src] and remove its contents.") ,
	span_notice("You try to open [src] and remove its contents.")
	)

	if(!do_after(usr, 1 SECOND, target = src))
		return

	if(operating)
		to_chat(usr, span_warning("You can't do that, [src] door is locked!"))
		return

	usr.visible_message(
	span_notice("[usr] opened [src] and has taken out [english_list(cookingContents())].") ,
	span_notice("You have opened [src] and taken out [english_list(cookingContents())].")
	)
	dispose()

/obj/machinery/microwave/CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
	if(!mover)
		return TRUE
	if(mover.checkpass(PASSTABLE))
	//Animals can run under them, lots of empty space
		return TRUE
	return ..()

/datum/recipe/splat // We use this to handle cooking micros (or mice, etc) in a microwave. Janky but it works better than snowflake code to handle the same thing.
	items = list(
		/obj/item/holder
	)
	result = /obj/effect/decal/cleanable/blood/gibs
	wiki_flag = WIKI_SPOILER

/datum/recipe/splat/before_cook(obj/container)
	if(istype(container, /obj/machinery/microwave))
		var/obj/machinery/microwave/M = container
		M.muck()
		playsound(container.loc, 'sound/items/drop/flesh.ogg', 100, 1)
	. = ..()

/datum/recipe/splat/make_food(obj/container)
	for(var/obj/item/holder/H in container)
		if(H.held_mob)
			to_chat(H.held_mob, span_danger("You hear an earsplitting humming and your head aches!"))
			qdel(H.held_mob)
			H.held_mob = null
			qdel(H)

	. = ..()

/obj/machinery/microwave/proc/cookingContents() //VOREEdit, this is a better way to deal with the contents of a microwave, since the previous method is stupid.
	var/list/workingList = contents.Copy() // Using the copy proc because otherwise the two lists seem to become soul bonded.
	workingList -= component_parts
	workingList -= circuit
	if(paicard)
		workingList -= paicard
	for(var/M in workingList)
		if(istype(M, circuit)) // Yes, we remove circuit twice. Yes, it's necessary. Yes, it's stupid.
			workingList -= M
	return workingList

#undef MICROWAVE_FLAGS
#undef MICROWAVE_NORMAL
#undef MICROWAVE_MUCK
#undef MICROWAVE_PRE

#undef NOT_BROKEN
#undef KINDA_BROKEN
#undef REALLY_BROKEN

#undef MAX_MICROWAVE_DIRTINESS
