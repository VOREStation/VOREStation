
/obj/item/healthanalyzer/scroll //reports all of the above, as well as name and quantity of nonmed reagents in stomach
	name = "scroll of divination"
	desc = "An unusual scroll that appears to report all of the details of a person's health when waved near them. Oddly, it seems to have a little metal chip up near the handles..."
	advscan = 3
	origin_tech = list(TECH_MAGNET = 7, TECH_BIO = 8)
	icon_state = "health_scroll"


/obj/item/tool/crowbar/alien/magic
	name = "sentient crowbar"
	desc = "A crowbar with a green gem set in it and a green ribbon tied to it, it floats lightly by itself and appears to be able to pry on its own. It almost feels like there is some sort of anti gravity generator running in it..."
	catalogue_data = list(/datum/category_item/catalogue/anomalous/precursor_a/alien_crowbar)
	icon_state = "crowbar_sentient"

/obj/item/tool/screwdriver/alien/magic
	name = "vintage screwdriver of revolving"
	desc = "A vintage screwdriver that spins as fast as a drill with little aid, it has a red gem on the handle. It oddly sounds like a drill too..."
	catalogue_data = list(/datum/category_item/catalogue/anomalous/precursor_a/alien_screwdriver)
	icon = 'icons/obj/abductor.dmi'
	icon_state = "screwdriver_old"

/obj/item/weldingtool/alien/magic
	name = "bellows of flame"
	desc = "A set of bellows that have a yellow gem on the spout, they emit flames when pressed. Oddly seems to have a faint phoron smell to it..."
	catalogue_data = list(/datum/category_item/catalogue/anomalous/precursor_a/alien_welder)
	icon = 'icons/obj/abductor.dmi'
	icon_state = "bellows"

/obj/item/tool/wirecutters/alien/magic
	name = "secateurs of organisation"
	desc = "Extremely sharp secateurs, fitted with a glowing blue gem, said to be magically enhanced for speed. There seems to be a little whirring sound coming from beneath that gem..."
	icon = 'icons/obj/abductor.dmi'
	icon_state = "cutters_magic"

/obj/item/tool/wrench/alien/magic
	name = "pliers of molding"
	desc = "A set of pliers that seems to mold to the shape of their target, housing a pink gem. Oddly seems to have a slightly slimey texture at the metal..."
	catalogue_data = list(/datum/category_item/catalogue/anomalous/precursor_a/alien_wrench)
	icon = 'icons/obj/abductor.dmi'
	icon_state = "pliers"

/obj/item/surgical/bone_clamp/alien/magic
	icon = 'icons/obj/abductor.dmi'
	toolspeed = 0.75
	icon_state = "bone_boneclamp"
	name = "bone bone clamp"
	desc = "A bone clamp made of bones for fixing bones using bones, it feels strangely adept. In fact, it doesn't really feel like actual bone at all..."

// Bath

/obj/structure/bed/bath
	name = "wash tub"
	desc = "A wooden tub that can be filled with water for washing yourself."
	icon_state = "bath"
	base_icon = "bath"
	flags = OPENCONTAINER
	var/amount_per_transfer_from_this = 5

/obj/structure/bed/bath/update_icon()
	if(reagents.total_volume < 1)
		icon_state = "bath"
	else if(reagents.total_volume < 50)
		icon_state = "bath1"
	else if(reagents.total_volume < 150)
		icon_state = "bath2"
	else if(reagents.total_volume < 301)
		icon_state = "bath3"
	return // Doesn't care about material or anything else.

