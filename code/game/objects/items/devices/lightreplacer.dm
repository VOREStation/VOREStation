
// Light Replacer (LR)
//
// ABOUT THE DEVICE
//
// This is a device supposedly to be used by Janitors and Janitor Cyborgs which will
// allow them to easily replace lights. This was mostly designed for Janitor Cyborgs since
// they don't have hands or a way to replace lightbulbs.
//
// HOW IT WORKS
//
// You attack a light fixture with it, if the light fixture is broken it will replace the
// light fixture with a working light; the broken light is then placed on the floor for the
// user to then pickup with a trash bag. If it's empty then it will just place a light in the fixture.
//
// HOW TO REFILL THE DEVICE
//
// It can be manually refilled or by clicking on a storage item containing lights.
// If it's part of a robot module, it will charge when the Robot is inside a Recharge Station.
//
// EMAGGED FEATURES
//
// NOTICE: The Cyborg cannot use the emagged Light Replacer and the light's explosion was nerfed. It cannot create holes in the station anymore.
//
// I'm not sure everyone will react the emag's features so please say what your opinions are of it.
//
// When emagged it will rig every light it replaces, which will explode when the light is on.
// This is VERY noticable, even the device's name changes when you emag it so if anyone
// examines you when you're holding it in your hand, you will be discovered.
// It will also be very obvious who is setting all these lights off, since only Janitor Borgs and Janitors have easy
// access to them, and only one of them can emag their device.
//
// The explosion cannot insta-kill anyone with 30% or more health.

#define LIGHT_OK 0
#define LIGHT_EMPTY 1
#define LIGHT_BROKEN 2
#define LIGHT_BURNED 3


/obj/item/device/lightreplacer

	name = "light replacer"
	desc = "A device to automatically replace lights. Refill with working lightbulbs or sheets of glass."
	force = 8
	icon = 'icons/obj/janitor.dmi'
	icon_state = "lightreplacer0"
	slot_flags = SLOT_BELT
	origin_tech = list(TECH_MAGNET = 3, TECH_MATERIAL = 2)

	var/max_uses = 32
	var/uses = 32
	var/emagged = 0
	var/failmsg = ""
	var/charge = 0

	// Eating used bulbs gives us bulb shards
	var/bulb_shards = 0
	// when we get this many shards, we get a free bulb.
	var/shards_required = 4

/obj/item/device/lightreplacer/New()
	failmsg = "The [name]'s refill light blinks red."
	..()

/obj/item/device/lightreplacer/examine(mob/user)
	if(..(user, 2))
		to_chat(user, "It has [uses] lights remaining.")

/obj/item/device/lightreplacer/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/stack/material) && W.get_material_name() == "glass")
		var/obj/item/stack/G = W
		if(uses >= max_uses)
			to_chat(user, "<span class='warning'>[src.name] is full.</span>")
			return
		else if(G.use(1))
			add_uses(16) //Autolathe converts 1 sheet into 16 lights.
			to_chat(user, "<span class='notice'>You insert a piece of glass into \the [src.name]. You have [uses] light\s remaining.</span>")
			return
		else
			to_chat(user, "<span class='warning'>You need one sheet of glass to replace lights.</span>")

	if(istype(W, /obj/item/weapon/light))
		var/new_bulbs = 0
		var/obj/item/weapon/light/L = W
		if(L.status == 0) // LIGHT OKAY
			if(uses < max_uses)
				if(!user.unEquip(W))
					return
				add_uses(1)
				qdel(L)
		else
			if(!user.unEquip(W))
				return
			new_bulbs += AddShards(1)
			qdel(L)
		if(new_bulbs != 0)
			playsound(src.loc, 'sound/machines/ding.ogg', 50, 1)
		to_chat(user, "You insert \the [L.name] into \the [src.name]. You have [uses] light\s remaining.")
		return

	if(istype(W, /obj/item/weapon/storage))
		var/obj/item/weapon/storage/S = W
		var/found_lightbulbs = FALSE
		var/replaced_something = TRUE

		for(var/obj/item/I in S.contents)
			if(istype(I,/obj/item/weapon/light))
				var/obj/item/weapon/light/L = I
				found_lightbulbs = TRUE
				if(src.uses >= max_uses)
					break
				if(L.status == LIGHT_OK)
					replaced_something = TRUE
					add_uses(1)
					qdel(L)

				else if(L.status == LIGHT_BROKEN || L.status == LIGHT_BURNED)
					replaced_something = TRUE
					AddShards(1)
					qdel(L)

		if(!found_lightbulbs)
			to_chat(user, "<span class='warning'>\The [S] contains no bulbs.</span>")
			return

		if(!replaced_something && src.uses == max_uses)
			to_chat(user, "<span class='warning'>\The [src] is full!</span>")
			return

		to_chat(user, "<span class='notice'>You fill \the [src] with lights from \the [S].</span>")

