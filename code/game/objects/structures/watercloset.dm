//todo: toothbrushes, and some sort of "toilet-filthinator" for the hos

#define SHOWER_FREEZING "freezing"
#define SHOWER_TEMP_FREEZING T0C
#define SHOWER_NORMAL "normal"
#define SHOWER_TEMP_NORMAL 293
#define SHOWER_BOILING "boiling"
#define SHOWER_TEMP_BOILING T0C + 100

/obj/structure/toilet
	name = "toilet"
	desc = "The HT-451, a torque rotation-based, waste disposal unit for small matter. This one seems remarkably clean."
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "toilet"
	density = FALSE
	anchored = TRUE
	var/open = FALSE			//if the lid is up
	var/cistern = FALSE			//if the cistern bit is open
	var/w_items = 0				//the combined w_class of all the items in the cistern

	/// Used to both track the crystal needed to upgrade the toilet, and to tell if the toilet is teleplumbed. Set to True in subtypes or mapping if you'd like it to be teleplumbed on init.
	var/obj/item/teleplumb_crystal = null
	/// Bin used to upgrade this toilet. Turned into a real object on init.
	var/obj/item/stock_parts/matter_bin/bin	= /obj/item/stock_parts/matter_bin

	//Flushing stuff
	var/panic_mult = 1
	var/refilling = FALSE
	var/mob/living/swirlie = null	//the mob being given a swirlie
	var/atom/teleplumb_dest			//the destination of this toilet if it's teleplumbed

/obj/structure/toilet/Initialize(mapload)
	. = ..()
	open = round(rand(0, 1))
	update_icon()
	AddComponent(/datum/component/hose_connector/endless_drain) // Cannot suck from toilet... for obvious reasons.

	if(ispath(bin))
		bin = new bin(src)

	if(teleplumb_crystal)
		teleplumb_crystal = new /obj/item/bluespace_crystal(src)
		teleplumb_dest = locate(/obj/effect/landmark/teleplumb_exit)
		desc = "The BS-500, a bluespace rift-rotation-based waste disposal unit for small matter. This one seems remarkably clean."

	// Non-bluespace plumbing. For POIs and player construction n' stuff.
	var/obj/structure/disposalpipe/trunk/trunk = locate() in get_turf(src)
	AddComponent(/datum/component/disposal_system_connection, FALSE, FALSE) //Dont show our disposal connection, and we want to handle failed flushes on our own.
	RegisterSignal(src, COMSIG_DISPOSAL_RECEIVE, PROC_REF(toilet_reflux))
	if(trunk)
		SEND_SIGNAL(src, COMSIG_DISPOSAL_LINK, trunk)

/obj/structure/toilet/update_icon()
	icon_state = "[initial(icon_state)][open][cistern]"

/obj/structure/toilet/attack_hand(mob/living/user as mob)
	if(swirlie)
		user.setClickCooldown(user.get_attack_speed())
		user.visible_message(span_danger("[user] slams the toilet seat onto [swirlie.name]'s head!"), span_notice("You slam the toilet seat onto [swirlie.name]'s head!"), "You hear reverberating porcelain.")
		swirlie.adjustBruteLoss(5)
		return

	if(cistern && !open)
		var/list/cistern_loot = list()
		for(var/atom/movable/AM in contents)
			if(AM == bin || AM == teleplumb_crystal)
				continue
			cistern_loot += AM

		if(!length(cistern_loot))
			//You can take the bluespace crystal out if there's nothing else in the cistern.
			if(teleplumb_crystal && ishuman(user)) //Only humans can grief the toilets
				if(tgui_alert(user, "You see a glimmering crystal attached to parts of the toilet's components... Do you want to take it?", "Toilet Crystal", list("Take it!", "Leave it.")) == "Take it!")
					user.put_in_hands(teleplumb_crystal)
					to_chat(user, span_notice("You take \the [teleplumb_crystal]."))
					teleplumb_crystal = null
					teleplumb_dest = null
					desc = initial(desc)
				else
					to_chat(user, span_notice("You decide to leave it."))
			to_chat(user, span_notice("The cistern is empty."))
			return
		var/obj/item/I = pick(cistern_loot)
		if(ishuman(user))
			user.put_in_hands(I)
		else
			I.loc = get_turf(src)
		to_chat(user, span_notice("You find \an [I] in the cistern."))
		w_items -= I.w_class
		return

	open = !open
	update_icon()

/obj/structure/toilet/attack_ai(mob/user as mob)
	if(isrobot(user))
		if(user.client && !user.is_remote_viewing())
			return attack_hand(user)
	else
		return attack_hand(user)

