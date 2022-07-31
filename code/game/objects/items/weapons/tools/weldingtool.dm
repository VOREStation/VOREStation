#define WELDER_FUEL_BURN_INTERVAL 13
/*
 * Welding Tool
 */
/obj/item/weldingtool
	name = "\improper welding tool"
	icon = 'icons/obj/tools.dmi'
	icon_state = "welder"
	item_state = "welder"
	slot_flags = SLOT_BELT

	//Amount of OUCH when it's thrown
	force = 3.0
	throwforce = 5.0
	throw_speed = 1
	throw_range = 5
	w_class = ITEMSIZE_SMALL

	//Cost to make in the autolathe
	matter = list(MAT_STEEL = 70, MAT_GLASS = 30)

	//R&D tech level
	origin_tech = list(TECH_ENGINEERING = 1)

	tool_qualities = list(TOOL_WELDER)

	//Welding tool specific stuff
	var/welding = 0 	//Whether or not the welding tool is off(0), on(1) or currently welding(2)
	var/status = 1 		//Whether the welder is secured or unsecured (able to attach rods to it to make a flamethrower)
	var/max_fuel = 20 	//The max amount of fuel the welder can hold

	var/acti_sound = 'sound/items/welderactivate.ogg'
	var/deac_sound = 'sound/items/welderdeactivate.ogg'
	usesound = 'sound/items/Welder2.ogg'
	var/change_icons = TRUE
	var/flame_intensity = 2 //how powerful the emitted light is when used.
	var/flame_color = "#FF9933" // What color the welder light emits when its on.  Default is an orange-ish color.
	var/eye_safety_modifier = 0 // Increasing this will make less eye protection needed to stop eye damage.  IE at 1, sunglasses will fully protect.
	var/burned_fuel_for = 0 // Keeps track of how long the welder's been on, used to gradually empty the welder if left one, without RNG.
	var/always_process = FALSE // If true, keeps the welder on the process list even if it's off.  Used for when it needs to regenerate fuel.
	toolspeed = 1
	drop_sound = 'sound/items/drop/weldingtool.ogg'
	pickup_sound = 'sound/items/pickup/weldingtool.ogg'

/obj/item/weldingtool/Initialize()
	. = ..()
//	var/random_fuel = min(rand(10,20),max_fuel)
	var/datum/reagents/R = new/datum/reagents(max_fuel)
	reagents = R
	R.my_atom = src
	R.add_reagent("fuel", max_fuel)
	update_icon()
	if(always_process)
		START_PROCESSING(SSobj, src)

/obj/item/weldingtool/Destroy()
	if(welding || always_process)
		STOP_PROCESSING(SSobj, src)
	return ..()

/obj/item/weldingtool/examine(mob/user)
	. = ..()
	if(max_fuel && loc == user)
		. += "It contains [get_fuel()]/[src.max_fuel] units of fuel!"

/obj/item/weldingtool/attack(atom/A, mob/living/user, def_zone)
	if(ishuman(A) && user.a_intent == I_HELP)
		var/mob/living/carbon/human/H = A
		var/obj/item/organ/external/S = H.organs_by_name[user.zone_sel.selecting]

		if(!S || S.robotic < ORGAN_ROBOT || S.open == 3)
			return ..()

		//VOREStation Add - No welding nanoform limbs
		if(S.robotic > ORGAN_LIFELIKE)
			return ..()
		//VOREStation Add End

		if(S.organ_tag == BP_HEAD)
			if(H.head && istype(H.head,/obj/item/clothing/head/helmet/space))
				to_chat(user, "<span class='warning'>You can't apply [src] through [H.head]!</span>")
				return 1
		else
			if(H.wear_suit && istype(H.wear_suit,/obj/item/clothing/suit/space))
				to_chat(user, "<span class='warning'>You can't apply [src] through [H.wear_suit]!</span>")
				return 1

		if(!welding)
			to_chat(user, "<span class='warning'>You'll need to turn [src] on to patch the damage on [H]'s [S.name]!</span>")
			return 1

		if(S.robo_repair(15, BRUTE, "some dents", src, user))
			remove_fuel(1, user)
			return 1

	return ..()