/obj/item/device/lightreplacer/attack_self(mob/user)
	/* // This would probably be a bit OP. If you want it though, uncomment the code.
	if(isrobot(user))
		var/mob/living/silicon/robot/R = user
		if(R.emagged)
			src.Emag()
			to_chat(usr, You short circuit the [src].")
			return
	*/
	to_chat(usr, "It has [uses] lights remaining.")

/obj/item/device/lightreplacer/update_icon()
	icon_state = "lightreplacer[emagged]"


/obj/item/device/lightreplacer/proc/Use(var/mob/user)

	playsound(src.loc, 'sound/machines/click.ogg', 50, 1)
	add_uses(-1)
	return 1

// Negative numbers will subtract
/obj/item/device/lightreplacer/proc/add_uses(var/amount = 1)
	uses = min(max(uses + amount, 0), max_uses)


/obj/item/device/lightreplacer/proc/AddShards(amount = 1)
	bulb_shards += amount
	var/new_bulbs = round(bulb_shards / shards_required)
	if(new_bulbs > 0)
		add_uses(new_bulbs)
	bulb_shards = bulb_shards % shards_required
	return new_bulbs

/obj/item/device/lightreplacer/proc/Charge(var/mob/user, var/amount = 1)
	charge += amount
	if(charge > 6)
		add_uses(1)
		charge = 0

/obj/item/device/lightreplacer/proc/ReplaceLight(var/obj/machinery/light/target, var/mob/living/U)

	if(target.status != LIGHT_OK)
		if(CanUse(U))
			if(!Use(U)) return
			to_chat(U, "<span class='notice'>You replace the [target.get_fitting_name()] with the [src].</span>")

			if(target.status != LIGHT_EMPTY)
				var/new_bulbs = AddShards(1)
				if(new_bulbs != 0)
					to_chat(U, "<span class='notice'>\The [src] has fabricated a new bulb from the broken bulbs it has stored. It now has [uses] uses.</span>")
					playsound(src.loc, 'sound/machines/ding.ogg', 50, 1)
				target.status = LIGHT_EMPTY
				target.update()

			var/obj/item/weapon/light/L2 = new target.light_type()

			target.status = L2.status
			target.switchcount = L2.switchcount
			target.rigged = emagged
			target.brightness_range = L2.brightness_range
			target.brightness_power = L2.brightness_power
			target.brightness_color = L2.brightness_color
			target.on = target.has_power()
			target.update()
			qdel(L2)

			if(target.on && target.rigged)
				target.explode()
			return

		else
			to_chat(U, failmsg)
			return
	else
		to_chat(U, "There is a working [target.get_fitting_name()] already inserted.")
		return

/obj/item/device/lightreplacer/emag_act(var/remaining_charges, var/mob/user)
	emagged = !emagged
	playsound(src.loc, "sparks", 100, 1)
	update_icon()
	return 1

//Can you use it?

/obj/item/device/lightreplacer/proc/CanUse(var/mob/living/user)
	src.add_fingerprint(user)
	//Not sure what else to check for. Maybe if clumsy?
	if(uses > 0)
		return 1
	else
		return 0

#undef LIGHT_OK
#undef LIGHT_EMPTY
#undef LIGHT_BROKEN
#undef LIGHT_BURNED