/obj/structure/toilet/attackby(obj/item/I as obj, mob/living/user as mob)
	if(I.has_tool_quality(TOOL_CROWBAR))
		to_chat(user, span_notice("You start to [cistern ? "replace the lid on the cistern" : "lift the lid off the cistern"]."))
		playsound(src, 'sound/effects/stonedoor_openclose.ogg', 50, 1)
		if(do_after(user, 3 SECONDS, target = src))
			user.visible_message(span_notice("[user] [cistern ? "replaces the lid on the cistern" : "lifts the lid off the cistern"]!"), span_notice("You [cistern ? "replace the lid on the cistern" : "lift the lid off the cistern"]!"), "You hear grinding porcelain.")
			cistern = !cistern
			update_icon()
			return

	if(I.has_tool_quality(TOOL_WRENCH) && cistern) //Kill Toilet.
		if(refilling)
			to_chat(user, span_notice("Wait for \the [src] to finish refilling..."))
		to_chat(user, span_notice("You begin to dismantle \the [src]..."))
		if(!do_after(user, 5 SECONDS, src))
			return
		to_chat(user, span_notice("You dismantle \the [src]."))
		deconstruct()
		return

	if(istype(I, /obj/item/grab))
		user.setClickCooldown(user.get_attack_speed(I))
		var/obj/item/grab/G = I

		if(isliving(G.affecting))
			var/mob/living/GM = G.affecting

			if(G.state <= GRAB_PASSIVE)
				to_chat(user, span_notice("You need a tighter grip."))
				return
			if(!GM.loc == get_turf(src))
				to_chat(user, span_notice("[GM.name] needs to be on the toilet."))
				return
			if(open && !swirlie)
				user.visible_message(span_danger("[user] starts to give [GM] a swirlie!"), span_notice("You start to give [GM] a swirlie!"))
				swirlie = GM
				if(do_after(user, 3 SECONDS, target = GM))
					if(!open) //Someone closed it while we were trying to swirlie. Rude.
						open = TRUE //Open it.
						update_icon()
					if(!refilling)
						user.visible_message(span_danger("[user] gives [GM] a swirlie!"), span_notice("You give [GM] a swirlie!"), "You hear a toilet flushing.")
						if(!GM.internal)
							GM.adjustOxyLoss(5)
						if(GM.size_multiplier <= 0.75)
							GM.visible_message(span_danger("[GM] gets sucked into \the [src] due to their small size!"), span_userdanger("You get sucked into \the [src]!"))
							GM.forceMove(get_turf(src))
							GM.Weaken(5)
						flush()
					else
						user.visible_message(span_warning("[user] tries to give [GM.name] a swirlie, but the toilet was still refilling!"), span_warning("You cant give [GM] swirlie while \the [src] is still refilling!"))
				swirlie = null
			else
				user.visible_message(span_danger("[user] slams [GM] into the [src]!"), span_notice("You slam [GM] into the [src]!"))
				GM.adjustBruteLoss(5)

	if(cistern && !teleplumb_crystal && istype(I, /obj/item/bluespace_crystal))
		to_chat(user, span_notice("You begin to insert \the [I] into \the [src]..."))
		if(!do_after(user, 2 SECONDS, src))
			return
		to_chat(user, span_notice("You insert \the [I] into \the [src]. A deep rumble eminates from within it, and a faint blue glow eminates from the bottom of the bowl for a moment."))
		user.drop_item()
		I.forceMove(src)
		teleplumb_crystal = I
		//TODO: add a way to link this to custom destinations.
		teleplumb_dest = locate(/obj/effect/landmark/teleplumb_exit)
		desc = "The BS-500, a bluespace rift-rotation-based waste disposal unit for small matter. This one seems remarkably clean."
		return

	if(cistern && istype(I, /obj/item/stock_parts/matter_bin))
		to_chat(user, span_notice("You begin to replace \the [bin] in \the [src] with \the [I]."))
		if(!do_after(user, 2 SECONDS, src))
			return
		to_chat(user, span_notice("You replace \the [bin] with \the [I]."))
		bin.forceMove(src.loc) //Remove the old bin.
		user.drop_item()
		I.forceMove(src)
		bin = I //Set the internally stored bin to the new bin.
		return

	if(cistern && !istype(user,/mob/living/silicon/robot)) //STOP PUTTING YOUR MODULES IN THE TOILET.
		if(I.w_class > ITEMSIZE_NORMAL) //3
			to_chat(user, span_notice("\The [I] does not fit."))
			return
		if(w_items + I.w_class > ITEMSIZE_COST_TINY * 5) // 5 tiny or 2 small and 1 tiny
			to_chat(user, span_notice("The cistern is full."))
			return
		user.drop_item()
		I.loc = src
		w_items += I.w_class
		to_chat(user, "You carefully place \the [I] into the cistern.")
		return

/obj/structure/toilet/click_alt(mob/user)
	if(!isliving(user) || get_dist(user, src) > 1 || user.loc == src )
		return
	if(user.stat) //replace with user.canUseTopic() in the future
		return CLICK_ACTION_BLOCKING
	if(user.a_intent == I_HURT)
		panic_mult++
	if(!open)
		to_chat(user, span_notice("You need to open the lid before flushing \the [src]."))
		return CLICK_ACTION_BLOCKING
	if(refilling)
		to_chat(user, span_notice("The toilet is still refilling its tank."))
		playsound(src, 'sound/machines/door_locked.ogg', 30, 1)
		return CLICK_ACTION_BLOCKING
	//Flush succeeds
	user.visible_message(span_notice("[user] flushes the toilet."), span_notice("You flush the toilet."), "you hear a toilet flushing.")
	flush()
	return CLICK_ACTION_SUCCESS

