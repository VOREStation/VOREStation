///// __          __     _____  _   _ _____ _   _  _____ /////
///// \ \        / /\   |  __ \| \ | |_   _| \ | |/ ____|/////
/////  \ \  /\  / /  \  | |__) |  \| | | | |  \| | |  __ /////
/////   \ \/  \/ / /\ \ |  _  /| . ` | | | | . ` | | |_ |/////
/////    \  /\  / ____ \| | \ \| |\  |_| |_| |\  | |__| |/////
/////     \/  \/_/    \_\_|  \_\_| \_|_____|_| \_|\_____|/////


///// I have no clue why. I am too tired to figure out. Do not enable this file. For some esoteric reasons it breaks runtimes. Particularly, runtime logging.
///// No I don't know why. No I don't care to figure out why. Not anymore. I haven't seen these things used anywhere. By anyone.
///// If somebody REALLY wants these, they can be the ones to figure out why the hell this random-ass water backpack file breaks runtime list. I am disabling this and I am done with this. Good night.

/*
 * Hydroponics tank and base code
 */
/obj/item/watertank
	name = "backpack water tank"
	desc = "A S.U.N.S.H.I.N.E. brand watertank backpack with nozzle to water plants."
	icon = 'icons/inventory/back/item.dmi'
	icon_state = "waterbackpack"
	item_state = "waterbackpack"
	w_class = ITEMSIZE_LARGE
	slot_flags = SLOT_BACK
	slowdown = 0.5
	armor = list(MELEE = 0, BULLET = 0, LASER = 0, ENERGY = 0, BOMB = 0, BIO = 0, RAD = 0, FIRE = 100, ACID = 30)

	var/obj/item/noz
	var/volume = 500

/obj/item/watertank/Initialize()
	. = ..()
	create_reagents(volume)
	noz = make_noz()

/obj/item/watertank/MouseDrop()
	if(ismob(loc))
		if(!CanMouseDrop(src))
			return
		var/mob/M = loc
		if(!M.unEquip(src))
			return
		add_fingerprint(usr)
		M.put_in_any_hand_if_possible(src)

/obj/item/watertank/Destroy()
	QDEL_NULL(noz)
	return ..()

/obj/item/watertank/ui_action_click(mob/user)
	toggle_mister(user)

/obj/item/watertank/attack_hand(var/mob/user)
	if(loc == user)
		toggle_mister()
	else
		..()

/obj/item/watertank/item_action_slot_check(slot, mob/user)
	if(slot == user.getBackSlot())
		return 1

//checks that the base unit is in the correct slot to be used
/obj/item/watertank/proc/slot_check()
	var/mob/M = loc
	if(!istype(M))
		return 0 //not equipped

	if((slot_flags & SLOT_BACK) && M.get_equipped_item(slot_back) == src)
		return 1
	if((slot_flags & SLOT_BACK) && M.get_equipped_item(slot_s_store) == src)
		return 1

	return 0

/obj/item/watertank/verb/toggle_mister()
	set name = "Toggle Mister"
	set category = "Object"

	var/mob/living/carbon/human/user = usr
	if(!noz)
		to_chat(user, "<span class='warning'>The mister is missing!</span>")
		return
	if(noz.loc != src)
		remove_noz(user) //Remove from their hands and back onto the defib unit
		return
	if(!slot_check())
		to_chat(user, "<span class='warning'>You need to equip [src] before taking out [noz].</span>")
	else
		if(!usr.put_in_hands(noz)) //Detach the handset into the user's hands
			to_chat(user, "<span class='warning'>You need a free hand to hold the handset!</span>")
		update_icon() //success

/obj/item/watertank/proc/make_noz()
	return new /obj/item/reagent_containers/spray/mister(src)

/obj/item/watertank/equipped(mob/user, slot)
	..()
	if(slot != slot_back)
		remove_noz()

/obj/item/watertank/proc/remove_noz(var/mob/user)
	if(!noz) return

	if(ismob(noz.loc))
		var/mob/M = noz.loc
		if(M.drop_from_inventory(noz, src))
			to_chat(user, "<span class='notice'>\The [noz] snaps back into the main unit.</span>")
	else
		noz.forceMove(src)

/obj/item/watertank/attackby(obj/item/W, mob/user, params)
	if(W == noz)
		remove_noz()
		return 1
	else
		return ..()

/obj/item/watertank/dropped(var/mob/user)
	..()
	remove_noz(user)

/*
 * This mister item is intended as an extension of the watertank and always attached to it.
 * Therefore, it's designed to be "locked" to the player's hands or extended back onto
 * the watertank backpack. Allowing it to be placed elsewhere or created without a parent
 * watertank object will likely lead to weird behaviour or runtimes.
 */

/*
 * Hydroponics mister
 */
/obj/item/reagent_containers/spray/mister
	name = "water mister"
	desc = "A mister nozzle attached to a water tank."
	icon_state = "mister"
	item_state = "mister"
	w_class = ITEMSIZE_LARGE
	amount_per_transfer_from_this = 50
	possible_transfer_amounts = list(50)
	volume = 500
	item_flags = NOBLUDGEON
	slot_flags = NONE

	var/obj/item/watertank/tank

