/obj/item/weapon/melee/energy
	var/active = 0
	var/active_force
	var/active_throwforce
	var/active_w_class
	var/active_embed_chance = 0		//In the off chance one of these is supposed to embed, you can just tweak this var
	sharp = 0
	edge = 0
	armor_penetration = 50
	flags = NOCONDUCT | NOBLOODY
	var/lrange = 2
	var/lpower = 2
	var/lcolor = "#0099FF"
	var/colorable = FALSE
	var/rainbow = FALSE
	// If it uses energy.
	var/use_cell = FALSE
	var/hitcost = 120
	var/obj/item/weapon/cell/bcell = null
	var/cell_type = /obj/item/weapon/cell/device
	item_icons = list(
			slot_l_hand_str = 'icons/mob/items/lefthand_melee.dmi',
			slot_r_hand_str = 'icons/mob/items/righthand_melee.dmi',
			)

/obj/item/weapon/melee/energy/sword/green/New()
	colorable = FALSE
	lcolor = "#008000"

/obj/item/weapon/melee/energy/sword/red/New()
	colorable = FALSE
	lcolor = "#FF0000"

/obj/item/weapon/melee/energy/sword/blue/New()
	colorable = FALSE
	lcolor = "#0000FF"

/obj/item/weapon/melee/energy/sword/purple/New()
	colorable = FALSE
	lcolor = "#800080"

/obj/item/weapon/melee/energy/sword/white/New()
	colorable = FALSE
	lcolor = "#FFFFFF"

/obj/item/weapon/melee/energy/proc/activate(mob/living/user)
	if(active)
		return
	active = 1
	if(rainbow)
		item_state = "[icon_state]_blade_rainbow"
	else
		item_state = "[icon_state]_blade"
	embed_chance = active_embed_chance
	force = active_force
	throwforce = active_throwforce
	sharp = 1
	edge = 1
	w_class = active_w_class
	playsound(src, 'sound/weapons/saberon.ogg', 50, 1)
	update_icon()
	set_light(lrange, lpower, lcolor)

/obj/item/weapon/melee/energy/proc/deactivate(mob/living/user)
	if(!active)
		return
	playsound(src, 'sound/weapons/saberoff.ogg', 50, 1)
	item_state = "[icon_state]"
	active = 0
	embed_chance = initial(embed_chance)
	force = initial(force)
	throwforce = initial(throwforce)
	sharp = initial(sharp)
	edge = initial(edge)
	w_class = initial(w_class)
	update_icon()
	set_light(0,0)

/obj/item/weapon/melee/energy/proc/use_charge(var/cost)
	if(active)
		if(bcell)
			if(bcell.checked_use(cost))
				return 1
			else
				return 0
	return null

/obj/item/weapon/melee/energy/examine(mob/user)
	. = ..()
	if(use_cell && Adjacent(user))
		if(bcell)
			. += "<span class='notice'>The blade is [round(bcell.percent())]% charged.</span>"
		else
			. += "<span class='warning'>The blade does not have a power source installed.</span>"