/obj/structure/toilet/proc/flush()
	refilling = TRUE
	playsound(src, 'sound/vore/death7.ogg', 50, 1) //Got lazy about getting new sound files. Have a sick remix lmao.
	playsound(src, 'sound/effects/bubbles.ogg', 50, 1)
	playsound(src, 'sound/mecha/powerup.ogg', 30, 1)

	var/list/bowl_contents = list()
	for(var/obj/item/I in loc.contents)
		if(istype(I) && !I.anchored)
			bowl_contents += I
	for(var/mob/living/L in loc.contents)
		if(L.buckled || !(L.resting || L.lying))
			continue
		var/bin_bonus = 0.15
		if(bin)
			bin_bonus *= bin.rating
		if(L.size_multiplier <= 0.6 + bin_bonus)
			bowl_contents += L

	if(!length(bowl_contents)) //Reduced recharge if nothing is being flushed
		VARSET_IN(src, refilling, FALSE, 7.5 SECONDS)
		return

	var/bowl_conga = 0
	for(var/atom/movable/F in bowl_contents)
		if(QDELETED(F))
			continue

		if(bowl_conga < 150)
			bowl_conga += 2

		spawn(3 + bowl_conga)
			F.SpinAnimation(5,3)
			spawn(15)
				if(F.loc == loc)
					F.forceMove(src)
	addtimer(CALLBACK(src, PROC_REF(flush_send), bowl_contents), 15 SECONDS)
	VARSET_IN(src, refilling, FALSE, 20 SECONDS)
	return

/obj/structure/toilet/proc/flush_send(list/to_send)
	var/flush_weight = 0
	var/max_flush_weight = get_flush_power()
	var/list/taken_contents = list()
	for(var/atom/movable/flushed in to_send)
		if(flushed.loc != src)
			continue

		//Mobs and items are calculated differently
		var/weight_value = 0
		if(isitem(flushed))
			var/obj/item/I = flushed
			weight_value = I.w_class
		if(isliving(flushed))
			var/mob/living/L = flushed
			weight_value = L.size_multiplier * 10

		if(flush_weight + weight_value <= max_flush_weight)
			taken_contents += flushed
			flush_weight += weight_value
			if(teleplumb_crystal && teleplumb_dest)
				if(isliving(flushed))
					var/mob/living/m = flushed
					to_chat(m, span_danger("You're glunked down by \the [src] through a series of extradimensional bluespace pipeworks!"))
				flushed.forceMove(teleplumb_dest)

	var/datum/gas_mixture/air_contents = new(1) //1 liter of nothing, ig.
	if(SEND_SIGNAL(src, COMSIG_DISPOSAL_FLUSH, to_send, air_contents))
		for(var/atom/movable/flushed in to_send)
			if(isliving(flushed))
				var/mob/living/m = flushed
				to_chat(m, span_warning("You're flushed away by \the [src]!"))

	var/flush_failed = FALSE
	for(var/atom/movable/flushed in to_send)
		if(flushed.loc != src) //Not in here, flushed or otherwise.
			continue
		flush_failed = TRUE
		flushed.forceMove(src.loc)
	if(flush_failed)
		visible_message(span_warning("\The [src] glurks and splutters, unable to guzzle more stuff down in a single flush!"), span_warning("Glornch"))
	panic_mult = 0

/obj/structure/toilet/proc/toilet_reflux(datum/source, list/received_items, datum/gas_mixture/gas)
	SIGNAL_HANDLER
	var/turf/T = get_turf(src)
	T.assume_air(gas)

	if(!length(received_items))
		visible_message(span_warning("The water in \the [src] gurgles and bubbles ominously..."), span_notice("You hear a wet gurgling and spluttering..."), runemessage = "glurgles")
		return
	visible_message(span_danger("\The [src] gurgles for a moment, before spewing forth a bunch of stuff in a wave of toilet water!"), "GLORGLONCH!")
	for(var/atom/movable/AM in received_items)
		var/turf/target_turf = get_offset_target_turf(loc, rand(-2, 2), rand(-2, 2))

		AM.forceMove(T)
		AM.pipe_eject(0)
		AM.throw_at(target_turf, 5, 1)

	//Toilet blast !
	for(var/direction in GLOB.alldirs + null) // null is for the center tile.
		if(prob(75) && direction != null) //Only sometimes wet blast, except the center tile. That always wets.
			continue
		var/turf/target_turf = get_ranged_target_turf(src, direction, rand(1, 2))
		if(!target_turf) // This shouldn't fail but...
			continue
		var/obj/effect/effect/water/W = new(get_turf(T))
		W.create_reagents(15)
		W.reagents.add_reagent(REAGENT_ID_WATER, 15)
		W.set_color()
		W.set_up(target_turf)

/obj/structure/toilet/proc/deconstruct()
	place_deconstruction_materials()
	for(var/atom/movable/AM in contents) //Should handle both cistern and upgrade parts.
		AM.forceMove(src.loc)
	qdel(src)
	return

/obj/structure/toilet/proc/place_deconstruction_materials()
	new /obj/item/stack/material/steel(src.loc, 5)
	new /obj/item/reagent_containers/glass/bucket(src.loc)

