#define CELLS 8
#define CELLSIZE (32/CELLS)

////////////////////////////////////////////////////////////////////////////////
/// Food.
////////////////////////////////////////////////////////////////////////////////
/obj/item/food
	name = "snack"
	desc = "yummy"
	icon = 'icons/obj/food.dmi'
	icon_state = null
	center_of_mass_x = 16
	center_of_mass_y = 16
	w_class = ITEMSIZE_SMALL
	force = 0
	description_info = "Food can use the Rename Food verb in the Object Tab to rename it."
	drop_sound = 'sound/items/drop/food.ogg'
	pickup_sound = 'sound/items/pickup/food.ogg'

	var/amount_per_transfer_from_this = 5
	var/max_transfer_amount = null
	var/min_transfer_amount = 5
	var/volume = 80
	// Reagents that the food starts with. Use this instead of stuffing reagents.add_reagent() into Initialize(mapload), please.
	var/list/food_reagents

	var/food_can_insert_micro = TRUE
	var/list/food_inserted_micros

	var/filling_color = "#FFFFFF" //Used by sandwiches and custom food.
	var/bitesize = 1
	var/bitecount = 0
	var/trash = null
	var/slice_path
	var/slices_num
	var/dried_type = null
	var/dry = 0
	var/survivalfood = FALSE
	var/nutriment_amt = 0
	var/list/nutriment_desc = list("food" = 1)
	var/datum/reagent/nutriment/coating/coating = null
	var/icon/flat_icon = null //Used to cache a flat icon generated from dipping in batter. This is used again to make the cooked-batter-overlay
	var/do_coating_prefix = 1 //If 0, we wont do "battered thing" or similar prefixes. Mainly for recipes that include batter but have a special name

	/// Used for foods that are "cooked" without being made into a specific recipe or combination.
	/// Generally applied during modification cooking with oven/fryer
	/// Used to stop deepfried meat from looking like slightly tanned raw meat, and make it actually look cooked
	var/cooked_icon = null

	/// If this has a wrapper on it. If true, it will print a message and ask you to remove it
	var/package = FALSE
	/// Packaged meals drop this trash type item when opened, if set
	var/package_trash
	/// Packaged meals switch to this state when opened, if set
	var/package_open_state
	/// Packaged meals that have opening animation
	var/package_opening_state

	/// For packaged/canned food sounds
	var/opening_sound = null
	/// Sound of eating.
	var/eating_sound = 'sound/items/eatfood.ogg'

	var/special_handling = FALSE

	// Tracks precooked food to stop deep fried baked grilled grilled grilled diona nymph cereal.
	var/tmp/list/cooked = list()

/obj/item/food/verb/change_name()
	set name = "Rename Food"
	set category = "Object"
	set src in view(0)

	handle_name_change(usr)

/obj/item/food/proc/handle_name_change(var/mob/living/user)
	if(user.stat == DEAD || !(ishuman(user) || isrobot(user)))
		to_chat(user, span_warning("You can't cook!"))
		return
	var/n_name = sanitizeSafe(tgui_input_text(user, "What would you like to name \the [src]? Leave blank to reset.", "Food Naming", initial(name), MAX_NAME_LEN, encode = FALSE))
	if(!n_name)
		n_name = initial(name)

	name = n_name

/obj/item/food/Initialize(mapload)
	. = ..()
	if(!max_transfer_amount)
		src.verbs -= /obj/item/food/verb/set_APTFT
	create_reagents(volume)

	if(food_reagents)
		var/total_so_far = 0
		for(var/string in food_reagents)
			var/amt = food_reagents[string] || 1
			total_so_far += amt
			reagents.add_reagent(string, amt)
		if(total_so_far > volume)
			WARNING("[src]([src.type]) starts with more reagents than it has total volume")
		food_reagents = null
	if ((center_of_mass_x || center_of_mass_y) && !pixel_x && !pixel_y)
		src.pixel_x = rand(-6.0, 6) //Randomizes postion
		src.pixel_y = rand(-6.0, 6)

/obj/item/food/attackby(obj/item/W, mob/user)
	. = ..()