/obj/item/weapon/melee/energy/attack_self(mob/living/user as mob)
	if(use_cell)
		if((!bcell || bcell.charge < hitcost) && !active)
			to_chat(user, "<span class='notice'>\The [src] does not seem to have power.</span>")
			return

	var/datum/gender/TU = gender_datums[user.get_visible_gender()]
	if (active)
		if ((CLUMSY in user.mutations) && prob(50))
			user.visible_message("<span class='danger'>\The [user] accidentally cuts [TU.himself] with \the [src].</span>",\
			"<span class='danger'>You accidentally cut yourself with \the [src].</span>")
			user.take_organ_damage(5,5)
		deactivate(user)
	else
		activate(user)

	if(istype(user,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		H.update_inv_l_hand()
		H.update_inv_r_hand()

	add_fingerprint(user)
	return

/obj/item/weapon/melee/energy/suicide_act(mob/user)
	var/datum/gender/TU = gender_datums[user.get_visible_gender()]
	if(active)
		user.visible_message(pick("<span class='danger'>\The [user] is slitting [TU.his] stomach open with \the [src]! It looks like [TU.he] [TU.is] trying to commit seppuku.</span>",\
			"<span class='danger'>\The [user] is falling on \the [src]! It looks like [TU.he] [TU.is] trying to commit suicide.</span>"))
		return (BRUTELOSS|FIRELOSS)

/obj/item/weapon/melee/energy/attack(mob/M, mob/user)
	if(active && use_cell)
		if(!use_charge(hitcost))
			deactivate(user)
			visible_message("<span class='notice'>\The [src]'s blade flickers, before deactivating.</span>")
	return ..()

/obj/item/weapon/melee/energy/attackby(obj/item/weapon/W, mob/user)
	if(istype(W, /obj/item/device/multitool) && colorable && !active)
		if(!rainbow)
			rainbow = TRUE
		else
			rainbow = FALSE
		to_chat(user, "<span class='notice'>You manipulate the color controller in [src].</span>")
		update_icon()
	if(use_cell)
		if(istype(W, cell_type))
			if(!bcell)
				user.drop_item()
				W.loc = src
				bcell = W
				to_chat(user, "<span class='notice'>You install a cell in [src].</span>")
				update_icon()
			else
				to_chat(user, "<span class='notice'>[src] already has a cell.</span>")
		else if(W.is_screwdriver() && bcell)
			bcell.update_icon()
			bcell.forceMove(get_turf(loc))
			bcell = null
			to_chat(user, "<span class='notice'>You remove the cell from \the [src].</span>")
			deactivate()
			update_icon()
			return
	return ..()

/obj/item/weapon/melee/energy/get_cell()
	return bcell

/obj/item/weapon/melee/energy/update_icon()
	. = ..()
	var/mutable_appearance/blade_overlay = mutable_appearance(icon, "[icon_state]_blade")
	blade_overlay.color = lcolor
	color = lcolor
	if(rainbow)
		blade_overlay = mutable_appearance(icon, "[icon_state]_blade_rainbow")
		blade_overlay.color = "FFFFFF"
		color = "FFFFFF"
	cut_overlays()		//So that it doesn't keep stacking overlays non-stop on top of each other
	if(active)
		add_overlay(blade_overlay)
	if(istype(usr,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = usr
		H.update_inv_l_hand()
		H.update_inv_r_hand()




/obj/item/weapon/melee/energy/AltClick(mob/living/user)
	if(!colorable) //checks if is not colorable
		return
	if(!in_range(src, user))	//Basic checks to prevent abuse
		return
	if(user.incapacitated() || !istype(user))
		to_chat(user, "<span class='warning'>You can't do that right now!</span>")
		return

	if(alert("Are you sure you want to recolor your blade?", "Confirm Recolor", "Yes", "No") == "Yes")
		var/energy_color_input = input(usr,"","Choose Energy Color",lcolor) as color|null
		if(energy_color_input)
			lcolor = sanitize_hexcolor(energy_color_input)
		update_icon()

/obj/item/weapon/melee/energy/examine(mob/user)
	. = ..()
	. += "<span class='notice'>Alt-click to recolor it.</span>"

/*
 * Energy Axe
 */
/obj/item/weapon/melee/energy/axe
	name = "energy axe"
	desc = "An energised battle axe."
	icon_state = "eaxe"
	item_state = "eaxe"
	colorable = FALSE
	lcolor = null
	//active_force = 150 //holy...
	active_force = 60
	active_throwforce = 35
	active_w_class = ITEMSIZE_HUGE
	//force = 40
	//throwforce = 25
	force = 20
	throwforce = 10
	throw_speed = 1
	throw_range = 5
	w_class = ITEMSIZE_NORMAL
	origin_tech = list(TECH_MAGNET = 3, TECH_COMBAT = 4)
	attack_verb = list("attacked", "chopped", "cleaved", "torn", "cut")
	sharp = 1
	edge = 1
	can_cleave = TRUE

/obj/item/weapon/melee/energy/axe/activate(mob/living/user)
	..()
	damtype = SEARING
	to_chat(user, "<span class='notice'>\The [src] is now energised.</span>")

/obj/item/weapon/melee/energy/axe/deactivate(mob/living/user)
	..()
	damtype = BRUTE
	to_chat(user, "<span class='notice'>\The [src] is de-energised. It's just a regular axe now.</span>")

/obj/item/weapon/melee/energy/axe/suicide_act(mob/user)
	var/datum/gender/TU = gender_datums[user.get_visible_gender()]
	visible_message("<span class='warning'>\The [user] swings \the [src] towards [TU.his] head! It looks like [TU.he] [TU.is] trying to commit suicide.</span>")
	return (BRUTELOSS|FIRELOSS)

/obj/item/weapon/melee/energy/axe/charge
	name = "charge axe"
	desc = "An energised axe."
	active_force = 35
	active_throwforce = 20
	force = 15

	use_cell = TRUE
	hitcost = 120

/obj/item/weapon/melee/energy/axe/charge/loaded/New()
	..()
	bcell = new/obj/item/weapon/cell/device/weapon(src)

/*
 * Energy Sword
 */
/obj/item/weapon/melee/energy/sword
	color
	name = "energy sword"
	desc = "May the force be within you."
	icon_state = "esword"
	item_state = "esword"
	active_force = 30
	active_throwforce = 20
	active_w_class = ITEMSIZE_LARGE
	force = 3
	throwforce = 5
	throw_speed = 1
	throw_range = 5
	w_class = ITEMSIZE_SMALL
	flags = NOBLOODY
	origin_tech = list(TECH_MAGNET = 3, TECH_ILLEGAL = 4)
	sharp = 1
	edge = 1
	colorable = TRUE


	projectile_parry_chance = 65

/obj/item/weapon/melee/energy/sword/dropped(var/mob/user)
	..()
	if(!istype(loc,/mob))
		deactivate(user)


/obj/item/weapon/melee/energy/sword/activate(mob/living/user)
	if(!active)
		to_chat(user, "<span class='notice'>\The [src] is now energised.</span>")

	..()
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")


/obj/item/weapon/melee/energy/sword/deactivate(mob/living/user)
	if(active)
		to_chat(user, "<span class='notice'>\The [src] deactivates!</span>")
	..()
	attack_verb = list()

/obj/item/weapon/melee/energy/sword/handle_shield(mob/user, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")
	if(active && default_parry_check(user, attacker, damage_source) && prob(60))
		user.visible_message("<span class='danger'>\The [user] parries [attack_text] with \the [src]!</span>")

		var/datum/effect/effect/system/spark_spread/spark_system = new /datum/effect/effect/system/spark_spread()
		spark_system.set_up(5, 0, user.loc)
		spark_system.start()
		playsound(src, 'sound/weapons/blade1.ogg', 50, 1)
		return 1
	if(active && unique_parry_check(user, attacker, damage_source) && prob(projectile_parry_chance))
		user.visible_message("<span class='danger'>\The [user] deflects [attack_text] with \the [src]!</span>")

		var/datum/effect/effect/system/spark_spread/spark_system = new /datum/effect/effect/system/spark_spread()
		spark_system.set_up(5, 0, user.loc)
		spark_system.start()
		playsound(src, 'sound/weapons/blade1.ogg', 50, 1)
		return 1

	return 0

/obj/item/weapon/melee/energy/sword/unique_parry_check(mob/user, mob/attacker, atom/damage_source)
	if(user.incapacitated() || !istype(damage_source, /obj/item/projectile/))
		return 0

	var/bad_arc = reverse_direction(user.dir)
	if(!check_shield_arc(user, bad_arc, damage_source, attacker))
		return 0

	return 1

/obj/item/weapon/melee/energy/sword/pirate
	name = "energy cutlass"
	desc = "Arrrr matey."
	icon_state = "cutlass"
	item_state = "cutlass"
	colorable = TRUE


/*
 *Ionic Rapier
 */

/obj/item/weapon/melee/energy/sword/ionic_rapier
	name = "ionic rapier"
	desc = "Designed specifically for disrupting electronics at close range, it is extremely deadly against synthetics, but almost harmless to pure organic targets."
	description_info = "This is a dangerous melee weapon that will deliver a moderately powerful electromagnetic pulse to whatever it strikes.  \
	Striking a lesser robotic entity will compel it to attack you, as well.  It also does extra burn damage to robotic entities, but it does \
	very little damage to purely organic targets."
	icon_state = "ionrapier"
	item_state = "ionrapier"
	active_force = 5
	active_throwforce = 3
	active_embed_chance = 0
	sharp = 1
	edge = 1
	armor_penetration = 0
	flags = NOBLOODY
	lrange = 2
	lpower = 2
	lcolor = "#0000FF"
	projectile_parry_chance = 30	// It's not specifically designed for cutting and slashing, but it can still, maybe, save your life.

/obj/item/weapon/melee/energy/sword/ionic_rapier/afterattack(var/atom/movable/AM, var/mob/living/user, var/proximity)
	if(istype(AM, /obj) && proximity && active)
		// EMP stuff.
		var/obj/O = AM
		O.emp_act(3) // A weaker severity is used because this has infinite uses.
		playsound(O, 'sound/effects/EMPulse.ogg', 100, 1)
		user.setClickCooldown(user.get_attack_speed(src)) // A lot of objects don't set click delay.
	return ..()

/obj/item/weapon/melee/energy/sword/ionic_rapier/apply_hit_effect(mob/living/target, mob/living/user, var/hit_zone)
	. = ..()
	if(target.isSynthetic() && active)
		// Do some extra damage.  Not a whole lot more since emp_act() is pretty nasty on FBPs already.
		target.emp_act(3) // A weaker severity is used because this has infinite uses.
		playsound(target, 'sound/effects/EMPulse.ogg', 100, 1)
		target.adjustFireLoss(force * 3) // 15 Burn, for 20 total.
		playsound(target, 'sound/weapons/blade1.ogg', 100, 1)

		// Make lesser robots really mad at us.
		if(target.mob_class & MOB_CLASS_SYNTHETIC)
			if(target.has_AI())
				target.taunt(user)
			target.adjustFireLoss(force * 6) // 30 Burn, for 50 total.

/obj/item/weapon/melee/energy/sword/ionic_rapier/lance
	name = "zero-point lance"
	desc = "Designed specifically for disrupting electronics at relatively close range, however it is still capable of dealing some damage to living beings."
	active_force = 20
	armor_penetration = 15
	reach = 2

/*
 * Charge blade. Uses a cell, and costs energy per strike.
 */

/obj/item/weapon/melee/energy/sword/charge
	name = "charge sword"
	desc = "A small, handheld device which emits a high-energy 'blade'."
	origin_tech = list(TECH_COMBAT = 5, TECH_MAGNET = 3, TECH_ILLEGAL = 4)
	active_force = 25
	armor_penetration = 25
	projectile_parry_chance = 40
	colorable = TRUE

	hitcost = 75

/obj/item/weapon/melee/energy/sword/charge/loaded/New()
	..()
	bcell = new/obj/item/weapon/cell/device/weapon(src)

//Energy Blade (ninja uses this)

//Can't be activated or deactivated, so no reason to be a subtype of energy
/obj/item/weapon/melee/energy/blade
	name = "energy blade"
	desc = "A concentrated beam of energy in the shape of a blade. Very stylish... and lethal."
	icon_state = "blade"
	item_state = "blade"
	force = 40 //Normal attacks deal very high damage - about the same as wielded fire axe
	armor_penetration = 100
	sharp = 1
	edge = 1
	anchored = 1    // Never spawned outside of inventory, should be fine.
	throwforce = 1  //Throwing or dropping the item deletes it.
	throw_speed = 1
	throw_range = 1
	w_class = ITEMSIZE_LARGE//So you can't hide it in your pocket or some such.
	flags = NOBLOODY
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	var/mob/living/creator
	var/datum/effect/effect/system/spark_spread/spark_system
	projectile_parry_chance = 60
	lcolor = "#00FF00"

/obj/item/weapon/melee/energy/blade/New()

	spark_system = new /datum/effect/effect/system/spark_spread()
	spark_system.set_up(5, 0, src)
	spark_system.attach(src)

	START_PROCESSING(SSobj, src)
	set_light(lrange, lpower, lcolor)

/obj/item/weapon/melee/energy/blade/Destroy()
	STOP_PROCESSING(SSobj, src)
	..()

/obj/item/weapon/melee/energy/blade/attack_self(mob/user as mob)
	user.drop_from_inventory(src)
	spawn(1) if(src) qdel(src)

/obj/item/weapon/melee/energy/blade/dropped()
	spawn(1) if(src) qdel(src)

/obj/item/weapon/melee/energy/blade/process()
	if(!creator || loc != creator || !creator.item_is_in_hands(src))
		// Tidy up a bit.
		if(istype(loc,/mob/living))
			var/mob/living/carbon/human/host = loc
			if(istype(host))
				for(var/obj/item/organ/external/organ in host.organs)
					for(var/obj/item/O in organ.implants)
						if(O == src)
							organ.implants -= src
			host.pinned -= src
			host.embedded -= src
			host.drop_from_inventory(src)
		spawn(1) if(src) qdel(src)

/obj/item/weapon/melee/energy/blade/handle_shield(mob/user, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")
	if(default_parry_check(user, attacker, damage_source) && prob(60))
		user.visible_message("<span class='danger'>\The [user] parries [attack_text] with \the [src]!</span>")

		var/datum/effect/effect/system/spark_spread/spark_system = new /datum/effect/effect/system/spark_spread()
		spark_system.set_up(5, 0, user.loc)
		spark_system.start()
		playsound(src, 'sound/weapons/blade1.ogg', 50, 1)
		return 1
	if(unique_parry_check(user, attacker, damage_source) && prob(projectile_parry_chance))
		user.visible_message("<span class='danger'>\The [user] deflects [attack_text] with \the [src]!</span>")

		var/datum/effect/effect/system/spark_spread/spark_system = new /datum/effect/effect/system/spark_spread()
		spark_system.set_up(5, 0, user.loc)
		spark_system.start()
		playsound(src, 'sound/weapons/blade1.ogg', 50, 1)
		return 1

	return 0

/obj/item/weapon/melee/energy/blade/unique_parry_check(mob/user, mob/attacker, atom/damage_source)

	if(user.incapacitated() || !istype(damage_source, /obj/item/projectile/))
		return 0

	var/bad_arc = reverse_direction(user.dir)
	if(!check_shield_arc(user, bad_arc, damage_source, attacker))
		return 0

	return 1

//Energy Spear

/obj/item/weapon/melee/energy/spear
	name = "energy spear"
	desc = "Concentrated energy forming a sharp tip at the end of a long rod."
	icon_state = "espear"
	armor_penetration = 75
	sharp = 1
	edge = 1
	force = 5
	throwforce = 10
	throw_speed = 7
	throw_range = 11
	reach = 2
	w_class = ITEMSIZE_LARGE
	active_force = 25
	active_throwforce = 30
	active_w_class = ITEMSIZE_HUGE
	colorable = TRUE


	lcolor = "#800080"

/obj/item/weapon/melee/energy/spear/activate(mob/living/user)
	if(!active)
		to_chat(user, "<span class='notice'>\The [src] is now energised.</span>")
	..()
	attack_verb = list("jabbed", "stabbed", "impaled")


/obj/item/weapon/melee/energy/spear/deactivate(mob/living/user)
	if(active)
		to_chat(user, "<span class='notice'>\The [src] deactivates!</span>")
	..()
	attack_verb = list("whacked", "beat", "slapped", "thonked")

/obj/item/weapon/melee/energy/spear/handle_shield(mob/user, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")
	if(active && default_parry_check(user, attacker, damage_source) && prob(50))
		user.visible_message("<span class='danger'>\The [user] parries [attack_text] with \the [src]!</span>")
		var/datum/effect/effect/system/spark_spread/spark_system = new /datum/effect/effect/system/spark_spread()
		spark_system.set_up(5, 0, user.loc)
		spark_system.start()
		playsound(src, 'sound/weapons/blade1.ogg', 50, 1)
		return 1
	return 0