/obj/structure/toilet/proc/get_flush_power()
	. = ITEMSIZE_COST_SMALL * 3 // 3 small items, or 6 tiny items.
	if(bin)
		. *= bin.rating
	. *= panic_mult
	if(teleplumb_crystal) //Teleplumbed gets applied at the end
		. *= 2

/obj/structure/toilet/teleplumbed
	teleplumb_crystal = TRUE

/obj/structure/toilet/prison
	name = "prison toilet"
	desc = "The HT-421, a torque rotation based waste disposal unit for small matter. This older model isnt quite as capable as newer units."
	icon_state = "toilet2"

/obj/structure/toilet/prison/place_deconstruction_materials()
	new /obj/item/stack/material/iron(src.loc, 5)
	new /obj/item/reagent_containers/glass/bucket(src.loc)

/obj/structure/toilet/prison/get_flush_power()
	. = ..()
	if(teleplumb_crystal) //No teleplumb bonus.
		. /= 2
	return round(. / 3) //Has a 1/3 the power of a normal toilet.

/obj/structure/toilet/prison/flush_send(list/to_send) //Permabrig escape prevention
	for(var/mob/living/escapee in to_send)
		to_chat(escapee, span_warning("A grate at the bottom of \the [src] prevents you from being flushed away!")) //Kinda gross, come to think of it.
		escapee.forceMove(src.loc)
		to_send -= escapee
	. = ..()

/obj/structure/urinal
	name = "urinal"
	desc = "The HU-452, an experimental urinal."
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "urinal"
	density = FALSE
	anchored = TRUE

/obj/structure/urinal/attackby(obj/item/I as obj, mob/user as mob)
	if(istype(I, /obj/item/grab))
		var/obj/item/grab/G = I
		if(isliving(G.affecting))
			var/mob/living/GM = G.affecting
			if(G.state>1)
				if(!GM.loc == get_turf(src))
					to_chat(user, span_notice("[GM.name] needs to be on the urinal."))
					return
				user.visible_message(span_danger("[user] slams [GM.name] into the [src]!"), span_notice("You slam [GM.name] into the [src]!"))
				GM.adjustBruteLoss(8)
			else
				to_chat(user, span_notice("You need a tighter grip."))



/obj/machinery/shower
	name = "shower"
	desc = "The HS-451. Installed in the 2250s by the Hygiene Division."
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "shower"
	density = FALSE
	anchored = TRUE
	use_power = USE_POWER_OFF
	var/on = 0
	var/current_temperature = SHOWER_NORMAL		//SHOWER_FREEZING, SHOWER_NORMAL, or SHOWER_BOILING
	var/datum/looping_sound/showering/soundloop
	var/reagent_id = REAGENT_ID_WATER
	var/reaction_volume = 200

/obj/machinery/shower/Initialize(mapload)
	. = ..()
	create_reagents(reaction_volume)
	reagents.add_reagent(reagent_id, reaction_volume)
	soundloop = new(list(src), FALSE)

/obj/machinery/shower/Destroy()
	QDEL_NULL(soundloop)
	QDEL_NULL(reagents)
	STOP_MACHINE_PROCESSING(src)
	return ..()

//add heat controls? when emagged, you can freeze to death in it?

/obj/machinery/shower/attack_hand(mob/M as mob)
	on = !on
	update_icon()
	handle_mist()
	add_fingerprint(M)
	if(on)
		START_MACHINE_PROCESSING(src)
		process()
		soundloop.start()
	else
		soundloop.stop()

/obj/machinery/shower/attackby(obj/item/I as obj, mob/user as mob)
	if(istype(I, /obj/item/analyzer)) //Lol? Why...
		to_chat(user, span_notice("The water temperature seems to be [current_temperature]."))

/obj/machinery/shower/allow_pai_interaction(mob/living/silicon/pai/user, proximity_flag)
	return proximity_flag

/obj/machinery/shower/click_alt(mob/user)
	..()
	var/list/temperature_settings = list(SHOWER_NORMAL, SHOWER_BOILING, SHOWER_FREEZING)
	var/newtemp = tgui_input_list(user, "What setting would you like to set the temperature valve to?", "Water Temperature Valve", temperature_settings)
	to_chat(user, span_notice("You begin to adjust the temperature..."))
	if(do_after(user, 5 SECONDS, src))
		current_temperature = newtemp
		user.visible_message(span_notice("[user] adjusts the shower."), span_notice("You adjust the shower to [current_temperature] temperature."))
		add_fingerprint(user)
	handle_mist()

/obj/machinery/shower/examine(mob/user)
	. = ..()
	. += span_notice("You can <b>alt-click</b> to change the temperature.")

/obj/machinery/shower/update_icon()
	cut_overlays()
	if(on)
		if(reagent_id == REAGENT_ID_WATER)
			add_overlay(image('icons/obj/watercloset.dmi', src, "water", MOB_LAYER + 1, dir))
		else
			var/mutable_appearance/colorful_shower = image('icons/obj/watercloset.dmi', src, "water", MOB_LAYER + 1, dir)
			colorful_shower.color = reagents.get_color() //Whatever the fuck happens to be spewing out of here.
			add_overlay(colorful_shower)