/obj/structure/bed/bath/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/mop) || istype(I, /obj/item/soap)) //VOREStation Edit - "Allows soap and rags to be used on mopbuckets"
		if(reagents.total_volume < 1)
			to_chat(user, span_warning("\The [src] is out of water!"))
		else
			reagents.trans_to_obj(I, 5)
			to_chat(user, span_notice("You wet \the [I] in \the [src]."))
			playsound(src, 'sound/effects/slosh.ogg', 25, 1)
	if(istype(I, /obj/item/reagent_containers/glass))
		update_icon()
		return
	else if(istype(I, /obj/item/grab))
		var/obj/item/grab/G = I
		var/mob/living/affecting = G.affecting
		if(has_buckled_mobs()) //Handles trying to buckle someone else to a chair when someone else is on it
			to_chat(user, span_notice("\The [src] already has someone buckled to it."))
			return
		user.visible_message(span_notice("[user] attempts to buckle [affecting] into \the [src]!"))
		if(do_after(user, 20, G.affecting))
			affecting.loc = loc
			spawn(0)
				if(buckle_mob(affecting))
					affecting.visible_message(\
						span_danger("[affecting.name] is buckled to [src] by [user.name]!"),\
						span_danger("You are buckled to [src] by [user.name]!"),\
						span_notice("You hear metal clanking."))
			qdel(I)


/obj/structure/bed/bath/Initialize(mapload)
	create_reagents(300)
	. = ..()

//oven

/obj/machinery/appliance/cooker/oven/yeoldoven
	name = "oven"
	desc = "Old fashioned cookies are ready, dear."
	icon_state = "yeoldovenopen"

/obj/machinery/appliance/cooker/oven/yeoldoven/update_icon()
	if(!open)
		if(!stat)
			icon_state = "yeoldovenclosed_on"
			if(cooking == TRUE)
				icon_state = "yeoldovenclosed_cooking"
				if(oven_loop)
					oven_loop.start(src)
			else
				icon_state = "yeoldovenclosed_on"
				if(oven_loop)
					oven_loop.stop(src)
		else
			icon_state = "yeoldovenclosed_off"
			if(oven_loop)
				oven_loop.stop(src)
	else
		icon_state = "yeoldovenopen"
		if(oven_loop)
			oven_loop.stop(src)

//toilet

/obj/structure/toilet/wooden
	name = "wooden toilet"
	desc = "It's basically a hole in a box with a bucket inside. This one seems remarkably clean."
	icon_state = "toilet3"
	open = 1

/obj/structure/toilet/wooden/attack_hand(mob/living/user as mob)
	return //No lid

/obj/structure/toilet/wooden/attackby(obj/item/I as obj, mob/living/user as mob) //simpler interactions
	if(istype(I, /obj/item/grab))
		user.setClickCooldown(user.get_attack_speed(I))
		var/obj/item/grab/G = I

		if(isliving(G.affecting))
			var/mob/living/GM = G.affecting

			if(G.state>1)
				if(!GM.loc == get_turf(src))
					to_chat(user, span_notice("[GM.name] needs to be on the toilet."))
					return
				if(open && !swirlie)
					user.visible_message(span_danger("[user] starts to give [GM.name] a swirlie!"), span_notice("You start to give [GM.name] a swirlie!"))
					swirlie = GM
					if(do_after(user, 30, GM))
						user.visible_message(span_danger("[user] gives [GM.name] a swirlie!"), span_notice("You give [GM.name] a swirlie!"), "You hear a toilet flushing.")
						if(!GM.internal)
							GM.adjustOxyLoss(5)
					swirlie = null
				else
					user.visible_message(span_danger("[user] slams [GM.name] into the [src]!"), span_notice("You slam [GM.name] into the [src]!"))
					GM.adjustBruteLoss(5)
			else
				to_chat(user, span_notice("You need a tighter grip."))

	if(cistern && !istype(user,/mob/living/silicon/robot)) //STOP PUTTING YOUR MODULES IN THE TOILET.
		if(I.w_class > 3)
			to_chat(user, span_notice("\The [I] does not fit."))
			return
		if(w_items + I.w_class > 5)
			to_chat(user, span_notice("The cistern is full."))
			return
		user.drop_item()
		I.loc = src
		w_items += I.w_class
		to_chat(user, "You carefully place \the [I] into the cistern.")
		return