/obj/item/food/afterattack(atom/A, mob/user, proximity, params)
	if((center_of_mass_x || center_of_mass_y) && proximity && params && istype(A, /obj/structure/table))
		//Places the item on a grid
		var/list/mouse_control = params2list(params)

		var/mouse_x = text2num(mouse_control["icon-x"])
		var/mouse_y = text2num(mouse_control["icon-y"])

		if(!isnum(mouse_x) || !isnum(mouse_y))
			return

		var/cell_x = max(0, min(CELLS-1, round(mouse_x/CELLSIZE)))
		var/cell_y = max(0, min(CELLS-1, round(mouse_y/CELLSIZE)))

		pixel_x = (CELLSIZE * (0.5 + cell_x)) - center_of_mass_x
		pixel_y = (CELLSIZE * (0.5 + cell_y)) - center_of_mass_y

/obj/item/food/container_resist(mob/living/M)
	if(food_inserted_micros)
		food_inserted_micros -= M
	if(isdisposalpacket(loc))
		M.forceMove(loc)
	else
		M.forceMove(get_turf(src))
	to_chat(M, span_warning("You climb out of \the [src]."))

/obj/item/food/verb/set_APTFT() //set amount_per_transfer_from_this
	set name = "Set transfer amount"
	set category = "Object"
	set src in range(0)
	var/N = tgui_input_number(usr, "Amount per transfer from this: ([min_transfer_amount]-[max_transfer_amount])","[src]",amount_per_transfer_from_this,max_transfer_amount,min_transfer_amount)
	if(N)
		amount_per_transfer_from_this = N

/obj/item/food/proc/reagentlist() // For attack logs
	if(reagents)
		return reagents.get_reagents()
	return "No reagent holder"

/obj/item/food/proc/standard_dispenser_refill(var/mob/user, var/obj/structure/reagent_dispensers/target) // This goes into afterattack
	if(!istype(target))
		return 0

	if(target.open_top)
		return 0

	if(!target.reagents || !target.reagents.total_volume)
		balloon_alert(user, "[target] is empty.")
		return 1

	if(reagents && !reagents.get_free_space())
		balloon_alert(user, "[src] is full.")
		return 1

	var/trans = target.reagents.trans_to_obj(src, target:amount_per_transfer_from_this)
	balloon_alert(user, "[trans] units transfered to \the [src]")
	return 1

/obj/item/food/proc/standard_splash_mob(var/mob/user, var/mob/target) // This goes into afterattack
	if(!istype(target))
		return

	if(!reagents || !reagents.total_volume)
		balloon_alert(user, "[src] is empty!")
		return 1

	if(target.reagents && !target.reagents.get_free_space())
		balloon_alert(user, "\the [target] is full!")
		return 1

	var/contained = reagentlist()
	add_attack_logs(user,target,"Splashed with [src.name] containing [contained]")
	balloon_alert_visible("[target] is splashed with something by [user]!", "splashed the solution onto [target]")
	reagents.splash(target, reagents.total_volume)
	return 1

/obj/item/food/proc/self_feed_message(var/mob/user)
	balloon_alert(user, "you eat \the [src]")

/obj/item/food/proc/other_feed_message_start(var/mob/user, var/mob/target)
	balloon_alert_visible(user, "[user] is trying to feed [target] \the [src]!")

/obj/item/food/proc/other_feed_message_finish(var/mob/user, var/mob/target)
	balloon_alert_visible(user, "[user] has fed [target] \the [src]!")

/obj/item/food/proc/feed_sound(var/mob/user)
	playsound(user, eating_sound, rand(10, 50), 1)

