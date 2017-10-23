/obj/item/weapon/melee/energy
	var/active = 0
	var/active_force
	var/active_throwforce
	var/active_w_class
	var/active_embed_chance = 0		//In the off chance one of these is supposed to embed, you can just tweak this var
	sharp = 0
	edge = 0
	armor_penetration = 50
	flags = NOBLOODY
	var/lrange = 2
	var/lpower = 2
	var/lcolor = "#0099FF"

/obj/item/weapon/melee/energy/proc/activate(mob/living/user)
	if(active)
		return
	active = 1
	embed_chance = active_embed_chance
	force = active_force
	throwforce = active_throwforce
	sharp = 1
	edge = 1
	w_class = active_w_class
	playsound(user, 'sound/weapons/saberon.ogg', 50, 1)
	set_light(lrange, lpower, lcolor)

/obj/item/weapon/melee/energy/proc/deactivate(mob/living/user)
	if(!active)
		return
	playsound(user, 'sound/weapons/saberoff.ogg', 50, 1)
	active = 0
	embed_chance = initial(embed_chance)
	force = initial(force)
	throwforce = initial(throwforce)
	sharp = initial(sharp)
	edge = initial(edge)
	w_class = initial(w_class)
	set_light(0,0)

/obj/item/weapon/melee/energy/attack_self(mob/living/user as mob)
	if (active)
		if ((CLUMSY in user.mutations) && prob(50))
			user.visible_message("<span class='danger'>\The [user] accidentally cuts \himself with \the [src].</span>",\
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
	var/tempgender = "[user.gender == MALE ? "he's" : user.gender == FEMALE ? "she's" : "they are"]"
	if (active)
		viewers(user) << pick("<span class='danger'>\The [user] is slitting \his stomach open with \the [src]! It looks like [tempgender] trying to commit seppuku.</span>", \
		                      "<span class='danger'>\The [user] is falling on \the [src]! It looks like [tempgender] trying to commit suicide.</span>")
		return (BRUTELOSS|FIRELOSS)

/*
 * Energy Axe
 */
/obj/item/weapon/melee/energy/axe
	name = "energy axe"
	desc = "An energised battle axe."
	icon_state = "axe0"
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
	flags = CONDUCT | NOBLOODY
	origin_tech = list(TECH_MAGNET = 3, TECH_COMBAT = 4)
	attack_verb = list("attacked", "chopped", "cleaved", "torn", "cut")
	sharp = 1
	edge = 1

/obj/item/weapon/melee/energy/axe/activate(mob/living/user)
	..()
	icon_state = "axe1"
	user << "<span class='notice'>\The [src] is now energised.</span>"

/obj/item/weapon/melee/energy/axe/deactivate(mob/living/user)
	..()
	icon_state = initial(icon_state)
	user << "<span class='notice'>\The [src] is de-energised. It's just a regular axe now.</span>"

/obj/item/weapon/melee/energy/axe/suicide_act(mob/user)
	viewers(user) << "<span class='warning'>\The [user] swings \the [src] towards \his head! It looks like \he's trying to commit suicide.</span>"
	return (BRUTELOSS|FIRELOSS)

/*
 * Energy Sword
 */
/obj/item/weapon/melee/energy/sword
	color
	name = "energy sword"
	desc = "May the force be within you."
	icon_state = "sword0"
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
	var/blade_color
	var/random_color = TRUE
	var/active_state = "sword"

/obj/item/weapon/melee/energy/sword/dropped(var/mob/user)
	..()
	if(!istype(loc,/mob))
		deactivate(user)

/obj/item/weapon/melee/energy/sword/New()
	if(random_color)
		blade_color = pick("red","blue","green","purple")
		lcolor = blade_color

/obj/item/weapon/melee/energy/sword/green/New()
	blade_color = "green"
	lcolor = "#008000"

/obj/item/weapon/melee/energy/sword/red/New()
	blade_color = "red"
	lcolor = "#FF0000"

/obj/item/weapon/melee/energy/sword/blue/New()
	blade_color = "blue"
	lcolor = "#0000FF"

/obj/item/weapon/melee/energy/sword/purple/New()
	blade_color = "purple"
	lcolor = "#800080"

/obj/item/weapon/melee/energy/sword/activate(mob/living/user)
	if(!active)
		user << "<span class='notice'>\The [src] is now energised.</span>"

	..()
	attack_verb = list("attacked", "slashed", "stabbed", "sliced", "torn", "ripped", "diced", "cut")
	icon_state = "[active_state][blade_color]"


/obj/item/weapon/melee/energy/sword/deactivate(mob/living/user)
	if(active)
		user << "<span class='notice'>\The [src] deactivates!</span>"
	..()
	attack_verb = list()
	icon_state = initial(icon_state)

/obj/item/weapon/melee/energy/sword/handle_shield(mob/user, var/damage, atom/damage_source = null, mob/attacker = null, var/def_zone = null, var/attack_text = "the attack")
	if(active && default_parry_check(user, attacker, damage_source) && prob(50))
		user.visible_message("<span class='danger'>\The [user] parries [attack_text] with \the [src]!</span>")

		var/datum/effect/effect/system/spark_spread/spark_system = new /datum/effect/effect/system/spark_spread()
		spark_system.set_up(5, 0, user.loc)
		spark_system.start()
		playsound(user.loc, 'sound/weapons/blade1.ogg', 50, 1)
		return 1
	return 0

/obj/item/weapon/melee/energy/sword/pirate
	name = "energy cutlass"
	desc = "Arrrr matey."
	icon_state = "cutlass0"

/obj/item/weapon/melee/energy/sword/pirate/activate(mob/living/user)
	..()
	icon_state = "cutlass1"

/*
 *Ionic Rapier
 */

/obj/item/weapon/melee/energy/sword/ionic_rapier
	name = "ionic rapier"
	desc = "Designed specifically for disrupting electronics at close range, it is extremely deadly against synthetics, but almost harmless to pure organic targets."
	description_info = "This is a dangerous melee weapon that will deliver a moderately powerful electromagnetic pulse to whatever it strikes.  \
	Striking a lesser robotic entity will compel it to attack you, as well.  It also does extra burn damage to robotic entities, but it does \
	very little damage to purely organic targets."
	icon_state = "ionic_rapier0"
	random_color = FALSE
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
	active_state = "ionic_rapier"

/obj/item/weapon/melee/energy/sword/ionic_rapier/afterattack(var/atom/movable/AM, var/mob/living/user, var/proximity)
	if(istype(AM, /obj) && proximity && active)
		// EMP stuff.
		var/obj/O = AM
		O.emp_act(3) // A weaker severity is used because this has infinite uses.
		playsound(get_turf(O), 'sound/effects/EMPulse.ogg', 100, 1)
		user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN) // A lot of objects don't set click delay.
	return ..()

