//trees
/obj/structure/flora/tree
	name = "tree"
	anchored = TRUE
	density = TRUE
	pixel_x = -16
	plane = MOB_PLANE // You know what, let's play it safe.
	layer = ABOVE_MOB_LAYER
	var/base_state = null	// Used for stumps.
	var/health = 200		// Used for chopping down trees.
	var/max_health = 200
	var/shake_animation_degrees = 4	// How much to shake the tree when struck.  Larger trees should have smaller numbers or it looks weird.
	var/obj/item/stack/material/product = null	// What you get when chopping this tree down.  Generally it will be a type of wood.
	var/product_amount = 10 // How much of a stack you get, if the above is defined.
	var/is_stump = FALSE // If true, suspends damage tracking and most other effects.
	var/indestructable = FALSE // If true, the tree cannot die.

/obj/structure/flora/tree/Initialize()
	icon_state = choose_icon_state()

	return ..()

/obj/structure/flora/tree/update_transform()
	var/matrix/M = matrix()
	M.Scale(icon_scale_x, icon_scale_y)
	M.Translate(0, 16*(icon_scale_y-1))
	animate(src, transform = M, time = 10)

// Override this for special icons.
/obj/structure/flora/tree/proc/choose_icon_state()
	return icon_state

/obj/structure/flora/tree/can_harvest(var/obj/item/I)
	. = FALSE
	if(!is_stump && harvest_tool && istype(I, harvest_tool) && harvest_loot && harvest_loot.len && harvest_count < max_harvests)
		. = TRUE
	return .

/obj/structure/flora/tree/attackby(var/obj/item/weapon/W, var/mob/living/user)
	if(can_harvest(W))
		..(W, user)
		return

	if(!istype(W))
		return ..()

	if(is_stump)
		if(istype(W,/obj/item/weapon/shovel))
			if(do_after(user, 5 SECONDS))
				visible_message("<b>\The [user]</b> digs up \the [src] stump with \the [W].")
				qdel(src)
		return

	visible_message("<span class='danger'>\The [user] hits \the [src] with \the [W]!</span>")

	var/damage_to_do = W.force
	if(!W.sharp && !W.edge)
		damage_to_do = round(damage_to_do / 4)
	if(damage_to_do > 0)
		if(W.sharp && W.edge)
			playsound(src, 'sound/effects/woodcutting.ogg', 50, 1)
		else
			playsound(src, W.hitsound, 50, 1)
		if(damage_to_do > 5 && !indestructable)
			adjust_health(-damage_to_do)
		else
			to_chat(user, "<span class='warning'>\The [W] is ineffective at harming \the [src].</span>")

	hit_animation()
	user.setClickCooldown(user.get_attack_speed(W))
	user.do_attack_animation(src)

// Shakes the tree slightly, more or less stolen from lockers.
/obj/structure/flora/tree/proc/hit_animation()
	var/init_px = pixel_x
	var/shake_dir = pick(-1, 1)
	var/matrix/M = matrix()
	M.Scale(icon_scale_x, icon_scale_y)
	M.Translate(0, 16*(icon_scale_y-1))
	animate(src, transform=turn(M, shake_animation_degrees * shake_dir), pixel_x=init_px + 2*shake_dir, time=1)
	animate(transform=M, pixel_x=init_px, time=6, easing=ELASTIC_EASING)

// Used when the tree gets hurt.
/obj/structure/flora/tree/proc/adjust_health(var/amount, var/damage_wood = FALSE)
	if(is_stump || indestructable)
		return

	// Bullets and lasers ruin some of the wood
	if(damage_wood && product_amount > 0)
		var/wood = initial(product_amount)
		product_amount -= round(wood * (abs(amount)/max_health))

	health = between(0, health + amount, max_health)
	if(health <= 0)
		die()
		return

// Called when the tree loses all health, for whatever reason.
/obj/structure/flora/tree/proc/die()
	if(is_stump || indestructable)
		return

	if(product && product_amount) // Make wooden logs.
		var/obj/item/stack/material/M = new product(get_turf(src), product_amount)
		M.update_icon()
	visible_message("<span class='danger'>\The [src] is felled!</span>")
	stump()

// Makes the tree into a mostly non-interactive stump.
/obj/structure/flora/tree/proc/stump()
	if(is_stump)
		return

	is_stump = TRUE
	density = FALSE
	icon_state = "[base_state]_stump"
	cut_overlays() // For the Sif tree and other future glowy trees.
	set_light(0)

/obj/structure/flora/tree/ex_act(var/severity)
	adjust_health(-(max_health / severity), TRUE)

/obj/structure/flora/tree/bullet_act(var/obj/item/projectile/Proj)
	if(Proj.get_structure_damage())
		adjust_health(-Proj.get_structure_damage(), TRUE)

/obj/structure/flora/tree/tesla_act(power, explosive)
	adjust_health(-power / 100, TRUE) // Kills most trees in one lightning strike.
	..()

/obj/structure/flora/tree/get_description_interaction()
	var/list/results = list()

	if(!is_stump)
		results += "[desc_panel_image("hatchet")]to cut down this tree into logs.  Any sharp and strong weapon will do."

	results += ..()

	return results

// Subtypes.

// Pine trees

/obj/structure/flora/tree/pine
	name = "pine tree"
	icon = 'icons/obj/flora/pinetrees.dmi'
	icon_state = "pine_1"
	base_state = "pine"
	product = /obj/item/stack/material/log
	shake_animation_degrees = 3

