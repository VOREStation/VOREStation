/obj/structure/girder
	name = "girder"
	icon_state = "girder"
	anchored = TRUE
	density = TRUE
	plane = PLATING_PLANE
	w_class = ITEMSIZE_HUGE
	var/state = 0
	var/health = 200
	var/max_health = 200
	var/displaced_health = 50
	var/current_damage = 0
	var/cover = 50 //how much cover the girder provides against projectiles.
	var/default_material = MAT_STEEL
	var/datum/material/girder_material
	var/datum/material/reinf_material
	var/reinforcing = 0
	var/applies_material_colour = 1
	var/wall_type = /turf/simulated/wall

/obj/structure/girder/New(var/newloc, var/material_key)
	..(newloc)
	if(!material_key)
		material_key = default_material
	set_material(material_key)
	update_icon()

/obj/structure/girder/Destroy()
	if(girder_material.products_need_process())
		STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/structure/girder/process()
	if(!radiate())
		STOP_PROCESSING(SSobj, src)
		return

/obj/structure/girder/proc/radiate()
	var/total_radiation = girder_material.radioactivity + (reinf_material ? reinf_material.radioactivity / 2 : 0)
	if(!total_radiation)
		return

	SSradiation.radiate(src, total_radiation)
	return total_radiation


/obj/structure/girder/proc/set_material(var/new_material)
	girder_material = get_material_by_name(new_material)
	if(!girder_material)
		qdel(src)
	name = "[girder_material.display_name] [initial(name)]"
	max_health = round(girder_material.integrity) //Should be 150 with default integrity (steel). Weaker than ye-olden Girders now.
	health = max_health
	displaced_health = round(max_health/4)
	if(applies_material_colour)
		color = girder_material.icon_colour
	if(girder_material.products_need_process()) //Am I radioactive or some other? Process me!
		START_PROCESSING(SSobj, src)
	else if(datum_flags & DF_ISPROCESSING) //If I happened to be radioactive or s.o. previously, and am not now, stop processing.
		STOP_PROCESSING(SSobj, src)

/obj/structure/girder/get_material()
	return girder_material

/obj/structure/girder/update_icon()
	if(anchored)
		icon_state = initial(icon_state)
	else
		icon_state = "displaced"

/obj/structure/girder/displaced
	icon_state = "displaced"
	anchored = FALSE
	health = 50
	cover = 25

/obj/structure/girder/displaced/New(var/newloc, var/material_key)
	..(newloc, material_key)
	displace()

/obj/structure/girder/proc/displace()
	name = "displaced [girder_material.display_name] [initial(name)]"
	icon_state = "displaced"
	anchored = FALSE
	health = (displaced_health - round(current_damage / 4))
	cover = 25

/obj/structure/girder/attack_generic(var/mob/user, var/damage, var/attack_message = "smashes apart")
	if(damage < STRUCTURE_MIN_DAMAGE_THRESHOLD)
		return 0
	user.do_attack_animation(src)
	visible_message("<span class='danger'>[user] [attack_message] the [src]!</span>")
	spawn(1) dismantle()
	return 1

/obj/structure/girder/bullet_act(var/obj/item/projectile/Proj)
	//Girders only provide partial cover. There's a chance that the projectiles will just pass through. (unless you are trying to shoot the girder)
	if(Proj.original != src && !prob(cover))
		return PROJECTILE_CONTINUE //pass through

	var/damage = Proj.get_structure_damage()
	if(!damage)
		return

	if(!istype(Proj, /obj/item/projectile/beam))
		damage *= 0.4 //non beams do reduced damage

	else if(girder_material && girder_material.reflectivity >= 0.5) // Reflect lasers.
		var/new_damage = damage * girder_material.reflectivity
		var/outgoing_damage = damage - new_damage
		damage = round(new_damage)
		Proj.damage = outgoing_damage

		visible_message("<span class='danger'>\The [src] reflects \the [Proj]!</span>")

		// Find a turf near or on the original location to bounce to
		var/new_x = Proj.starting.x + pick(0, 0, 0, -1, 1, -2, 2)
		var/new_y = Proj.starting.y + pick(0, 0, 0, -1, 1, -2, 2)
		//var/turf/curloc = get_turf(src)
		var/turf/curloc = get_step(src, get_dir(src, Proj.starting))

		Proj.penetrating += 1 // Needed for the beam to get out of the girder.

		// redirect the projectile
		Proj.redirect(new_x, new_y, curloc, null)

	health -= damage
	..()
	if(health <= 0)
		dismantle()

	return

