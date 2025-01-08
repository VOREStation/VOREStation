/// Modified to work with the Artifact Harvester
/datum/artifact_effect/resurrect
	name = "Resurrection Vitality Swap" //Lets give whoever's using this a hint of just what it does.
	effect_type = EFFECT_RESURRECT

	var/stored_life = 0

	effect_state = "pulsing"
	effect_color = "#ff0000"

/datum/artifact_effect/resurrect/proc/steal_life(var/mob/living/target = null)
	var/atom/holder = get_master_holder()
	if(istype(holder, /obj/item/anobattery))
		holder = holder.loc
	if(isliving(holder.loc)) //We are being held by someone.
		holder = holder.loc
	if(!istype(target))
		return 0

	if(target.stat != DEAD && stored_life < 200)
		holder.Beam(target, icon_state = "drain_life", time = 1 SECOND)
		target.apply_damage(5, SEARING, BP_TORSO)
		return 5

	return 0

/datum/artifact_effect/resurrect/proc/give_life(var/mob/living/target = null)
	var/atom/holder = get_master_holder()

	/// ALRIGHT, LET ME EXPLAIN THIS ABOMINATION.
	/// First, we got holder = get_master_holder() that gives us either the artifact (and we skip all this nonsense)
	/// OR it returns anobattery. We then check to see if it is (it is) and then go 'alright, that's our holder now'
	/// If it's on the ground, it stops there and creates the beams and all the cool stuff.
	/// But if someone is holding us, it goes one further and sets the mob holding us as the holder
	/// To allow for proper generation of beams and whatnot.
	/// A lot of the xenoarch code does this because the harvester was never properly implemented in the 12ish years it's been here.
	/// So while this LOOKS weird, it's efficent.
	if(istype(holder, /obj/item/anobattery))
		holder = holder.loc
	if(isliving(holder.loc)) //We are being held by someone.
		holder = holder.loc
	if(!isliving(target))
		return

	if(target.stat == DEAD && stored_life)
		holder.Beam(target, icon_state = "lichbeam", time = 1 SECOND)
		target.adjustBruteLoss(-5)
		target.adjustFireLoss(-5)
		target.adjustCloneLoss(-5)
		target.adjustOxyLoss(-5)
		target.adjustHalLoss(-5)
		target.adjustToxLoss(-5)
		stored_life = max(0, stored_life - 5)

		if(target.health > (target.maxHealth / 4))
			attempt_revive(target)
			stored_life = 0

/datum/artifact_effect/resurrect/proc/attempt_revive(var/mob/living/L = null)
	var/atom/holder = get_master_holder()
	spawn()
		if(isanimal(L))
			var/mob/living/simple_mob/SM = L
			SM.adjustBruteLoss(-40)
			SM.adjustFireLoss(-40)
			SM.health = SM.getMaxHealth() / 3
			SM.stat = CONSCIOUS
			dead_mob_list -= SM
			living_mob_list += SM
			SM.update_icon()
			SM.revive()
			holder.visible_message(span_alien("\The [SM]'s eyes open in a flash of light!"))
		else if(ishuman(L))
			var/mob/living/carbon/human/H = L

			if(!H.client && H.mind)
				for(var/mob/observer/dead/ghost in player_list)
					if(ghost.mind == H.mind)
						to_chat(ghost, span_large(span_interface(span_bold("An artifact is trying to \
						revive you. Return to your body if you want to be resurrected!") + "\
						(Verbs -> Ghost -> Re-enter corpse)")))
						break

			H.adjustBruteLoss(-40)
			H.adjustFireLoss(-40)
			holder.visible_message(span_alien("\The [H]'s body begins to shift and stir, loud, wet cracks emitting from within!"))

			sleep(10 SECONDS)
			if(H.client)
				L.stat = CONSCIOUS
				dead_mob_list -= H
				living_mob_list += H
				H.timeofdeath = null

				holder.visible_message(span_alien("\The [H]'s eyes open in a flash of light!"))
			else
				holder.visible_message(span_alien("\The [H]'s body stays still...Perhaps their mind was not ready to rejoin their body."))

/datum/artifact_effect/resurrect/DoEffectTouch(var/mob/user)
	var/atom/holder = get_master_holder()
	if(istype(holder, /obj/item/anobattery))
		holder = holder.loc
	if(isliving(holder.loc)) //We are being held by someone.
		holder = holder.loc
	for(var/mob/living/L in oview(effectrange, get_turf(holder)))
		stored_life += 4 * steal_life(L)

	for(var/mob/living/L in oview(effectrange, get_turf(holder)))
		if(L.stat == DEAD)
			give_life(L)
			break

/datum/artifact_effect/resurrect/DoEffectAura()
	var/atom/holder = get_master_holder()
	if(istype(holder, /obj/item/anobattery))
		holder = holder.loc
	if(isliving(holder.loc)) //We are being held by someone.
		holder = holder.loc
	for(var/mob/living/L in oview(effectrange, get_turf(holder)))
		stored_life += steal_life(L)

	for(var/mob/living/L in oview(effectrange, get_turf(holder)))
		if(L.stat == DEAD)
			give_life(L)
			break

/datum/artifact_effect/resurrect/DoEffectPulse()
	var/atom/holder = get_master_holder()
	if(istype(holder, /obj/item/anobattery))
		holder = holder.loc
	if(isliving(holder.loc)) //We are being held by someone.
		holder = holder.loc
	for(var/mob/living/L in oview(effectrange, get_turf(holder)))
		stored_life += 2 * steal_life(L)

	for(var/mob/living/L in oview(effectrange, get_turf(holder)))
		if(L.stat == DEAD)
			give_life(L)
			break