/obj/machinery/shower/proc/handle_mist()
	// If there is no mist, and the shower was turned on (on a non-freezing temp): make mist in 5 seconds
	// If there was already mist, and the shower was turned off (or made cold): remove the existing mist in 25 sec
	var/obj/effect/mist/mist = locate() in loc
	if(!mist && on && current_temperature != SHOWER_FREEZING)
		addtimer(CALLBACK(src, PROC_REF(make_mist)), 5 SECONDS, TIMER_DELETE_ME)

	if(mist && (!on || current_temperature == SHOWER_FREEZING))
		addtimer(CALLBACK(src, PROC_REF(clear_mist)), 25 SECONDS, TIMER_DELETE_ME)

/obj/machinery/shower/proc/make_mist()
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_OVERRIDE(TRUE)
	var/obj/effect/mist/mist = locate() in loc
	if(!mist && on && current_temperature != SHOWER_FREEZING)
		new /obj/effect/mist(loc)

/obj/machinery/shower/proc/clear_mist()
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_OVERRIDE(TRUE)
	var/obj/effect/mist/mist = locate() in loc
	if(mist && (!on || current_temperature == SHOWER_FREEZING))
		qdel(mist)


/obj/machinery/shower/Crossed(atom/movable/AM)
	..()
	if(on)
		wash_atom(AM)

//Yes, showers are super powerful as far as washing goes.
/obj/machinery/shower/proc/wash_atom(atom/A)
	A.wash(CLEAN_RAD | CLEAN_TYPE_WEAK) // Clean radiation non-instantly
	A.wash(CLEAN_WASH)
	A.wash(CLEAN_SCRUB)
	reagents.splash(A, reaction_volume / 20, 1, TRUE, min_spill = 0, max_spill = 0) //Reaction volume needs to be divided by 20 due to a larger internal volume

	if(!isliving(A))
		return
	var/mob/living/L = A
	check_heat(L)
	L.extinguish_mob()
	L.adjust_fire_stacks(-20) //Douse ourselves with water to avoid fire more easily
	L.radiation = CLAMP(L.radiation - 5, 0, RADIATION_CAP)

	if(!iscarbon(A))
		return
	//flush away reagents on the skin
	var/mob/living/carbon/C = A
	if(C.touching)
		var/remove_amount = C.touching.maximum_volume * C.reagent_permeability() //take off your suit first
		C.touching.remove_any(remove_amount)

/obj/machinery/shower/process()
	if(on)
		if(isturf(loc)) //Wash the turf.
			wash_atom(loc)
		for(var/AM in loc) //Wash everything in the same loc (technically doesnt need to be a turf.)
			wash_atom(AM)
	else
		return PROCESS_KILL

/obj/machinery/shower/proc/check_heat(mob/living/L)
	var/list/temperature_settings = list(SHOWER_FREEZING = SHOWER_TEMP_FREEZING, SHOWER_NORMAL = SHOWER_TEMP_NORMAL, SHOWER_BOILING = SHOWER_TEMP_BOILING)
	var/temperature = temperature_settings[current_temperature]
	switch(current_temperature)
		if(SHOWER_FREEZING)
			/* // We dont have adjust_bodytemperature()
			if(iscarbon(L))
				L.adjust_bodytemperature(-80, temperature)
			*/
			L.bodytemperature = max(L.bodytemperature - 80, temperature)
			if(ishuman(L))
				var/mob/living/carbon/human/H = L
				if(temperature <= H.species.cold_level_1)
					to_chat(L, span_warning("The water is freezing cold!"))
			else
				to_chat(L, span_warning("The water is freezing cold!"))
		if(SHOWER_BOILING)
			/* // We dont have adjust_bodytemperature()
			if(iscarbon(L))
				L.adjust_bodytemperature(35, 0, temperature)
			*/
			L.bodytemperature = min(L.bodytemperature + 35, temperature)
			if(ishuman(L))
				var/mob/living/carbon/human/H = L
				if(temperature >= H.species.heat_level_1)
					to_chat(L, span_danger("The water is searing hot!"))
					L.adjustFireLoss(5)
			else //Sorry, simplemobs just get Burnt
				to_chat(L, span_danger("The water is searing hot!"))
				L.adjustFireLoss(5)
		else
			if(L.bodytemperature < 288) // 15C
				L.bodytemperature = min(L.bodytemperature + 10, SHOWER_TEMP_NORMAL)
				//L.adjust_bodytemperature(10)
			if(L.bodytemperature > 298) // 25C
				L.bodytemperature = max(L.bodytemperature - 10, SHOWER_TEMP_NORMAL)
				//L.adjust_bodytemperature(-10)

/obj/effect/mist
	name = "mist"
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "mist"
	plane = MOB_PLANE
	layer = ABOVE_MOB_LAYER
	anchored = TRUE
	mouse_opacity = 0

////////////////////////RUBBER DUCKIES//////////////////////////////

/obj/item/bikehorn/rubberducky
	name = "rubber ducky"
	desc = "Rubber ducky you're so fine, you make bathtime lots of fuuun. Rubber ducky I'm awfully fooooond of yooooouuuu~"	//thanks doohl
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "rubberducky"
	item_state = "rubberducky"
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand.dmi',
	)
	honk_sound = 'sound/voice/quack.ogg'

//Admin spawn duckies

