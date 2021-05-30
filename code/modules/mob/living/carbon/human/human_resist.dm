/mob/living/carbon/human/resist_restraints()
	if(wear_suit && istype(wear_suit, /obj/item/clothing/suit/straight_jacket))
		return escape_straight_jacket()
	return ..()

#define RESIST_ATTACK_DEFAULT	0
#define RESIST_ATTACK_CLAWS		1
#define RESIST_ATTACK_BITE		2

/mob/living/carbon/human/proc/escape_straight_jacket()
	setClickCooldown(100)

	if(can_break_straight_jacket())
		break_straight_jacket()
		return

	var/mob/living/carbon/human/H = src
	var/obj/item/clothing/suit/straight_jacket/SJ = H.wear_suit

	var/breakouttime = SJ.resist_time	// Configurable per-jacket!

	var/attack_type = RESIST_ATTACK_DEFAULT

	if(H.gloves && istype(H.gloves,/obj/item/clothing/gloves/gauntlets/rig))
		breakouttime /= 2	// Pneumatic force goes a long way.
	else if(H.species.unarmed_types)
		for(var/datum/unarmed_attack/U in H.species.unarmed_types)
			if(istype(U, /datum/unarmed_attack/claws))
				breakouttime /= 1.5
				attack_type = RESIST_ATTACK_CLAWS
				break
			else if(istype(U, /datum/unarmed_attack/bite/sharp))
				breakouttime /= 1.25
				attack_type = RESIST_ATTACK_BITE
				break

	switch(attack_type)
		if(RESIST_ATTACK_DEFAULT)
			visible_message(
			"<span class='danger'>\The [src] struggles to remove \the [SJ]!</span>",
			"<span class='warning'>You struggle to remove \the [SJ]. (This will take around [round(breakouttime / 600)] minutes and you need to stand still.)</span>"
			)
		if(RESIST_ATTACK_CLAWS)
			visible_message(
			"<span class='danger'>\The [src] starts clawing at \the [SJ]!</span>",
			"<span class='warning'>You claw at \the [SJ]. (This will take around [round(breakouttime / 600)] minutes and you need to stand still.)</span>"
			)
		if(RESIST_ATTACK_BITE)
			visible_message(
			"<span class='danger'>\The [src] starts gnawing on \the [SJ]!</span>",
			"<span class='warning'>You gnaw on \the [SJ]. (This will take around [round(breakouttime / 600)] minutes and you need to stand still.)</span>"
			)

	if(do_after(src, breakouttime, incapacitation_flags = INCAPACITATION_DISABLED & INCAPACITATION_KNOCKDOWN))
		if(!wear_suit)
			return
		visible_message(
			"<span class='danger'>\The [src] manages to remove \the [wear_suit]!</span>",
			"<span class='notice'>You successfully remove \the [wear_suit].</span>"
			)
		drop_from_inventory(wear_suit)

#undef RESIST_ATTACK_DEFAULT
#undef RESIST_ATTACK_CLAWS
#undef RESIST_ATTACK_BITE

/mob/living/carbon/human/proc/can_break_straight_jacket()
	if((HULK in mutations) || species.can_shred(src,1))
		return 1

/mob/living/carbon/human/proc/break_straight_jacket()
	visible_message(
		"<span class='danger'>[src] is trying to rip \the [wear_suit]!</span>",
		"<span class='warning'>You attempt to rip your [wear_suit.name] apart. (This will take around 5 seconds and you need to stand still)</span>"
		)

	if(do_after(src, 20 SECONDS, incapacitation_flags = INCAPACITATION_DEFAULT & ~INCAPACITATION_RESTRAINED))	// Same scaling as breaking cuffs, 5 seconds to 120 seconds, 20 seconds to 480 seconds.
		if(!wear_suit || buckled)
			return

		visible_message(
			"<span class='danger'>[src] manages to rip \the [wear_suit]!</span>",
			"<span class='warning'>You successfully rip your [wear_suit.name].</span>"
			)

		say(pick(";RAAAAAAAARGH!", ";HNNNNNNNNNGGGGGGH!", ";GWAAAAAAAARRRHHH!", "NNNNNNNNGGGGGGGGHH!", ";AAAAAAARRRGH!", "RAAAAAAAARGH!", "HNNNNNNNNNGGGGGGH!", "GWAAAAAAAARRRHHH!", "AAAAAAARRRGH!" ))

		qdel(wear_suit)
		wear_suit = null
		if(buckled && buckled.buckle_require_restraints)
			buckled.unbuckle_mob()

/mob/living/carbon/human/can_break_cuffs()
	if(species.can_shred(src,1))
		return 1
	return ..()
