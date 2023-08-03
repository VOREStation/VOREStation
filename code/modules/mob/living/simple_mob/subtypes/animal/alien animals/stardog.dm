//I'm sorry for this file, no one should have to deal with this
//I am in a pain trance and coding is the only thing that can distract me
//I am a dwarf in a fey mood, but what I make will not be a masterwork, woe

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
	player_msg = "The dog accepts you into itself, allowing you to dictate what will happen. The dog occasionally thinks unknowable thoughts, though you can understand some of its needs and desires. The dog shares its experience with you. You can navigate space, 'transition' to certain locations, and you can dine upon some of the space weather. The dog doesn't seem to know how any of this works exactly, this is just how things are for the dog, they come as naturally to the dog as blinking."

	var/affinity = 0
	var/obj/structure/control_pod/control_node = null
	var/shipvore = FALSE	//Enable this to allow the star dog to eat spaceships by dragging them onto its sprite.
	var/admin_override = FALSE	//If true, makes affinity and nutrition irrelevant.
	var/list/weather_areas = list()	//We'll call a proc on these areas when we eat, don't worry!

/mob/living/simple_mob/vore/overmap/stardog/Login()
	. = ..()
	verbs -= /mob/living/simple_mob/proc/set_name
	verbs -= /mob/living/simple_mob/proc/set_desc

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
	if(admin_override)
		affinity = 9999
		nutrition = 9999
	if(devourable)	//This will cause problems probably so please do not eat the dog
		devourable = FALSE
		digestable = FALSE
	if(ckey && control_node)
		if(nutrition <= 200)
			adjust_affinity(-10)
		else if(nutrition < 500)
			adjust_affinity(-3)
		else
			adjust_affinity(-1)
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

/mob/living/simple_mob/vore/overmap/stardog/perform_the_nom(mob/living/user, mob/living/prey, mob/living/pred, obj/belly/belly, delay)
	to_chat(src, "<span class='warning'>You can't do that.</span>")	//The dog can move back and forth between the overmap.
	return															//If it can do normal vore mechanics, it can carry players to the OM,
																	//and release them there. I think that's probably a bad idea.

/mob/living/simple_mob/vore/overmap/stardog/Initialize()
	. = ..()
	child_om_marker.set_light(5, 1, "#ff8df5")

/mob/living/simple_mob/vore/overmap/stardog/Destroy()
	if(control_node)
		control_node.host = null
		control_node = null
	for(var/anything in weather_areas)
		weather_areas -= anything
	return ..()

/mob/living/simple_mob/vore/overmap/stardog/Stat()
	..()
	if(statpanel("Status"))
		stat(null, "Affinity: [round(affinity)]")

/mob/living/simple_mob/vore/overmap/stardog/start_pulling(var/atom/movable/AM)
	if(!istype(loc, /turf/unsimulated/map))	//Don't pull stuff on the overmap
		..()

/mob/living/simple_mob/vore/overmap/stardog/proc/adjust_affinity(amount)
	if(amount > 0)
		var/multiplier = nutrition / 250
		affinity += (amount * multiplier)
	if(amount < 0)
		affinity += amount
	if(affinity <= 0)
		affinity = 0
	if(affinity > 1000)
		affinity = 1000

/mob/living/simple_mob/vore/overmap/stardog/verb/eject()
	set name = "Eject"
	set desc = "Stop controlling the dog and return to your own body."
	set category = "Abilities"

	control_node.eject()

/mob/living/simple_mob/vore/overmap/stardog/verb/eat_space_weather()
	set name = "Eat Space Weather"
	set desc = "Eat carp or rocks!"
	set category = "Abilities"

	var/obj/effect/overmap/event/E
	var/nut = 0
	var/aff = 0
	var/mob = FALSE
	var/ore = 0
	var/tre = 0
	var/msg = "REPLACE ME"
	var/heal = FALSE
	var/delet = TRUE

	for(var/obj/effect/overmap/event/e in loc)
		if(istype(e, /obj/effect/overmap/event/carp))
			E = e
			nut = 250
			aff = -50
			mob = TRUE
			var/list/msglist = list(
				"You lap up \the [E]. They're pretty filling, but you don't really like the taste...",
				"You lap up \the [E]. You can feel them wiggle all the way down... They don't taste very good, but you feel energized afterward.",
				"You lap up \the [E]. They flee away from you, attempting to scatter in all directions, but you're faster! They leave an unpleasant taste on your tongue, but your belly doesn't seem to mind them."
			)
			msg = pick(msglist)
		else if(istype(e, /obj/effect/overmap/event/dust))
			E = e
			aff = -100
			tre = 15
			ore = 25
			var/list/msglist = list(
				"You lap up \the [E]. The dust clings to your mouth and throat!!! You cough and splutter unhappily! It is literally space dirt, and it tastes like it!",
				"You lap up \the [E]. The bitter taste of the dust sticks to your tongue and takes a lot of work to get off! It's really frustrating!",
				"You lap up \the [E]. Not only does it taste horrible and feel worse going down, some of it gets in your eyes!"
			)
			msg = pick(msglist)
		else if(istype(e, /obj/effect/overmap/event/meteor))
			E = e
			aff = -200
			tre = 5
			ore = 100
			var/list/msglist = list(
				"You lap up \the [E]. The rocks roll down your gullet haphazardly. Some of them knock together and clatter their way down, while others turn to powder. Some of them even have some pretty sharp edges that don't feel very nice! They certainly don't taste very nice, and they weight heavily inside of your belly...",
				"You lap up \the [E]. When they land inside you can feel the weight of them settle in. They make your insides kind of queasy...",
				"You lap up \the [E]. They taste like rocks, and make you think of all the better things you could be eating..."
			)

			msg = pick(msglist)
		else if(istype(e, /obj/effect/overmap/event/electric))
			E = e
			aff = 15
			msg = "You try to eat \the [E], but you find that no matter how much of it you lick or homn upon, yet more remains! It makes your mouth tingle, and your fur stand on end! It's kind of fun, but it doesn't taste like anything, and you definitely don't feel any more full."
			delet = FALSE
		else if(istype(e, /obj/effect/overmap/event/ion))
			E = e
			aff = 20
			msg = "When you approach \the [E], you find that the dog's will pulls away from your own a little bit. It seems to really like the shimmering clouds, and it feels really good to nestle up among them. Like taking a relaxing dip into a regenerative spring. Any aches and pains that the dog was experiencing seem to fade away, leaving it feeling refreshed!"
			heal = TRUE
			delet = FALSE
		else
			to_chat(src, "<span class='warning'>You can't eat \the [e].</span>")
			return

	if(!E)
		to_chat(src, "<span class='warning'>There isn't anything to eat here.</span>")
		return

	to_chat(src, "<span class='notice'>You begin to eat \the [E]...</span>")

	if(!do_after(src, 20 SECONDS, E, exclusive = TRUE))
		return
	to_chat(src, "<span class='notice'>[msg]</span>")
	if(nut || aff)
		adjust_nutrition(nut)
		adjust_affinity(aff)
	if(mob)
		spawn_mob()
		to_chat(src, "<span class='notice'>You can feel something moving inside of you...</span>")
	if(ore)
		spawn_ore(ore)
	if(tre)
		spawn_treasure(tre)
	if(heal)
		adjustFireLoss(-999)
		adjustBruteLoss(-999)
	if(delet)
		qdel(E)

