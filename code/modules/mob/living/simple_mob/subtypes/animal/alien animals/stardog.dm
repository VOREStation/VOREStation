/datum/category_item/catalogue/fauna/stardog
	name = "Alien Wildlife - Star Dog"
	desc = "I appears to be a canine of some sort, though absolutely massive in scale and surrounded in radical redspace energies!"
	value = CATALOGUER_REWARD_SUPERHARD

/mob/living/simple_mob/vore/overmap/stardog
	name = "dog"
	desc = "It is a relatively ordinary looking canine mutt! It radiates mischief and otherworldly energy..."
	tt_desc = "E Canis lupus stellarus"

	scanner_desc = "I appears to be a canine of some sort, though absolutely massive in scale and surrounded in radical redspace energies!"
	catalogue_data = list(/datum/category_item/catalogue/fauna/stardog)

	icon = 'icons/mob/vore.dmi'
	icon_state = "woof"
	icon_living = "woof"
	icon_dead = "woof_dead"
	icon_rest = "woof_rest"

	om_child_type = /obj/effect/overmap/visitable/ship/simplemob/stardog

	response_help = "pets"
	response_disarm = "rudely paps"
	response_harm = "punches"

	attacktext = list("nipped", "chomped", "bullied", "gnaws on")
	attack_sound = 'sound/voice/bork.ogg'
	friendly = list("snoofs", "nuzzles", "ruffs happily at", "smooshes on")

	ai_holder_type = /datum/ai_holder/simple_mob/woof/stardog

	has_langs = list(LANGUAGE_ANIMAL, LANGUAGE_CANILUNZT, LANGUAGE_GALCOM)
	say_list_type = /datum/say_list/softdog
	swallowTime = 0.1 SECONDS

	loot_list = list(/obj/random/underdark/uncertain)

	armor = list(
		"melee" = 1000,
		"bullet" = 1000,
		"laser" = 1000,
		"energy" = 1000,
		"bomb" = 1000,
		"bio" = 1000,
		"rad" = 1000)

	armor_soak = list(
		"melee" = 1000,
		"bullet" = 1000,
		"laser" = 1000,
		"energy" = 1000,
		"bomb" = 1000,
		"bio" = 1000,
		"rad" = 1000
		)

	movement_cooldown = 5
	copy_prefs_to_mob = FALSE
	var/affinity = 0
	var/obj/structure/control_pod/control_node = null
	var/shipvore = FALSE	//Enable this to allow the star dog to eat spaceships by dragging them onto its sprite.

/mob/living/simple_mob/vore/overmap/stardog/attack_hand(mob/living/user)
	if(!(user.pickup_pref && user.pickup_active))
		return ..()
	var/list/possible_targets = list()

	for(var/mob/living/player in player_list)
		if(!(player.z in child_om_marker.map_z))
			continue
		if(!(isliving(player) && istype(player.loc,/turf/simulated/floor/outdoors/fur) && player.client))
			continue
		if(player.resizable && player.pickup_pref)
			possible_targets |= player

	if(!possible_targets.len)
		return ..()
	user.visible_message("<span class='warning'>\The [user] reaches for something in \the [src]'s fur...</span>","<span class='notice'>You look through \the [src]'s fur...</span>")
	var/mob/living/that_one = tgui_input_list(user, "Select a mob:", "Select a mob to grab!", possible_targets)
	if(!that_one)
		return ..()
	to_chat(that_one, "<span class='danger'>\The [user]'s hand reaches toward you!!!</span>")
	if(!do_after(user, 3 SECONDS, src))
		return ..()
	if(!istype(that_one.loc,/turf/simulated/floor/outdoors/fur))
		to_chat(user, "<span class='warning'>\The [that_one] got away...</span>")
		to_chat(that_one, "<span class='notice'>You got away!</span>")
		return
	var/prev_size = that_one.size_multiplier
	that_one.resize(RESIZE_TINY, ignore_prefs = TRUE)
	if(!that_one.attempt_to_scoop(user, ignore_size = TRUE))
		that_one.resize(prev_size, ignore_prefs = TRUE)
		return ..()

