//todo: toothbrushes, and some sort of "toilet-filthinator" for the hos

/obj/structure/toilet
	name = "toilet"
	desc = "The HT-451, a torque rotation-based, waste disposal unit for small matter. This one seems remarkably clean."
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "toilet"
	density = FALSE
	anchored = TRUE
	var/open = 0			//if the lid is up
	var/cistern = 0			//if the cistern bit is open
	var/w_items = 0			//the combined w_class of all the items in the cistern
	var/mob/living/swirlie = null	//the mob being given a swirlie

/obj/structure/toilet/New()
	open = round(rand(0, 1))
	update_icon()

/obj/structure/toilet/attack_hand(mob/living/user as mob)
	if(swirlie)
		usr.setClickCooldown(user.get_attack_speed())
		usr.visible_message("<span class='danger'>[user] slams the toilet seat onto [swirlie.name]'s head!</span>", "<span class='notice'>You slam the toilet seat onto [swirlie.name]'s head!</span>", "You hear reverberating porcelain.")
		swirlie.adjustBruteLoss(5)
		return

	if(cistern && !open)
		if(!contents.len)
			to_chat(user, "<span class='notice'>The cistern is empty.</span>")
			return
		else
			var/obj/item/I = pick(contents)
			if(ishuman(user))
				user.put_in_hands(I)
			else
				I.loc = get_turf(src)
			to_chat(user, "<span class='notice'>You find \an [I] in the cistern.</span>")
			w_items -= I.w_class
			return

	open = !open
	update_icon()

/obj/structure/toilet/update_icon()
	icon_state = "[initial(icon_state)][open][cistern]"

/obj/structure/toilet/attackby(obj/item/I as obj, mob/living/user as mob)
	if(I.has_tool_quality(TOOL_CROWBAR))
		to_chat(user, "<span class='notice'>You start to [cistern ? "replace the lid on the cistern" : "lift the lid off the cistern"].</span>")
		playsound(src, 'sound/effects/stonedoor_openclose.ogg', 50, 1)
		if(do_after(user, 30))
			user.visible_message("<span class='notice'>[user] [cistern ? "replaces the lid on the cistern" : "lifts the lid off the cistern"]!</span>", "<span class='notice'>You [cistern ? "replace the lid on the cistern" : "lift the lid off the cistern"]!</span>", "You hear grinding porcelain.")
			cistern = !cistern
			update_icon()
			return

	if(istype(I, /obj/item/weapon/grab))
		user.setClickCooldown(user.get_attack_speed(I))
		var/obj/item/weapon/grab/G = I

		if(isliving(G.affecting))
			var/mob/living/GM = G.affecting

			if(G.state>1)
				if(!GM.loc == get_turf(src))
					to_chat(user, "<span class='notice'>[GM.name] needs to be on the toilet.</span>")
					return
				if(open && !swirlie)
					user.visible_message("<span class='danger'>[user] starts to give [GM.name] a swirlie!</span>", "<span class='notice'>You start to give [GM.name] a swirlie!</span>")
					swirlie = GM
					if(do_after(user, 30, GM))
						user.visible_message("<span class='danger'>[user] gives [GM.name] a swirlie!</span>", "<span class='notice'>You give [GM.name] a swirlie!</span>", "You hear a toilet flushing.")
						if(!GM.internal)
							GM.adjustOxyLoss(5)
					swirlie = null
				else
					user.visible_message("<span class='danger'>[user] slams [GM.name] into the [src]!</span>", "<span class='notice'>You slam [GM.name] into the [src]!</span>")
					GM.adjustBruteLoss(5)
			else
				to_chat(user, "<span class='notice'>You need a tighter grip.</span>")

	if(cistern && !istype(user,/mob/living/silicon/robot)) //STOP PUTTING YOUR MODULES IN THE TOILET.
		if(I.w_class > 3)
			to_chat(user, "<span class='notice'>\The [I] does not fit.</span>")
			return
		if(w_items + I.w_class > 5)
			to_chat(user, "<span class='notice'>The cistern is full.</span>")
			return
		user.drop_item()
		I.loc = src
		w_items += I.w_class
		to_chat(user, "You carefully place \the [I] into the cistern.")
		return