/obj/item/weldingtool/attackby(obj/item/W as obj, mob/living/user as mob)
	if(istype(W,/obj/item/tool/screwdriver))
		if(welding)
			to_chat(user, "<span class='danger'>Stop welding first!</span>")
			return
		status = !status
		if(status)
			to_chat(user, "<span class='notice'>You secure the welder.</span>")
		else
			to_chat(user, "<span class='notice'>The welder can now be attached and modified.</span>")
		src.add_fingerprint(user)
		return

	if((!status) && (istype(W,/obj/item/stack/rods)))
		var/obj/item/stack/rods/R = W
		R.use(1)
		var/obj/item/flamethrower/F = new/obj/item/flamethrower(user.loc)
		src.loc = F
		F.weldtool = src
		if (user.client)
			user.client.screen -= src
		if (user.r_hand == src)
			user.remove_from_mob(src)
		else
			user.remove_from_mob(src)
		src.master = F
		src.layer = initial(src.layer)
		user.remove_from_mob(src)
		if (user.client)
			user.client.screen -= src
		src.loc = F
		src.add_fingerprint(user)
		return

	..()
	return

/obj/item/weldingtool/process()
	if(welding)
		++burned_fuel_for
		if(burned_fuel_for >= WELDER_FUEL_BURN_INTERVAL)
			remove_fuel(1)
		if(get_fuel() < 1)
			setWelding(0)
		else			//Only start fires when its on and has enough fuel to actually keep working
			var/turf/location = src.loc
			if(istype(location, /mob/living))
				var/mob/living/M = location
				if(M.item_is_in_hands(src))
					location = get_turf(M)
			if (istype(location, /turf))
				location.hotspot_expose(700, 5)

/obj/item/weldingtool/afterattack(obj/O as obj, mob/user as mob, proximity)
	if(!proximity) return
	if (istype(O, /obj/structure/reagent_dispensers/fueltank) && get_dist(src,O) <= 1)
		if(!welding && max_fuel)
			O.reagents.trans_to_obj(src, max_fuel)
			to_chat(user, "<span class='notice'>Welder refueled</span>")
			playsound(src, 'sound/effects/refill.ogg', 50, 1, -6)
			return
		else if(!welding)
			to_chat(user, "<span class='notice'>[src] doesn't use fuel.</span>")
			return
		else
			message_admins("[key_name_admin(user)] triggered a fueltank explosion with a welding tool.")
			log_game("[key_name(user)] triggered a fueltank explosion with a welding tool.")
			to_chat(user, "<span class='danger'>You begin welding on the fueltank and with a moment of lucidity you realize, this might not have been the smartest thing you've ever done.</span>")
			var/obj/structure/reagent_dispensers/fueltank/tank = O
			tank.explode()
			return
	if (src.welding)
		remove_fuel(1)
		var/turf/location = get_turf(user)
		if(isliving(O))
			var/mob/living/L = O
			L.IgniteMob()
		if (istype(location, /turf))
			location.hotspot_expose(700, 50, 1)
/obj/item/weldingtool/attack_self(mob/user)
	setWelding(!welding, user)

//Returns the amount of fuel in the welder
/obj/item/weldingtool/proc/get_fuel()
	return reagents.get_reagent_amount("fuel")

/obj/item/weldingtool/proc/get_max_fuel()
	return max_fuel

//Removes fuel from the welding tool. If a mob is passed, it will perform an eyecheck on the mob. This should probably be renamed to use()
/obj/item/weldingtool/proc/remove_fuel(var/amount = 1, var/mob/M = null)
	if(!welding)
		return 0
	if(amount)
		burned_fuel_for = 0 // Reset the counter since we're removing fuel.
	if(get_fuel() >= amount)
		reagents.remove_reagent("fuel", amount)
		if(M)
			eyecheck(M)
		update_icon()
		return 1
	else
		if(M)
			to_chat(M, "<span class='notice'>You need more welding fuel to complete this task.</span>")
		update_icon()
		return 0

//Returns whether or not the welding tool is currently on.
/obj/item/weldingtool/proc/isOn()
	return welding

/obj/item/weldingtool/update_icon()
	..()
	cut_overlays()
	// Welding overlay.
	if(welding)
		add_overlay("[icon_state]-on")
		item_state = "[initial(item_state)]1"
	else
		item_state = initial(item_state)

	// Fuel counter overlay.
	if(change_icons && get_max_fuel())
		var/ratio = get_fuel() / get_max_fuel()
		ratio = CEILING(ratio * 4, 1) * 25
		add_overlay("[icon_state][ratio]")

	// Lights
	if(welding && flame_intensity)
		set_light(flame_intensity, flame_intensity, flame_color)
	else
		set_light(0)