/obj/item/bikehorn/rubberducky/red
	name = "rubber ducky"
	desc = "From the depths of hell it arose, feathers glistening with crimson, a honk that struck fear into all men."	//thanks doohl
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "rubberducky_red"
	item_state = "rubberducky_red"
	honk_sound = 'sound/effects/adminhelp.ogg'
	var/honk_count = 0
	special_handling = TRUE

/obj/item/bikehorn/rubberducky/red/attack_self(mob/user)
	. = ..(user)
	if(.)
		return TRUE
	if(honk_count >= 3)
		var/turf/epicenter = get_turf(src)
		explosion(epicenter, 0, 0, 1, 3)
		qdel(src)
		return
	else if(cooldown <= world.time)
		cooldown = (world.time + 2 SECONDS)
		playsound(src, honk_sound, 50, 1)
		add_fingerprint(user)
		if(honk_text)
			audible_message(span_maroon("[honk_text]"))
		honk_count++
	return

/obj/item/bikehorn/rubberducky/blue
	name = "rubber ducky"
	desc = "The see me rollin', they hatin'."	//thanks doohl
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "rubberducky_blue"
	item_state = "rubberducky_blue"
	honk_sound = 'sound/effects/bubbles.ogg'
	special_handling = TRUE

/obj/item/bikehorn/rubberducky/blue/attack_self(mob/user)
	. = ..(user)
	if(.)
		return TRUE
	if(cooldown <= world.time)
		cooldown = (world.time + 2 SECONDS)
		playsound(src, honk_sound, 50, 1)
		add_fingerprint(user)
		if(honk_text)
			audible_message(span_maroon("[honk_text]"))
		var/turf/simulated/whereweare = get_turf(src)
		whereweare.wet_floor(2)
	return

/obj/item/bikehorn/rubberducky/pink
	name = "rubber ducky"
	desc = "It's extra squishy!"
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "rubberducky_pink"
	item_state = "rubberducky_pink"
	honk_sound = 'sound/vore/sunesound/pred/insertion_01.ogg'
	special_handling = TRUE

/obj/item/bikehorn/rubberducky/pink/attack_self(mob/user)
	. = ..(user)
	if(.)
		return TRUE
	if(cooldown <= world.time)
		if(!user.devourable)
			to_chat(user, span_vnotice("You can't bring yourself to squeeze it..."))
			return
		cooldown = (world.time + 2 SECONDS)
		playsound(src, honk_sound, 50, 1)
		add_fingerprint(user)
		if(honk_text)
			audible_message(span_maroon("[honk_text]"))
		user.drop_item()
		user.forceMove(src)
		to_chat(user, span_vnotice("You have been swallowed alive by the rubber ducky. Your entire body compacted up and squeezed into the tiny space that makes up the oddly realistic and not at all rubbery stomach. The walls themselves are kneading over you, grinding some sort of fluids into your trapped body. You can even hear the sound of bodily functions echoing around you..."))

/obj/item/bikehorn/rubberducky/pink/container_resist(var/mob/living/escapee)
	if(isdisposalpacket(loc))
		escapee.forceMove(loc)
	else
		escapee.forceMove(get_turf(src))
	to_chat(escapee, span_vnotice("You managed to crawl out of the rubber ducky!"))

/obj/item/bikehorn/rubberducky/grey
	name = "rubber ducky"
	desc = "There's something otherworldly about this particular duck..."
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "rubberducky_grey"
	item_state = "rubberducky_grey"
	honk_sound = 'sound/effects/ghost.ogg'
	special_handling = TRUE

/obj/item/bikehorn/rubberducky/grey/attack_self(mob/user)
	. = ..(user)
	if(.)
		return TRUE
	if(cooldown <= world.time)
		cooldown = (world.time + 2 SECONDS)
		playsound(src, honk_sound, 50, 1)
		add_fingerprint(user)
		if(honk_text)
			audible_message(span_maroon("[honk_text]"))
		for(var/obj/machinery/light/L in GLOB.machines)
			if(L.z != user.z || get_dist(user,L) > 10)
				continue
			else
				L.flicker(10)
		user.drop_item()
		var/turf/T = locate(rand(1, 140), rand(1, 140), user.z)
		forceMove(T)
	return

/obj/item/bikehorn/rubberducky/green
	name = "rubber ducky"
	desc = "Like a true Nature’s child, we were born, born to be wild."
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "rubberducky_green"
	item_state = "rubberducky_green"
	honk_sound = 'sound/arcade/mana.ogg'
	var/list/flora = list(/obj/structure/flora/ausbushes,
						/obj/structure/flora/ausbushes/reedbush,
						/obj/structure/flora/ausbushes/leafybush,
						/obj/structure/flora/ausbushes/palebush,
						/obj/structure/flora/ausbushes/stalkybush,
						/obj/structure/flora/ausbushes/grassybush,
						/obj/structure/flora/ausbushes/fernybush,
						/obj/structure/flora/ausbushes/sunnybush,
						/obj/structure/flora/ausbushes/genericbush,
						/obj/structure/flora/ausbushes/pointybush,
						/obj/structure/flora/ausbushes/lavendergrass,
						/obj/structure/flora/ausbushes/ywflowers,
						/obj/structure/flora/ausbushes/brflowers,
						/obj/structure/flora/ausbushes/ppflowers,
						/obj/structure/flora/ausbushes/sparsegrass,
						/obj/structure/flora/ausbushes/fullgrass)
	special_handling = TRUE