/obj/structure/toilet/prison
	name = "prison toilet"
	icon_state = "toilet2"

/obj/structure/toilet/prison/attack_hand(mob/living/user)
	return

/obj/structure/toilet/prison/attackby(obj/item/I, mob/living/user)
	if(istype(I, /obj/item/weapon/grab))
		user.setClickCooldown(user.get_attack_speed(I))
		var/obj/item/weapon/grab/G = I

		if(isliving(G.affecting))
			var/mob/living/GM = G.affecting

			if(G.state>1)
				if(!GM.loc == get_turf(src))
					to_chat(user, "<span class='notice'>[GM.name] needs to be on the toilet.</span>")
					return
				if(open && !swirlie)
					user.visible_message("<span class='danger'>[user] starts to give [GM.name] a swirlie!</span>", "<span class='notice'>You start to give [GM.name] a swirlie!</span>")
					swirlie = GM
					if(do_after(user, 30, GM))
						user.visible_message("<span class='danger'>[user] gives [GM.name] a swirlie!</span>", "<span class='notice'>You give [GM.name] a swirlie!</span>", "You hear a toilet flushing.")
						if(!GM.internal)
							GM.adjustOxyLoss(5)
					swirlie = null
				else
					user.visible_message("<span class='danger'>[user] slams [GM.name] into the [src]!</span>", "<span class='notice'>You slam [GM.name] into the [src]!</span>")
					GM.adjustBruteLoss(5)
			else
				to_chat(user, "<span class='notice'>You need a tighter grip.</span>")

/obj/structure/urinal
	name = "urinal"
	desc = "The HU-452, an experimental urinal."
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "urinal"
	density = FALSE
	anchored = TRUE

/obj/structure/urinal/attackby(obj/item/I as obj, mob/user as mob)
	if(istype(I, /obj/item/weapon/grab))
		var/obj/item/weapon/grab/G = I
		if(isliving(G.affecting))
			var/mob/living/GM = G.affecting
			if(G.state>1)
				if(!GM.loc == get_turf(src))
					to_chat(user, "<span class='notice'>[GM.name] needs to be on the urinal.</span>")
					return
				user.visible_message("<span class='danger'>[user] slams [GM.name] into the [src]!</span>", "<span class='notice'>You slam [GM.name] into the [src]!</span>")
				GM.adjustBruteLoss(8)
			else
				to_chat(user, "<span class='notice'>You need a tighter grip.</span>")



/obj/machinery/shower
	name = "shower"
	desc = "The HS-451. Installed in the 2250s by the Hygiene Division."
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "shower"
	density = FALSE
	anchored = TRUE
	use_power = USE_POWER_OFF
	var/on = 0
	var/obj/effect/mist/mymist = null
	var/ismist = 0				//needs a var so we can make it linger~
	var/watertemp = "normal"	//freezing, normal, or boiling
	var/is_washing = 0
	var/list/temperature_settings = list("normal" = 310, "boiling" = T0C+100, "freezing" = T0C)
	var/datum/looping_sound/showering/soundloop

/obj/machinery/shower/Initialize()
	create_reagents(50)
	soundloop = new(list(src), FALSE)
	return ..()

/obj/machinery/shower/Destroy()
	QDEL_NULL(soundloop)
	return ..()

//add heat controls? when emagged, you can freeze to death in it?

/obj/effect/mist
	name = "mist"
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "mist"
	plane = MOB_PLANE
	layer = ABOVE_MOB_LAYER
	anchored = TRUE
	mouse_opacity = 0