/obj/structure/toilet/wooden/Initialize(mapload)
	open = 1 //just to make sure it works
	icon_state = "toilet3"
	. = ..()

/obj/structure/toilet/wooden/update_icon()
	return

//cooking pot

/obj/machinery/microwave/cookingpot
	name = "cooking pot"
	icon_state = "cookingpot"
	desc = "An old fashioned cooking pot above some logs."

/obj/machinery/microwave/cookingpot/start()
	src.visible_message(span_notice("The cooking pot starts cooking."), span_notice("You hear a fire roar."))
	src.operating = TRUE
	src.icon_state = "cookingpot1"
	SStgui.update_uis(src)

/obj/machinery/microwave/cookingpot/abort()
	operating = FALSE // Turn it off again aferwards
	if(icon_state == "cookingpot1")
		icon_state = "cookingpot"
	SStgui.update_uis(src)


/obj/machinery/microwave/cookingpot/stop()
	operating = FALSE // Turn it off again aferwards
	if(icon_state == "cookingpot1")
		icon_state = "cookingpot"
	SStgui.update_uis(src)

/obj/machinery/microwave/cookingpot/attackby(var/obj/item/O as obj, var/mob/user as mob)
	if(src.broken > 0)
		if(src.broken == 2 && O.is_screwdriver()) // If it's broken and they're using a screwdriver
			user.visible_message( \
				span_infoplain(span_bold("\The [user]") + " starts to fix part of the cooking pot."), \
				span_notice("You start to fix part of the cooking pot.") \
			)
			playsound(src, O.usesound, 50, 1)
			if (do_after(user,20 * O.toolspeed))
				user.visible_message( \
					span_infoplain(span_bold("\The [user]") + " fixes part of the cooking pot."), \
					span_notice("You have fixed part of the cooking pot.") \
				)
				src.broken = 1 // Fix it a bit
		else if(src.broken == 1 && O.is_wrench()) // If it's broken and they're doing the wrench
			user.visible_message( \
				span_infoplain(span_bold("\The [user]") + " starts to fix part of the cooking pot."), \
				span_notice("You start to fix part of the cooking pot.") \
			)
			if (do_after(user,20 * O.toolspeed))
				user.visible_message( \
					span_infoplain(span_bold("\The [user]") + " fixes the cooking pot."), \
					span_notice("You have fixed the cooking pot.") \
				)
				src.icon_state = "cookingpot"
				src.broken = 0 // Fix it!
				src.dirty = 0 // just to be sure
				src.flags = OPENCONTAINER | NOREACT
		else
			to_chat(user, span_warning("It's broken!"))
			return 1

	else if(src.dirty==100) // The microwave is all dirty so can't be used!
		if(istype(O, /obj/item/reagent_containers/spray/cleaner) || istype(O, /obj/item/soap)) // If they're trying to clean it then let them
			user.visible_message( \
				span_bold("\The [user]") + "starts to clean the cooking pot.", \
				span_notice("You start to clean the cooking pot.") \
			)
			if (do_after(user,20))
				user.visible_message( \
					span_notice("\The [user] has cleaned the cooking pot."), \
					span_notice("You have cleaned the cooking pot.") \
				)
				src.dirty = 0 // It's clean!
				src.broken = 0 // just to be sure
				src.icon_state = "cookingpot"
				src.flags = OPENCONTAINER | NOREACT
				SStgui.update_uis(src)
		else //Otherwise bad luck!!
			to_chat(user, span_warning("It's dirty!"))
			return 1
	else if(is_type_in_list(O,acceptable_items))
		var/list/workingList = cookingContents()
		if(workingList.len>=(max_n_of_items + circuit_item_capacity))	//Adds component_parts to the maximum number of items. changed 1 to actually just be the circuit item capacity var.
			to_chat(user, span_warning("This [src] is full of ingredients, you cannot put more."))
			return 1
		if(istype(O, /obj/item/stack) && O:get_amount() > 1) // This is bad, but I can't think of how to change it
			var/obj/item/stack/S = O
			new O.type (src)
			S.use(1)
			user.visible_message( \
				span_notice("\The [user] has added one of [O] to \the [src]."), \
				span_notice("You add one of [O] to \the [src]."))
			return
		else
		//	user.remove_from_mob(O)	//This just causes problems so far as I can tell. -Pete - Man whoever you are, it's been years. o7
			user.drop_from_inventory(O,src)
			user.visible_message( \
				span_notice("\The [user] has added \the [O] to \the [src]."), \
				span_notice("You add \the [O] to \the [src]."))
			SStgui.update_uis(src)
			return
	else if (istype(O,/obj/item/storage/bag/plants)) // There might be a better way about making plant bags dump their contents into a microwave, but it works.
		var/obj/item/storage/bag/plants/bag = O
		var/failed = 1
		for(var/obj/item/G in O.contents)
			if(!G.reagents || !G.reagents.total_volume)
				continue
			failed = 0
			if(contents.len>=(max_n_of_items + component_parts.len + circuit_item_capacity))
				to_chat(user, span_warning("This [src] is full of ingredients, you cannot put more."))
				return 0
			else
				bag.remove_from_storage(G, src)
				contents += G
				if(contents.len>=(max_n_of_items + component_parts.len + circuit_item_capacity))
					break

		if(failed)
			to_chat(user, "Nothing in the plant bag is usable.")
			return 0

		if(!O.contents.len)
			to_chat(user, "You empty \the [O] into \the [src].")
		else
			to_chat(user, "You fill \the [src] from \the [O].")

		SStgui.update_uis(src)
		return 0

	else if(istype(O,/obj/item/reagent_containers/glass) || \
			istype(O,/obj/item/reagent_containers/food/drinks) || \
			istype(O,/obj/item/reagent_containers/food/condiment) \
		)
		if (!O.reagents)
			return 1
		for (var/datum/reagent/R in O.reagents.reagent_list)
			if (!(R.id in acceptable_reagents))
				to_chat(user, span_warning("Your [O] contains components unsuitable for cookery."))
				return 1
		return
	else if(istype(O,/obj/item/grab))
		var/obj/item/grab/G = O
		to_chat(user, span_warning("This is ridiculous. You can not fit \the [G.affecting] in this [src]."))
		return 1
	else if(O.is_screwdriver())
		default_deconstruction_screwdriver(user, O)
		return
	else if(O.is_crowbar())
		if(default_deconstruction_crowbar(user, O))
			return
		else
			user.visible_message( \
				span_notice("\The [user] begins [src.anchored ? "unsecuring" : "securing"] the cooking pot."), \
				span_notice("You attempt to [src.anchored ? "unsecure" : "secure"] the cooking pot.")
				)
			if (do_after(user,20/O.toolspeed))
				user.visible_message( \
				span_notice("\The [user] [src.anchored ? "unsecures" : "secures"] the cooking pot."), \
				span_notice("You [src.anchored ? "unsecure" : "secure"] the cooking pot.")
				)
				src.anchored = !src.anchored
			else
				to_chat(user, span_notice("You decide not to do that."))
	else if(default_part_replacement(user, O))
		return
	else if(istype(O, /obj/item/paicard))
		if(!paicard)
			insertpai(user, O)
	else
		to_chat(user, span_warning("You have no idea what you can cook with this [O]."))
	..()
	SStgui.update_uis(src)