/obj/structure/girder/blob_act()
	dismantle()

/obj/structure/girder/proc/reset_girder()
	name = "[girder_material.display_name] [initial(name)]"
	anchored = TRUE
	cover = initial(cover)
	health = min(max_health - current_damage,max_health)
	state = 0
	icon_state = initial(icon_state)
	reinforcing = 0
	if(reinf_material)
		reinforce_girder()

/obj/structure/girder/attackby(obj/item/W as obj, mob/user as mob)
	if(W.has_tool_quality(TOOL_WRENCH) && state == 0)
		if(anchored && !reinf_material)
			playsound(src, W.usesound, 100, 1)
			to_chat(user, "<span class='notice'>Now disassembling the girder...</span>")
			if(do_after(user,(35 + round(max_health/50)) * W.toolspeed))
				if(!src) return
				to_chat(user, "<span class='notice'>You dissasembled the girder!</span>")
				dismantle()
		else if(!anchored)
			playsound(src, W.usesound, 100, 1)
			to_chat(user, "<span class='notice'>Now securing the girder...</span>")
			if(do_after(user, 40 * W.toolspeed, src))
				to_chat(user, "<span class='notice'>You secured the girder!</span>")
				reset_girder()

	else if(istype(W, /obj/item/weapon/pickaxe/plasmacutter))
		to_chat(user, "<span class='notice'>Now slicing apart the girder...</span>")
		if(do_after(user,30 * W.toolspeed))
			if(!src) return
			to_chat(user, "<span class='notice'>You slice apart the girder!</span>")
			dismantle()

	else if(istype(W, /obj/item/weapon/pickaxe/diamonddrill))
		to_chat(user, "<span class='notice'>You drill through the girder!</span>")
		dismantle()

	else if(W.has_tool_quality(TOOL_SCREWDRIVER))
		if(state == 2)
			playsound(src, W.usesound, 100, 1)
			to_chat(user, "<span class='notice'>Now unsecuring support struts...</span>")
			if(do_after(user,40 * W.toolspeed))
				if(!src) return
				to_chat(user, "<span class='notice'>You unsecured the support struts!</span>")
				state = 1
		else if(anchored && !reinf_material)
			playsound(src, W.usesound, 100, 1)
			reinforcing = !reinforcing
			to_chat(user, "<span class='notice'>\The [src] can now be [reinforcing? "reinforced" : "constructed"]!</span>")

	else if(W.has_tool_quality(TOOL_WIRECUTTER) && state == 1)
		playsound(src, W.usesound, 100, 1)
		to_chat(user, "<span class='notice'>Now removing support struts...</span>")
		if(do_after(user,40 * W.toolspeed))
			if(!src) return
			to_chat(user, "<span class='notice'>You removed the support struts!</span>")
			reinf_material.place_dismantled_product(get_turf(src))
			reinf_material = null
			reset_girder()

	else if(W.has_tool_quality(TOOL_CROWBAR) && state == 0 && anchored)
		playsound(src, W.usesound, 100, 1)
		to_chat(user, "<span class='notice'>Now dislodging the girder...</span>")
		if(do_after(user, 40 * W.toolspeed))
			if(!src) return
			to_chat(user, "<span class='notice'>You dislodged the girder!</span>")
			displace()

	else if(istype(W, /obj/item/stack/material))
		if(reinforcing && !reinf_material)
			if(!reinforce_with_material(W, user))
				return ..()
		else
			if(!construct_wall(W, user))
				return ..()

	else
		return ..()