/obj/item/food/proc/standard_feed_mob(var/mob/user, var/mob/target) // This goes into attack
	if(!istype(target) || !target.can_feed())
		return FALSE

	if(!reagents || !reagents.total_volume)
		balloon_alert(user, "\the [src] is empty.")
		return TRUE

	if(!target.consume_liquid_belly)
		if(liquid_belly_check())
			to_chat(user, span_infoplain("[user == target ? "you can't" : "\The [target] can't"] consume that, it contains something produced from a belly!"))
			return FALSE

	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		if(!H.check_has_mouth())
			balloon_alert(user, "[user == target ? "you don't" : "\the [H] doesn't"] have a mouth!")
			return FALSE
		var/obj/item/blocked = H.check_mouth_coverage()
		if(blocked)
			balloon_alert(user, "\the [blocked] is in the way!")
			return FALSE

	user.setClickCooldown(user.get_attack_speed(src)) //puts a limit on how fast people can eat/drink things
	SEND_SIGNAL(src, COMSIG_GLASS_DRANK, target, user)
	if(user == target)
		self_feed_message(user)
		reagents.trans_to_mob(user, issmall(user) ? CEILING(amount_per_transfer_from_this/2, 1) : amount_per_transfer_from_this, CHEM_INGEST)
		feed_sound(user)
		return TRUE

	else
		other_feed_message_start(user, target)
		if(!do_after(user, 3 SECONDS, target))
			return FALSE
		other_feed_message_finish(user, target)

		var/contained = reagentlist()
		add_attack_logs(user,target,"Fed from [src.name] containing [contained]")
		reagents.trans_to_mob(target, amount_per_transfer_from_this, CHEM_INGEST)
		feed_sound(user)
		return TRUE

/obj/item/food/proc/standard_pour_into(var/mob/user, var/atom/target) // This goes into afterattack and yes, it's atom-level
	if(!target.is_open_container() || !target.reagents)
		return 0

	if(!reagents || !reagents.total_volume)
		balloon_alert(usr, "[src] is empty!")
		return 1

	if(!target.reagents.get_free_space())
		balloon_alert(usr, "[target] is full!")
		return 1

	var/trans = reagents.trans_to(target, amount_per_transfer_from_this)
	balloon_alert(user, "transfered [trans] units to [target]")
	return 1

/obj/item/food/proc/liquid_belly_check()
	if(!reagents)
		return FALSE
	for(var/datum/reagent/R in reagents.reagent_list)
		if(R.from_belly)
			return TRUE
	return FALSE

/obj/item/food/extrapolator_act(mob/living/user, obj/item/extrapolator/extrapolator, dry_run = FALSE)
	. = ..()
	EXTRAPOLATOR_ACT_SET(., EXTRAPOLATOR_ACT_PRIORITY_ISOLATE)
	var/datum/reagent/blood/blood = reagents.get_reagent(REAGENT_ID_BLOOD)
	EXTRAPOLATOR_ACT_ADD_DISEASES(., blood?.get_diseases())

//Placeholder for effect that trigger on eating that aren't tied to reagents.
/obj/item/food/proc/On_Consume(var/mob/living/eater, var/mob/living/feeder)
	SEND_SIGNAL(src, COMSIG_FOOD_EATEN, eater, feeder)
	if(food_inserted_micros && food_inserted_micros.len)
		for(var/mob/living/micro in food_inserted_micros)
			if(!can_food_vore(eater, micro))
				continue

			var/do_nom

			if(!reagents.total_volume)
				do_nom = TRUE
			else
				var/nom_chance = (bitecount/(bitecount + (bitesize / reagents.total_volume) + 1))*100
				if(prob(nom_chance))
					do_nom = TRUE

			if(do_nom)
				eater.vore_selected.nom_atom(micro)
				food_inserted_micros -= micro

	if(!reagents.total_volume)
		eater.balloon_alert_visible("eats \the [src].","finishes eating \the [src].")

		eater.drop_from_inventory(src) // Drop food from inventory so it doesn't end up staying on the hud after qdel, and so inhands go away

		if(trash)
			var/obj/item/TrashItem = new trash(eater)
			eater.put_in_hands(TrashItem)
		qdel(src)

/obj/item/food/attack_self(mob/user)
	. = ..(user)
	if(.)
		return TRUE
	if(special_handling)
		return FALSE
	if(package && !user.incapacitated())
		unpackage(user)

