// The lighting system
//
// consists of light fixtures (/obj/machinery/light) and light tube/bulb items (/obj/item/weapon/light)


// status values shared between lighting fixtures and items
#define LIGHT_OK 0
#define LIGHT_EMPTY 1
#define LIGHT_BROKEN 2
#define LIGHT_BURNED 3
#define LIGHT_BULB_TEMPERATURE 400 //K - used value for a 60W bulb

/obj/machinery/light_construct
	name = "light fixture frame"
	desc = "A light fixture under construction."
	icon = 'icons/obj/lighting.dmi'
	icon_state = "tube-construct-stage1"
	anchored = 1
	plane = MOB_PLANE
	layer = ABOVE_MOB_LAYER
	var/stage = 1
	var/fixture_type = "tube"
	var/sheets_refunded = 2
	var/obj/machinery/light/newlight = null

/obj/machinery/light_construct/New()
	..()
	if (fixture_type == "bulb")
		icon_state = "bulb-construct-stage1"
	if (fixture_type == "flamp")
		icon_state = "flamp-construct-stage1"

/obj/machinery/light_construct/examine(mob/user)
	if(!..(user, 2))
		return

	switch(src.stage)
		if(1)
			user << "It's an empty frame."
			return
		if(2)
			user << "It's wired."
			return
		if(3)
			user << "The casing is closed."
			return

/obj/machinery/light_construct/attackby(obj/item/weapon/W as obj, mob/user as mob)
	src.add_fingerprint(user)
	if (istype(W, /obj/item/weapon/wrench))
		if (src.stage == 1)
			playsound(src, W.usesound, 75, 1)
			usr << "You begin deconstructing [src]."
			if (!do_after(usr, 30 * W.toolspeed))
				return
			new /obj/item/stack/material/steel( get_turf(src.loc), sheets_refunded )
			user.visible_message("[user.name] deconstructs [src].", \
				"You deconstruct [src].", "You hear a noise.")
			playsound(src.loc, 'sound/items/Deconstruct.ogg', 75, 1)
			qdel(src)
		if (src.stage == 2)
			usr << "You have to remove the wires first."
			return

		if (src.stage == 3)
			usr << "You have to unscrew the case first."
			return

	if(istype(W, /obj/item/weapon/wirecutters))
		if (src.stage != 2) return
		src.stage = 1
		switch(fixture_type)
			if ("tube")
				src.icon_state = "tube-construct-stage1"
			if("bulb")
				src.icon_state = "bulb-construct-stage1"
			if("flamp")
				src.icon_state = "flamp-construct-stage1"
		new /obj/item/stack/cable_coil(get_turf(src.loc), 1, "red")
		user.visible_message("[user.name] removes the wiring from [src].", \
			"You remove the wiring from [src].", "You hear a noise.")
		playsound(src.loc, W.usesound, 50, 1)
		return

	if(istype(W, /obj/item/stack/cable_coil))
		if (src.stage != 1) return
		var/obj/item/stack/cable_coil/coil = W
		if (coil.use(1))
			switch(fixture_type)
				if ("tube")
					src.icon_state = "tube-construct-stage2"
				if("bulb")
					src.icon_state = "bulb-construct-stage2"
				if("flamp")
					src.icon_state = "flamp-construct-stage2"
			src.stage = 2
			user.visible_message("[user.name] adds wires to [src].", \
				"You add wires to [src].")
		return

	if(istype(W, /obj/item/weapon/screwdriver))
		if (src.stage == 2)
			switch(fixture_type)
				if ("tube")
					src.icon_state = "tube-empty"
				if("bulb")
					src.icon_state = "bulb-empty"
				if("flamp")
					src.icon_state = "flamp-empty"
			src.stage = 3
			user.visible_message("[user.name] closes [src]'s casing.", \
				"You close [src]'s casing.", "You hear a noise.")
			playsound(src, W.usesound, 75, 1)

			switch(fixture_type)

				if("tube")
					newlight = new /obj/machinery/light/built(src.loc)
				if ("bulb")
					newlight = new /obj/machinery/light/small/built(src.loc)
				if ("flamp")
					newlight = new /obj/machinery/light/flamp/built(src.loc)

			newlight.dir = src.dir
			src.transfer_fingerprints_to(newlight)
			qdel(src)
			return
	..()

/obj/machinery/light_construct/small
	name = "small light fixture frame"
	desc = "A small light fixture under construction."
	icon = 'icons/obj/lighting.dmi'
	icon_state = "bulb-construct-stage1"
	anchored = 1
	stage = 1
	fixture_type = "bulb"
	sheets_refunded = 1