/mob/living/simple_mob/vore/overmap/stardog/Life()
	. = ..()
	affinity = 9999
	nutrition = 9999
	if(devourable)
		devourable = FALSE
		digestable = FALSE
	if(ckey && control_node)
		adjust_affinity(-3)
		if(!affinity)
			control_node.eject()
	if(!ckey && resting)
		lay_down()

	if(istype(loc, /turf/unsimulated/map))
		if(!invisibility)
			invisibility = INVISIBILITY_ABSTRACT
			child_om_marker.invisibility = 0
			ai_holder.base_wander_delay = 50
			ai_holder.wander_delay = 1
			melee_damage_lower = 50
			melee_damage_upper = 100
			mob_size = MOB_HUGE
			child_om_marker.set_light(5, 1, "#ff8df5")
			movement_cooldown = 5

	else if(invisibility)
		invisibility = 0
		child_om_marker.invisibility = INVISIBILITY_ABSTRACT
		ai_holder.base_wander_delay = 5
		ai_holder.wander_delay = 1
		melee_damage_lower = 1
		melee_damage_upper = 5
		mob_size = MOB_SMALL
		child_om_marker.set_light(0)
		movement_cooldown = 0

/mob/living/simple_mob/vore/overmap/stardog/Initialize()
	. = ..()
	child_om_marker.set_light(5, 1, "#ff8df5")

/mob/living/simple_mob/vore/overmap/stardog/Destroy()
	if(control_node)
		control_node.host = null
		control_node = null
	return ..()

/mob/living/simple_mob/vore/overmap/stardog/Stat()
	..()
	if(statpanel("Status"))
		stat(null, "Affinity: [round(affinity)]")

/mob/living/simple_mob/vore/overmap/stardog/proc/adjust_affinity(amount)
	if(amount > 0)
		var/multiplier = nutrition / 250
		affinity += (amount * multiplier)
	if(amount < 0)
		affinity -= amount
	if(affinity <= 0)
		affinity = 0

/mob/living/simple_mob/vore/overmap/stardog/verb/eject()
	set name = "Eject"
	set desc = "Stop controlling the dog and return to your own body."
	set category = "Abilities"

	control_node.eject()

/mob/living/simple_mob/vore/overmap/stardog/verb/eat_space_weather()
	set name = "Eat Space Weather"
	set desc = "Eat carp or rocks!"
	set category = "Abilities"

/mob/living/simple_mob/vore/overmap/stardog/verb/transition()
	set name = "Transition"
	set desc = "Attempt to go to the location you have arrived at, or return to space!"
	set category = "Abilities"

	if(nutrition <= 500)
		to_chat(src, "<span class='warning'>You're too hungry...</span>")
		return
	if(istype(loc, /turf/unsimulated/map))
		var/list/destinations = list()
		var/list/our_maps = list()
		for(var/obj/effect/overmap/visitable/v in loc)
			if(v == child_om_marker)
				continue
			if(!v.map_z.len)
				continue
			for(var/our_z in v.map_z)
				our_maps |= v.map_z
		if(!our_maps.len)
			to_chat(src, "<span class='warning'>There is nowhere nearby to go to! You need to get closer to somewhere you can transition to before you can transition.</span>")
			return
		for(var/obj/effect/landmark/l in landmarks_list)
			if(l.z in our_maps)
				if(istype(l,/obj/effect/landmark/stardog))
					destinations |= l

		if(!destinations.len)
			to_chat(src, "<span class='warning'>There is nowhere nearby to land! You need to get closer to somewhere else that you can transition to before you can transition.</span>")
			return
		var/obj/effect/overmap/visitable/our_dest = tgui_input_list(src, "Where would you like to try to go?", "Transition", destinations, timeout = 10 SECONDS)
		if(!our_dest)
			return
		to_chat(src, "<span class='notice'>You begin to transition down to \the [our_dest], stay still...</span>")
		if(!do_after(src, 15 SECONDS, our_dest, exclusive = TRUE))
			to_chat(src, "<span class='warning'>You were interrupted.</span>")
			return
		visible_message("<span class='warning'>\The [src] disappears!!!</span>")
		forceMove(get_turf(our_dest))
		adjust_nutrition(-1000)
		visible_message("<span class='warning'>\The [src] steps into the area as if from nowhere!</span>")

	else
		to_chat(src, "<span class='notice'>You begin to transition back to space, stay still...</span>")
		if(!do_after(src, 15 SECONDS, exclusive = TRUE))
			to_chat(src, "<span class='warning'>You were interrupted.</span>")
			return

		visible_message("<span class='warning'>\The [src] disappears!!!</span>")
		forceMove(get_turf(get_overmap_sector(z)))
		adjust_nutrition(-500)