/obj/item/food/attack(mob/living/eater as mob, mob/user as mob, def_zone)
	if(reagents && !reagents.total_volume)
		balloon_alert(user, "none of \the [src] left!")
		user.drop_from_inventory(src)
		qdel(src)
		return FALSE

	if(package)
		balloon_alert(user, "the package is in the way!")
		return FALSE

	if(istype(eater, /mob/living/carbon))
		//TODO: replace with standard_feed_mob() call.

		if(!eater.consume_liquid_belly)
			if(liquid_belly_check())
				to_chat(user, span_infoplain("[user == eater ? "You can't" : "\The [eater] can't"] consume that, it contains something produced from a belly!"))
				return FALSE
		var/swallow_whole = FALSE
		var/obj/belly/belly_target				// These are surprise tools that will help us later

		var/fullness = eater.nutrition + (eater.reagents.get_reagent_amount(REAGENT_ID_NUTRIMENT) * 25)
		if(eater == user)								//If you're eating it yourself
			if(ishuman(eater))
				var/mob/living/carbon/human/human_eater = eater
				if(!human_eater.check_has_mouth())
					balloon_alert(user, "you don't have a mouth!")
					return
				var/obj/item/blocked = null
				if(survivalfood)
					blocked = human_eater.check_mouth_coverage_survival()
				else
					blocked = human_eater.check_mouth_coverage()
				if(blocked)
					balloon_alert(user, "\the [blocked] is in the way!")
					return

			user.setClickCooldown(user.get_attack_speed(src)) //puts a limit on how fast people can eat/drink things
			if (fullness <= 50)
				to_chat(eater, span_danger("You hungrily chew out a piece of [src] and gobble it!"))
			if (fullness > 50 && fullness <= 150)
				to_chat(eater, span_notice("You hungrily begin to eat [src]."))
			if (fullness > 150 && fullness <= 350)
				to_chat(eater, span_notice("You take a bite of [src]."))
			if (fullness > 350 && fullness <= 550)
				to_chat(eater, span_notice("You chew a bit of [src], despite feeling rather full."))
			if (fullness > 550 && fullness <= 650)
				to_chat(eater, span_notice("You swallow some more of the [src], causing your belly to swell out a little."))
			if (fullness > 650 && fullness <= 1000)
				to_chat(eater, span_notice("You stuff yourself with the [src]. Your stomach feels very heavy."))
			if (fullness > 1000 && fullness <= 3000)
				to_chat(eater, span_notice("You swallow down the hunk of [src]. Surely you have to have some limits?"))
			if (fullness > 3000 && fullness <= 5500)
				to_chat(eater, span_danger("You force the piece of [src] down. You can feel your stomach getting firm as it reaches its limits."))
			if (fullness > 5500 && fullness <= 6000)
				to_chat(eater, span_danger("You glug down the bite of [src], you are reaching the very limits of what you can eat, but maybe a few more bites could be managed..."))
			if (fullness > 6000) // There has to be a limit eventually.
				to_chat(eater, span_danger("Nope. That's it. You literally cannot force any more of [src] to go down your throat. It's fair to say you're full."))
				return FALSE

		else if(user.a_intent == I_HURT)
			return ..()

		else
			if(ishuman(eater))
				var/mob/living/carbon/human/human_eater = eater
				if(!human_eater.check_has_mouth())
					balloon_alert(user, "\the [human_eater] doesn't have a mouth!")
					return
				var/obj/item/blocked = null
				var/unconcious = FALSE
				blocked = human_eater.check_mouth_coverage()
				if(survivalfood)
					blocked = human_eater.check_mouth_coverage_survival()
					if(human_eater.stat && human_eater.check_mouth_coverage())
						unconcious = TRUE
						blocked = human_eater.check_mouth_coverage()

				if(isliving(user))	// We definitely are, but never hurts to check
					var/mob/living/feeder = user
					swallow_whole = feeder.stuffing_feeder
				if(swallow_whole)
					belly_target = tgui_input_list(user, "Choose Belly", "Belly Choice", human_eater.feedable_bellies())

				if(unconcious)
					to_chat(user, span_warning("You can't feed [human_eater] through \the [blocked] while they are unconcious!"))
					return

				if(blocked)
					// to_chat(user, span_warning("\The [blocked] is in the way!"))
					balloon_alert(user, "\the [blocked] is in the way!")
					return

				if(swallow_whole)
					if(!(human_eater.feeding))
						balloon_alert(user, "you can't feed [human_eater] a whole [src] as they refuse to be fed whole things!")
						return
					if(!belly_target)
						balloon_alert(user, "you can't feed [human_eater] a whole [src] as they don't appear to have a belly to fit it!")
						return

				if(swallow_whole)
					user.balloon_alert_visible("[user] attempts to make [human_eater] consume [src] whole into their [belly_target].")
				else
					user.balloon_alert_visible("[user] attempts to feed [human_eater] [src].")

				var/feed_duration = 3 SECONDS
				if(swallow_whole)
					feed_duration = 5 SECONDS

				user.setClickCooldown(user.get_attack_speed(src))
				if(!do_after(user, feed_duration, human_eater)) return
				if(!reagents || (reagents && !reagents.total_volume)) return

				if(swallow_whole && !belly_target) return			// Just in case we lost belly mid-feed

				if(swallow_whole)
					add_attack_logs(user, human_eater,"Whole-fed with [src.name] containing [reagentlist(src)] into [belly_target]", admin_notify = FALSE)
					user.visible_message("[user] successfully forces [src] into [human_eater]'s [belly_target].")
					user.balloon_alert_visible("forces [src] into [human_eater]'s [belly_target]")
				else
					add_attack_logs(user, human_eater,"Fed with [src.name] containing [reagentlist(src)]", admin_notify = FALSE)
					user.visible_message("[user] feeds [human_eater] [src].")
					user.balloon_alert_visible("feeds [human_eater] [src].")

			else
				balloon_alert(user, "this creature does not seem to have a mouth!")
				return

		if(swallow_whole)
			user.drop_item()
			forceMove(belly_target)
			return TRUE
		else if(reagents)								//Handle ingestion of the reagent.
			feed_sound(eater)
			if(reagents.total_volume)
				var/bite_mod = 1
				var/mob/living/carbon/human/human_eater = eater
				if(istype(human_eater))
					bite_mod = human_eater.species.bite_mod
				if(reagents.total_volume > bitesize * bite_mod)
					reagents.trans_to_mob(eater, bitesize * bite_mod, CHEM_INGEST)
				else
					reagents.trans_to_mob(eater, reagents.total_volume, CHEM_INGEST)
				bitecount++
				On_Consume(eater, user)
			return TRUE

	return FALSE

