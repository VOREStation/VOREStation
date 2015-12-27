//cast_method flags
#define CAST_USE		1	//Clicking the spell in your hand.
#define CAST_MELEE		2	//Clicking an atom in melee range.
#define CAST_RANGED		4	//Clicking an atom beyond melee range.
#define CAST_THROW		8	//Throwing the spell and hitting an atom.
#define CAST_COMBINE	16	//Clicking another spell with this spell.
#define CAST_INNATE		32	//Activates upon verb usage, used for mobs without hands.

//Aspects
#define ASPECT_FIRE			"fire" 		//Damage over time and raising body-temp.  Firesuits protect from this.
#define ASPECT_FROST		"frost"		//Slows down the affected, also involves imbedding with icicles.  Winter coats protect from this.
#define ASPECT_SHOCK		"shock"		//Energy-expensive, usually stuns.  Insulated armor protects from this.
#define ASPECT_AIR			"air"		//Mostly involves manipulation of atmos, useless in a vacuum.  Magboots protect from this.
#define ASPECT_FORCE		"force" 	//Manipulates gravity to push things away or towards a location.
#define ASPECT_TELE			"tele"		//Teleportation of self, other objects, or other people.
#define ASPECT_DARK			"dark"		//Makes all those photons vanish using magic-- WITH SCIENCE.  Used for sneaky stuff.
#define ASPECT_LIGHT		"light"		//The opposite of dark, usually blinds, makes holo-illusions, or makes laser lightshows.
#define ASPECT_EMP			"emp"		//Self explainitory.
#define ASPECT_CHAOS		"chaos"		//Heavily RNG-based, causes instability to the victim.
#define ASPECT_CHROMATIC	"chromatic"	//Used to combine with other spells.


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
	var/obj/item/weapon/technomancer_core/core = null
	var/cost = 0
	var/cast_methods = null
	var/aspect = null
	var/toggled = 0 //Mainly used for overlays

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

//TODO
/obj/item/weapon/spell/proc/pay_energy(var/amount)
	if(!core)
		return 0
	return core.pay_energy(amount)

/obj/item/weapon/spell/proc/give_energy(var/amount)
	return 1

/obj/item/weapon/spell/proc/adjust_instability(var/amount)
	if(!owner)
		return 0
	owner.adjust_instability(amount)

/obj/item/weapon/spell/New()
	..()
	if(ishuman(loc))
		owner = loc
	if(owner)
		if(istype(/obj/item/weapon/technomancer_core, owner.back))
			core = owner.back
	update_icon()

/obj/item/weapon/spell/Destroy()
	owner = null
	..()

/obj/item/weapon/spell/update_icon()
	if(toggled)
		var/image/new_overlay = image('icons/obj/spells.dmi',"toggled")
		overlays |= new_overlay
	else
		overlays.Cut()
	..()

/obj/item/weapon/spell/proc/run_checks()
	if(!owner)
		return 0
	if(!core)
		core = locate(/obj/item/weapon/technomancer_core) in owner
		if(!core)
			owner << "<span class='danger'>You need to be wearing a core on your back!</span>"
			return 0
	if(core.loc != owner || owner.back != core) //Make sure the core's being worn.
		owner << "<span class='danger'>You need to be wearing a core on your back!</span>"
		return 0
	return 1

/obj/item/weapon/spell/attack_self(mob/user)
	if(run_checks() && (cast_methods & CAST_USE))
		world << "attack_self([user]) called"
		on_use_cast(user)
	..()

/obj/item/weapon/spell/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/weapon/spell))
		var/obj/item/weapon/spell/spell = W
		if(run_checks() & (cast_methods & CAST_COMBINE))
			spell.on_combine_cast(src, user)
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
		if(cast_methods & CAST_COMBINE) //For some reason attackby() won't work for this.
			if(istype(target, /obj/item/weapon/spell))
				var/obj/item/weapon/spell/spell = target
				spell.on_combine_cast(src, user)
				return
		if(cast_methods & CAST_MELEE)
//			if(..()) //Check that we didn't miss.
			on_melee_cast(target, user)
			world << "melee cast called"
		else if(cast_methods & CAST_RANGED) //Try to use a ranged method if a melee one doesn't exist.
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

/mob/verb/radiance()
	set category = "Functions"
	set name = "Radiance()"
	set src = usr
	if(!ishuman(src))
		return 0

	var/mob/living/carbon/human/H = src

	H.place_spell_in_hand(/obj/item/weapon/spell/radiance)

/mob/verb/purify()
	set category = "Functions"
	set name = "Purify()"
	set src = usr
	if(!ishuman(src))
		return 0

	var/mob/living/carbon/human/H = src

	H.place_spell_in_hand(/obj/item/weapon/spell/purify)

/mob/verb/disable_technology()
	set category = "Functions"
	set name = "Disable_Technology()"
	set src = usr
	if(!ishuman(src))
		return 0

	var/mob/living/carbon/human/H = src

	H.place_spell_in_hand(/obj/item/weapon/spell/pulsar)

/mob/verb/passwall()
	set category = "Functions"
	set name = "Passwall()"
	set src = usr
	if(!ishuman(src))
		return 0

	var/mob/living/carbon/human/H = src

	H.place_spell_in_hand(/obj/item/weapon/spell/passwall)

/mob/verb/phase_shift()
	set category = "Functions"
	set name = "Phase_Shift()"
	set src = usr
	if(!ishuman(src))
		return 0

	var/mob/living/carbon/human/H = src

	H.place_spell_in_hand(/obj/item/weapon/spell/phase_shift)

/mob/verb/warp_strike()
	set category = "Functions"
	set name = "Warp_Strike()"
	set src = usr
	if(!ishuman(src))
		return 0

	var/mob/living/carbon/human/H = src

	H.place_spell_in_hand(/obj/item/weapon/spell/warp_strike)

/mob/verb/discharge()
	set category = "Functions"
	set name = "Discharge()"
	set src = usr
	if(!ishuman(src))
		return 0

	var/mob/living/carbon/human/H = src

	H.place_spell_in_hand(/obj/item/weapon/spell/discharge)

/mob/verb/aspect_bolt()
	set category = "Functions"
	set name = "Aspect Bolt()"
	set src = usr
	if(!ishuman(src))
		return 0

	var/mob/living/carbon/human/H = src

	H.place_spell_in_hand(/obj/item/weapon/spell/aspect_bolt)

/mob/living/carbon/human/proc/place_spell_in_hand(var/path)
	if(!path || !ispath(path))
		return 0
	if(src.l_hand && src.r_hand) //Make sure our hands aren't full.
		src << "<span class='warning'>You require a free hand to use a function.</span>"
		return 0
	var/obj/item/weapon/spell/S = PoolOrNew(path, src)
	if(S.run_checks())
		src.put_in_hands(S)
	else
		qdel(S)

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