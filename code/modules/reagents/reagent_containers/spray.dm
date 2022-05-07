/obj/item/weapon/reagent_containers/spray
	name = "spray bottle"
	desc = "A spray bottle, with an unscrewable top."
	icon = 'icons/obj/janitor.dmi'
	icon_state = "cleaner"
	item_state = "cleaner"
	center_of_mass = list("x" = 16,"y" = 10)
	flags = OPENCONTAINER|NOBLUDGEON
	matter = list(MAT_GLASS = 300, MAT_STEEL = 300)
	slot_flags = SLOT_BELT
	throwforce = 3
	w_class = ITEMSIZE_SMALL
	throw_speed = 2
	throw_range = 10
	amount_per_transfer_from_this = 10
	unacidable = TRUE //plastic
	possible_transfer_amounts = list(5,10) //Set to null instead of list, if there is only one.
	var/spray_size = 3
	var/list/spray_sizes = list(1,3)
	volume = 250

/obj/item/weapon/reagent_containers/spray/Initialize()
	. = ..()
	src.verbs -= /obj/item/weapon/reagent_containers/verb/set_APTFT

/obj/item/weapon/reagent_containers/spray/afterattack(atom/A as mob|obj, mob/user as mob, proximity)
	if(istype(A, /obj/item/weapon/storage) || istype(A, /obj/structure/table) || istype(A, /obj/structure/closet) || istype(A, /obj/item/weapon/reagent_containers) || istype(A, /obj/structure/sink) || istype(A, /obj/structure/janitorialcart))
		return

	if(istype(A, /spell))
		return

	if(proximity)
		if(standard_dispenser_refill(user, A))
			return

	if(reagents.total_volume < amount_per_transfer_from_this)
		to_chat(user, "<span class='notice'>\The [src] is empty!</span>")
		return

	Spray_at(A, user, proximity)

	user.setClickCooldown(4)

	if(reagents.has_reagent("sacid"))
		message_admins("[key_name_admin(user)] fired sulphuric acid from \a [src].")
		log_game("[key_name(user)] fired sulphuric acid from \a [src].")
	if(reagents.has_reagent("pacid"))
		message_admins("[key_name_admin(user)] fired Polyacid from \a [src].")
		log_game("[key_name(user)] fired Polyacid from \a [src].")
	if(reagents.has_reagent("lube"))
		message_admins("[key_name_admin(user)] fired Space lube from \a [src].")
		log_game("[key_name(user)] fired Space lube from \a [src].")
	return

/obj/item/weapon/reagent_containers/spray/proc/Spray_at(atom/A as mob|obj, mob/user as mob, proximity)
	playsound(src, 'sound/effects/spray2.ogg', 50, 1, -6)
	if (A.density && proximity)
		A.visible_message("[usr] sprays [A] with [src].")
		reagents.splash(A, amount_per_transfer_from_this)
	else
		spawn(0)
			var/obj/effect/effect/water/chempuff/D = new/obj/effect/effect/water/chempuff(get_turf(src))
			var/turf/my_target = get_turf(A)
			D.create_reagents(amount_per_transfer_from_this)
			if(!src)
				return
			reagents.trans_to_obj(D, amount_per_transfer_from_this)
			D.set_color()
			D.set_up(my_target, spray_size, 10)
	return

/obj/item/weapon/reagent_containers/spray/attack_self(var/mob/user)
	if(!possible_transfer_amounts)
		return
	amount_per_transfer_from_this = next_in_list(amount_per_transfer_from_this, possible_transfer_amounts)
	spray_size = next_in_list(spray_size, spray_sizes)
	to_chat(user, "<span class='notice'>You adjusted the pressure nozzle. You'll now use [amount_per_transfer_from_this] units per spray.</span>")

/obj/item/weapon/reagent_containers/spray/examine(mob/user)
	. = ..()
	if(loc == user)
		. += "[round(reagents.total_volume)] units left."

/obj/item/weapon/reagent_containers/spray/verb/empty()

	set name = "Empty Spray Bottle"
	set category = "Object"
	set src in usr

	if (tgui_alert(usr, "Are you sure you want to empty that?", "Empty Bottle:", list("Yes", "No")) != "Yes")
		return
	if(isturf(usr.loc))
		to_chat(usr, "<span class='notice'>You empty \the [src] onto the floor.</span>")
		reagents.splash(usr.loc, reagents.total_volume)