/obj/machinery/light_construct/flamp
	name = "floor light fixture frame"
	desc = "A floor light fixture under construction."
	icon = 'icons/obj/lighting.dmi'
	icon_state = "flamp-construct-stage1"
	anchored = 0
	plane = OBJ_PLANE
	layer = OBJ_LAYER
	stage = 1
	fixture_type = "flamp"
	sheets_refunded = 2

// the standard tube light fixture
/obj/machinery/light
	name = "light fixture"
	icon = 'icons/obj/lighting_vr.dmi'
	var/base_state = "tube"		// base description and icon_state
	icon_state = "tube1"
	desc = "A lighting fixture."
	anchored = 1
	plane = MOB_PLANE
	layer = ABOVE_MOB_LAYER
	use_power = 2
	idle_power_usage = 2
	active_power_usage = 20 // VOREStation Edit - Keep lights at 20 power
	power_channel = LIGHT //Lights are calc'd via area so they dont need to be in the machine list
	var/on = 0					// 1 if on, 0 if off
	var/brightness_range = 10	// luminosity when on, also used in power calculation //VOREStation Edit - 8->10
	var/brightness_power = 0.8
	var/brightness_color = LIGHT_COLOR_FLUORESCENT_TUBE //VOREStation Edit - Our tubes are whiter
	var/status = LIGHT_OK		// LIGHT_OK, _EMPTY, _BURNED or _BROKEN
	var/flickering = 0
	var/light_type = /obj/item/weapon/light/tube		// the type of light item
	var/fitting = "tube"
	var/switchcount = 0			// count of number of times switched on/off
								// this is used to calc the probability the light burns out

	var/rigged = 0				// true if rigged to explode
	var/needsound = FALSE		// Flag to prevent playing turn-on sound multiple times, and from playing at roundstart
	var/shows_alerts = TRUE		// Flag for if this fixture should show alerts.  Make sure icon states exist!
	var/current_alert = null	// Which alert are we showing right now?

// the smaller bulb light fixture

/obj/machinery/light/small
	icon_state = "bulb1"
	base_state = "bulb"
	fitting = "bulb"
	brightness_range = 5 //VOREStation Edit - 4->5
	brightness_color = LIGHT_COLOR_INCANDESCENT_BULB
	desc = "A small lighting fixture."
	light_type = /obj/item/weapon/light/bulb
	shows_alerts = FALSE

/obj/machinery/light/flamp
	icon = 'icons/obj/lighting.dmi'
	icon_state = "flamp1"
	base_state = "flamp"
	fitting = "bulb"
	brightness_range = 8 //VOREStation Edit - 4->8
	plane = OBJ_PLANE
	layer = OBJ_LAYER
	brightness_color = LIGHT_COLOR_INCANDESCENT_BULB
	desc = "A floor lamp."
	light_type = /obj/item/weapon/light/bulb
	shows_alerts = FALSE
	var/lamp_shade = 1

/obj/machinery/light/small/emergency
	brightness_range = 4
	brightness_color = "#da0205"

/obj/machinery/light/spot
	name = "spotlight"
	fitting = "large tube"
	light_type = /obj/item/weapon/light/tube/large
	shows_alerts = FALSE
	brightness_range = 12
	brightness_power = 0.9

/obj/machinery/light/built/New()
	status = LIGHT_EMPTY
	update(0)
	..()

/obj/machinery/light/small/built/New()
	status = LIGHT_EMPTY
	update(0)
	..()

/obj/machinery/light/flamp/built/New()
	status = LIGHT_EMPTY
	lamp_shade = 0
	update(0)
	..()
//VOREStation Add - Shadeless!
/obj/machinery/light/flamp/noshade/New()
	lamp_shade = 0
	update(0)
	..()
//VOREStation Add End
// create a new lighting fixture
/obj/machinery/light/New()
	..()

	spawn(2)
		on = has_power()

		switch(fitting)
			if("tube")
				if(prob(2))
					broken(1)
			if("bulb")
				if(prob(5))
					broken(1)
		spawn(1)
			update(0)

/obj/machinery/light/Destroy()
	var/area/A = get_area(src)
	if(A)
		on = 0
//		A.update_lights()
	return ..()