/mob/living/simple_mob/vore/overmap/stardog/proc/spawn_mob()
	for(var/area/redgate/stardog/flesh_abyss/a in weather_areas)
		if(istype(a, /area/redgate/stardog/flesh_abyss))
			a.spawn_mob()
/mob/living/simple_mob/vore/overmap/stardog/proc/spawn_ore(chance)
	for(var/area/redgate/stardog/flesh_abyss/a in weather_areas)
		if(istype(a, /area/redgate/stardog/flesh_abyss) && prob(chance))
			a.spawn_ore()
/mob/living/simple_mob/vore/overmap/stardog/proc/spawn_treasure(chance)
	for(var/area/redgate/stardog/flesh_abyss/a in weather_areas)
		if(istype(a, /area/redgate/stardog/flesh_abyss) && prob(chance))
			a.spawn_treasure()

/mob/living/simple_mob/vore/overmap/stardog/verb/transition()	//Don't ask how it works. I don't know. I didn't think about it. I just thought it would be cool.
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
				our_maps |= our_z
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
		for(var/obj/effect/landmark/stardog/l in destinations)
		var/obj/effect/overmap/visitable/our_dest = tgui_input_list(src, "Where would you like to try to go?", "Transition", destinations, timeout = 15 SECONDS, strict_modern = TRUE)
		if(!our_dest)
			to_chat(src, "<span class='warning'>You decide not to transition.</span>")
			return
		to_chat(src, "<span class='notice'>You begin to transition down to \the [our_dest], stay still...</span>")
		if(!do_after(src, 15 SECONDS, exclusive = TRUE))
			to_chat(src, "<span class='warning'>You were interrupted.</span>")
			return
		visible_message("<span class='warning'>\The [src] disappears!!!</span>")
		stop_pulling()
		forceMove(get_turf(our_dest))
		adjust_nutrition(-1000)
		visible_message("<span class='warning'>\The [src] steps into the area as if from nowhere!</span>")

	else
		to_chat(src, "<span class='notice'>You begin to transition back to space, stay still...</span>")
		if(!do_after(src, 15 SECONDS, exclusive = TRUE))
			to_chat(src, "<span class='warning'>You were interrupted.</span>")
			return

		visible_message("<span class='warning'>\The [src] disappears!!!</span>")
		stop_pulling()
		forceMove(get_turf(get_overmap_sector(z)))
		adjust_nutrition(-500)


/obj/effect/overmap/visitable/ship/simplemob/stardog
	icon = 'icons/obj/overmap.dmi'
	icon_state = "ship"
	skybox_icon = 'icons/skybox/anomaly.dmi'
	skybox_icon_state = "space_dog"
	skybox_pixel_x = 0
	skybox_pixel_y = 0
	glide_size = 2
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

/turf/simulated/floor/outdoors/fur/attackby()
	return

/turf/simulated/floor/outdoors/fur/attack_hand(mob/user)
	. = ..()
	pet()

/turf/simulated/floor/outdoors/fur/ex_act(severity)
	return


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
	tree_chance = 0

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