//space cleaner
/obj/item/weapon/reagent_containers/spray/cleaner
	name = "space cleaner"
	desc = "BLAM!-brand non-foaming space cleaner!"

/obj/item/weapon/reagent_containers/spray/cleaner/drone
	name = "space cleaner"
	desc = "BLAM!-brand non-foaming space cleaner!"
	volume = 50

/obj/item/weapon/reagent_containers/spray/cleaner/Initialize()
	. = ..()
	reagents.add_reagent("cleaner", volume)

/obj/item/weapon/reagent_containers/spray/sterilizine
	name = "sterilizine"
	desc = "Great for hiding incriminating bloodstains and sterilizing scalpels."

/obj/item/weapon/reagent_containers/spray/sterilizine/Initialize()
	. = ..()
	reagents.add_reagent("sterilizine", volume)

/obj/item/weapon/reagent_containers/spray/pepper
	name = "pepperspray"
	desc = "Manufactured by UhangInc, used to blind and down an opponent quickly."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "pepperspray"
	item_state = "pepperspray"
	center_of_mass = list("x" = 16,"y" = 16)
	possible_transfer_amounts = null
	volume = 40
	var/safety = TRUE

/obj/item/weapon/reagent_containers/spray/pepper/Initialize()
	. = ..()
	reagents.add_reagent("condensedcapsaicin", volume)

/obj/item/weapon/reagent_containers/spray/pepper/examine(mob/user)
	. = ..()
	if(Adjacent(user))
		. += "The safety is [safety ? "on" : "off"]."

/obj/item/weapon/reagent_containers/spray/pepper/attack_self(var/mob/user)
	safety = !safety
	to_chat(usr, "<span class = 'notice'>You switch the safety [safety ? "on" : "off"].</span>")

/obj/item/weapon/reagent_containers/spray/pepper/Spray_at(atom/A as mob|obj)
	if(safety)
		to_chat(usr, "<span class = 'warning'>The safety is on!</span>")
		return
	. = ..()

<<<<<<< HEAD
/obj/item/weapon/reagent_containers/spray/waterflower
=======
/obj/item/reagent_containers/spray/pepper/small
	name = "personal pepperspray"
	desc = "A small personal defense weapon with up to two smaller pumps of blinding spray."
	icon_state = "pepperspray_small"
	item_state = "pepperspray_small"
	volume = 10
	amount_per_transfer_from_this = 5

/obj/item/reagent_containers/spray/waterflower
>>>>>>> 16f35bdfad1... Merge pull request #8607 from Sypsoti/loadoutcontraband
	name = "water flower"
	desc = "A seemingly innocent sunflower...with a twist."
	icon = 'icons/obj/device.dmi'
	icon_state = "sunflower"
	item_state = "sunflower"
	amount_per_transfer_from_this = 1
	possible_transfer_amounts = null
	volume = 10
	drop_sound = 'sound/items/drop/herb.ogg'
	pickup_sound = 'sound/items/pickup/herb.ogg'

/obj/item/weapon/reagent_containers/spray/waterflower/Initialize()
	. = ..()
	reagents.add_reagent("water", 10)

/obj/item/weapon/reagent_containers/spray/chemsprayer
	name = "chem sprayer"
	desc = "A utility used to spray large amounts of reagent in a given area."
	icon = 'icons/obj/gun.dmi'
	icon_state = "chemsprayer"
	item_state = "chemsprayer"
	item_icons = list(slot_l_hand_str = 'icons/mob/items/lefthand_guns.dmi', slot_r_hand_str = 'icons/mob/items/righthand_guns.dmi')
	center_of_mass = list("x" = 16,"y" = 16)
	throwforce = 3
	w_class = ITEMSIZE_NORMAL
	possible_transfer_amounts = null
	volume = 600
	origin_tech = list(TECH_COMBAT = 3, TECH_MATERIAL = 3, TECH_ENGINEERING = 3)