/obj/item/food/examine(mob/user)
	. = ..()
	if(Adjacent(user))
		if(food_inserted_micros && food_inserted_micros.len)
			. += span_notice("It has [english_list(food_inserted_micros)] stuck in it.")
		if(coating)
			. += span_notice("It's coated in [coating.name]!")
		if(bitecount==0)
			return .
		else if (bitecount==1)
			. += span_notice("It was bitten by someone!")
		else if (bitecount<=3)
			. += span_notice("It was bitten [bitecount] times!")
		else
			. += span_notice("It was bitten multiple times!")

/obj/item/food/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W,/obj/item/storage))
		. = ..() // -> item/attackby()
		return

	// Eating with forks
	if(istype(W,/obj/item/material/kitchen/utensil))
		var/obj/item/material/kitchen/utensil/utensil = W
		utensil.load_food(user, src)
		return

	if(food_can_insert_micro && istype(W, /obj/item/holder))
		if(!(istype(W, /obj/item/holder/micro) || istype(W, /obj/item/holder/mouse)))
			. = ..()
			return

		if(package)
			to_chat(user, span_warning("You cannot stuff anything into \the [src] without opening it first."))
			balloon_alert(user, "open \the [src] first!")
			return

		var/obj/item/holder/holder = W

		if(!food_inserted_micros)
			food_inserted_micros = list()

		var/mob/living/living_mob = holder.held_mob

		living_mob.forceMove(src)
		holder.held_mob = null
		user.drop_from_inventory(holder)
		qdel(holder)

		food_inserted_micros += living_mob

		to_chat(user, "Stuffed [living_mob] into \the [src].")
		balloon_alert(user, "stuffs [living_mob] into \the [src].")
		to_chat(living_mob, span_warning("[user] stuffs you into \the [src]."))
		return

	if (is_sliceable())
		//these are used to allow hiding edge items in food that is not on a table/tray
		var/can_slice_here = isturf(src.loc) && ((locate(/obj/structure/table) in src.loc) || (locate(/obj/machinery/optable) in src.loc) || (locate(/obj/item/tray) in src.loc))
		var/hide_item = !has_edge(W) || !can_slice_here

		if (hide_item)
			if (W.w_class >= src.w_class || is_robot_module(W) || istype(W, /obj/item/holder))
				return

			if(tgui_alert(user,"You can't slice \the [src] here. Would you like to hide \the [W] inside it instead?","No Cutting Surface!",list("Yes","No")) != "Yes")
				to_chat(user, span_warning("You cannot slice \the [src] here! You need a table or at least a tray to do it."))
				balloon_alert(user, "you cannot slice \the [src] here! You need a table or at least a tray to do it.")
				return
			else
				to_chat(user, "Slipped \the [W] inside \the [src].")
				balloon_alert(user, "slipped \the [W] inside \the [src].")
				user.drop_from_inventory(W, src)
				add_fingerprint(user)
				contents += W
				return

		if (has_edge(W))
			if (!can_slice_here)
				to_chat(user, span_warning("You cannot slice \the [src] here! You need a table or at least a tray to do it."))
				balloon_alert(user, "you need a table or at least a tray to slice it.")
				return

			var/slices_lost = 0
			if (W.w_class > 3)
				user.visible_message(span_notice("\The [user] crudely slices \the [src] with [W]!"), span_notice("You crudely slice \the [src] with your [W]!"))
				user.balloon_alert_visible("crudely slices \the [src]", "crudely sliced \the [src]")
				slices_lost = rand(1,min(1,round(slices_num/2)))
			else
				user.visible_message(span_notice(span_bold("\The [user]") + " slices \the [src]!"), span_notice("You slice \the [src]!"))
				user.balloon_alert_visible("slices \the [src]", "sliced \the [src]!")
			var/reagents_per_slice = reagents.total_volume/slices_num
			for(var/i=1 to (slices_num-slices_lost))
				var/obj/slice = new slice_path (src.loc)
				reagents.trans_to_obj(slice, reagents_per_slice)
				if(food_inserted_micros && food_inserted_micros.len && isfood(slice))
					var/obj/item/food/S = slice
					for(var/mob/living/F in food_inserted_micros)
						F.forceMove(S)
						if(!S.food_inserted_micros)
							S.food_inserted_micros = list()
						S.food_inserted_micros += F
						food_inserted_micros -= F
			on_slice_extra()

			qdel(src)
			return