/obj/machinery/light/update_icon()

	switch(status)		// set icon_states
		if(LIGHT_OK)
			if(shows_alerts && current_alert && on)
				icon_state = "[base_state]-alert-[current_alert]"
			else
				icon_state = "[base_state][on]"
		if(LIGHT_EMPTY)
			icon_state = "[base_state]-empty"
			on = 0
		if(LIGHT_BURNED)
			icon_state = "[base_state]-burned"
			on = 0
		if(LIGHT_BROKEN)
			icon_state = "[base_state]-broken"
			on = 0
	return

/obj/machinery/light/flamp/update_icon()
	if(lamp_shade)
		base_state = "flampshade"
		switch(status)		// set icon_states
			if(LIGHT_OK)
				icon_state = "[base_state][on]"
			if(LIGHT_EMPTY)
				on = 0
				icon_state = "[base_state][on]"
			if(LIGHT_BURNED)
				on = 0
				icon_state = "[base_state][on]"
			if(LIGHT_BROKEN)
				on = 0
				icon_state = "[base_state][on]"
		return
	else
		base_state = "flamp"
		..()

/obj/machinery/light/proc/set_alert_atmos()
	if(shows_alerts)
		current_alert = "atmos"
		brightness_color = "#6D6DFC"
		if(on)
			update()

/obj/machinery/light/proc/set_alert_fire()
	if(shows_alerts)
		current_alert = "fire"
		brightness_color = "#FF3030"
		if(on)
			update()

/obj/machinery/light/proc/reset_alert()
	if(shows_alerts)
		current_alert = null
		brightness_color = initial(brightness_color) || "" // Workaround for BYOND stupidity. Can't set it to null or it won't clear.
		if(on)
			update()

// update the icon_state and luminosity of the light depending on its state
/obj/machinery/light/proc/update(var/trigger = 1)
	update_icon()
	if(!on)
		needsound = TRUE // Play sound next time we turn on
	else if(needsound)
		playsound(src.loc, 'sound/effects/lighton.ogg', 65, 1)
		needsound = FALSE // Don't play sound again until we've been turned off

	if(on)
		if(light_range != brightness_range || light_power != brightness_power || light_color != brightness_color)
			switchcount++
			if(rigged)
				if(status == LIGHT_OK && trigger)

					log_admin("LOG: Rigged light explosion, last touched by [fingerprintslast]")
					message_admins("LOG: Rigged light explosion, last touched by [fingerprintslast]")

					explode()
			else if( prob( min(60, switchcount*switchcount*0.01) ) )
				if(status == LIGHT_OK && trigger)
					status = LIGHT_BURNED
					update_icon()
					on = 0
					set_light(0)
			else
				use_power = 2
				set_light(brightness_range, brightness_power, brightness_color)
	else
		use_power = 1
		set_light(0)

	active_power_usage = light_range * light_power


/obj/machinery/light/attack_generic(var/mob/user, var/damage)
	if(!damage)
		return
	if(status == LIGHT_EMPTY||status == LIGHT_BROKEN)
		user << "That object is useless to you."
		return
	if(!(status == LIGHT_OK||status == LIGHT_BURNED))
		return
	visible_message("<span class='danger'>[user] smashes the light!</span>")
	user.do_attack_animation(src)
	broken()
	return 1

/obj/machinery/light/blob_act()
	broken()

// attempt to set the light's on/off status
// will not switch on if broken/burned/empty
/obj/machinery/light/proc/seton(var/s)
	on = (s && status == LIGHT_OK)
	update()

// examine verb
/obj/machinery/light/examine(mob/user)
	switch(status)
		if(LIGHT_OK)
			user << "[desc] It is turned [on? "on" : "off"]."
		if(LIGHT_EMPTY)
			user << "[desc] The [fitting] has been removed."
		if(LIGHT_BURNED)
			user << "[desc] The [fitting] is burnt out."
		if(LIGHT_BROKEN)
			user << "[desc] The [fitting] has been smashed."



// attack with item - insert light (if right type), otherwise try to break the light