/obj/item/bikehorn/rubberducky/green/attack_self(mob/user)
	. = ..(user)
	if(.)
		return TRUE
	if(cooldown <= world.time)
		cooldown = (world.time + 2 SECONDS)
		playsound(src, honk_sound, 50, 1)
		add_fingerprint(user)
		if(honk_text)
			audible_message(span_maroon("[honk_text]"))
		var/turf/simulated/whereweare = get_turf(src)
		var/obj/P = pick(flora)
		new P(whereweare)
	return

/obj/item/bikehorn/rubberducky/white
	name = "rubber ducky"
	desc = "It's so full of energy, such a happy little guy, I just wanna give him a squeeze."	//thanks doohl
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "rubberducky_white"
	item_state = "rubberducky_white"
	honk_sound = 'sound/effects/lightningshock.ogg'
	special_handling = TRUE

/obj/item/bikehorn/rubberducky/white/attack_self(mob/user)
	. = ..(user)
	if(.)
		return TRUE
	if(cooldown <= world.time)
		cooldown = (world.time + 2 SECONDS)
		playsound(src, honk_sound, 50, 1)
		add_fingerprint(user)
		if(honk_text)
			audible_message(span_maroon("[honk_text]"))
		lightning_strike(get_turf(src), 1)
		qdel(src)
	return

/obj/item/grenade/anti_photon/rubberducky/black
	desc = "Good work NanoTrasen Employee, you struck fear within the Syndicate."
	name = "rubber ducky"
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "rubberducky_black"
	item_state = "rubberducky_black"
	light_sound = 'sound/voice/quack.ogg'
	blast_sound = 'sound/voice/quack.ogg'

/obj/item/bikehorn/rubberducky/gold
	name = "rubber ducky"
	desc = "You could give your very life for this duck."
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "rubberducky_gold"
	item_state = "rubberducky_gold"
	honk_sound = 'sound/voice/quack_reverb.ogg'
	special_handling = TRUE

/obj/item/bikehorn/rubberducky/gold/attack_self(mob/user)
	. = ..(user)
	if(.)
		return TRUE
	if(cooldown <= world.time)
		cooldown = (world.time + 2 SECONDS)
		playsound(src, honk_sound, 50, 1)
		add_fingerprint(user)
		if(honk_text)
			audible_message(span_maroon("[honk_text]"))
		if(isliving(user))
			var/mob/living/U = user
			U.dust()
		user.drop_item()
		qdel(src)
	return

/obj/item/bikehorn/rubberducky/viking
	name = "rubber ducky"
	desc = "Honking is a duckie exclusive power."
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "rubberducky_viking"
	item_state = "rubberducky_viking"
	honk_sound = 'sound/voice/scream_jelly_m1.ogg'
	honk_text = "DUK ROH DAH!"
	special_handling = TRUE

/obj/item/bikehorn/rubberducky/viking/attack_self(mob/user)
	. = ..(user)
	if(.)
		return TRUE
	if(cooldown <= world.time)
		cooldown = (world.time + 2 SECONDS)
		playsound(src, honk_sound, 50, 1)
		add_fingerprint(user)
		if(honk_text)
			audible_message(span_maroon("[honk_text]"))
		user.drop_item()
		user.throw_at_random(FALSE,9,2)
	return

/obj/item/bikehorn/rubberducky/galaxy
	name = "rubber ducky"
	desc = "In the vastness of space all things center around thing, somewhere, a core."
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "rubberducky_galaxy"
	item_state = "rubberducky_galaxy"
	honk_sound = 'sound/effects/teleport.ogg'
	special_handling = TRUE

/obj/item/bikehorn/rubberducky/galaxy/attack_self(mob/user)
	. = ..(user)
	if(.)
		return TRUE
	if(cooldown <= world.time)
		cooldown = (world.time + 2 SECONDS)
		playsound(src, honk_sound, 50, 1)
		add_fingerprint(user)
		if(honk_text)
			audible_message(span_maroon("[honk_text]"))
		var/list/possible_orbiters = list()
		for(var/obj/item/I in oview(7,user))
			possible_orbiters += I
		for(var/mob/living/M in oview(7,user))
			possible_orbiters += M
		var/atom/movable/selected_orbiter = pick(possible_orbiters)
		selected_orbiter.orbit(user,32,TRUE,20,36)
	return

//////////////////////////////SINKS//////////////////////////////

/obj/structure/sink
	name = "sink"
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "sink"
	desc = "A sink used for washing one's hands and face."
	anchored = TRUE
	var/busy = 0 	//Something's being washed at the moment

/obj/structure/sink/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/hose_connector/endless_source/water)
	AddComponent(/datum/component/hose_connector/endless_drain)

/obj/structure/sink/MouseDrop_T(var/obj/item/thing, var/mob/user)
	..()
	if(!istype(thing) || !thing.is_open_container())
		return ..()
	if(!user.Adjacent(src))
		return ..()
	if(!thing.reagents || thing.reagents.total_volume == 0)
		to_chat(user, span_warning("\The [thing] is empty."))
		return
	// Clear the vessel.
	visible_message(span_infoplain(span_bold("\The [user]") + " tips the contents of \the [thing] into \the [src]."))
	thing.reagents.clear_reagents()
	thing.update_icon()

