//trees
/obj/structure/flora/tree
	name = "tree"
	anchored = 1
	density = 1
	pixel_x = -16
	layer = MOB_LAYER // You know what, let's play it safe.
	var/base_state = null	// Used for stumps.
	var/health = 200		// Used for chopping down trees.
	var/max_health = 200
	var/shake_animation_degrees = 4	// How much to shake the tree when struck.  Larger trees should have smaller numbers or it looks weird.
	var/obj/item/stack/material/product = null	// What you get when chopping this tree down.  Generally it will be a type of wood.
	var/product_amount = 10 // How much of a stack you get, if the above is defined.
	var/is_stump = FALSE // If true, suspends damage tracking and most other effects.

/obj/structure/flora/tree/attackby(var/obj/item/weapon/W, var/mob/living/user)
	if(!istype(W))
		return ..()

	if(is_stump)
		if(istype(W,/obj/item/weapon/shovel))
			if(do_after(user, 5 SECONDS))
				visible_message("<span class='notice'>\The [user] digs up \the [src] stump with \the [W].</span>")
				qdel(src)
		return

	visible_message("<span class='danger'>\The [user] hits \the [src] with \the [W]!</span>")

	var/damage_to_do = W.force
	if(!W.sharp && !W.edge)
		damage_to_do = round(damage_to_do / 4)
	if(damage_to_do > 0)
		if(W.sharp && W.edge)
			playsound(get_turf(src), 'sound/effects/woodcutting.ogg', 50, 1)
		else
			playsound(get_turf(src), W.hitsound, 50, 1)
		if(damage_to_do > 5)
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
	animate(src, transform=turn(matrix(), shake_animation_degrees * shake_dir), pixel_x=init_px + 2*shake_dir, time=1)
	animate(transform=null, pixel_x=init_px, time=6, easing=ELASTIC_EASING)

// Used when the tree gets hurt.
/obj/structure/flora/tree/proc/adjust_health(var/amount, var/is_ranged = FALSE)
	if(is_stump)
		return

	// Bullets and lasers ruin some of the wood
	if(is_ranged && product_amount > 0)
		var/wood = initial(product_amount)
		product_amount -= round(wood * (abs(amount)/max_health))

	health = between(0, health + amount, max_health)
	if(health <= 0)
		die()
		return

// Called when the tree loses all health, for whatever reason.
/obj/structure/flora/tree/proc/die()
	if(is_stump)
		return

	if(product && product_amount) // Make wooden logs.
		var/obj/item/stack/material/M = new product(get_turf(src))
		M.amount = product_amount
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
	overlays.Cut() // For the Sif tree and other future glowy trees.
	set_light(0)

/obj/structure/flora/tree/ex_act(var/severity)
	adjust_health(-(max_health / severity))

/obj/structure/flora/tree/bullet_act(var/obj/item/projectile/Proj)
	if(Proj.get_structure_damage())
		adjust_health(-Proj.get_structure_damage(), TRUE)

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

/obj/structure/flora/tree/pine/New()
	..()
	icon_state = "[base_state]_[rand(1, 3)]"


/obj/structure/flora/tree/pine/xmas
	name = "xmas tree"
	icon = 'icons/obj/flora/pinetrees.dmi'
	icon_state = "pine_c"

/obj/structure/flora/tree/pine/xmas/New()
	..()
	icon_state = "pine_c"

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

/obj/structure/flora/tree/palm/New()
	..()
	icon_state = "[base_state][rand(1, 2)]"


// Dead trees

/obj/structure/flora/tree/dead
	icon = 'icons/obj/flora/deadtrees.dmi'
	icon_state = "tree_1"
	base_state = "tree"
	product = /obj/item/stack/material/log
	product_amount = 5
	health = 200
	max_health = 200

/obj/structure/flora/tree/dead/New()
	..()
	icon_state = "[base_state]_[rand(1, 6)]"

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

/obj/structure/flora/tree/jungle_small/New()
	..()
	icon_state = "[base_state][rand(1, 6)]"

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

/obj/structure/flora/tree/jungle/New()
	..()
	icon_state = "[base_state][rand(1, 6)]"

// Sif trees

/obj/structure/flora/tree/sif
	name = "glowing tree"
	desc = "It's a tree, except this one seems quite alien.  It glows a deep blue."
	icon = 'icons/obj/flora/deadtrees.dmi'
	icon_state = "tree_sif"
	base_state = "tree_sif"
	product = /obj/item/stack/material/log/sif

/obj/structure/flora/tree/sif/New()
	update_icon()

/obj/structure/flora/tree/sif/update_icon()
	set_light(5, 1, "#33ccff")
	var/image/glow = image(icon = 'icons/obj/flora/deadtrees.dmi', icon_state = "[icon_state]_glow")
	glow.plane = PLANE_LIGHTING_ABOVE
	overlays = list(glow)