/obj/machinery/light/attackby(obj/item/W, mob/user)

	//Light replacer code
	if(istype(W, /obj/item/device/lightreplacer))
		var/obj/item/device/lightreplacer/LR = W
		if(isliving(user))
			var/mob/living/U = user
			LR.ReplaceLight(src, U)
			return

	// attempt to insert light
	if(istype(W, /obj/item/weapon/light))
		if(status != LIGHT_EMPTY)
			user << "There is a [fitting] already inserted."
			return
		else
			src.add_fingerprint(user)
			var/obj/item/weapon/light/L = W
			if(istype(L, light_type))
				status = L.status
				user << "You insert the [L.name]."
				switchcount = L.switchcount
				rigged = L.rigged
				brightness_range = L.brightness_range
				brightness_power = L.brightness_power
				brightness_color = L.brightness_color
				on = has_power()
				update()

				user.drop_item()	//drop the item to update overlays and such
				qdel(L)

				if(on && rigged)

					log_admin("LOG: Rigged light explosion, last touched by [fingerprintslast]")
					message_admins("LOG: Rigged light explosion, last touched by [fingerprintslast]")

					explode()
			else
				user << "This type of light requires a [fitting]."
				return

		// attempt to break the light
		//If xenos decide they want to smash a light bulb with a toolbox, who am I to stop them? /N

	else if(status != LIGHT_BROKEN && status != LIGHT_EMPTY)


		if(prob(1+W.force * 5))

			user << "You hit the light, and it smashes!"
			for(var/mob/M in viewers(src))
				if(M == user)
					continue
				M.show_message("[user.name] smashed the light!", 3, "You hear a tinkle of breaking glass", 2)
			if(on && (W.flags & CONDUCT))
				//if(!user.mutations & COLD_RESISTANCE)
				if (prob(12))
					electrocute_mob(user, get_area(src), src, 0.3)
			broken()

		else
			user << "You hit the light!"

	// attempt to stick weapon into light socket
	else if(status == LIGHT_EMPTY)
		if(istype(W, /obj/item/weapon/screwdriver)) //If it's a screwdriver open it.
			playsound(src, W.usesound, 75, 1)
			user.visible_message("[user.name] opens [src]'s casing.", \
				"You open [src]'s casing.", "You hear a noise.")
			var/obj/machinery/light_construct/newlight = null
			switch(fitting)
				if("tube")
					newlight = new /obj/machinery/light_construct(src.loc)
					newlight.icon_state = "tube-construct-stage2"

				if("bulb")
					newlight = new /obj/machinery/light_construct/small(src.loc)
					newlight.icon_state = "bulb-construct-stage2"

				if("flamp")
					newlight = new /obj/machinery/light_construct/flamp(src.loc)
					newlight.icon_state = "flamp-construct-stage2"

			newlight.dir = src.dir
			newlight.stage = 2
			newlight.fingerprints = src.fingerprints
			newlight.fingerprintshidden = src.fingerprintshidden
			newlight.fingerprintslast = src.fingerprintslast
			qdel(src)
			return

		user << "You stick \the [W] into the light socket!"
		if(has_power() && (W.flags & CONDUCT))
			var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
			s.set_up(3, 1, src)
			s.start()
			//if(!user.mutations & COLD_RESISTANCE)
			if (prob(75))
				electrocute_mob(user, get_area(src), src, rand(0.7,1.0))

/obj/machinery/light/flamp/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/weapon/wrench))
		anchored = !anchored
		playsound(src, W.usesound, 50, 1)
		user << "<span class='notice'>You [anchored ? "wrench" : "unwrench"] \the [src].</span>"

	if(!lamp_shade)
		if(istype(W, /obj/item/weapon/lampshade))
			lamp_shade = 1
			qdel(W)
			update_icon()
			return

	else
		if(istype(W, /obj/item/weapon/screwdriver))
			playsound(src, W.usesound, 75, 1)
			user.visible_message("[user.name] removes [src]'s lamp shade.", \
				"You remove [src]'s lamp shade.", "You hear a noise.")
			lamp_shade = 0
			new /obj/item/weapon/lampshade(src.loc)
			update_icon()
			return

	..()

// returns whether this light has power
// true if area has power and lightswitch is on
/obj/machinery/light/proc/has_power()
	var/area/A = get_area(src)
	return A && A.lightswitch && (!A.requires_power || A.power_light)

/obj/machinery/light/flamp/has_power()
	var/area/A = get_area(src)
	if(lamp_shade)
		return A && (!A.requires_power || A.power_light)
	else
		return A && A.lightswitch && (!A.requires_power || A.power_light)

/obj/machinery/light/proc/flicker(var/amount = rand(10, 20))
	if(flickering) return
	flickering = 1
	spawn(0)
		if(on && status == LIGHT_OK)
			for(var/i = 0; i < amount; i++)
				if(status != LIGHT_OK) break
				on = !on
				update(0)
				sleep(rand(5, 15))
			on = (status == LIGHT_OK)
			update(0)
		flickering = 0

// ai attack - make lights flicker, because why not

/obj/machinery/light/attack_ai(mob/user)
	src.flicker(1)
	return