/obj/item/food/proc/on_slice_extra()
	return

/obj/item/food/MouseDrop_T(mob/living/M, mob/user)
	if(!user.stat && istype(M) && (M == user) && Adjacent(M) && (M.get_effective_size(TRUE) <= 0.50) && food_can_insert_micro)
		if(!food_inserted_micros)
			food_inserted_micros = list()

		M.forceMove(src)

		food_inserted_micros += M

		to_chat(user, span_warning("You climb into \the [src]."))
		return

	return ..()

/obj/item/food/proc/is_sliceable()
	return (slices_num && slice_path && slices_num > 0)

/obj/item/food/Destroy()
	if(contents)
		for(var/atom/movable/something in contents)
			something.dropInto(loc)
			if(food_inserted_micros && (something in food_inserted_micros))
				food_inserted_micros -= something
	. = ..()

	return

/obj/item/food/proc/unpackage(mob/user)
	package = FALSE
	to_chat(user, span_notice("You unseal the [src]."))
	balloon_alert(user, "unsealed \the [src].")
	playsound(user, opening_sound, 15, 1)
	if(package_trash)
		var/obj/item/T = new package_trash
		user.put_in_hands(T)
	if(package_open_state)
		icon_state = package_open_state
		if(package_opening_state)
			flick(package_opening_state, src)

/obj/item/food/attack_generic(var/mob/living/user)
	if(!isanimal(user) && !isalien(user))
		return
	user.visible_message(span_infoplain(span_bold("[user]") + " nibbles away at \the [src]."),span_info("You nibble away at \the [src]."))
	user.balloon_alert_visible("nibbles away at \the [src].","nibbled away at \the [src].")
	bitecount++
	if(reagents)
		reagents.trans_to_mob(user, bitesize, CHEM_INGEST)
	spawn(5)
		if(!src && !user.client)
			user.automatic_custom_emote(VISIBLE_MESSAGE,"[pick("burps", "cries for more", "burps twice", "looks at the area where the food was")]", check_stat = TRUE)
			qdel(src)
	On_Consume(user)