/obj/machinery/microwave/cookingpot/broke()
	src.icon_state = "cookingpotb" // Make it look all busted up and shit
	src.visible_message(span_warning("The cooking pot breaks!")) //Let them know they're stupid
	src.broken = 2 // Make it broken so it can't be used util fixed
	src.flags = null //So you can't add condiments
	src.operating = 0 // Turn it off again aferwards
	SStgui.update_uis(src)
	soundloop.stop()
	src.ejectpai() // If it broke, time to yeet the PAI.

/obj/machinery/microwave/cookingpot/dispose(var/message = 1)
	for (var/atom/movable/A in cookingContents())
		A.forceMove(loc)
	if (src.reagents.total_volume)
		src.dirty++
	src.reagents.clear_reagents()
	if(message)
		to_chat(usr, span_notice("You dispose of the cooking pot contents."))
	SStgui.update_uis(src)

/obj/machinery/microwave/cookingpot/muck_start()
	playsound(src, 'sound/effects/splat.ogg', 50, 1) // Play a splat sound
	src.icon_state = "cookingpotbloody1" // Make it look dirty!!

/obj/machinery/microwave/cookingpot/muck_finish()
	src.visible_message(span_warning("The cooking pot gets covered in muck!"))
	src.dirty = 100 // Make it dirty so it can't be used util cleaned
	src.flags = null //So you can't add condiments
	src.icon_state = "cookingpotbloody0" // Make it look dirty too
	src.operating = 0 // Turn it off again aferwards
	SStgui.update_uis(src)
	soundloop.stop()