//	icon_state = welding ? "[icon_state]1" : "[initial(icon_state)]"
	var/mob/M = loc
	if(istype(M))
		M.update_inv_l_hand()
		M.update_inv_r_hand()

/obj/item/weldingtool/MouseDrop(obj/over_object as obj)
	if(!canremove)
		return

	if (ishuman(usr) || issmall(usr)) //so monkeys can take off their backpacks -- Urist

		if (istype(usr.loc,/obj/mecha)) // stops inventory actions in a mech. why?
			return

		if (!( istype(over_object, /obj/screen) ))
			return ..()

		//makes sure that the thing is equipped, so that we can't drag it into our hand from miles away.
		//there's got to be a better way of doing this.
		if (!(src.loc == usr) || (src.loc && src.loc.loc == usr))
			return

		if (( usr.restrained() ) || ( usr.stat ))
			return

		if ((src.loc == usr) && !(istype(over_object, /obj/screen)) && !usr.unEquip(src))
			return

		switch(over_object.name)
			if("r_hand")
				usr.u_equip(src)
				usr.put_in_r_hand(src)
			if("l_hand")
				usr.u_equip(src)
				usr.put_in_l_hand(src)
		src.add_fingerprint(usr)

//Sets the welding state of the welding tool. If you see W.welding = 1 anywhere, please change it to W.setWelding(1)
//so that the welding tool updates accordingly
/obj/item/weldingtool/proc/setWelding(var/set_welding, var/mob/M)
	if(!status)	return

	var/turf/T = get_turf(src)
	//If we're turning it on
	if(set_welding && !welding)
		if (get_fuel() > 0)
			if(M)
				to_chat(M, "<span class='notice'>You switch the [src] on.</span>")
			else if(T)
				T.visible_message("<span class='danger'>\The [src] turns on.</span>")
			playsound(src, acti_sound, 50, 1)
			src.force = 15
			src.damtype = "fire"
			src.w_class = ITEMSIZE_LARGE
			src.hitsound = 'sound/items/welder.ogg'
			welding = 1
			update_icon()
			if(!always_process)
				START_PROCESSING(SSobj, src)
		else
			if(M)
				var/msg = max_fuel ? "welding fuel" : "charge"
				to_chat(M, "<span class='notice'>You need more [msg] to complete this task.</span>")
			return
	//Otherwise
	else if(!set_welding && welding)
		if(!always_process)
			STOP_PROCESSING(SSobj, src)
		if(M)
			to_chat(M, "<span class='notice'>You switch \the [src] off.</span>")
		else if(T)
			T.visible_message("<span class='warning'>\The [src] turns off.</span>")
		playsound(src, deac_sound, 50, 1)
		src.force = 3
		src.damtype = "brute"
		src.w_class = initial(src.w_class)
		src.welding = 0
		src.hitsound = initial(src.hitsound)
		update_icon()