/obj/effect/overmap/visitable/ship/simplemob/stardog
	icon = 'icons/obj/overmap.dmi'
	icon_state = "ship"
	icon = 'icons/obj/overmap.dmi'
	icon_state = "ship"
	skybox_icon = 'icons/skybox/anomaly.dmi'
	skybox_icon_state = "space_dog"
	skybox_pixel_x = 0
	skybox_pixel_y = 0
	glide_size = 1
	parent_mob_type = /mob/living/simple_mob/vore/overmap/stardog
	scanner_desc = "CONFIGURE ME"

/datum/ai_holder/simple_mob/woof/stardog
	hostile = FALSE
	cooperative = TRUE
	retaliate = TRUE
	speak_chance = 1
	wander = TRUE
	wander_delay = 1
	base_wander_delay = 50

/turf/simulated/floor/outdoors/fur
	name = "fur"
	desc = "Thick, silky fur!"
	icon = 'icons/turf/fur.dmi'
	icon_state = "fur0"
	edge_blending_priority = 4
	initial_flooring = /decl/flooring/fur
	can_dig = FALSE
	turf_layers = list()
	var/tree_chance = 25
	var/tree_color = null
	var/tree_type = /obj/structure/flora/tree/fur

/turf/simulated/floor/outdoors/fur/Entered(atom/movable/AM, atom/oldloc)
	. = ..()
	if(ishuman(AM))
		var/mob/living/carbon/human/L = AM
		L.fur_submerge()

/turf/simulated/floor/outdoors/fur/Exited(atom/movable/AM, atom/new_loc)
	. = ..()
	if(ishuman(AM))
		var/mob/living/carbon/human/L = AM
		L.fur_submerge()

/mob/living/carbon/human/proc/fur_submerge()
	if(QDESTROYING(src))
		return

	remove_layer(MOB_WATER_LAYER)

	if(!istype(loc,/turf/simulated/floor/outdoors/fur) || lying)
		return

	var/atom/A = loc
	var/image/I = image(icon = 'icons/turf/fur.dmi', icon_state = "submerged", layer = BODY_LAYER+MOB_WATER_LAYER)
	I.color = A.color
	overlays_standing[MOB_WATER_LAYER] = I

	apply_layer(MOB_WATER_LAYER)

/turf/simulated/floor/outdoors/fur/woof
	color = "#c69c85"
	tree_color = "#eeb698"

/turf/simulated/floor/outdoors/fur/woof/no_trees
	icon_state = "furX"

/turf/simulated/floor/outdoors/fur/Initialize()
	. = ..()
	if(tree_chance && prob(tree_chance) && !check_density())
		var/obj/structure/flora/tree/tree = new tree_type(src)
		if(tree_color)
			tree.color = tree_color
		else
			tree.color = color

/turf/simulated/floor/outdoors/fur/woof/wall
	name = "dense fur"
	desc = "Silky and soft, but too thick to pass or cut!"
	color = "#92705d"
	opacity = TRUE
	tree_color = null
	tree_chance = 100
	tree_type = /obj/structure/flora/tree/fur/wall
	outdoors = FALSE