/obj/machinery/light/flamp/attack_ai(mob/user)
	attack_hand()
	return

// attack with hand - remove tube/bulb
// if hands aren't protected and the light is on, burn the player
/obj/machinery/light/attack_hand(mob/user)

	add_fingerprint(user)

	if(status == LIGHT_EMPTY)
		user << "There is no [fitting] in this light."
		return

	if(istype(user,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		if(H.species.can_shred(H))
			user.setClickCooldown(user.get_attack_speed())
			for(var/mob/M in viewers(src))
				M.show_message("<font color='red'>[user.name] smashed the light!</font>", 3, "You hear a tinkle of breaking glass", 2)
			broken()
			return

	// make it burn hands if not wearing fire-insulated gloves
	if(on)
		var/prot = 0
		var/mob/living/carbon/human/H = user

		if(istype(H))
			if(H.species.heat_level_1 > LIGHT_BULB_TEMPERATURE)
				prot = 1
			else if(H.gloves)
				var/obj/item/clothing/gloves/G = H.gloves
				if(G.max_heat_protection_temperature)
					if(G.max_heat_protection_temperature > LIGHT_BULB_TEMPERATURE)
						prot = 1
		else
			prot = 1

		if(prot > 0 || (COLD_RESISTANCE in user.mutations))
			user << "You remove the light [fitting]"
		else if(TK in user.mutations)
			user << "You telekinetically remove the light [fitting]."
		else
			user << "You try to remove the light [fitting], but it's too hot and you don't want to burn your hand."
			return				// if burned, don't remove the light
	else
		user << "You remove the light [fitting]."

	// create a light tube/bulb item and put it in the user's hand
	var/obj/item/weapon/light/L = new light_type()
	L.status = status
	L.rigged = rigged
	L.brightness_range = brightness_range
	L.brightness_power = brightness_power
	L.brightness_color = brightness_color

	// light item inherits the switchcount, then zero it
	L.switchcount = switchcount
	switchcount = 0

	L.update()
	L.add_fingerprint(user)

	user.put_in_active_hand(L)	//puts it in our active hand

	status = LIGHT_EMPTY
	update()

/obj/machinery/light/flamp/attack_hand(mob/user)
	if(lamp_shade)
		if(status == LIGHT_EMPTY)
			user << "There is no [fitting] in this light."
			return

		if(on)
			on = 0
			update()
		else
			on = has_power()
			update()
	else
		..()


/obj/machinery/light/attack_tk(mob/user)
	if(status == LIGHT_EMPTY)
		user << "There is no [fitting] in this light."
		return

	user << "You telekinetically remove the light [fitting]."
	// create a light tube/bulb item and put it in the user's hand
	var/obj/item/weapon/light/L = new light_type()
	L.status = status
	L.rigged = rigged
	L.brightness_range = brightness_range
	L.brightness_power = brightness_power
	L.brightness_color = brightness_color

	// light item inherits the switchcount, then zero it
	L.switchcount = switchcount
	switchcount = 0

	L.update()
	L.add_fingerprint(user)
	L.loc = loc

	status = LIGHT_EMPTY
	update()

// break the light and make sparks if was on

/obj/machinery/light/proc/broken(var/skip_sound_and_sparks = 0)
	if(status == LIGHT_EMPTY)
		return

	if(!skip_sound_and_sparks)
		if(status == LIGHT_OK || status == LIGHT_BURNED)
			playsound(src.loc, 'sound/effects/Glasshit.ogg', 75, 1)
		if(on)
			var/datum/effect/effect/system/spark_spread/s = new /datum/effect/effect/system/spark_spread
			s.set_up(3, 1, src)
			s.start()
	status = LIGHT_BROKEN
	update()

/obj/machinery/light/proc/fix()
	if(status == LIGHT_OK)
		return
	status = LIGHT_OK
	on = 1
	update()

// explosion effect
// destroy the whole light fixture or just shatter it

/obj/machinery/light/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			if (prob(75))
				broken()
		if(3.0)
			if (prob(50))
				broken()
	return

//blob effect


// timed process
// use power

#define LIGHTING_POWER_FACTOR 20		//20W per unit luminosity


/obj/machinery/light/process()
	if(on)
		use_power(light_range * LIGHTING_POWER_FACTOR, LIGHT)


// called when area power state changes
/obj/machinery/light/power_change()
	spawn(10)
		seton(has_power())

// called when on fire

/obj/machinery/light/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if(prob(max(0, exposed_temperature - 673)))   //0% at <400C, 100% at >500C
		broken()

// explode the light

/obj/machinery/light/proc/explode()
	var/turf/T = get_turf(src.loc)
	spawn(0)
		broken()	// break it first to give a warning
		sleep(2)
		explosion(T, 0, 0, 2, 2)
		sleep(1)
		qdel(src)

// the light item
// can be tube or bulb subtypes
// will fit into empty /obj/machinery/light of the corresponding type

/obj/item/weapon/light
	icon = 'icons/obj/lighting.dmi'
	force = 2
	throwforce = 5
	w_class = ITEMSIZE_TINY
	var/status = 0		// LIGHT_OK, LIGHT_BURNED or LIGHT_BROKEN
	var/base_state
	var/switchcount = 0	// number of times switched
	matter = list(DEFAULT_WALL_MATERIAL = 60)
	var/rigged = 0		// true if rigged to explode
	var/brightness_range = 2 //how much light it gives off
	var/brightness_power = 0.8
	var/brightness_color = LIGHT_COLOR_INCANDESCENT_TUBE

/obj/item/weapon/light/tube
	name = "light tube"
	desc = "A replacement light tube."
	icon_state = "ltube"
	base_state = "ltube"
	item_state = "c_tube"
	matter = list("glass" = 100)
	brightness_range = 8

/obj/item/weapon/light/tube/large
	w_class = ITEMSIZE_SMALL
	name = "large light tube"
	brightness_range = 15
	brightness_power = 0.9

/obj/item/weapon/light/bulb
	name = "light bulb"
	desc = "A replacement light bulb."
	icon_state = "lbulb"
	base_state = "lbulb"
	item_state = "contvapour"
	matter = list("glass" = 100)
	brightness_range = 5
	brightness_color = LIGHT_COLOR_INCANDESCENT_BULB

/obj/item/weapon/light/throw_impact(atom/hit_atom)
	..()
	shatter()

/obj/item/weapon/light/bulb/fire
	name = "fire bulb"
	desc = "A replacement fire bulb."
	icon_state = "fbulb"
	base_state = "fbulb"
	item_state = "egg4"
	matter = list("glass" = 100)
	brightness_range = 5

// update the icon state and description of the light

/obj/item/weapon/light/proc/update()
	switch(status)
		if(LIGHT_OK)
			icon_state = base_state
			desc = "A replacement [name]."
		if(LIGHT_BURNED)
			icon_state = "[base_state]-burned"
			desc = "A burnt-out [name]."
		if(LIGHT_BROKEN)
			icon_state = "[base_state]-broken"
			desc = "A broken [name]."


/obj/item/weapon/light/New()
	..()
	switch(name)
		if("light tube")
			brightness_range = rand(6,9)
		if("light bulb")
			brightness_range = rand(4,6)
	update()


// attack bulb/tube with object
// if a syringe, can inject phoron to make it explode
/obj/item/weapon/light/attackby(var/obj/item/I, var/mob/user)
	..()
	if(istype(I, /obj/item/weapon/reagent_containers/syringe))
		var/obj/item/weapon/reagent_containers/syringe/S = I

		user << "You inject the solution into the [src]."

		if(S.reagents.has_reagent("phoron", 5))

			log_admin("LOG: [user.name] ([user.ckey]) injected a light with phoron, rigging it to explode.")
			message_admins("LOG: [user.name] ([user.ckey]) injected a light with phoron, rigging it to explode.")

			rigged = 1

		S.reagents.clear_reagents()
	else
		..()
	return

// called after an attack with a light item
// shatter light, unless it was an attempt to put it in a light socket
// now only shatter if the intent was harm

/obj/item/weapon/light/afterattack(atom/target, mob/user, proximity)
	if(!proximity) return
	if(istype(target, /obj/machinery/light))
		return
	if(user.a_intent != I_HURT)
		return

	shatter()

/obj/item/weapon/light/proc/shatter()
	if(status == LIGHT_OK || status == LIGHT_BURNED)
		src.visible_message("<font color='red'>[name] shatters.</font>","<font color='red'> You hear a small glass object shatter.</font>")
		status = LIGHT_BROKEN
		force = 5
		sharp = 1
		playsound(src.loc, 'sound/effects/Glasshit.ogg', 75, 1)
		update()

//Lamp Shade
/obj/item/weapon/lampshade
	name = "lamp shade"
	desc = "A lamp shade for a lamp."
	icon = 'icons/obj/lighting.dmi'
	icon_state = "lampshade"
	w_class = ITEMSIZE_TINY