/obj/structure/sink/attack_hand(mob/user as mob)
	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		var/obj/item/organ/external/temp = H.organs_by_name[BP_R_HAND]
		if (H.hand)
			temp = H.organs_by_name[BP_L_HAND]
		if(temp && !temp.is_usable())
			to_chat(user, span_notice("You try to move your [temp.name], but cannot!"))
			return

	if(isrobot(user) || isAI(user))
		return

	if(!Adjacent(user))
		return

	if(busy)
		to_chat(user, span_warning("Someone's already washing here."))
		return

	to_chat(user, span_notice("You start washing your hands."))
	playsound(src, 'sound/effects/sink_long.ogg', 75, 1)

	busy = 1
	if(!do_after(user, 4 SECONDS, target = src))
		busy = 0
		to_chat(user, span_notice("You stop washing your hands."))
		return
	busy = 0

	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.gloves)
			H.gloves.wash(CLEAN_SCRUB)
			H.update_inv_gloves()
			H.gloves.germ_level = 0
		else
			if(H.r_hand)
				H.r_hand.wash(CLEAN_SCRUB)
			if(H.l_hand)
				H.l_hand.wash(CLEAN_SCRUB)
			H.bloody_hands = 0
			H.germ_level = 0
			H.hand_blood_color = null
			H.forensic_data?.wash(CLEAN_SCRUB)
		H.update_bloodied()
	else
		user.wash(CLEAN_SCRUB)
	for(var/mob/V in viewers(src, null))
		V.show_message(span_notice("[user] washes their hands using \the [src]."))

/obj/structure/sink/attackby(obj/item/O as obj, mob/user as mob)
	if(busy)
		to_chat(user, span_warning("Someone's already washing here."))
		return

	var/obj/item/reagent_containers/RG = O
	if (istype(RG) && RG.is_open_container())
		RG.reagents.add_reagent(REAGENT_ID_WATER, min(RG.volume - RG.reagents.total_volume, RG.amount_per_transfer_from_this))
		user.visible_message(span_notice("[user] fills \the [RG] using \the [src]."),span_notice("You fill \the [RG] using \the [src]."))
		playsound(src, 'sound/effects/sink.ogg', 75, 1)
		return 1

	else if (istype(O, /obj/item/melee/baton))
		var/obj/item/melee/baton/B = O
		if(B.bcell)
			if(B.bcell.charge > 0 && B.status == 1)
				flick("baton_active", src)
				user.Stun(10)
				user.stuttering = 10
				user.Weaken(10)
				if(isrobot(user))
					var/mob/living/silicon/robot/R = user
					R.cell.charge -= 20
				else
					B.deductcharge(B.hitcost)
				user.visible_message( \
					span_danger("[user] was stunned by [user.p_their()] wet [O]!"), \
					span_userdanger("[user] was stunned by [user.p_their()] wet [O]!"))
				return 1
	else if(istype(O, /obj/item/mop))
		O.reagents.add_reagent(REAGENT_ID_WATER, 5)
		to_chat(user, span_notice("You wet \the [O] in \the [src]."))
		playsound(src, 'sound/effects/slosh.ogg', 25, 1)
		return
	else if(istype(O, /obj/item/soap))
		var/obj/item/soap/soap = O
		to_chat(user, span_notice("You wet \the [O] in \the [src]"))
		soap.wet()
		O.wash(CLEAN_SCRUB)
		return

	var/turf/location = user.loc
	if(!isturf(location)) return

	var/obj/item/I = O
	if(!I || !istype(I,/obj/item)) return

	to_chat(user, span_notice("You start washing \the [I]."))

	busy = 1
	if(!do_after(user, 4 SECONDS, target = src))
		busy = 0
		to_chat(user, span_notice("You stop washing \the [I]."))
		return
	busy = 0

	O.wash(CLEAN_SCRUB)
	O.water_act(rand(1,10))
	user.visible_message( \
		span_notice("[user] washes \a [I] using \the [src]."), \
		span_notice("You wash \a [I] using \the [src]."))

/obj/structure/sink/kitchen
	name = "kitchen sink"
	icon_state = "sink2"

/obj/structure/sink/countertop
	name = "countertop sink"
	icon_state = "sink3"

/obj/structure/sink/puddle	//splishy splashy ^_^
	name = "puddle"
	icon_state = "puddle"
	desc = "A small pool of some liquid, ostensibly water."

/obj/structure/sink/puddle/attack_hand(mob/M as mob)
	icon_state = "puddle-splash"
	..()
	icon_state = "puddle"

/obj/structure/sink/puddle/attackby(obj/item/O as obj, mob/user as mob)
	icon_state = "puddle-splash"
	..()
	icon_state = "puddle"

#undef SHOWER_FREEZING
#undef SHOWER_TEMP_FREEZING
#undef SHOWER_NORMAL
#undef SHOWER_TEMP_NORMAL
#undef SHOWER_BOILING
#undef SHOWER_TEMP_BOILING