/turf/simulated/floor/outdoors/fur/verb/pet()
	set name = "Pet Fur"
	set desc = "Pet the fur!"
	set category = "IC"
	set src in oview(1)

	usr.visible_message("<span class = 'notice'>\The [usr] pets \the [src].</span>", "<span class = 'notice'>You pet \the [src].</span>", runemessage = "pet pat...")
	var/obj/effect/overmap/visitable/ship/simplemob/stardog/s = get_overmap_sector(z)

	if(s && istype(s, /obj/effect/overmap/visitable/ship/simplemob/stardog))
		var/mob/living/simple_mob/vore/overmap/stardog/m = s.parent
		m.adjust_affinity(1)
		if(m.affinity >= 10 && prob(5))
			m.visible_message("\The [m]'s tail wags happily!")

/turf/simulated/floor/outdoors/fur/verb/emote_beyond(message as message)
	set name = "Emote Beyond"
	set desc = "Emote to those beyond the fur!"
	set category = "IC"
	set src in oview(1)

	if(!isliving(usr))
		return
	var/mob/living/L = usr
	if(L.client.prefs.muted & MUTE_IC)
		to_chat(L, "<span class='warning'>You cannot speak in IC (muted).</span>")
		return
	if (!message)
		message = tgui_input_text(usr, "Type a message to emote.","Emote Beyond")
	message = sanitize_or_reflect(message,L)
	if (!message)
		return
	if (L.stat == DEAD)
		return L.say_dead(message)
	var/obj/effect/overmap/visitable/ship/simplemob/stardog/s = get_overmap_sector(z)
	if(!s || !istype(s, /obj/effect/overmap/visitable/ship/simplemob/stardog))
		return

	var/mob/living/simple_mob/vore/overmap/stardog/m = s.parent

	log_subtle(message,L)
	message = "<span class='emote_subtle'><B>[L]</B> <I>[message]</I></span>"
	message = "<B>(From the back of \the [m]) </B>" + message
	message = encode_html_emphasis(message)

	var/undisplayed_message = "<span class='emote'><B>[L]</B> <I>does something too subtle for you to see.</I></span>"
	var/list/vis = get_mobs_and_objs_in_view_fast(get_turf(m),1,2)
	var/list/vis_mobs = vis["mobs"]
	vis_mobs |= L
	for(var/mob/M as anything in vis_mobs)
		if(isnewplayer(M))
			continue
		if(isobserver(M) && !L.is_preference_enabled(/datum/client_preference/whisubtle_vis) && !M.client?.holder)
			spawn(0)
				M.show_message(undisplayed_message, 2)
		else
			spawn(0)
				M.show_message(message, 2)
				if(M.is_preference_enabled(/datum/client_preference/subtle_sounds))
					M << sound('sound/talksounds/subtle_sound.ogg', volume = 50)

/decl/flooring/fur
	name = "fur"
	desc = "Thick, silky fur!"
	icon = 'icons/turf/fur.dmi'
	icon_base = "fur"
	has_base_range = 15

	can_paint = TRUE

	footstep_sounds = list()