/obj/item/reagent_containers/spray/mister/Initialize()
	. = ..()
	tank = loc
	if(!istype(tank))
		return INITIALIZE_HINT_QDEL
	reagents = tank.reagents //This mister is really just a proxy for the tank's reagents

/obj/item/reagent_containers/spray/mister/doMove(atom/destination)
	if(destination && (destination != tank.loc || !ismob(destination)))
		if (loc != tank)
			to_chat(tank.loc, "<span class = 'notice'>The mister snaps back onto the watertank.</span>")
		destination = tank
	..()

/obj/item/reagent_containers/spray/mister/afterattack(obj/target, mob/user, proximity)
	if(target.loc == loc) //Safety check so you don't fill your mister with mutagen or something and then blast yourself in the face with it
		return
	..()

/*
 * Janitor tank
 */
/obj/item/watertank/janitor
	name = "backpack cleaner tank"
	desc = "A janitorial cleaner backpack with nozzle to clean blood and graffiti."
	icon_state = "waterbackpackjani"
	item_state = "waterbackpackjani"

/obj/item/watertank/janitor/Initialize()
	. = ..()
	reagents.add_reagent("cleaner", 500)

/obj/item/watertank/janitor/make_noz()
	return new /obj/item/reagent_containers/spray/mister/janitor(src)

/*
 * Janitor mister
 */
/obj/item/reagent_containers/spray/mister/janitor
	name = "janitor spray nozzle"
	desc = "A janitorial spray nozzle attached to a watertank, designed to clean up large messes."
	icon_state = "misterjani"
	item_state = "misterjani"
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = list(5,10)
	spray_size = 4

/*
 * Security tank
 */
/obj/item/watertank/pepperspray
	name = "ANTI-TIDER-2500 suppression backpack"
	desc = "The ultimate crowd-control device; this tool allows the user to quickly and efficiently pacify groups of hostile targets."
	icon_state = "pepperbackpacksec"
	item_state = "pepperbackpacksec"
	volume = 1000

/obj/item/watertank/pepperspray/Initialize()
	. = ..()
	reagents.add_reagent("condensedcapsaicin", 1000)

/obj/item/watertank/pepperspray/make_noz()
	return new /obj/item/reagent_containers/spray/mister/pepperspray(src)

/*
 * Security mister
 */
/obj/item/reagent_containers/spray/mister/pepperspray
	name = "security spray nozzle"
	desc = "A pacifying spray nozzle attached to a pepperspray tank, designed to silence perps."
	icon_state = "mistersec"
	item_state = "mistersec"
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = list(5,10)
	spray_size = 6

/*
 * Operative tank
 */
/obj/item/watertank/op
	name = "uborka tank"
	desc = "A Russian backpack spray for systematic cleansing of carbon lifeforms."
	icon_state = "waterbackpackop"
	item_state = "waterbackpackop"
	w_class = ITEMSIZE_NORMAL
	volume = 2000
	slowdown = 0

/obj/item/watertank/op/Initialize()
	. = ..()
	reagents.add_reagent("fuel", 500)
	reagents.add_reagent("cryptobiolin", 500)
	reagents.add_reagent("phoron", 500)
	reagents.add_reagent("condensedcapsaicin", 500)

/obj/item/watertank/op/make_noz()
	return new /obj/item/reagent_containers/spray/mister/op(src)

/*
 * Operative mister
 */
/obj/item/reagent_containers/spray/mister/op
	name = "uborka spray nozzle"
	desc = "A mister nozzle attached to several extended water tanks. It suspiciously has a compressor in the system and is labelled entirely in Cyrillic."
	icon_state = "misterop"
	item_state = "misterop"
	w_class = ITEMSIZE_HUGE
	volume = 2000
	amount_per_transfer_from_this = 100
	possible_transfer_amounts = list(75,100,150)

/*
 * Atmos tank
 */
/obj/item/watertank/atmos
	name = "backpack firefighter tank"
	desc = "A pressurized backpack tank with extinguisher nozzle, intended to fight fires."
	icon_state = "waterbackpackatmos"
	item_state = "waterbackpackatmos"
	volume = 200

/obj/item/watertank/atmos/Initialize()
	. = ..()
	reagents.add_reagent("water", 200)

/obj/item/watertank/atmos/make_noz()
	return new /obj/item/reagent_containers/spray/mister/atmos(src)

/*
 * Atmos hose
 */
/obj/item/reagent_containers/spray/mister/atmos
	name = "extinguisher nozzle"
	desc = "A heavy duty nozzle attached to a firefighter's backpack tank."
	icon_state = "atmos_nozzle"
	item_state = "nozzleatmos"
	w_class = ITEMSIZE_HUGE
	volume = 200
	amount_per_transfer_from_this = 5
	possible_transfer_amounts = list(5,10)
	spray_size = null

/obj/item/reagent_containers/spray/mister/atmos/Spray_at(atom/A as mob|obj)
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