////////////////////////////////////////////////////////////////////////////////
/// FOOD END
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
/// Drinks.
////////////////////////////////////////////////////////////////////////////////
/obj/item/food/drinks	// TODO: split food and drink into their own separate things!
	name = "drink"
	desc = "yummy"
	icon = 'icons/obj/drinks.dmi'
	drop_sound = 'sound/items/drop/drinkglass.ogg'
	pickup_sound =  'sound/items/pickup/drinkglass.ogg'
	eating_sound = 'sound/items/drink.ogg'
	icon_state = null
	flags = OPENCONTAINER
	amount_per_transfer_from_this = 5
	max_transfer_amount = 50
	volume = 50
	trash = null
	var/cant_open = 0
	var/cant_chance = 0

	var/is_can = FALSE

	/// Yims
	food_can_insert_micro = TRUE

/obj/item/food/drinks/Initialize(mapload)
	. = ..()
	if (prob(cant_chance))
		cant_open = TRUE

/obj/item/food/drinks/on_reagent_change()
	if (reagents.reagent_list.len > 0)
		var/datum/reagent/reagent = reagents.get_master_reagent()
		if(reagent.price_tag)
			price_tag = reagent.price_tag
		else
			price_tag = null
	return

/obj/item/food/drinks/Destroy()
	if(food_inserted_micros)
		for(var/mob/mob in food_inserted_micros)
			mob.dropInto(loc)
			food_inserted_micros -= mob
	. = ..()

	return

/obj/item/food/drinks/attackby(obj/item/W as obj, mob/user as mob)
	if(food_can_insert_micro && istype(W, /obj/item/holder))
		if(!(istype(W, /obj/item/holder/micro) || istype(W, /obj/item/holder/mouse)))
			. = ..()
			return

		if(!is_open_container())
			to_chat(user, span_warning("You cannot drop anything into \the [src] without opening it first."))
			return

		var/obj/item/holder/holder = W

		if(!food_inserted_micros)
			food_inserted_micros = list()

		var/mob/living/living_mob = holder.held_mob

		living_mob.forceMove(src)
		holder.held_mob = null
		user.drop_from_inventory(holder)
		qdel(holder)

		food_inserted_micros += living_mob

		to_chat(user, span_warning("You drop [living_mob] into \the [src]."))
		to_chat(living_mob, span_warning("[user] drops you into \the [src]."))
		return

	return ..()

/obj/item/food/drinks/MouseDrop_T(mob/living/M, mob/user)
	if(!user.stat && istype(M) && (M == user) && Adjacent(M) && (M.get_effective_size(TRUE) <= 0.50) && food_can_insert_micro)
		if(!food_inserted_micros)
			food_inserted_micros = list()

		M.forceMove(src)

		food_inserted_micros += M

		to_chat(user, span_warning("You climb into \the [src]."))
		return

	return ..()

/obj/item/food/drinks/On_Consume(var/mob/living/eater, var/mob/feeder, var/changed = FALSE)
	SEND_SIGNAL(src, COMSIG_GLASS_DRANK, eater, feeder)
	if(!feeder)
		feeder = eater

	if(food_inserted_micros && food_inserted_micros.len)
		for(var/mob/living/micro in food_inserted_micros)
			if(!can_food_vore(eater, micro))
				continue

			var/do_nom = FALSE

			if(!reagents.total_volume)
				do_nom = TRUE
			else
				var/nom_chance = (1 - (reagents.total_volume / volume))*100
				if(prob(nom_chance))
					do_nom = TRUE

			if(do_nom)
				eater.vore_selected.nom_atom(micro)
				food_inserted_micros -= micro

	if(!reagents.total_volume && changed)
		eater.visible_message(span_notice("[eater] finishes drinking from \the [src]."),span_notice("You finish drinking from \the [src]."))
		if(trash)
			feeder.drop_from_inventory(src)	//so icons update :[
			if(ispath(trash,/obj/item))
				var/obj/item/TrashItem = new trash(feeder)
				feeder.put_in_hands(TrashItem)
			else if(istype(trash,/obj/item))
				feeder.put_in_hands(trash)
			qdel(src)
	return

/obj/item/food/drinks/on_rag_wipe(var/obj/item/reagent_containers/glass/rag/R)
	wash(CLEAN_SCRUB)