/obj/structure/flora/tree/fur
	name = "tall fur"
	desc = "Tall stalks of fur block your path! Someone needs a trim!"
	icon = 'icons/obj/fur_tree.dmi'
	icon_state = "tallfur1"
	base_state = "tallfur"
	opacity = TRUE
	product = /obj/item/stack/material/fur
	product_amount = 10
	health = 100
	max_health = 100
	pixel_x = 0
	pixel_y = 0
	shake_animation_degrees = 2
	sticks = FALSE
	var/mob_chance = 5
	var/static/list/mob_list = list(
		/mob/living/simple_mob/vore/aggressive/corrupthound,
		/mob/living/simple_mob/vore/aggressive/corrupthound/prettyboi,
		/mob/living/simple_mob/vore/aggressive/deathclaw,
		/mob/living/simple_mob/vore/aggressive/dino,
		/mob/living/simple_mob/vore/aggressive/dragon,
		/mob/living/simple_mob/vore/aggressive/frog,
		/mob/living/simple_mob/vore/aggressive/giant_snake,
		/mob/living/simple_mob/vore/aggressive/mimic,
		/mob/living/simple_mob/vore/aggressive/panther,
		/mob/living/simple_mob/vore/aggressive/rat,
		/mob/living/simple_mob/vore/alienanimals/catslug,
		/mob/living/simple_mob/vore/alienanimals/dustjumper,
		/mob/living/simple_mob/vore/alienanimals/skeleton,
		/mob/living/simple_mob/vore/alienanimals/space_jellyfish,
		/mob/living/simple_mob/vore/alienanimals/startreader,
		/mob/living/simple_mob/vore/alienanimals/succlet,
		/mob/living/simple_mob/vore/alienanimals/teppi,
		/mob/living/simple_mob/vore/alienanimals/teppi/baby,
		/mob/living/simple_mob/vore/bee,
		/mob/living/simple_mob/vore/bigdragon,
		/mob/living/simple_mob/vore/bigdragon/friendly,
		/mob/living/simple_mob/vore/catgirl,
		/mob/living/simple_mob/vore/fennec,
		/mob/living/simple_mob/vore/fennec/huge,
		/mob/living/simple_mob/vore/fennix,
		/mob/living/simple_mob/vore/greatwolf,
		/mob/living/simple_mob/vore/hippo,
		/mob/living/simple_mob/vore/horse,
		/mob/living/simple_mob/vore/horse/big,
		/mob/living/simple_mob/vore/jelly,
		/mob/living/simple_mob/vore/lamia/random,
		/mob/living/simple_mob/vore/leopardmander,
		/mob/living/simple_mob/vore/oregrub,
		/mob/living/simple_mob/vore/otie,
		/mob/living/simple_mob/vore/otie/red,
		/mob/living/simple_mob/vore/pakkun,
		/mob/living/simple_mob/vore/rabbit,
		/mob/living/simple_mob/vore/redpanda,
		/mob/living/simple_mob/vore/sect_drone,
		/mob/living/simple_mob/vore/sect_queen,
		/mob/living/simple_mob/vore/sheep,
		/mob/living/simple_mob/vore/solargrub,
		/mob/living/simple_mob/vore/squirrel,
		/mob/living/simple_mob/vore/squirrel/big,
		/mob/living/simple_mob/vore/weretiger,
		/mob/living/simple_mob/vore/wolf,
		/mob/living/simple_mob/vore/wolf/direwolf,
		/mob/living/simple_mob/vore/wolfgirl,
		/mob/living/simple_mob/vore/woof
	)

/obj/structure/flora/tree/fur/choose_icon_state()
	return "[base_state][rand(1, 2)]"

/obj/structure/flora/tree/fur/attack_hand(mob/user)
	to_chat(user, "<span class='notice'>Your hand sinks into \the [src]!</span>")

/obj/structure/flora/tree/fur/die()
	if(product && product_amount)
		var/obj/item/stack/material/fur/F = new product(get_turf(src), product_amount)
		F.color = color
		F.update_icon()
	visible_message("<span class='notice'>\The [src] is felled!</span>")
	if(prob(mob_chance))
		if(!mob_list.len)
			return
		var/ourmob = pickweight(mob_list)
		var/mob/living/simple_mob/s = new ourmob(get_turf(src))
		visible_message("<span class='danger'>\The [s] tumbles out of \the [src]!</span>")
		s.ai_holder.hostile = FALSE
		s.ai_holder.retaliate = TRUE

	var/obj/effect/overmap/visitable/ship/simplemob/stardog/s = get_overmap_sector(z)
	if(s && istype(s,/obj/effect/overmap/visitable/ship/simplemob/stardog))
		var/mob/living/simple_mob/vore/overmap/stardog/dog = s.parent
		dog.adjust_affinity(15)

	qdel(src)

/obj/structure/flora/tree/fur/wall
	name = "dense fur"
	desc = "Silky and soft, but too thick to pass or cut!"