/obj/structure/flora/tree/pine/choose_icon_state()
	return "[base_state]_[rand(1, 3)]"


/obj/structure/flora/tree/pine/xmas
	name = "xmas tree"
	icon = 'icons/obj/flora/pinetrees.dmi'
	icon_state = "pine_c"

/obj/structure/flora/tree/pine/xmas/presents
	icon_state = "pinepresents"
	desc = "A wondrous decorated Christmas tree. It has presents!"
	indestructable = TRUE
	var/gift_type = /obj/item/weapon/a_gift
	var/list/ckeys_that_took = list()

/obj/structure/flora/tree/pine/xmas/presents/choose_icon_state()
	return "pinepresents"

/obj/structure/flora/tree/pine/xmas/presents/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return
	if(!user.ckey)
		return

	if(ckeys_that_took[user.ckey])
		to_chat(user, span("warning", "There are no presents with your name on."))
		return
	to_chat(user, span("notice", "After a bit of rummaging, you locate a gift with your name on it!"))
	ckeys_that_took[user.ckey] = TRUE
	var/obj/item/G = new gift_type(src)
	user.put_in_hands(G)

// Palm trees

/obj/structure/flora/tree/palm
	icon = 'icons/obj/flora/palmtrees.dmi'
	icon_state = "palm1"
	base_state = "palm"
	product = /obj/item/stack/material/log
	product_amount = 5
	health = 200
	max_health = 200
	pixel_x = 0

/obj/structure/flora/tree/palm/choose_icon_state()
	return "[base_state][rand(1, 2)]"


// Dead trees

/obj/structure/flora/tree/dead
	icon = 'icons/obj/flora/deadtrees.dmi'
	icon_state = "tree_1"
	base_state = "tree"
	product = /obj/item/stack/material/log
	product_amount = 5
	health = 200
	max_health = 200

/obj/structure/flora/tree/dead/choose_icon_state()
	return "[base_state]_[rand(1, 6)]"

// Small jungle trees

/obj/structure/flora/tree/jungle_small
	icon = 'icons/obj/flora/jungletreesmall.dmi'
	icon_state = "tree"
	base_state = "tree"
	product = /obj/item/stack/material/log
	product_amount = 10
	health = 400
	max_health = 400
	pixel_x = -32

/obj/structure/flora/tree/jungle_small/choose_icon_state()
	return "[base_state][rand(1, 6)]"

// Big jungle trees

/obj/structure/flora/tree/jungle
	icon = 'icons/obj/flora/jungletree.dmi'
	icon_state = "tree"
	base_state = "tree"
	product = /obj/item/stack/material/log
	product_amount = 20
	health = 800
	max_health = 800
	pixel_x = -48
	pixel_y = -16
	shake_animation_degrees = 2

/obj/structure/flora/tree/jungle/choose_icon_state()
	return "[base_state][rand(1, 6)]"

// Sif trees

/datum/category_item/catalogue/flora/sif_tree
	name = "Sivian Flora - Tree"
	desc = "The damp, shaded environment of Sif's most common variety of tree provides an ideal environment for a wide \
	variety of bioluminescent bacteria. The soft glow of the microscopic organisms in turn attracts several native microphagous \
	animals which act as an effective dispersal method. By this mechanism, new trees and bacterial colonies often sprout in \
	unison, having formed a symbiotic relationship over countless years of evolution.\
	<br><br>\
	Wood-like material can be obtained from this by cutting it down with a bladed tool."
	value = CATALOGUER_REWARD_TRIVIAL

/obj/structure/flora/tree/sif
	name = "glowing tree"
	desc = "It's a tree, except this one seems quite alien.  It glows a deep blue."
	icon = 'icons/obj/flora/deadtrees.dmi'
	icon_state = "tree_sif"
	base_state = "tree_sif"
	blocks_emissive = FALSE
	product = /obj/item/stack/material/log/sif
	catalogue_data = list(/datum/category_item/catalogue/flora/sif_tree)
	randomize_size = TRUE

	harvest_tool = /obj/item/weapon/material/knife
	max_harvests = 2
	min_harvests = 0
	harvest_loot = list(
		/obj/item/weapon/reagent_containers/food/snacks/siffruit = 20,
		/obj/item/weapon/reagent_containers/food/snacks/grown/sif/sifpod = 5,
		/obj/item/seeds/sifbulb = 1
	)

	var/light_shift = 0

/obj/structure/flora/tree/sif/choose_icon_state()
	light_shift = rand(0, 5)
	return "[base_state][light_shift]"

/obj/structure/flora/tree/sif/Initialize()
	. = ..()
	update_icon()

/obj/structure/flora/tree/sif/update_icon()
<<<<<<< HEAD
	cut_overlays()
	var/bulbs = (5 - light_shift)
	if(bulbs > 0)
		set_light(bulbs, 1, "#33ccff")	// 5 variants, missing bulbs. 5th has no bulbs, so no glow.
		add_overlay(mutable_appearance(icon, "[base_state][bulbs]_glow"))
		add_overlay(emissive_appearance(icon, "[base_state][bulbs]_glow"))
	
=======
	set_light(5 - light_shift, 1, "#33ccff")	// 5 variants, missing bulbs. 5th has no bulbs, so no glow.
	var/image/glow = image(icon = icon, icon_state = "[base_state][light_shift]_glow")
	glow.plane = PLANE_LIGHTING_ABOVE
	cut_overlays()
	add_overlay(glow)
>>>>>>> 2a494dcb666... Merge pull request #8530 from Spookerton/cerebulon/ssoverlay