/obj/structure/girder/take_damage(var/damage)
	health -= damage
	if(health <= 0)
		dismantle()
	else
		current_damage = current_damage + damage //Rather than calculate this every time we need to use it, just calculate it here and save it.


/obj/structure/girder/proc/construct_wall(obj/item/stack/material/S, mob/user)
	var/amount_to_use = reinf_material ? 1 : 2
	if(S.get_amount() < amount_to_use)
		to_chat(user, "<span class='notice'>There isn't enough material here to construct a wall.</span>")
		return 0

	var/datum/material/M = name_to_material[S.default_type]
	if(!istype(M))
		return 0

	var/wall_fake
	add_hiddenprint(usr)

	if(M.integrity < 50)
		to_chat(user, "<span class='notice'>This material is too soft for use in wall construction.</span>")
		return 0

	to_chat(user, "<span class='notice'>You begin adding the plating...</span>")

	if(!do_after(user,40) || !S.use(amount_to_use))
		return 1 //once we've gotten this far don't call parent attackby()

	if(anchored)
		to_chat(user, "<span class='notice'>You added the plating!</span>")
	else
		to_chat(user, "<span class='notice'>You create a false wall! Push on it to open or close the passage.</span>")
		wall_fake = 1

	var/turf/Tsrc = get_turf(src)
	Tsrc.ChangeTurf(wall_type)
	var/turf/simulated/wall/T = get_turf(src)
	T.set_material(M, reinf_material, girder_material)
	if(wall_fake)
		T.can_open = 1
	T.add_hiddenprint(usr)
	qdel(src)
	return 1

/obj/structure/girder/proc/reinforce_with_material(obj/item/stack/material/S, mob/user) //if the verb is removed this can be renamed.
	if(reinf_material)
		to_chat(user, "<span class='notice'>\The [src] is already reinforced.</span>")
		return 0

	if(S.get_amount() < 1)
		to_chat(user, "<span class='notice'>There isn't enough material here to reinforce the girder.</span>")
		return 0

	var/datum/material/M = name_to_material[S.default_type]
	if(!istype(M) || M.integrity < 50)
		to_chat(user, "You cannot reinforce \the [src] with that; it is too soft.")
		return 0

	to_chat(user, "<span class='notice'>Now reinforcing...</span>")
	if (!do_after(user,40) || !S.use(1))
		return 1 //don't call parent attackby() past this point
	to_chat(user, "<span class='notice'>You added reinforcement!</span>")

	reinf_material = M
	reinforce_girder()
	return 1

/obj/structure/girder/proc/reinforce_girder()
	cover = reinf_material.hardness
	health = health + round(reinf_material.integrity/2)
	state = 2
	icon_state = "reinforced"
	reinforcing = 0

/obj/structure/girder/proc/dismantle()
	girder_material.place_dismantled_product(get_turf(src))
	qdel(src)

/obj/structure/girder/attack_hand(mob/user as mob)
	if (HULK in user.mutations)
		visible_message("<span class='danger'>[user] smashes [src] apart!</span>")
		dismantle()
		return
	return ..()


/obj/structure/girder/ex_act(severity)
	switch(severity)
		if(1.0)
			qdel(src)
			return
		if(2.0)
			if (prob(30))
				dismantle()
			return
		if(3.0)
			if (prob(5))
				dismantle()
			return
		else
	return

/obj/structure/girder/cult
	name = "column"
	icon= 'icons/obj/cult.dmi'
	icon_state= "cultgirder"
	max_health = 250
	health = 250
	cover = 70
	girder_material = "cult"
	applies_material_colour = 0