/obj/structure/flora/tree/fur/wall/attackby(obj/item/weapon/W, mob/living/user)
	return

/area/redgate/stardog
	name = "flesh abyss"
	icon_state = "redblatri"

/area/redgate/stardog/lounge
	name = "redgate lounge"
	icon_state = "redwhisqu"
	requires_power = 0

/area/redgate/stardog/outside
	name = "star dog"
	icon_state = "redblacir"
	semirandom = TRUE
	valid_mobs = list(
		list(
			/mob/living/simple_mob/vore/woof,
			/mob/living/simple_mob/vore/woof/hostile/ranged,
			/mob/living/simple_mob/vore/woof/hostile/terrible
			) = 100,
		list(
			/mob/living/simple_mob/vore/wolf,
			/mob/living/simple_mob/vore/wolf/direwolf,
			/mob/living/simple_mob/vore/greatwolf
			) = 50,
		list(
			/mob/living/simple_mob/vore/otie,
			/mob/living/simple_mob/vore/otie/friendly/chubby,
			/mob/living/simple_mob/vore/otie/red,
			/mob/living/simple_mob/vore/otie/red/chubby
		) = 50,
		list(
			/mob/living/simple_mob/animal/passive/dog/corgi,
			/mob/living/simple_mob/animal/passive/dog/brittany,
			/mob/living/simple_mob/animal/passive/dog/bullterrier,
			/mob/living/simple_mob/animal/passive/dog/tamaskan
		) = 1,
		list(
			/mob/living/simple_mob/animal/space/carp = 100,
			/mob/living/simple_mob/animal/space/carp/large = 25,
			/mob/living/simple_mob/animal/space/carp/large/huge = 10,
			/mob/living/simple_mob/animal/space/bats = 5,
			/mob/living/simple_mob/animal/space/bear = 5,
			/mob/living/simple_mob/animal/space/gnat = 5,
			/mob/living/simple_mob/animal/space/ray = 5,
			/mob/living/simple_mob/animal/space/shark = 5
		),
		list(
			/mob/living/simple_mob/vore/alienanimals/succlet = 50,
			/mob/living/simple_mob/vore/alienanimals/succlet/dark = 50,
			/mob/living/simple_mob/vore/alienanimals/succlet/moss = 50,
			/mob/living/simple_mob/vore/alienanimals/succlet/poison = 10,
			/mob/living/simple_mob/vore/alienanimals/succlet/big = 10,
			/mob/living/simple_mob/vore/alienanimals/succlet/king = 1
		) = 10
		)
	semirandom_groups = 5
	semirandom_group_min = 1
	semirandom_group_max = 10
	mob_intent = "retaliate"

/obj/structure/control_pod
	name = "node"
	desc = "Fleshy!"
	icon = 'icons/obj/flesh_machines.dmi'
	icon_state = "control_node0"

	density = TRUE
	anchored = TRUE
	pixel_x = -16
	pixel_y = -10
	unacidable = TRUE

	var/mob/living/simple_mob/vore/overmap/stardog/host
	var/mob/living/controller

/obj/structure/control_pod/Initialize(mapload)
	. = ..()
	set_up()

/obj/structure/control_pod/proc/set_up()
	var/obj/effect/overmap/visitable/ship/simplemob/stardog/s = get_overmap_sector(z)
	if(istype(s,/obj/effect/overmap/visitable/ship/simplemob/stardog))
		var/mob/living/simple_mob/vore/overmap/stardog/dog = s.parent
		if(!dog.control_node)
			host = dog
			dog.control_node = src

/obj/structure/control_pod/Destroy()
	if(host)
		host.control_node = null
		host = null
	return ..()

/obj/structure/control_pod/attack_hand(mob/living/user)
	. = ..()
	if(!host)
		set_up()
		if(!host)
			to_chat(user, "<span class = 'warning'>It doesn't respond...</span>")
			return
	if(controller)
		to_chat(user, "<span class = 'warning'>\The [controller] is already connected! There's no room for you right now!</span>")
		return
	control(user)