/obj/machinery/shower/attack_hand(mob/M as mob)
	on = !on
	update_icon()
	if(on)
		soundloop.start()
		if (M.loc == loc)
			wash(M)
			process_heat(M)
		for (var/atom/movable/G in src.loc)
			G.clean_blood(TRUE)
	else
		soundloop.stop()

/obj/machinery/shower/attackby(obj/item/I as obj, mob/user as mob)
	if(I.type == /obj/item/device/analyzer)
		to_chat(user, "<span class='notice'>The water temperature seems to be [watertemp].</span>")
	if(I.has_tool_quality(TOOL_WRENCH))
		var/newtemp = tgui_input_list(user, "What setting would you like to set the temperature valve to?", "Water Temperature Valve", temperature_settings)
		to_chat(user, "<span class='notice'>You begin to adjust the temperature valve with \the [I].</span>")
		playsound(src, I.usesound, 50, 1)
		if(do_after(user, 50 * I.toolspeed))
			watertemp = newtemp
			user.visible_message("<span class='notice'>[user] adjusts the shower with \the [I].</span>", "<span class='notice'>You adjust the shower with \the [I].</span>")
			add_fingerprint(user)

/obj/machinery/shower/update_icon()	//this is terribly unreadable, but basically it makes the shower mist up
	cut_overlays()					//once it's been on for a while, in addition to handling the water overlay.
	if(mymist)
		qdel(mymist)
		mymist = null

	if(on)
		add_overlay(image('icons/obj/watercloset.dmi', src, "water", MOB_LAYER + 1, dir))
		if(temperature_settings[watertemp] < T20C)
			return //no mist for cold water
		if(!ismist)
			spawn(50)
				if(src && on)
					ismist = 1
					mymist = new /obj/effect/mist(loc)
		else
			ismist = 1
			mymist = new /obj/effect/mist(loc)
	else if(ismist)
		ismist = 1
		mymist = new /obj/effect/mist(loc)
		spawn(250)
			if(src && !on)
				qdel(mymist)
				mymist = null
				ismist = 0

//Yes, showers are super powerful as far as washing goes.
/obj/machinery/shower/proc/wash(atom/movable/O as obj|mob)
	if(!on) return

	if(isliving(O))
		var/mob/living/L = O
		L.ExtinguishMob()
		L.fire_stacks = -20 //Douse ourselves with water to avoid fire more easily

	if(iscarbon(O))
		//flush away reagents on the skin
		var/mob/living/carbon/M = O
		if(M.touching)
			var/remove_amount = M.touching.maximum_volume * M.reagent_permeability() //take off your suit first
			M.touching.remove_any(remove_amount)

		M.clean_blood()

	reagents.splash(O, 10, min_spill = 0, max_spill = 0)

/obj/machinery/shower/process()
	if(!on) return
	for(var/atom/movable/AM in loc)
		if(AM.simulated)
			wash(AM)
			if(isliving(AM))
				var/mob/living/L = AM
				process_heat(L)
	wash_floor()
	reagents.add_reagent("water", reagents.get_free_space())

/obj/machinery/shower/proc/wash_floor()
	if(is_washing)
		return
	is_washing = 1
	var/turf/T = get_turf(src)
	T.clean(src)
	spawn(100)
		is_washing = 0

/obj/machinery/shower/proc/process_heat(mob/living/M)
	if(!on || !istype(M)) return

	var/temperature = temperature_settings[watertemp]
	var/temp_adj = between(BODYTEMP_COOLING_MAX, temperature - M.bodytemperature, BODYTEMP_HEATING_MAX)
	M.bodytemperature += temp_adj

	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(temperature >= H.species.heat_level_1)
			to_chat(H, "<span class='danger'>The water is searing hot!</span>")
		else if(temperature <= H.species.cold_level_1)
			to_chat(H, "<span class='warning'>The water is freezing cold!</span>")