// Magic bluespace stuff


/obj/item/clothing/gloves/bluespace/magic
	name = "bracer of resilience"
	desc = "A bracer that is said to make one resistent to size changing magic."
	icon = 'icons/inventory/accessory/item_vr.dmi'
	icon_state = "bs_magic"

//harpoon

/obj/item/bluespace_harpoon/wand
	name = "teleportation wand"
	desc = "An odd wand that weighs more than it looks like it should. It has a wire protruding from it and a glass-like tip, suggesting there may be more tech behind this than magic."

	icon = 'icons/obj/gun_vr.dmi'
	icon_state = "harpoonwand-2"

/obj/item/bluespace_harpoon/wand/update_icon()
	if(transforming)
		switch(mode)
			if(0)
				flick("harpoonwand-2-change", src)
				icon_state = "harpoonwand-1"
			if(1)
				flick("harpoonwand-1-change",src)
				icon_state = "harpoonwand-2"
		transforming = 0

/*
 * magic orb
 */

/obj/item/gun/energy/taser/magic
	name = "orb of lightning"
	desc = "An orb filled with electrical energy, it looks oddly like a toy plasma orb..."
	description_fluff = ""
	icon_state = "orb"

//Kettle

/obj/machinery/chemical_dispenser/kettle //reskin of coffee dispenser
	name = "kettle"
	desc = "A kettle used for making hot drinks."
	icon_state = "kettle"
	ui_title = "kettle"
	accept_drinking = 1

/obj/machinery/chemical_dispenser/kettle/full
	spawn_cartridges = list(
			/obj/item/reagent_containers/chem_disp_cartridge/coffee,
			/obj/item/reagent_containers/chem_disp_cartridge/cafe_latte,
			/obj/item/reagent_containers/chem_disp_cartridge/soy_latte,
			/obj/item/reagent_containers/chem_disp_cartridge/hot_coco,
			/obj/item/reagent_containers/chem_disp_cartridge/milk,
			/obj/item/reagent_containers/chem_disp_cartridge/cream,
			/obj/item/reagent_containers/chem_disp_cartridge/sugar,
			/obj/item/reagent_containers/chem_disp_cartridge/tea,
			/obj/item/reagent_containers/chem_disp_cartridge/ice,
			/obj/item/reagent_containers/chem_disp_cartridge/mint,
			/obj/item/reagent_containers/chem_disp_cartridge/orange,
			/obj/item/reagent_containers/chem_disp_cartridge/lemon,
			/obj/item/reagent_containers/chem_disp_cartridge/lime,
			/obj/item/reagent_containers/chem_disp_cartridge/berry,
			/obj/item/reagent_containers/chem_disp_cartridge/greentea,
			/obj/item/reagent_containers/chem_disp_cartridge/decaf,
			/obj/item/reagent_containers/chem_disp_cartridge/chaitea,
			/obj/item/reagent_containers/chem_disp_cartridge/decafchai
		)