/obj/item/food/drinks/attack_self(mob/user, special_pass)
	. = ..(user)
	if(.)
		return TRUE
	if(special_handling && !special_pass)
		return FALSE
	if(!is_open_container() && !(is_can && user.a_intent == I_HURT))
		open(user)

/obj/item/food/drinks/proc/open(mob/user)
	if(!cant_open)
		playsound(src,"canopen", rand(10,50), 1)
		GLOB.cans_opened_roundstat++
		to_chat(user, span_notice("You open [src] with an audible pop!"))
		flags |= OPENCONTAINER
	else
		to_chat(user, span_warning("...wait a second, this one doesn't have a ring pull. It's not a <b>can</b>, it's a <b>can't!</b>"))
		name = "\improper can't of [initial(name)]"	//don't update the name until they try to open it

/obj/item/food/drinks/attack(mob/M as mob, mob/user as mob, def_zone)
	if(force && !(flags & NOBLUDGEON) && user.a_intent == I_HURT)
		return ..()

	if(standard_feed_mob(user, M))
		return

	return FALSE

/obj/item/food/drinks/afterattack(obj/target, mob/user, proximity)
	if(!proximity) return

	if(standard_dispenser_refill(user, target))
		return
	if(standard_pour_into(user, target))
		return
	return ..()

/obj/item/food/drinks/standard_feed_mob(var/mob/user, var/mob/target)
	if(!is_open_container())
		to_chat(user, span_notice("You need to open [src]!"))
		return TRUE
	var/original_volume = reagents.total_volume
	.=..()
	var/changed = !(reagents.total_volume == original_volume)
	On_Consume(target, user, changed)
	return

/obj/item/food/drinks/standard_dispenser_refill(var/mob/user, var/obj/structure/reagent_dispensers/target)
	if(!is_open_container())
		to_chat(user, span_notice("You need to open [src]!"))
		return TRUE
	return ..()

/obj/item/food/drinks/standard_pour_into(var/mob/user, var/atom/target)
	if(!is_open_container())
		to_chat(user, span_notice("You need to open [src]!"))
		return TRUE
	return ..()

/obj/item/food/drinks/self_feed_message(var/mob/user)
	if(amount_per_transfer_from_this == volume)	//I wanted to use a switch, but switch statements can't use vars and the maximum volume of containers varies
		to_chat(user, span_notice("You knock back the entire [src] in one go!"))
	else if(amount_per_transfer_from_this == 1)
		to_chat(user, span_notice("You take a dainty little sip from \the [src]."))
	else if(amount_per_transfer_from_this <= 4)	//below the standard 5
		to_chat(user, span_notice("You take a modest sip from \the [src]."))
	else if(amount_per_transfer_from_this <= 10)	//the standard five to a bit more
		to_chat(user, span_notice("You swallow a gulp from \the [src]."))
	else if(amount_per_transfer_from_this <= 30)
		to_chat(user, span_notice("You take a long drag from \the [src]."))
	else if(amount_per_transfer_from_this <= 60)
		to_chat(user, span_notice("You chug from \the [src]!"))
	else	//default message as a fallback
		to_chat(user, span_notice("You swallow a gulp from \the [src]."))

/obj/item/food/drinks/examine(mob/user)
	. = ..()
	if(Adjacent(user))
		if(cant_open)
			. += span_warning("It doesn't have a ring pull!")
		if(food_inserted_micros && food_inserted_micros.len)
			. += span_notice("It has [english_list(food_inserted_micros)] [!reagents?.total_volume ? "sitting" : "floating"] in it.")
		if(!reagents?.total_volume)
			. += span_notice("It is empty!")
		else if (reagents.total_volume <= volume * 0.25)
			. += span_notice("It is almost empty!")
		else if (reagents.total_volume <= volume * 0.66)
			. += span_notice("It is half full!")
		else if (reagents.total_volume <= volume * 0.90)
			. += span_notice("It is almost full!")
		else
			. += span_notice("It is full!")


////////////////////////////////////////////////////////////////////////////////
/// Drinks. END
////////////////////////////////////////////////////////////////////////////////

#undef CELLS
#undef CELLSIZE