/obj/item/weapon/bikehorn/rubberducky
	name = "rubber ducky"
	desc = "Rubber ducky you're so fine, you make bathtime lots of fuuun. Rubber ducky I'm awfully fooooond of yooooouuuu~"	//thanks doohl
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "rubberducky"
	item_state = "rubberducky"
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand.dmi',
	)
	honk_sound = 'sound/voice/quack.ogg' //VOREStation edit
	var/honk_text = 0

/obj/item/weapon/bikehorn/rubberducky/attack_self(mob/user as mob)
	if(spam_flag == 0)
		spam_flag = 1
		playsound(src, honk_sound, 50, 1)
		if(honk_text)
			audible_message(span_maroon("[honk_text]"))
		src.add_fingerprint(user)
		spawn(20)
			spam_flag = 0
	return

//Admin spawn duckies

/obj/item/weapon/bikehorn/rubberducky/red
	name = "rubber ducky"
	desc = "From the depths of hell it arose, feathers glistening with crimson, a honk that struck fear into all men."	//thanks doohl
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "rubberducky_red"
	item_state = "rubberducky_red"
	honk_sound = 'sound/effects/adminhelp.ogg'
	var/honk_count = 0

/obj/item/weapon/bikehorn/rubberducky/red/attack_self(mob/user as mob)
	if(honk_count >= 3)
		var/turf/epicenter = src.loc
		explosion(epicenter, 0, 0, 1, 3)
		qdel(src)
		return
	else if(spam_flag == 0)
		spam_flag = 1
		playsound(src, honk_sound, 50, 1)
		src.add_fingerprint(user)
		if(honk_text)
			audible_message(span_maroon("[honk_text]"))
		honk_count ++
		spawn(20)
			spam_flag = 0
	return

/obj/item/weapon/bikehorn/rubberducky/blue
	name = "rubber ducky"
	desc = "The see me rollin', they hatin'."	//thanks doohl
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "rubberducky_blue"
	item_state = "rubberducky_blue"
	honk_sound = 'sound/effects/bubbles.ogg'
	var/honk_count = 0

/obj/item/weapon/bikehorn/rubberducky/blue/attack_self(mob/user as mob)
	if(spam_flag == 0)
		var/turf/simulated/whereweare = get_turf(src)
		whereweare.wet_floor(2)
		spam_flag = 1
		playsound(src, honk_sound, 50, 1)
		if(honk_text)
			audible_message(span_maroon("[honk_text]"))
		src.add_fingerprint(user)
		spawn(20)
			spam_flag = 0
	return

/obj/item/weapon/bikehorn/rubberducky/pink
	name = "rubber ducky"
	desc = "It's extra squishy!"
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "rubberducky_pink"
	item_state = "rubberducky_pink"
	honk_sound = 'sound/vore/sunesound/pred/insertion_01.ogg'
	var/honk_count = 0

/obj/item/weapon/bikehorn/rubberducky/pink/attack_self(mob/user as mob)
	if(spam_flag == 0)
		if(!user.devourable)
			to_chat(user, "<span class='vnotice'>You can't bring yourself to squeeze it...</span>")
			return
		spam_flag = 1
		playsound(src, honk_sound, 50, 1)
		if(honk_text)
			audible_message(span_maroon("[honk_text]"))
		src.add_fingerprint(user)
		user.drop_item()
		user.forceMove(src)
		to_chat(user, "<span class='vnotice'>You have been swallowed alive by the rubber ducky. Your entire body compacted up and squeezed into the tiny space that makes up the oddly realistic and not at all rubbery stomach. The walls themselves are kneading over you, grinding some sort of fluids into your trapped body. You can even hear the sound of bodily functions echoing around you...</span>")
		spawn(20)
			spam_flag = 0
	return

/obj/item/weapon/bikehorn/rubberducky/pink/container_resist(var/mob/living/escapee)
	escapee.forceMove(get_turf(src))
	to_chat(escapee, "<span class='vnotice'>You managed to crawl out of the rubber ducky!</span>")