/obj/item/weapon/reagent_containers/spray/chemsprayer/Spray_at(atom/A as mob|obj)
	playsound(src, 'sound/effects/spray3.ogg', rand(50,1), -6)
	var/direction = get_dir(src, A)
	var/turf/T = get_turf(A)
	var/turf/T1 = get_step(T,turn(direction, 90))
	var/turf/T2 = get_step(T,turn(direction, -90))
	var/list/the_targets = list(T, T1, T2)

	for(var/a = 1 to 3)
		spawn(0)
			if(reagents.total_volume < 1) break
			var/obj/effect/effect/water/chempuff/D = new/obj/effect/effect/water/chempuff(get_turf(src))
			var/turf/my_target = the_targets[a]
			D.create_reagents(amount_per_transfer_from_this)
			if(!src)
				return
			reagents.trans_to_obj(D, amount_per_transfer_from_this)
			D.set_color()
			D.set_up(my_target, rand(6, 8), 2)
	return

/obj/item/weapon/reagent_containers/spray/plantbgone
	name = "Plant-B-Gone"
	desc = "Kills those pesky weeds!"
	icon = 'icons/obj/hydroponics_machines.dmi'
	icon_state = "plantbgone"
	item_state = "plantbgone"
	volume = 100

/obj/item/weapon/reagent_containers/spray/plantbgone/Initialize()
	. = ..()
	reagents.add_reagent("plantbgone", 100)

/obj/item/weapon/reagent_containers/spray/chemsprayer/hosed
	name = "hose nozzle"
	desc = "A heavy spray nozzle that must be attached to a hose."
	icon = 'icons/obj/janitor.dmi'
	icon_state = "cleaner-industrial"
	item_state = "cleaner"
	center_of_mass = list("x" = 16,"y" = 10)

	possible_transfer_amounts = list(5,10,20)

	var/heavy_spray = FALSE
	var/spray_particles = 3

	var/icon/hose_overlay

	var/obj/item/hose_connector/input/active/InputSocket

/obj/item/weapon/reagent_containers/spray/chemsprayer/hosed/Initialize()
	. = ..()

	InputSocket = new(src)

/obj/item/weapon/reagent_containers/spray/chemsprayer/hosed/update_icon()
	..()

	cut_overlays()

	if(!hose_overlay)
		hose_overlay = new icon(icon, "[icon_state]+hose")

	if(InputSocket.get_pairing())
		add_overlay(hose_overlay)

/obj/item/weapon/reagent_containers/spray/chemsprayer/hosed/AltClick(mob/living/carbon/user)
	if(++spray_particles > 3) spray_particles = 1

	to_chat(user, "<span class='notice'>You turn the dial on \the [src] to [spray_particles].</span>")
	return

/obj/item/weapon/reagent_containers/spray/chemsprayer/hosed/CtrlClick(var/mob/user)
	if(loc != get_turf(src))
		heavy_spray = !heavy_spray
	else
		. = ..()

/obj/item/weapon/reagent_containers/spray/chemsprayer/hosed/Spray_at(atom/A as mob|obj)
	update_icon()

	var/direction = get_dir(src, A)
	var/turf/T = get_turf(A)
	var/turf/T1 = get_step(T,turn(direction, 90))
	var/turf/T2 = get_step(T,turn(direction, -90))
	var/list/the_targets = list(T, T1, T2)

	if(src.reagents.total_volume < 1)
		to_chat(usr, "<span class='notice'>\The [src] is empty.</span>")
		return

	if(!heavy_spray)
		for(var/a = 1 to 3)
			spawn(0)
				if(reagents.total_volume < 1) break
				playsound(src, 'sound/effects/spray2.ogg', 50, 1, -6)
				var/obj/effect/effect/water/chempuff/D = new/obj/effect/effect/water/chempuff(get_turf(src))
				var/turf/my_target = the_targets[a]
				D.create_reagents(amount_per_transfer_from_this)
				if(!src)
					return
				reagents.trans_to_obj(D, amount_per_transfer_from_this)
				D.set_color()
				D.set_up(my_target, rand(6, 8), 2)
		return

	else
		playsound(src, 'sound/effects/extinguish.ogg', 75, 1, -3)

		for(var/a = 1 to spray_particles)
			spawn(0)
				if(!src || !reagents.total_volume) return

				var/obj/effect/effect/water/W = new /obj/effect/effect/water(get_turf(src))
				var/turf/my_target
				if(a <= the_targets.len)
					my_target = the_targets[a]
				else
					my_target = pick(the_targets)
				W.create_reagents(amount_per_transfer_from_this)
				reagents.trans_to_obj(W, amount_per_transfer_from_this)
				W.set_color()
				W.set_up(my_target)

		return