/turf/simulated/floor/outdoors/fur/verb/emote_beyond(message as message)	//Now even the stars will know your sin.
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
	var/static/list/mob_list = list(	//Just, all the vore mobs. If some of the paths weren't shitty I would just put like `subtypesof(/mob/living/simple_mob/vore)` here. Maybe I'll fix that later, I am dying right now, I hope I will be remembered fondly when I die
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
	return

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
		s.ghostjoin = TRUE
		s.ghostjoin_icon()

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
	name = "dog"
/area/redgate/stardog/flesh_abyss
	name = "flesh abyss"
	icon_state = "redblatri"
	forced_ambience = list('sound/vore/stomach_loop.ogg', 'sound/vore/sunesound/prey/loop.ogg')
	floracountmax = 0
	valid_flora = list(
		/obj/structure/outcrop/coal = 10,
		/obj/structure/outcrop/diamond = 1,
		/obj/structure/outcrop/gold = 3,
		/obj/structure/outcrop/iron = 10,
		/obj/structure/outcrop/lead = 6,
		/obj/structure/outcrop/phoron = 10,
		/obj/structure/outcrop/platinum = 5,
		/obj/structure/outcrop/silver = 8,
		/obj/structure/outcrop/uranium = 3,
		/obj/random/outcrop = 5
	)

	semirandom = TRUE
	semirandom_groups = 1
	semirandom_group_min = 5
	semirandom_group_max = 15
	mob_intent = "retaliate"
	valid_mobs = list(
		list(
			/mob/living/simple_mob/vore/vore_hostile/abyss_lurker = 100,
			/mob/living/simple_mob/vore/vore_hostile/leaper = 100,
			/mob/living/simple_mob/vore/vore_hostile/gelatinous_cube = 10
			)
			)

	var/mob_chance = 10
	var/treasure_chance = 50
	var/list/valid_treasure = list(
		/obj/item/weapon/cell/infinite = 5,
		/obj/item/weapon/cell/device/weapon/recharge/alien = 5,
		/obj/item/device/nif/authentic = 1,
		/obj/item/toy/bosunwhistle = 50,
		/obj/random/mouseray = 50,
		/obj/item/weapon/gun/energy/mouseray/metamorphosis/advanced/random = 10,
		/obj/item/weapon/gun/energy/mouseray/metamorphosis/advanced = 5,
		/obj/item/clothing/mask/gas/voice = 25,
		/obj/item/device/perfect_tele = 15,
		/obj/item/weapon/gun/energy/sizegun = 50,
		/obj/item/device/slow_sizegun = 50,
		/obj/item/capture_crystal/master = 5,
		/obj/item/capture_crystal/ultra = 15,
		/obj/item/capture_crystal/great = 25,
		/obj/item/capture_crystal/random = 50,
		/obj/random/pizzabox = 10,	//The dog intercepted your pizza voucher delivery, what a scamp
		/obj/item/weapon/bluespace_harpoon = 15,
		/obj/random/awayloot = 5,
		/obj/random/cash = 15,
		/obj/random/cash/big = 10,
		/obj/random/cash/huge = 5,
		/obj/random/maintenance/clean = 10,
		/obj/random/maintenance/misc = 10
		)
	var/treasuremax = 3
	var/spawnstuff = TRUE
	var/include_enzyme = FALSE

/area/redgate/stardog/flesh_abyss/EvalValidSpawnTurfs()
	for(var/turf/simulated/floor/F in src)
		if(istype(F, /turf/simulated/floor/flesh))
			valid_spawn_turfs |= F

		if(include_enzyme)
			if(istype(F, /turf/simulated/floor/water/digestive_enzymes))
				valid_spawn_turfs |= F

/area/redgate/stardog/flesh_abyss/spawn_flora_on_turf()
	if(!spawnstuff)
		return
	if(!valid_flora.len)
		to_world_log("[src] does not have a set valid flora list!")
		return TRUE

	var/obj/F
	var/turf/Turf
	var/howmany = rand(0,floracountmax)
	for(var/floracount = 1 to howmany)
		F = pickweight(valid_flora)
		Turf = pick(valid_spawn_turfs)
		if(!Turf.check_density())
			new F(Turf)

/area/redgate/stardog/flesh_abyss/spawn_mob_on_turf()
	if(!spawnstuff)
		return
	if(!valid_mobs.len)
		to_world_log("[src] does not have a set valid mobs list!")
		return TRUE

	var/mob/M
	var/turf/Turf
	if(semirandom)
		for(var/groupscount = 1 to (semirandom_groups))
			var/ourgroup = pickweight(valid_mobs)
			var/goodnum = rand(semirandom_group_min, semirandom_group_max)
			for(var/mobscount = 1 to (goodnum))
				M = pickweight(ourgroup)
				Turf = pick(valid_spawn_turfs)
				if(!Turf.check_density())
					var/mob/ourmob = new M(Turf)
					adjust_mob(ourmob)
	else
		for(var/mobscount = 1 to mobcountmax)
			M = pickweight(valid_mobs)
			Turf = pick(valid_spawn_turfs)
			if(!Turf.check_density())
				var/mob/ourmob = new M(Turf)
				adjust_mob(ourmob)

/area/redgate/stardog/flesh_abyss/proc/spawn_mob()
	if(!spawnstuff)
		return
	if(!valid_mobs.len)
		to_world_log("[src] does not have a set valid mobs list!")
		return

	if(!prob(mob_chance))
		return
	var/mob/M
	var/turf/Turf
	var/goodnum = rand(semirandom_group_min, semirandom_group_max)
	for(var/mobscount = 1 to goodnum)
		M = pickweight(pickweight(valid_mobs))
		Turf = pick(valid_spawn_turfs)
		if(!Turf.check_density())
			var/mob/ourmob = new M(Turf)
			adjust_mob(ourmob)

/area/redgate/stardog/flesh_abyss/proc/spawn_ore()
	if(!spawnstuff)
		return
	if(!valid_flora.len)
		to_world_log("[src] does not have a set valid flora list!")
		return

	var/obj/F
	var/turf/Turf
	var/howmany = rand(1,floracountmax)
	for(var/ore = 1 to howmany)
		F = pickweight(valid_flora)
		Turf = pick(valid_spawn_turfs)
		if(!Turf.check_density())
			new F(Turf)

/area/redgate/stardog/flesh_abyss/proc/spawn_treasure()
	if(!spawnstuff)
		return
	if(treasure_chance <= 0)
		return
	if(!valid_treasure.len)
		to_world_log("[src] does not have a set valid treasure list!")
		return

	var/obj/F
	var/turf/Turf
	var/howmany = rand(1,treasuremax)
	for(var/treasure = 1 to howmany)
		if(prob(treasure_chance))
			continue
		F = pickweight(valid_treasure)
		Turf = pick(valid_spawn_turfs)
		if(!Turf.check_density())
			new F(Turf)

/area/redgate/stardog/flesh_abyss/no_spawn
	icon_state = "blublacir"
	semirandom_groups = 0
	semirandom_group_min = 0
	semirandom_group_max = 0

	valid_mobs = null
	spawnstuff = FALSE

/area/redgate/stardog/flesh_abyss/digestive_tract
	icon_state = "greblacir"
	semirandom_groups = 1
	semirandom_group_min = 1
	semirandom_group_max = 10
	include_enzyme = TRUE
	valid_mobs = list(
		list(
		/mob/living/simple_mob/vore/vore_hostile/abyss_lurker = 10,
		/mob/living/simple_mob/vore/vore_hostile/leaper = 20,
		/mob/living/simple_mob/vore/vore_hostile/gelatinous_cube = 100
		)
		)

/area/redgate/stardog/flesh_abyss/stomach
	floracountmax = 3
	valid_flora = list(
		/obj/structure/outcrop/coal = 10,
		/obj/structure/outcrop/diamond = 1,
		/obj/structure/outcrop/gold = 3,
		/obj/structure/outcrop/iron = 10,
		/obj/structure/outcrop/lead = 6,
		/obj/structure/outcrop/phoron = 10,
		/obj/structure/outcrop/platinum = 5,
		/obj/structure/outcrop/silver = 8,
		/obj/structure/outcrop/uranium = 3,
		/obj/random/outcrop = 5
	)
	semirandom = FALSE
	semirandom_groups = 1
	semirandom_group_min = 1
	semirandom_group_max = 3
	valid_mobs = list(
		list(
			/mob/living/simple_mob/animal/space/carp/event = 100,
			/mob/living/simple_mob/animal/space/carp/large = 25,
			/mob/living/simple_mob/animal/space/carp/large/huge = 5,
			/mob/living/simple_mob/vore/alienanimals/space_jellyfish = 100
			)
		)
	mob_chance = 10
	treasure_chance = 25
	treasuremax = 1
	spawnstuff = TRUE

/area/redgate/stardog/flesh_abyss/s_int
	floracountmax = 1
	valid_flora = list(
		/obj/structure/outcrop/coal = 5,
		/obj/structure/outcrop/diamond = 2,
		/obj/structure/outcrop/gold = 3,
		/obj/structure/outcrop/iron = 7,
		/obj/structure/outcrop/lead = 3,
		/obj/structure/outcrop/phoron = 5,
		/obj/structure/outcrop/platinum = 5,
		/obj/structure/outcrop/silver = 8,
		/obj/structure/outcrop/uranium = 3,
		/obj/random/outcrop = 5
	)
	semirandom = FALSE
	semirandom_groups = 1
	semirandom_group_min = 1
	semirandom_group_max = 3
	valid_mobs = list(
		list(
			/mob/living/simple_mob/animal/space/carp/event = 100,
			/mob/living/simple_mob/animal/space/carp/large = 25,
			/mob/living/simple_mob/animal/space/carp/large/huge = 5,
			/mob/living/simple_mob/vore/alienanimals/space_jellyfish = 100
			)
		)
	mob_chance = 5
	treasure_chance = 33
	treasuremax = 5
	spawnstuff = TRUE

/area/redgate/stardog/flesh_abyss/l_int
	floracountmax = 5
	valid_flora = list(
		/obj/structure/outcrop/diamond = 3,
		/obj/structure/outcrop/gold = 3,
		/obj/structure/outcrop/iron = 5,
		/obj/structure/outcrop/phoron = 1,
		/obj/structure/outcrop/platinum = 5,
		/obj/structure/outcrop/silver = 8,
		/obj/structure/outcrop/uranium = 3,
		/obj/random/outcrop = 1
	)
	semirandom = FALSE
	semirandom_groups = 1
	semirandom_group_min = 1
	semirandom_group_max = 1
	valid_mobs = list(
		list(
			/mob/living/simple_mob/animal/space/carp/event = 100,
			/mob/living/simple_mob/animal/space/carp/large = 25,
			/mob/living/simple_mob/animal/space/carp/large/huge = 5,
			/mob/living/simple_mob/vore/alienanimals/space_jellyfish = 100
			)
		)
	mob_chance = 5
	treasure_chance = 50
	treasuremax = 5
	spawnstuff = TRUE

/area/redgate/stardog/flesh_abyss/node
	enter_message = "<span class='notice'>Radical energy hangs as a haze in the air. It's much less hot here than other places within the dog, but the air is thick with alien whispers and desires that you can hardly comprehend.</span>"
	icon_state = "yelwhisqu"
	requires_power = 0
	spawnstuff = FALSE

/area/redgate/stardog/flesh_abyss/play_ambience(var/mob/living/L, initial = TRUE)
	if(!L.is_preference_enabled(/datum/client_preference/digestion_noises))
		return
	..()

/area/redgate/stardog/lounge
	name = "redgate lounge"
	icon_state = "redwhisqu"
	requires_power = 0
	forced_ambience = list()

/area/redgate/stardog/outside
	name = "star dog"
	icon_state = "redblacir"
	semirandom = TRUE
	ghostjoin = TRUE
	forced_ambience = list()
	valid_mobs = list(	//Dog map spawns the dogs. It's not hard to understand!
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
		list(	//The succlets can come too I guess lol
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

/obj/structure/control_pod	//god someone is going to try to fuck with this, everyone is going to be angry, I'm so sorry
	name = "node"
	desc = "A smooth node of nerves and flesh. It seems almost to radiate whispers of alien thought and emotion."
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
	control(user)

/obj/structure/control_pod/proc/control(mob/living/user)
	if(!host.affinity)	//take care of my dog
		to_chat(user, "<span class = 'warning'>As you press your hand to \the [src], it resists your advance... A sense of longing ripples through your mind...</span>")
		return
	if(controller)	//busy
		to_chat(user, "<span class = 'warning'>You can see \the [controller] inside! Tendrils of nerves seem to have attached themselves to \the [controller]! There's no room for you right now!</span>")
		return
	user.visible_message("<span class = 'notice'>\The [user] reaches out to touch \the [src]...</span>","<span class = 'notice'>You reach out to touch \the [src]...</span>")
	if(!do_after(user, 10 SECONDS, src, exclusive = TRUE))
		user.visible_message("<span class = 'warning'>\The [user] pulls back from \the [src].</span>","<span class = 'warning'>You pull back from \the [src].</span>")
		return
	if(controller)	//got busy while you were waiting, get rekt
		to_chat(user, "<span class = 'warning'>You can see \the [controller] inside! Tendrils of nerves seem to have attached themselves to \the [controller]! There's no room for you right now!</span>")
		return
	controller = user
	visible_message("<span class = 'warning'>\The [src] accepts \the [controller], submerging them beneath the surface of the flesh!</span>")
	user.stop_pulling()
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
	icon_state = "control_node0"
	plane = OBJ_PLANE
	set_light(0)
	var/our_x = rand(-5,5) + x
	var/our_y = rand(-5,5) + y

	var/turf/throwtarg = locate(our_x, our_y, z)	//teehee
	spawn(0)
		playsound(src, 'sound/vore/schlorp.ogg', vol = 100, vary = FALSE, volume_channel = VOLUME_CHANNEL_VORE)
		controller.throw_at(throwtarg, 10, 1)
		controller = null

/obj/effect/landmark/stardog	//I didn't know how else to decide where the dog will land
	name = "stardog landing"
	icon = 'icons/obj/landmark_vr.dmi'
	icon_state = "transition"

/obj/effect/landmark/stardog/Initialize()
	. = ..()
	var/area/a = get_area(src)
	name = a.name

/obj/effect/landmark/area_gatherer
	name = "stardog area gatherer"
/obj/effect/landmark/area_gatherer/Initialize()
	. = ..()
	LateInitialize()

/obj/effect/landmark/area_gatherer/LateInitialize()	//I am very afraid
	var/obj/effect/overmap/visitable/ship/simplemob/stardog/s = get_overmap_sector(z)
	var/mob/living/simple_mob/vore/overmap/stardog/dog = s.parent
	dog.weather_areas |= get_area(src)
	for(var/thing in dog.weather_areas)
	qdel(src)

/obj/machinery/computer/ship/navigation/telescreen/dog_eye
	name = "visual nexus"
	desc = "A glowing bundle of nerves across which you can see what the dog sees."
	icon = 'icons/obj/flesh_machines.dmi'
	icon_state = "screen_eye"
	pixel_x = -16
	pixel_y = -16
	clicksound = 'sound/vore/squish1.ogg'

/obj/machinery/computer/ship/navigation/telescreen/dog_eye/attackby(I, user)
	return

/obj/machinery/computer/ship/navigation/telescreen/dog_eye/update_icon()
	. = ..()
	icon_state = "screen_eye"

/obj/machinery/computer/ship/navigation/verb/emote_beyond(message as message)	//I could have put this into any other file but right here will do
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

/area/redgate/stardog/eyes/proc/consider_eyes()	//CONSIDER THEM PLEASE
	var/close = FALSE
	var/list/check = get_area_turfs(/area/redgate/stardog/eyes)
	for(var/turf/t in check)
		for(var/thing in t.contents)
			if(istype(thing, /obj/effect/dog_eye))	//We can have eyes in our eyes, it's fine
				continue
			if(isobj(thing) || ismob(thing))
				close = TRUE	//AAAAAAAAAAAAAAAUUUUUUUUGHHHHHHHHH ITS IN MY EYES HELP

	for(var/obj/effect/dog_eye/e in our_eyes)
		if(close)
			e.icon_state = "eye_closed"	// u . u
		else
			e.icon_state = "eye_open"	// * w *

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

/obj/effect/dog_nose/attack_hand(mob/living/user)
	. = ..()
	user.visible_message("<span class='notice'>\The [user] boops the snoot.</span>","<span class='notice'>You boop the snoot.</span>",runemessage = "boop")

/obj/effect/dog_nose/Crossed(atom/movable/AM as mob|obj)
	. = ..()
	sneef(AM)

/obj/effect/dog_nose/proc/sneef(mob/living/L)
	if(!isliving(L))
		return
	if(L.client)
		to_chat(L, "<span class='notice'>A hot breath rushes up from under your feet, before the air rushes back down into the dog's nose as the dog sniffs you! SNEEF SNEEF!!!</span>")

/obj/effect/dog_eye/Initialize()
	. = ..()
	var/area/redgate/stardog/eyes/e = get_area(src)
	if(istype(e,/area/redgate/stardog/eyes))
		e.our_eyes |= src

/obj/effect/dog_teleporter	//look, I could have just used a bump teleporter, and I don't have an excuse, also everyone is going to be angry but it hurts too much for me to care right now, hopefully I will finish this before I start caring
	name = "mouth"
	desc = "It's waiting to accept treats!"
	icon = 'icons/obj/flesh_machines.dmi'
	icon_state = "mouth"
	invisibility = 0
	anchored = TRUE
	pixel_x = -16
	var/id = "mouth_a"							//same id will be linked
	var/static/list/dog_teleporters = list()	//List of all the teleporters
	var/reciever = FALSE						//If true, doesn't teleport, only recieves
	var/obj/effect/dog_teleporter/target		//Target for teleporting to, automatically set by id
	var/throw_through = TRUE					//When moved the mob/obj will be thrown south
	var/teleport_sound = 'sound/vore/schlorp.ogg'	//The sound that plays when we use the teleporter. Respects vore sound preferences.
	var/teleport_message = ""

/obj/effect/dog_teleporter/Initialize()
	. = ..()
	dog_teleporters |= src
	do_setup()
	if(icon_state == "exit_b")	//♪♫Blinded by the light♪♫
		set_light(5, 1, "#ffffff")

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

/obj/effect/dog_teleporter/Crossed(atom/movable/AM as mob|obj)	//I am ashamed to admit how long it took to get this to do anything
	. = ..()
	lets_go(AM)

/obj/effect/dog_teleporter/proc/lets_go(atom/movable/AM as mob|obj)	//Wahoo! Here we go!
	if(reciever)
		return
	if(!target)
		do_setup()
	if(!target)
		return
	var/mob/living/L = null
	if(isliving(AM))
		L = AM
		if(!L.devourable || !L.allowmobvore)
			return
		L.stop_pulling()
		L.Weaken(3)
	if(target.reciever)		//We don't have to worry
		AM.unbuckle_all_mobs(TRUE)
		playsound(src, teleport_sound, vol = 100, vary = 1, preference = /datum/client_preference/eating_noises, volume_channel = VOLUME_CHANNEL_VORE)
		AM.forceMove(get_turf(target))
		extra(AM)
		return
	var/turf/place = locate(target.x, (target.y - 1), target.z)	//If the target is also a teleporter, let's pick a place to set them down next to the target.
	L.Weaken(3)													//Setting them ON the target will probably make an infinite loop, and that seems lame.
	AM.unbuckle_all_mobs(TRUE)
	playsound(src, teleport_sound, vol = 100, vary = 1, preference = /datum/client_preference/eating_noises, volume_channel = VOLUME_CHANNEL_VORE)
	AM.forceMove(place)
	extra(AM)

/obj/effect/dog_teleporter/proc/extra(atom/movable/AM as mob|obj)
	var/go = FALSE
	if(isliving(AM))
		var/mob/living/L = AM
		if(teleport_message && L.client)
			to_chat(src, "[teleport_message]")
		go = TRUE
	if(isobj(AM))
		go = FALSE

	if(!go)
		return

	visible_message("<span class='danger'>\The [AM] passes through \the [src]!</span>")
	if(throw_through)	//We will throw the target to the south!
		var/turf/throwtarg = locate(target.x, (target.y - 5), target.z)
		spawn(0)
			AM.throw_at(throwtarg, 10, 1)	//reverbfart.ogg

/obj/effect/dog_teleporter/food_gobbler
	teleport_sound = 'sound/vore/gulp.ogg'
	teleport_message = "<span class='notice'>The thundering drum of the dog's heart beat throbs all around you, while the sweltering heat of its body soaks into you. It's soft and wet as a symphony of gurgles and glorps fills the steamy air!</span>"

/obj/effect/dog_teleporter/food_gobbler/Crossed(atom/movable/AM)

	if(istype(AM, /obj/item/weapon/reagent_containers/food))
		gobble_food(AM)
	else return	..()

/obj/effect/dog_teleporter/food_gobbler/proc/gobble_food(obj/item/I)
	if(!isitem(I))
		return
	var/obj/effect/overmap/visitable/ship/simplemob/stardog/s = get_overmap_sector(z)
	if(s && istype(s,/obj/effect/overmap/visitable/ship/simplemob/stardog))
		if(!s.parent)
			return
		var/mob/living/simple_mob/vore/overmap/stardog/dog = s.parent
		dog.adjust_nutrition(I.reagents.total_volume)
		dog.adjust_affinity(25)
		playsound(src, teleport_sound, vol = 100, vary = 1, preference = /datum/client_preference/eating_noises, volume_channel = VOLUME_CHANNEL_VORE)
		visible_message("<span class='warning'>The dog gobbles up \the [I]!</span>")
		if(dog.client)
			to_chat(dog, "<span class='notice'>[I.thrower ? "\The [I.thrower]" : "Someone"] feeds \the [I] to you!</span>")
		qdel(I)

/obj/effect/dog_teleporter/reciever
	name = "exit"
	desc = "It's too tight to go in there!"
	icon_state = "exita"
	pixel_y = -16
	reciever = TRUE

/obj/effect/dog_teleporter/reciever/invisible
	invisibility = INVISIBILITY_ABSTRACT
	reciever = TRUE
	id = "mouth_a"

/obj/effect/dog_teleporter/reciever/invisible/mouth_return
	invisibility = INVISIBILITY_ABSTRACT
	reciever = TRUE
	id = "mouth_b"

/obj/effect/dog_teleporter/exit
	name = "exit"
	desc = "You can see the light at the end of the tunnel!"
	icon_state = "exit_b"
	id = "exit"
	pixel_x = -16
	pixel_y = -16

/obj/effect/dog_teleporter/mouth_return
	name = "light"
	desc = "You can see the light shining in from above!"
	icon_state = "exit_b"
	id = "mouth_b"
	pixel_x = -16
	pixel_y = -16

/obj/effect/dog_teleporter/reciever/exit	//tee hee
	name = "exit"
	desc = "It's too tight to go in there!"
	icon_state = "exit"
	id = "exit"
	pixel_x = -16
	pixel_y = -16
	layer = ABOVE_TURF_LAYER
	plane = TURF_PLANE

/turf/simulated/floor/water/digestive_enzymes	//I'm sorry - Medical is going to be really angry. I hope people don't go ';HELP, HELP IN THE FLESH ABYSS!!!' but I know they will
	name = "digestive enzymes"
	desc = "A body of some kind of green fluid.  It seems shallow enough to walk through, if needed."
	icon = 'icons/turf/stomach_vr.dmi'
	icon_state = "composite"
	water_icon = 'icons/turf/stomach_vr.dmi'
	water_state = "enzyme_shallow"
	under_state = "flesh_floor"

	reagent_type = "Sulphuric acid"	//why not
	outdoors = FALSE
	var/mob/living/simple_mob/vore/overmap/stardog/linked_mob
	var/mobstuff = TRUE		//if false, we don't care about dogs, and that's terrible
	var/we_process = FALSE	//don't start another process while you're processing, idiot

/turf/simulated/floor/water/digestive_enzymes/Entered(atom/movable/AM)
	if(digest_stuff(AM) && !we_process)
		START_PROCESSING(SSturfs, src)
		we_process = TRUE

/turf/simulated/floor/water/digestive_enzymes/hitby(atom/movable/AM)
	if(digest_stuff(AM) && !we_process)
		START_PROCESSING(SSturfs, src)
		we_process = TRUE

/turf/simulated/floor/water/digestive_enzymes/process()
	if(!digest_stuff())
		we_process = FALSE
		return PROCESS_KILL

/turf/simulated/floor/water/digestive_enzymes/proc/can_digest(atom/movable/AM as mob|obj)
	. = FALSE
	if(AM.loc != src)
		return FALSE
	if(isitem(AM))
		var/obj/item/I = AM
		if(I.unacidable || I.throwing || I.is_incorporeal())
			return FALSE
		var/food = FALSE
		if(istype(I,/obj/item/weapon/reagent_containers/food))
			food = TRUE
		if(prob(95))	//Give people a chance to pick them up
			return TRUE
		I.visible_message("<span class='warning'>\The [I] sizzles...</span>")
		var/yum = I.digest_act()	//Glorp
		if(istype(I , /obj/item/weapon/card))
			yum = 0		//No, IDs do not have infinite nutrition, thank you
		if(mobstuff && linked_mob && yum)
			if(food)
				yum += 50
			linked_mob.adjust_nutrition(yum)
		return TRUE
	if(isliving(AM))
		var/mob/living/L = AM
		if(L.unacidable || !L.digestable || L.buckled || L.hovering || L.throwing || L.is_incorporeal())
			return FALSE
		if(ishuman(L))
			var/mob/living/carbon/human/H = L
			if(!H.pl_suit_protected())
				return TRUE
			if(H.resting && !H.pl_head_protected())
				return TRUE
		else return TRUE

/turf/simulated/floor/water/digestive_enzymes/proc/digest_stuff(atom/movable/AM)	//I'm so sorry
	. = FALSE

	var/damage = 1
	if(mobstuff && !linked_mob)	//You might be wondering how we got here. It all started when I decided that I would make a vore level and make some of the turfs affect some mob somewhere in the world. So I used some convenient tools that people who are actually smart made, to make this horrible abomination.
		var/obj/effect/overmap/visitable/ship/simplemob/stardog/s = get_overmap_sector(z)
		if(s && istype(s,/obj/effect/overmap/visitable/ship/simplemob/stardog))
			linked_mob = s.parent	//dogge

	if(linked_mob)	//Please for the love of all that is good, make all this mob shit its own proc, future me
		damage += clamp(((500 - linked_mob.nutrition) / 100), 1 , 5)
	var/list/stuff = list()
	for(var/thing in src)
		if(can_digest(thing))
			stuff |= thing
	if(!stuff.len)
		return FALSE
	var/thing = pick(stuff)	//We only think about one thing at a time, otherwise things get wacky
	. = TRUE
	if(ishuman(thing))
		var/mob/living/carbon/human/H = thing
		if(!H)
			return
		visible_message(runemessage = "blub...")
		if(H.stat == DEAD)
			H.unacidable = TRUE	//Don't touch this one again, we're gonna delete it in a second
			H.release_vore_contents()
			for(var/obj/item/W in H)
				if(istype(W, /obj/item/organ/internal/mmi_holder/posibrain))
					var/obj/item/organ/internal/mmi_holder/MMI = W
					MMI.removed()
				if(istype(W, /obj/item/weapon/implant/backup) || istype(W, /obj/item/device/nif) || istype(W, /obj/item/organ))
					continue
				H.drop_from_inventory(W)
			if(linked_mob)
				var/how_much = H.mob_size + H.nutrition
				if(!H.ckey)
					how_much = how_much / 10	//Braindead mobs are worth less
				linked_mob.adjust_nutrition(how_much)
				H.mind?.vore_death = TRUE
			spawn(0)
			qdel(H)	//glorp
			return
		if(linked_mob)
			H.burn_skin(damage)
			if(linked_mob)
				var/how_much = (damage * H.size_multiplier) * H.get_digestion_nutrition_modifier() * linked_mob.get_digestion_efficiency_modifier()
				if(!H.ckey)
					how_much = how_much / 10	//Braindead mobs are worth less
				linked_mob.adjust_nutrition(how_much)
	else if (isliving(thing))
		var/mob/living/L = thing
		if(!L)
			return
		visible_message(runemessage = "blub...")
		if(L.stat == DEAD)
			L.unacidable = TRUE	//Don't touch this one again, we're gonna delete it in a second
			L.release_vore_contents()
			if(linked_mob)
				var/how_much = L.mob_size + L.nutrition
				if(!L.ckey)
					how_much = how_much / 10	//Braindead mobs are worth less
				linked_mob.adjust_nutrition(how_much)
			qdel(L) //gloop
			return
		L.adjustFireLoss(damage)
		if(linked_mob)
			var/how_much = (damage * L.size_multiplier) * L.get_digestion_nutrition_modifier() * linked_mob.get_digestion_efficiency_modifier()
			if(!L.ckey)
				how_much = how_much / 10	//Braindead mobs are worth less
			linked_mob.adjust_nutrition(how_much)

/turf/simulated/floor/flesh/mover
	icon_state = "flesh_floor_mover"
	var/movechance = 5
	var/we_process = FALSE
	var/move_dir = 2

/turf/simulated/floor/flesh/mover/Initialize(mapload)
	. = ..()
	move_dir = dir
	dir = SOUTH

/turf/simulated/floor/flesh/mover/Entered(atom/movable/AM)
	if(!we_process)
		START_PROCESSING(SSturfs, src)

/turf/simulated/floor/flesh/mover/hitby(atom/movable/AM)
	if(!we_process)
		START_PROCESSING(SSturfs, src)

/turf/simulated/floor/flesh/mover/process()	//Mostly stolen from conveyor2.dm
	if(movechance <= 0)
		we_process = FALSE
		return PROCESS_KILL
	we_process = TRUE
	if(!prob(movechance))	//Let's kind of control the speed that this happens at
		return
	var/items_moved = 0
	for(var/atom/movable/A in contents)
		if(A.anchored)
			continue
		if(!isitem(A) && !isliving(A))
			continue
		if(A.loc != src) //Don't move things that aren't here
			continue
		step(A,move_dir)
		items_moved++

		if(items_moved >= 10)
			break

	if(!items_moved)	//If we didn't move anything let's shut it down
		we_process = FALSE
		return PROCESS_KILL

/obj/structure/auto_flesh_door	//It's like a simple door, but it opens and closes automatically now and then!
	name = "flesh valve"
	density = TRUE
	opacity = TRUE
	anchored = TRUE
	can_atmos_pass = ATMOS_PASS_DENSITY

	icon = 'icons/turf/stomach_vr.dmi'
	icon_state = "fleshdoor"

	var/state = 0 //closed, 1 == open
	var/isSwitchingStates = 0
	var/countdown = 0
	var/knock_sound = 'sound/effects/attackblob.ogg'
	var/list/open_sounds = list(
		'sound/vore/sunesound/prey/squish_01.ogg',
		'sound/vore/sunesound/prey/squish_02.ogg',
		'sound/vore/sunesound/prey/squish_03.ogg',
		'sound/vore/sunesound/prey/squish_04.ogg',
		'sound/vore/sunesound/prey/stomachmove.ogg'
		)

/obj/structure/auto_flesh_door/Initialize()
	. = ..()
	countdown = rand(50,250)
	START_PROCESSING(SSobj, src)
	update_icon()

/obj/structure/auto_flesh_door/Destroy()
	STOP_PROCESSING(SSobj, src)
	update_nearby_tiles()
	return ..()

/obj/structure/auto_flesh_door/process()
	if(countdown <= 0)
		SwitchState()
	else
		countdown --
	if(!state)
		for(var/mob/living/L in src.loc.contents)
			if(isliving(L))
				L.Weaken(3)
				if(prob(5))
					to_chat(L, "<span class='warning'>\The [src] throbs heavily around you...</span>")

/obj/structure/auto_flesh_door/attack_hand(mob/user as mob)
	. = ..()
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	if(!Adjacent(user))
		return
	else if(user.a_intent == I_HELP)
		visible_message("[user] knocks on \the [src].", "Someone knocks on \the [src].")
		playsound(src, knock_sound, 50, 0, 3)
		countdown -= 10
	else
		visible_message("<span class='warning'>[user] hammers on \the [src]!</span>", "<span class='warning'>Someone hammers loudly on \the [src]!</span>")
		playsound(src, knock_sound, 50, 0, 3)
		countdown -= 25

/obj/structure/auto_flesh_door/CanPass(atom/movable/mover, turf/target)
	return !density

/obj/structure/auto_flesh_door/proc/SwitchState()
	if(state)
		Close()
	else
		Open()

/obj/structure/auto_flesh_door/proc/Open()
	isSwitchingStates = 1
	var/oursound = pick(open_sounds)
	playsound(src, oursound, 100, 1, preference = /datum/client_preference/digestion_noises , volume_channel = VOLUME_CHANNEL_VORE)
	flick("flesh-opening",src)
	sleep(8)
	density = FALSE
	set_opacity(0)
	state = 1
	update_icon()
	isSwitchingStates = 0
	update_nearby_tiles()
	countdown = rand(10,20)
	layer = OBJ_LAYER
	plane = OBJ_PLANE

/obj/structure/auto_flesh_door/proc/Close()
	isSwitchingStates = 1
	var/oursound = pick(open_sounds)
	playsound(src, oursound, 100, 1, preference = /datum/client_preference/digestion_noises , volume_channel = VOLUME_CHANNEL_VORE)
	flick("flesh-closing",src)
	sleep(8)
	density = TRUE
	set_opacity(1)
	state = 0
	update_icon()
	isSwitchingStates = 0
	update_nearby_tiles()
	countdown = rand(50,250)
	layer = ABOVE_MOB_LAYER
	plane = ABOVE_MOB_PLANE
	for(var/mob/living/L in src.loc.contents)
		if(isliving(L))
			L.Weaken(3)
			L.visible_message("<span class='danger'>\The [src] closes up on \the [L]!</span>","<span class='danger'>The weight of \the [src] closes in on you, squeezing you on all sides so tightly that you can hardly move! It throbs against you as the way is sealed, with you stuck in the middle!!!</span>")

/obj/structure/auto_flesh_door/update_icon()
	if(state)
		icon_state = "flesh-open"
	else
		icon_state = "flesh-closed"
