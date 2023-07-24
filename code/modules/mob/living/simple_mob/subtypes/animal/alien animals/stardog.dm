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

	movement_cooldown = 0
	var/affinity = 0

/mob/living/simple_mob/vore/overmap/stardog/Life()
	. = ..()

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

	else if(invisibility)
		invisibility = 0
		child_om_marker.invisibility = INVISIBILITY_ABSTRACT
		ai_holder.base_wander_delay = 5
		ai_holder.wander_delay = 1
		melee_damage_lower = 1
		melee_damage_upper = 5
		mob_size = MOB_SMALL
		child_om_marker.set_light(0)

/mob/living/simple_mob/vore/overmap/stardog/Initialize()
	. = ..()
	child_om_marker.set_light(5, 1, "#ff8df5")

/mob/living/simple_mob/vore/overmap/stardog/Destroy()
	for(var/turf/simulated/floor/outdoors/fur/f in world)
		if(f.host_mob == src)
			f.host_mob = null
	..()

/obj/effect/overmap/visitable/ship/simplemob/stardog
	icon = 'icons/obj/overmap.dmi'
	icon_state = "ship"
	icon = 'icons/obj/overmap.dmi'
	icon_state = "ship"
	skybox_icon = 'icons/skybox/anomaly.dmi'
	skybox_icon_state = "space_dog"
	skybox_pixel_x = 0
	skybox_pixel_y = 0
	glide_size = 6
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
	var/mob/living/simple_mob/vore/overmap/stardog/host_mob

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

/turf/simulated/floor/outdoors/fur/Initialize()
	. = ..()
	if(tree_chance && prob(tree_chance) && !check_density())
		var/obj/structure/flora/tree/fur/tree = new /obj/structure/flora/tree/fur(src)
		if(tree_color)
			tree.color = tree_color
		else
			tree.color = color

/turf/simulated/floor/outdoors/fur/verb/pet()
	set name = "Pet Fur"
	set desc = "Pet the fur!"
	set category = "IC"
	set src in oview(1)

	usr.visible_message("\The [usr] pets \the [src].")
	if(host_mob)
		host_mob.affinity ++
	else
		for(var/mob/living/simple_mob/vore/overmap/stardog/s in world)
			host_mob = s
			break

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

/obj/structure/flora/tree/fur/choose_icon_state()
	return "[base_state][rand(1, 2)]"

/obj/structure/flora/tree/fur/die()
	if(product && product_amount)
		var/obj/item/stack/material/fur/F = new product(get_turf(src), product_amount)
		F.color = color
		F.update_icon()
	visible_message("<span class='danger'>\The [src] is felled!</span>")
	qdel(src)