/obj/structure/control_pod/proc/control(mob/living/user)
	if(!host.affinity)
		to_chat(user, "<span class = 'warning'>As you press your hand to \the [src], it resists your advance... A sense of longing ripples through your mind...</span>")
		return
	if(controller)
		to_chat(user, "<span class = 'warning'>\The [controller] is already connected! There's no room for you right now!</span>")
		return
	user.visible_message("<span class = 'notice'>\The [user] reaches out to touch \the [src]...</span>","<span class = 'notice'>You reach out to touch \the [src]...</span>")
	if(!do_after(user, 10 SECONDS, src, exclusive = TRUE))
		user.visible_message("<span class = 'warning'>\The [user] pulls back from \the [src].</span>","<span class = 'warning'>You pull back from \the [src].</span>")
		return
	if(controller)
		to_chat(user, "<span class = 'warning'>\The [controller] is already connected! There's no room for you right now!</span>")
		return
	controller = user
	visible_message("<span class = 'warning'>\The [src] accepts \the [controller], submerging them beneath the surface of the flesh!</span>")
	user.forceMove(src)
	host.ckey = user.ckey
	log_admin("[host.ckey] has taken contol of \the [host].")
	icon_state = "control_node1"
	plane = ABOVE_MOB_PLANE
	set_light(5, 0.75, "#f94bff")

/obj/structure/control_pod/proc/eject()
	to_chat(host, "<span class = 'warning'>You feel your control over \the [host] slip away from you!</span>")
	controller.forceMove(get_turf(src))
	controller.ckey = host.ckey
	visible_message("<span class = 'warning'>\The [controller] is ejected from \the [src], tumbling free!</span>")
	log_admin("[controller.ckey] is no longer controlling [host], they have been returned to their body, [controller].")
	controller = null
	icon_state = "control_node0"
	plane = OBJ_PLANE
	set_light(0)

/obj/effect/landmark/stardog
	name = "stardog landing"
	icon = 'icons/obj/landmark_vr.dmi'
	icon_state = "transition"

/obj/effect/landmark/stardog/Initialize()
	. = ..()
	var/area/a = get_area(src)
	name = a.name

/obj/machinery/computer/ship/navigation/verb/emote_beyond(message as message)
	set name = "Emote Beyond"
	set desc = "Emote to those beyond the ship!"
	set category = "IC"
	set src in oview(7)

	if(!isliving(usr))
		return
	var/mob/living/L = usr
	if(L.client.prefs.muted & MUTE_IC)
		to_chat(L, "<span class='warning'>You cannot speak in IC (muted).</span>")
		return
	if (!message)
		message = tgui_input_text(usr, "Type a message to emote.","Emote Beyond")
	message = sanitize_or_reflect(message,L)
	if (!message)
		return
	if (L.stat == DEAD)
		return L.say_dead(message)
	var/obj/effect/overmap/visitable/ship/s = get_overmap_sector(z)
	if(!s || !istype(s, /obj/effect/overmap/visitable/ship))
		to_chat(L, "<span class='warning'>You can't do that here.</span>")
		return

	log_subtle(message,L)
	message = "<span class='emote_subtle'><B>[L]</B> <I>[message]</I></span>"
	message = "<B>(From within \the [s]) </B>" + message
	message = encode_html_emphasis(message)

	var/undisplayed_message = "<span class='emote'><B>[L]</B> <I>does something too subtle for you to see.</I></span>"
	var/list/vis = get_mobs_and_objs_in_view_fast(get_turf(s),1,2)
	var/list/vis_mobs = vis["mobs"]
	vis_mobs |= L
	for(var/mob/M as anything in vis_mobs)
		if(isnewplayer(M))
			continue
		if(isobserver(M) && !L.is_preference_enabled(/datum/client_preference/whisubtle_vis) && !M.client?.holder)
			spawn(0)
				M.show_message(undisplayed_message, 2)
		else
			spawn(0)
				M.show_message(message, 2)
				if(M.is_preference_enabled(/datum/client_preference/subtle_sounds))
					M << sound('sound/talksounds/subtle_sound.ogg', volume = 50)