/obj/structure/girder/cult/update_icon()
	if(anchored)
		icon_state = "cultgirder"
	else
		icon_state = "displaced"

/obj/structure/girder/cult/dismantle()
	new /obj/effect/decal/remains/human(get_turf(src))
	qdel(src)

/obj/structure/girder/cult/attackby(obj/item/W as obj, mob/user as mob)
	if(W.has_tool_quality(TOOL_WRENCH))
		playsound(src, W.usesound, 100, 1)
		to_chat(user, "<span class='notice'>Now disassembling the girder...</span>")
		if(do_after(user,40 * W.toolspeed))
			to_chat(user, "<span class='notice'>You dissasembled the girder!</span>")
			dismantle()

	else if(istype(W, /obj/item/weapon/pickaxe/plasmacutter))
		to_chat(user, "<span class='notice'>Now slicing apart the girder...</span>")
		if(do_after(user,30 * W.toolspeed))
			to_chat(user, "<span class='notice'>You slice apart the girder!</span>")
		dismantle()

	else if(istype(W, /obj/item/weapon/pickaxe/diamonddrill))
		to_chat(user, "<span class='notice'>You drill through the girder!</span>")
		new /obj/effect/decal/remains/human(get_turf(src))
		dismantle()

/obj/structure/girder/resin
	name = "soft girder"
	icon_state = "girder_resin"
	max_health = 225
	health = 225
	cover = 60
	girder_material = "resin"

/obj/structure/girder/rcd_values(mob/living/user, obj/item/weapon/rcd/the_rcd, passed_mode)
	var/turf/simulated/T = get_turf(src)
	if(!istype(T) || T.density)
		return FALSE

	switch(passed_mode)
		if(RCD_FLOORWALL)
			// Finishing a wall costs two sheets.
			var/cost = RCD_SHEETS_PER_MATTER_UNIT * 2
			// Rwalls cost three to finish.
			if(the_rcd.make_rwalls)
				cost += RCD_SHEETS_PER_MATTER_UNIT * 1
			return list(
				RCD_VALUE_MODE = RCD_FLOORWALL,
				RCD_VALUE_DELAY = 2 SECONDS,
				RCD_VALUE_COST = cost
			)
		if(RCD_DECONSTRUCT)
			return list(
				RCD_VALUE_MODE = RCD_DECONSTRUCT,
				RCD_VALUE_DELAY = 2 SECONDS,
				RCD_VALUE_COST = RCD_SHEETS_PER_MATTER_UNIT * 5
			)
	return FALSE

/obj/structure/girder/rcd_act(mob/living/user, obj/item/weapon/rcd/the_rcd, passed_mode)
	var/turf/simulated/T = get_turf(src)
	if(!istype(T) || T.density) // Should stop future bugs of people bringing girders to centcom and RCDing them, or somehow putting a girder on a durasteel wall and deconning it.
		return FALSE

	switch(passed_mode)
		if(RCD_FLOORWALL)
			to_chat(user, span("notice", "You finish a wall."))
			// This is mostly the same as using on a floor. The girder's material is preserved, however.
			T.ChangeTurf(wall_type)
			var/turf/simulated/wall/new_T = get_turf(src) // Ref to the wall we just built.
			// Apparently set_material(...) for walls requires refs to the material singletons and not strings.
			// This is different from how other material objects with their own set_material(...) do it, but whatever.
			var/datum/material/M = name_to_material[the_rcd.material_to_use]
			new_T.set_material(M, the_rcd.make_rwalls ? M : null, girder_material)
			new_T.add_hiddenprint(user)
			qdel(src)
			return TRUE

		if(RCD_DECONSTRUCT)
			to_chat(user, span("notice", "You deconstruct \the [src]."))
			qdel(src)
			return TRUE

/obj/structure/girder/bay
	wall_type = /turf/simulated/wall/bay

/obj/structure/girder/eris
	wall_type = /turf/simulated/wall/eris