/obj/item/weapon/melee/energy/sword/ionic_rapier/apply_hit_effect(mob/living/target, mob/living/user, var/hit_zone)
	. = ..()
	if(target.isSynthetic() && active)
		// Do some extra damage.  Not a whole lot more since emp_act() is pretty nasty on FBPs already.
		target.emp_act(3) // A weaker severity is used because this has infinite uses.
		playsound(get_turf(target), 'sound/effects/EMPulse.ogg', 100, 1)
		target.adjustFireLoss(force * 3) // 15 Burn, for 20 total.
		playsound(get_turf(target), 'sound/weapons/blade1.ogg', 100, 1)

		// Make lesser robots really mad at us.
		if(istype(target, /mob/living/simple_animal))
			var/mob/living/simple_animal/SA = target
			if(SA.intelligence_level == SA_ROBOTIC)
				SA.taunt(user)
			SA.adjustFireLoss(force * 6) // 30 Burn, for 50 total.

/*
 *Energy Blade
 */

//Can't be activated or deactivated, so no reason to be a subtype of energy
/obj/item/weapon/melee/energy/blade
	name = "energy blade"
	desc = "A concentrated beam of energy in the shape of a blade. Very stylish... and lethal."
	icon_state = "blade"
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
	lcolor = "#00FF00"

/obj/item/weapon/melee/energy/blade/New()

	spark_system = new /datum/effect/effect/system/spark_spread()
	spark_system.set_up(5, 0, src)
	spark_system.attach(src)

	processing_objects |= src
	set_light(lrange, lpower, lcolor)

/obj/item/weapon/melee/energy/blade/Destroy()
	processing_objects -= src
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