/obj/item/weapon/bikehorn/rubberducky/grey
	name = "rubber ducky"
	desc = "There's something otherworldly about this particular duck..."
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "rubberducky_grey"
	item_state = "rubberducky_grey"
	honk_sound = 'sound/effects/ghost.ogg'
	var/honk_count = 0

/obj/item/weapon/bikehorn/rubberducky/grey/attack_self(mob/user as mob)
	if(spam_flag == 0)
		for(var/obj/machinery/light/L in machines)
			if(L.z != user.z || get_dist(user,L) > 10)
				continue
			else
				L.flicker(10)
		spam_flag = 1
		playsound(src, honk_sound, 50, 1)
		if(honk_text)
			audible_message(span_maroon("[honk_text]"))
		src.add_fingerprint(user)
		user.drop_item()
		var/turf/T = locate(rand(1, 140), rand(1, 140), user.z)
		src.forceMove(T)
	return

/obj/item/weapon/bikehorn/rubberducky/green
	name = "rubber ducky"
	desc = "Like a true Nature’s child, we were born, born to be wild."
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "rubberducky_green"
	item_state = "rubberducky_green"
	honk_sound = 'sound/arcade/mana.ogg'
	var/honk_count = 0
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

/obj/item/weapon/bikehorn/rubberducky/green/attack_self(mob/user as mob)
	if(spam_flag == 0)
		var/turf/simulated/whereweare = get_turf(src)
		var/obj/P = pick(flora)
		new P(whereweare)
		spam_flag = 1
		playsound(src, honk_sound, 50, 1)
		if(honk_text)
			audible_message(span_maroon("[honk_text]"))
		src.add_fingerprint(user)
		spawn(20)
			spam_flag = 0
	return

/obj/item/weapon/bikehorn/rubberducky/white
	name = "rubber ducky"
	desc = "It's so full of energy, such a happy little guy, I just wanna give him a squeeze."	//thanks doohl
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "rubberducky_white"
	item_state = "rubberducky_white"
	honk_sound = 'sound/effects/lightningshock.ogg'
	var/honk_count = 0

/obj/item/weapon/bikehorn/rubberducky/white/attack_self(mob/user as mob)
	if(spam_flag == 0)
		lightning_strike(get_turf(src), 1)
		spam_flag = 1
		playsound(src, honk_sound, 50, 1)
		if(honk_text)
			audible_message(span_maroon("[honk_text]"))
		src.add_fingerprint(user)
		spawn(20)
			spam_flag = 0 //leaving this in incase it doesn't qdel somehow
		qdel(src)
	return

/obj/item/weapon/grenade/anti_photon/rubberducky/black
	desc = "Good work NanoTrasen Employee, you struck fear within the Syndicate."
	name = "rubber ducky"
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "rubberducky_black"
	item_state = "rubberducky_black"
	det_time = 20
	var/honk_text = 0

/obj/item/weapon/grenade/anti_photon/rubberducky/black/detonate()
	playsound(src, 'sound/voice/quack.ogg', 50, 1, 5)
	set_light(10, -10, "#FFFFFF")

	var/extra_delay = rand(0,90)

	spawn(extra_delay)
		spawn(200)
			if(prob(10+extra_delay))
				set_light(10, 10, "#[num2hex(rand(64,255))][num2hex(rand(64,255))][num2hex(rand(64,255))]")
		spawn(210)
			..()
			playsound(src, 'sound/voice/quack.ogg', 50, 1, 5)
			if(honk_text)
				audible_message(span_maroon("[honk_text]"))
			qdel(src)

/obj/structure/sink
	name = "sink"
	icon = 'icons/obj/watercloset.dmi'
	icon_state = "sink"
	desc = "A sink used for washing one's hands and face."
	anchored = TRUE
	var/busy = 0 	//Something's being washed at the moment

