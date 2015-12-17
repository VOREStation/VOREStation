#define CAST_USE		1
#define CAST_MELEE		2
#define CAST_RANGED		4
#define CAST_THROW		8
#define CAST_COMBINE	16

/obj/item/weapon/spell
	name = "glowing particles"
	desc = "Your hands appear to be glowing brightly."
	icon = 'icons/obj/spells.dmi'
	icon_state = "generic"
	item_icons = list(
	slot_l_hand_str = 'icons/mob/items/lefthand_spells.dmi',
	slot_r_hand_str = 'icons/mob/items/righthand_spells.dmi',
	)
	throwforce = 0
	force = 0
	var/mob/living/carbon/human/owner = null
	var/cost = 0
	var/cast_methods = null

/obj/item/weapon/spell/proc/on_use_cast(mob/user)
	return

/obj/item/weapon/spell/proc/on_throw_cast(atom/hit_atom)
	return

/obj/item/weapon/spell/proc/on_ranged_cast(atom/hit_atom, mob/user)
	return

/obj/item/weapon/spell/proc/on_melee_cast(atom/hit_atom, mob/living/user, def_zone)
	return

/obj/item/weapon/spell/proc/on_combine_cast(obj/item/W, mob/user)
	return

/obj/item/weapon/spell/New()
	..()
	if(ishuman(loc))
		owner = loc

/obj/item/weapon/spell/Destroy()
	owner = null
	..()

/obj/item/weapon/spell/proc/run_checks()
	if(!owner)
		return 0
	return 1

/obj/item/weapon/spell/attack_self(mob/user)
	if(run_checks() && (cast_methods & CAST_USE))
		world << "attack_self([user]) called"
		on_use_cast(user)
	..()

/obj/item/weapon/spell/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/weapon/spell))
		if(run_checks() & (cast_methods & CAST_COMBINE))
			on_combine_cast(W, user)
	else
		..()

/obj/item/weapon/spell/afterattack(atom/target, mob/user, proximity_flag, click_parameters)
	world << "afterattack([target],[user],[proximity_flag],[click_parameters]) called."
	if(!run_checks())
		return
	if(!proximity_flag)
		if(cast_methods & CAST_RANGED)
			on_ranged_cast(target, user)
			world << "range cast called"
	else
		if(cast_methods & CAST_MELEE)
			if(..()) //Check that we didn't miss.
				on_melee_cast(target, user)
				world << "melee cast called"
		else if(cast_methods & CAST_RANGED)
			on_ranged_cast(target, user)
			world << "range cast called"

//debug test verbs, kill Neerti if this makes it live.
/mob/verb/apportation()
	set category = "Functions"
	set name = "Apportation()"
	set src = usr
	if(!ishuman(src))
		return 0

	var/mob/living/carbon/human/H = src

	H.place_spell_in_hand(/obj/item/weapon/spell/apportation)

/mob/verb/blink()
	set category = "Functions"
	set name = "Blink()"
	set src = usr
	if(!ishuman(src))
		return 0

	var/mob/living/carbon/human/H = src

	H.place_spell_in_hand(/obj/item/weapon/spell/blink)

/mob/verb/darkness()
	set category = "Functions"
	set name = "Darkness()"
	set src = usr
	if(!ishuman(src))
		return 0

	var/mob/living/carbon/human/H = src

	H.place_spell_in_hand(/obj/item/weapon/spell/darkness)

/mob/living/carbon/human/proc/place_spell_in_hand(var/path)
	if(src.l_hand && src.r_hand) //Make sure our hands aren't full.
		src << "<span class='warning'>You require a free hand to use a function.</span>"
		return 0

	var/obj/item/weapon/spell/S = PoolOrNew(path, src)
	src.put_in_hands(S)

/obj/item/weapon/spell/dropped()
	spawn(1)
		if(src)
			qdel(src)

/obj/item/weapon/spell/throw_impact(atom/hit_atom)
	..()
	if(cast_methods & CAST_THROW)
		on_throw_cast(hit_atom)
		world << "on_throw_cast([hit_atom]) called."

	// If we miss or hit an obstacle, we still want to delete the spell.
	spawn(20)
		if(src)
			qdel(src)