/area/redgate/stardog/eyes

	name = "eye"
	icon_state = "bluwhicir"

	var/list/our_eyes = list()


/area/redgate/stardog/eyes/Entered(mob/M)
	. = ..()
	consider_eyes()

/area/redgate/stardog/eyes/Exited(atom/movable/AM, newLoc)
	. = ..()
	consider_eyes()

/area/redgate/stardog/eyes/proc/consider_eyes()
	var/close = FALSE
	var/list/check = get_area_turfs(/area/redgate/stardog/eyes)
	for(var/turf/t in check)
		for(var/thing in t.contents)
			if(istype(thing, /obj/effect/dog_eye))
				continue
			if(isobj(thing) || ismob(thing))
				close = TRUE

	for(var/obj/effect/dog_eye/e in our_eyes)
		if(close)
			e.icon_state = "eye_closed"
		else
			e.icon_state = "eye_open"

/obj/effect/dog_eye
	name = "eye"
	desc = "It's peeking!"
	icon = 'icons/obj/flesh_machines.dmi'
	icon_state = "eye_open"
	anchored = TRUE

	pixel_x = -16

/obj/effect/dog_nose
	name = "nose"
	desc = "Good for sniffin' with!"
	icon = 'icons/obj/flesh_machines.dmi'
	icon_state = "nose"
	anchored = TRUE

/obj/effect/dog_eye/Initialize()
	. = ..()
	var/area/redgate/stardog/eyes/e = get_area(src)
	if(istype(e,/area/redgate/stardog/eyes))
		e.our_eyes |= src

/obj/effect/dog_teleporter
	name = "mouth"
	desc = "It's waiting to accept treats!"
	icon = 'icons/obj/flesh_machines.dmi'
	icon_state = "mouth"
	invisibility = 0
	anchored = TRUE
	var/id = "mouth"
	var/static/list/dog_teleporters = list()
	var/reciever = FALSE
	var/obj/effect/dog_teleporter/target

/obj/effect/dog_teleporter/Initialize()
	. = ..()
	dog_teleporters |= src
	do_setup()

/obj/effect/dog_teleporter/proc/do_setup()
	if(target)
		return
	for(var/obj/effect/dog_teleporter/T in dog_teleporters)
		if(!istype(T,/obj/effect/dog_teleporter))
			dog_teleporters -= T
			continue
		if(id == T.id)
			if(T == src)
				continue
			target = T
			if(!T.target)
				T.target = src

/obj/effect/dog_teleporter/Crossed(atom/movable/AM as mob|obj)
	. = ..()
	lets_go(AM)

/obj/effect/dog_teleporter/proc/lets_go(atom/movable/AM as mob|obj)
	if(reciever)
		return
	if(!target)
		do_setup()
	if(!target)
		return
	if(isliving(AM))
		var/mob/living/L = AM
		if(!L.devourable || !L.allowmobvore)
			return
	AM.forceMove(get_turf(target))

/obj/effect/dog_teleporter/reciever
	reciever = TRUE

/obj/effect/dog_teleporter/exit
	name = "exit"
	desc = "You can see the light at the end of the tunnel!"
	icon_state = "exit_b"
	id = "exit"
	pixel_x = -16
	pixel_y = -16

/obj/effect/dog_teleporter/exit/Initialize()
	. = ..()

	set_light(5, 1, "#ffffff")

/obj/effect/dog_teleporter/reciever/mouth
	name = "light"
	desc = "It's too far up to make your way back out!"
	icon_state = "exit_b"
	id = "mouth"
	pixel_x = -16
	pixel_y = -16

/obj/effect/dog_teleporter/reciever/mouth/Initialize()
	. = ..()

	set_light(5, 1, "#ffffff")

/obj/effect/dog_teleporter/reciever/exit
	name = "exit"
	desc = "It's too tight to go in there!"
	icon_state = "exit"
	id = "exit"
	pixel_x = -16
	pixel_y = -16