/obj/structure/sink/MouseDrop_T(var/obj/item/thing, var/mob/user)
	..()
	if(!istype(thing) || !thing.is_open_container())
		return ..()
	if(!usr.Adjacent(src))
		return ..()
	if(!thing.reagents || thing.reagents.total_volume == 0)
		to_chat(usr, "<span class='warning'>\The [thing] is empty.</span>")
		return
	// Clear the vessel.
	visible_message("<b>\The [usr]</b> tips the contents of \the [thing] into \the [src].")
	thing.reagents.clear_reagents()
	thing.update_icon()

/obj/structure/sink/attack_hand(mob/user as mob)
	if (ishuman(user))
		var/mob/living/carbon/human/H = user
		var/obj/item/organ/external/temp = H.organs_by_name["r_hand"]
		if (H.hand)
			temp = H.organs_by_name["l_hand"]
		if(temp && !temp.is_usable())
			to_chat(user, "<span class='notice'>You try to move your [temp.name], but cannot!</span>")
			return

	if(isrobot(user) || isAI(user))
		return

	if(!Adjacent(user))
		return

	if(busy)
		to_chat(user, "<span class='warning'>Someone's already washing here.</span>")
		return

	to_chat(usr, "<span class='notice'>You start washing your hands.</span>")
	playsound(src, 'sound/effects/sink_long.ogg', 75, 1)

	busy = 1
	if(!do_after(user, 40, src))
		busy = 0
		to_chat(usr, "<span class='notice'>You stop washing your hands.</span>")
		return
	busy = 0

	user.clean_blood()
	if(ishuman(user))
		user:update_inv_gloves()
	for(var/mob/V in viewers(src, null))
		V.show_message("<span class='notice'>[user] washes their hands using \the [src].</span>")

/obj/structure/sink/attackby(obj/item/O as obj, mob/user as mob)
	if(busy)
		to_chat(user, "<span class='warning'>Someone's already washing here.</span>")
		return

	var/obj/item/weapon/reagent_containers/RG = O
	if (istype(RG) && RG.is_open_container())
		RG.reagents.add_reagent("water", min(RG.volume - RG.reagents.total_volume, RG.amount_per_transfer_from_this))
		user.visible_message("<span class='notice'>[user] fills \the [RG] using \the [src].</span>","<span class='notice'>You fill \the [RG] using \the [src].</span>")
		playsound(src, 'sound/effects/sink.ogg', 75, 1)
		return 1

	else if (istype(O, /obj/item/weapon/melee/baton))
		var/obj/item/weapon/melee/baton/B = O
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
				var/datum/gender/TU = gender_datums[user.get_visible_gender()]
				user.visible_message( \
					"<span class='danger'>[user] was stunned by [TU.his] wet [O]!</span>", \
					"<span class='userdanger'>[user] was stunned by [TU.his] wet [O]!</span>")
				return 1
	else if(istype(O, /obj/item/weapon/mop))
		O.reagents.add_reagent("water", 5)
		to_chat(user, "<span class='notice'>You wet \the [O] in \the [src].</span>")
		playsound(src, 'sound/effects/slosh.ogg', 25, 1)
		return

	var/turf/location = user.loc
	if(!isturf(location)) return

	var/obj/item/I = O
	if(!I || !istype(I,/obj/item)) return

	to_chat(usr, "<span class='notice'>You start washing \the [I].</span>")

	busy = 1
	if(!do_after(user, 40, src))
		busy = 0
		to_chat(usr, "<span class='notice'>You stop washing \the [I].</span>")
		return
	busy = 0

	O.clean_blood()
	O.water_act(rand(1,10))
	user.visible_message( \
		"<span class='notice'>[user] washes \a [I] using \the [src].</span>", \
		"<span class='notice'>You wash \a [I] using \the [src].</span>")

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