// teleporter

/obj/item/perfect_tele/magic
	name = "teleportation tome"
	desc = "A large tome that can be used to teleport to special pages that can be removed from it. The spine seems to have some sort buzzing tech inside..."
	icon = 'icons/obj/props/fantasy.dmi'
	icon_state = "teleporter"
	beacons_left = 3
	cell_type = /obj/item/cell/device
	origin_tech = list(TECH_MAGNET = 5, TECH_BLUESPACE = 5)

/obj/item/perfect_tele_beacon/magic
	name = "teleportation page"
	desc = "A single page from a tome, with a glowing blue symbol on it. It seems like the symbol is raised as though there were something running beneath it..."
	icon = 'icons/obj/props/fantasy.dmi'
	icon_state = "page"

/obj/item/perfect_tele/magic/attack_self(mob/user, var/radial_menu_anchor = src)
	if(loc_network)
		for(var/obj/item/perfect_tele_beacon/stationary/nb in premade_tele_beacons)
			if(nb.tele_network == loc_network)
				beacons[nb.tele_name] = nb
		loc_network = null //Consumed

	if(!(user.ckey in warned_users))
		warned_users |= user.ckey
		tgui_alert_async(user,{"
This device can be easily used to break ERP preferences due to the nature of teleporting and tele-vore.
Make sure you carefully examine someone's OOC prefs before teleporting them if you are going to use this device for ERP purposes.
This device records all warnings given and teleport events for admin review in case of pref-breaking, so just don't do it.
"},"OOC Warning")
	var/choice = show_radial_menu(user, radial_menu_anchor, radial_images, custom_check = CALLBACK(src, PROC_REF(check_menu), user), require_near = TRUE, tooltips = TRUE)

	if(!choice)
		return

	else if(choice == "New Beacon")
		if(beacons_left <= 0)
			to_chat(user, span_warning("The tome can't support any more pages!"))
			return

		var/new_name = html_encode(tgui_input_text(user,"New pages's name (2-20 char):","[src]",null,20))
		if(!check_menu(user))
			return

		if(length(new_name) > 20 || length(new_name) < 2)
			to_chat(user, span_warning("Entered name length invalid (must be longer than 2, no more than than 20)."))
			return

		if(new_name in beacons)
			to_chat(user, span_warning("No duplicate names, please. '[new_name]' exists already."))
			return

		var/obj/item/perfect_tele_beacon/magic/nb = new(get_turf(src))
		nb.tele_name = new_name
		nb.tele_hand = src
		nb.creator = user.ckey
		beacons[new_name] = nb
		beacons_left--
		if(isliving(user))
			var/mob/living/L = user
			L.put_in_any_hand_if_possible(nb)
		rebuild_radial_images()

	else
		destination = beacons[choice]
		rebuild_radial_images()

//sizegun

/obj/item/slow_sizegun/magic
	name = "wand of growth and shrinking"
	desc = "A wand said to be able to shrink or grow it's targets, it's encrusted with glowing gems and a... trigger?"
	icon = 'icons/obj/gun_vr.dmi'
	icon_state = "sizegun-magic-0"
	base_icon_state = "sizegun-magic"

//locked door

/obj/structure/simple_door/dungeon/Initialize(mapload,var/material_name)
	. = ..(mapload, material_name || MAT_CULT)

/obj/structure/simple_door/dungeon/locked
	locked = TRUE
	breakable = FALSE
	lock_id = "dungeon"

/obj/item/simple_key/dungeon
	name = "old key"
	desc = "A plain, old-timey key, as one might use to unlock a door."
	icon_state = "dungeon"
	key_id = "dungeon"