//Decides whether or not to damage a player's eyes based on what they're wearing as protection
//Note: This should probably be moved to mob
/obj/item/weldingtool/proc/eyecheck(mob/living/carbon/user)
	if(!istype(user))
		return 1
	var/safety = user.eyecheck()
	safety = between(-1, safety + eye_safety_modifier, 2)
	if(istype(user, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		var/obj/item/organ/internal/eyes/E = H.internal_organs_by_name[O_EYES]
		if(!E)
			return
		if(H.nif && H.nif.flag_check(NIF_V_UVFILTER,NIF_FLAGS_VISION)) return //VOREStation Add - NIF
		switch(safety)
			if(1)
				to_chat(usr, "<span class='warning'>Your eyes sting a little.</span>")
				E.damage += rand(1, 2)
				if(E.damage > 12)
					user.eye_blurry += rand(3,6)
			if(0)
				to_chat(usr, "<span class='warning'>Your eyes burn.</span>")
				E.damage += rand(2, 4)
				if(E.damage > 10)
					E.damage += rand(4,10)
			if(-1)
				to_chat(usr, "<span class='danger'>Your thermals intensify the welder's glow. Your eyes itch and burn severely.</span>")
				user.eye_blurry += rand(12,20)
				E.damage += rand(12, 16)
		if(safety<2)

			if(E.damage > 10)
				to_chat(user, "<span class='warning'>Your eyes are really starting to hurt. This can't be good for you!</span>")

			if (E.damage >= E.min_broken_damage)
				to_chat(user, "<span class='danger'>You go blind!</span>")
				user.sdisabilities |= BLIND
			else if (E.damage >= E.min_bruised_damage)
				to_chat(user, "<span class='danger'>You go blind!</span>")
				user.Blind(5)
				user.eye_blurry = 5
				// Don't cure being nearsighted
				if(!(H.disabilities & NEARSIGHTED))
					user.disabilities |= NEARSIGHTED
					spawn(100)
						user.disabilities &= ~NEARSIGHTED
	return

/obj/item/weldingtool/is_hot()
	return isOn()

/obj/item/weldingtool/largetank
	name = "industrial welding tool"
	desc = "A slightly larger welder with a larger tank."
	icon_state = "indwelder"
	max_fuel = 40
	origin_tech = list(TECH_ENGINEERING = 2, TECH_PHORON = 2)
	matter = list(MAT_STEEL = 70, MAT_GLASS = 60)

/obj/item/weldingtool/largetank/cyborg
	name = "integrated welding tool"
	desc = "An advanced welder designed to be used in robotic systems."
	toolspeed = 0.5

/obj/item/weldingtool/hugetank
	name = "upgraded welding tool"
	desc = "A much larger welder with a huge tank."
	icon_state = "upindwelder"
	max_fuel = 80
	w_class = ITEMSIZE_NORMAL
	origin_tech = list(TECH_ENGINEERING = 3)
	matter = list(MAT_STEEL = 70, MAT_GLASS = 120)

/obj/item/weldingtool/mini
	name = "emergency welding tool"
	desc = "A miniature welder used during emergencies."
	icon_state = "miniwelder"
	max_fuel = 10
	w_class = ITEMSIZE_SMALL
	matter = list(MAT_METAL = 30, MAT_GLASS = 10)
	change_icons = 0
	toolspeed = 2
	eye_safety_modifier = 1 // Safer on eyes.

/obj/item/weldingtool/mini/two
	icon_state = "miniwelder2"

/datum/category_item/catalogue/anomalous/precursor_a/alien_welder
	name = "Precursor Alpha Object - Self Refueling Exothermic Tool"
	desc = "An unwieldly tool which somewhat resembles a weapon, due to \
	having a prominent trigger attached to the part which would presumably \
	have been held by whatever had created this object. When the trigger is \
	held down, a small but very high temperature flame shoots out from the \
	tip of the tool. The grip is able to be held by human hands, however the \
	shape makes it somewhat awkward to hold.\
	<br><br>\
	The tool appears to utilize an unknown fuel to light and maintain the \
	flame. What is more unusual, is that the fuel appears to replenish itself. \
	How it does this is not known presently, however experimental human-made \
	welders have been known to have a similar quality.\
	<br><br>\
	Interestingly, the flame is able to cut through a wide array of materials, \
	such as iron, steel, stone, lead, plasteel, and even durasteel. Yet, it is unable \
	to cut the unknown material that itself and many other objects made by this \
	precursor civilization have made. This raises questions on the properties of \
	that material, and how difficult it would have been to work with. This tool \
	does demonstrate, however, that the alien fuel cannot melt precursor beams, walls, \
	or other structual elements, making it rather limited for their \
	deconstruction purposes."
	value = CATALOGUER_REWARD_EASY

/obj/item/weldingtool/alien
	name = "alien welding tool"
	desc = "An alien welding tool. Whatever fuel it uses, it never runs out."
	catalogue_data = list(/datum/category_item/catalogue/anomalous/precursor_a/alien_welder)
	icon = 'icons/obj/abductor.dmi'
	icon_state = "welder"
	toolspeed = 0.1
	flame_color = "#6699FF" // Light bluish.
	eye_safety_modifier = 2
	change_icons = 0
	origin_tech = list(TECH_PHORON = 5 ,TECH_ENGINEERING = 5)
	always_process = TRUE

/obj/item/weldingtool/alien/process()
	if(get_fuel() <= get_max_fuel())
		reagents.add_reagent("fuel", 1)
	..()

/obj/item/weldingtool/experimental
	name = "experimental welding tool"
	desc = "An experimental welder capable of synthesizing its own fuel from waste compounds. It can output a flame hotter than regular welders."
	icon_state = "exwelder"
	max_fuel = 40
	w_class = ITEMSIZE_NORMAL
	origin_tech = list(TECH_ENGINEERING = 4, TECH_PHORON = 3)
	matter = list(MAT_STEEL = 70, MAT_GLASS = 120)
	toolspeed = 0.5
	change_icons = 0
	flame_intensity = 3
	always_process = TRUE
	var/nextrefueltick = 0

/obj/item/weldingtool/experimental/process()
	..()
	if(get_fuel() < get_max_fuel() && nextrefueltick < world.time)
		nextrefueltick = world.time + 10
		reagents.add_reagent("fuel", 1)

/obj/item/weldingtool/experimental/hybrid
	name = "strange welding tool"
	desc = "An experimental welder capable of synthesizing its own fuel from spatial waveforms. It's like welding with a star!"
	icon_state = "hybwelder"
	max_fuel = 80 //more max fuel is better! Even if it doesn't actually use fuel.
	eye_safety_modifier = -2	// Brighter than the sun. Literally, you can look at the sun with a welding mask of proper grade, this will burn through that.
	toolspeed = 0.25
	w_class = ITEMSIZE_NORMAL
	flame_intensity = 5
	origin_tech = list(TECH_ENGINEERING = 5, TECH_PHORON = 4, TECH_PRECURSOR = 1)
	reach = 2

/*
 * Backpack Welder.
 */

/obj/item/weldingtool/tubefed
	name = "tube-fed welding tool"
	desc = "A bulky, cooler-burning welding tool that draws from a worn welding tank."
	icon_state = "tubewelder"
	max_fuel = 10
	w_class = ITEMSIZE_NO_CONTAINER
	matter = null
	toolspeed = 1.25
	change_icons = 0
	flame_intensity = 1
	eye_safety_modifier = 1
	always_process = TRUE
	var/obj/item/weldpack/mounted_pack = null

/obj/item/weldingtool/tubefed/Initialize(var/ml)
	. = ..()
	if(istype(loc, /obj/item/weldpack))
		mounted_pack = loc
	else
		return INITIALIZE_HINT_QDEL

/obj/item/weldingtool/tubefed/Destroy()
	mounted_pack.nozzle = null
	mounted_pack = null
	return ..()

/obj/item/weldingtool/tubefed/process()
	if(mounted_pack)
		if(!istype(mounted_pack.loc,/mob/living/carbon/human))
			mounted_pack.return_nozzle()
		else
			var/mob/living/carbon/human/H = mounted_pack.loc
			if(H.back != mounted_pack)
				mounted_pack.return_nozzle()

	if(mounted_pack.loc != src.loc && src.loc != mounted_pack)
		mounted_pack.return_nozzle()
		visible_message("<b>\The [src]</b> retracts to its fueltank.")

	if(get_fuel() <= get_max_fuel())
		mounted_pack.reagents.trans_to_obj(src, 1)

	..()

/obj/item/weldingtool/tubefed/dropped(mob/user)
	..()
	if(src.loc != user)
		mounted_pack.return_nozzle()
		to_chat(user, "<span class='notice'>\The [src] retracts to its fueltank.</span>")

/obj/item/weldingtool/tubefed/survival
	name = "tube-fed emergency welding tool"
	desc = "A bulky, cooler-burning welding tool that draws from a worn welding tank."
	icon_state = "tubewelder"
	max_fuel = 5
	toolspeed = 1.75
	eye_safety_modifier = 2

/*
 * Electric/Arc Welder
 */

/obj/item/weldingtool/electric	//AND HIS WELDING WAS ELECTRIC
	name = "electric welding tool"
	desc = "A welder which runs off of electricity."
	icon_state = "arcwelder"
	max_fuel = 0	//We'll handle the consumption later.
	item_state = "ewelder"
	var/obj/item/cell/power_supply //What type of power cell this uses
	var/charge_cost = 24	//The rough equivalent of 1 unit of fuel, based on us wanting 10 welds per battery
	var/cell_type = /obj/item/cell/device
	var/use_external_power = 0	//If in a borg or hardsuit, this needs to = 1
	flame_color = "#00CCFF"  // Blue-ish, to set it apart from the gas flames.
	acti_sound = 'sound/effects/sparks4.ogg'
	deac_sound = 'sound/effects/sparks4.ogg'

/obj/item/weldingtool/electric/unloaded
	cell_type = null

/obj/item/weldingtool/electric/Initialize()
	. = ..()
	if(cell_type == null)
		update_icon()
	else if(cell_type)
		power_supply = new cell_type(src)
	else
		power_supply = new /obj/item/cell/device(src)
	update_icon()

/obj/item/weldingtool/electric/get_cell()
	return power_supply

/obj/item/weldingtool/electric/examine(mob/user)
	. = ..()
	if(Adjacent(user))
		if(power_supply)
			. += "It [src.name] has [get_fuel()] charge left."
		else
			. += "It [src.name] has no power cell!"

/obj/item/weldingtool/electric/get_fuel()
	if(use_external_power)
		var/obj/item/cell/external = get_external_power_supply()
		if(external)
			return external.charge
	else if(power_supply)
		return power_supply.charge
	else
		return 0

/obj/item/weldingtool/electric/get_max_fuel()
	if(use_external_power)
		var/obj/item/cell/external = get_external_power_supply()
		if(external)
			return external.maxcharge
	else if(power_supply)
		return power_supply.maxcharge
	return 0

/obj/item/weldingtool/electric/remove_fuel(var/amount = 1, var/mob/M = null)
	if(!welding)
		return 0
	if(get_fuel() >= amount)
		power_supply.checked_use(charge_cost)
		if(use_external_power)
			var/obj/item/cell/external = get_external_power_supply()
			if(!external || !external.use(charge_cost)) //Take power from the borg...
				power_supply.give(charge_cost)	//Give it back to the cell.
		if(M)
			eyecheck(M)
		update_icon()
		return 1
	else
		if(M)
			to_chat(M, "<span class='notice'>You need more energy to complete this task.</span>")
		update_icon()
		return 0

/obj/item/weldingtool/electric/attack_hand(mob/user as mob)
	if(user.get_inactive_hand() == src)
		if(power_supply)
			power_supply.update_icon()
			user.put_in_hands(power_supply)
			power_supply = null
			to_chat(user, "<span class='notice'>You remove the cell from the [src].</span>")
			setWelding(0)
			update_icon()
			return
		..()
	else
		return ..()

/obj/item/weldingtool/electric/attackby(obj/item/W, mob/user as mob)
	if(istype(W, /obj/item/cell))
		if(istype(W, /obj/item/cell/device))
			if(!power_supply)
				user.drop_item()
				W.loc = src
				power_supply = W
				to_chat(user, "<span class='notice'>You install a cell in \the [src].</span>")
				update_icon()
			else
				to_chat(user, "<span class='notice'>\The [src] already has a cell.</span>")
		else
			to_chat(user, "<span class='notice'>\The [src] cannot use that type of cell.</span>")
	else
		..()

/obj/item/weldingtool/electric/proc/get_external_power_supply()
	if(isrobot(src.loc))
		var/mob/living/silicon/robot/R = src.loc
		return R.cell
	if(istype(src.loc, /obj/item/rig_module))
		var/obj/item/rig_module/module = src.loc
		if(module.holder && module.holder.wearer)
			var/mob/living/carbon/human/H = module.holder.wearer
			if(istype(H) && H.back)
				var/obj/item/rig/suit = H.back
				if(istype(suit))
					return suit.cell
	if(istype(src.loc, /obj/item/mecha_parts/mecha_equipment))
		var/obj/item/mecha_parts/mecha_equipment/mounting = src.loc
		if(mounting.chassis && mounting.chassis.cell)
			return mounting.chassis.cell
	return null

/obj/item/weldingtool/electric/mounted
	use_external_power = 1

/obj/item/weldingtool/electric/mounted/cyborg
	toolspeed = 0.5

/obj/item/weldingtool/electric/mounted/exosuit
	var/obj/item/mecha_parts/mecha_equipment/equip_mount = null
	flame_intensity = 1
	eye_safety_modifier = 2
	always_process = TRUE

/obj/item/weldingtool/electric/mounted/exosuit/Initialize()
	. = ..()

	if(istype(loc, /obj/item/mecha_parts/mecha_equipment))
		equip_mount = loc

/obj/item/weldingtool/electric/mounted/exosuit/process()
	..()

	if(equip_mount && equip_mount.chassis)
		var/obj/mecha/M = equip_mount.chassis
		if(M.selected == equip_mount && get_fuel())
			setWelding(TRUE, M.occupant)
		else
			setWelding(FALSE, M.occupant)

#undef WELDER_FUEL_BURN_INTERVAL
