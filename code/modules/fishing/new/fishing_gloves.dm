///A pair of gloves that both allow the user to fish without the need of a held fishing rod and provides athletics experience.
/obj/item/clothing/gloves/fishing
	name = "athletic fishing gloves"
	desc = "A pair of gloves to fish without a fishing rod but your raw <b>athletics</b> strength. It doubles as a good workout device. <i><b>WARNING</b>: May cause injuries when catching bigger fish.</i>"
	icon_state = "fishing_gloves"
	///The current fishing minigame datum the wearer is engaged in.
	var/datum/fishing_challenge/challenge

/obj/item/clothing/gloves/fishing/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/profound_fisher, new /obj/item/fishing_rod/mob_fisher/athletic(src))
	AddElement(/datum/element/adjust_fishing_difficulty, -4) //on top of the extra that you get from the athletics skill.

/obj/item/clothing/gloves/fishing/equipped(mob/user, slot)
	. = ..()
	if(slot == SLOT_GLOVES)
		RegisterSignal(user, COMSIG_MOB_BEGIN_FISHING_MINIGAME, PROC_REF(begin_workout))

/obj/item/clothing/gloves/fishing/dropped(mob/user)
	UnregisterSignal(user, COMSIG_MOB_BEGIN_FISHING_MINIGAME)
	if(challenge)
		stop_workout(user)
	return ..()

/obj/item/clothing/gloves/fishing/proc/begin_workout(datum/source, datum/fishing_challenge/challenge)
	SIGNAL_HANDLER
	RegisterSignal(source, COMSIG_MOB_COMPLETE_FISHING, PROC_REF(stop_workout))
	if(HAS_TRAIT(source, TRAIT_PROFOUND_FISHER)) //Only begin working out if we're fishing with these gloves and not some other fishing rod..
		START_PROCESSING(SSprocessing, src)
		src.challenge = challenge

/obj/item/clothing/gloves/fishing/proc/stop_workout(datum/source)
	SIGNAL_HANDLER
	UnregisterSignal(source, COMSIG_MOB_COMPLETE_FISHING)
	challenge = null
	STOP_PROCESSING(SSprocessing, src)

/obj/item/clothing/gloves/fishing/process(seconds_per_tick)
	return
//	var/mob/living/wearer = loc
//	var/stamina_exhaustion = 2 + challenge.difficulty * 0.02
//	var/is_heavy_gravity = wearer.has_gravity() > STANDARD_GRAVITY
//	var/obj/item/organ/cyberimp/chest/spine/potential_spine = wearer.get_organ_slot(ORGAN_SLOT_SPINE)
//	if(istype(potential_spine))
//		stamina_exhaustion *= potential_spine.athletics_boost_multiplier
//	if(HAS_TRAIT(wearer, TRAIT_STRENGTH))
//		stamina_exhaustion *= 0.5

//	var/experience = 0.3 + challenge.difficulty * 0.003
//	if(is_heavy_gravity)
//		stamina_exhaustion *= 1.5
//		experience *= 2

//	wearer.adjust_stamina_loss(stamina_exhaustion)
//	wearer.mind?.adjust_experience(/datum/skill/athletics, experience)
//	wearer.apply_status_effect(/datum/status_effect/exercised)

///The internal fishing rod of the athletic fishing gloves. The more athletic you're, the easier the minigame will be.
/obj/item/fishing_rod/mob_fisher/athletic
	name = "athletics fishing gloves"
	icon = /obj/item/clothing/gloves/fishing::icon
	icon_state = /obj/item/clothing/gloves/fishing::icon_state
	frame_state = "frame_athletic"
	line = null
	bait = null
	ui_description = "A pair of gloves to fish without a fishing rod while training your athletics."
	wiki_description = "<b>It requires the Advanced Fishing Technology Node to be researched to be printed.</b> It may hurt the user when catching larger fish."
	show_in_wiki = TRUE //Show this cool pair of gloves in the wiki.

/obj/item/fishing_rod/mob_fisher/athletic/Initialize(mapload)
	. = ..()
	RegisterSignal(src, COMSIG_FISHING_ROD_CAUGHT_FISH, PROC_REF(noodling_is_dangerous))

/obj/item/fishing_rod/mob_fisher/athletic/get_fishing_overlays()
	return list()

/obj/item/fishing_rod/mob_fisher/athletic/hook_hit(atom/atom_hit_by_hook_projectile, mob/user)
//	difficulty_modifier = -3 * (user.mind?.get_skill_level(/datum/skill/athletics) - 1)
	return ..()

/obj/item/fishing_rod/mob_fisher/athletic/proc/noodling_is_dangerous(datum/source, atom/movable/reward, mob/living/user)
	SIGNAL_HANDLER
	if(!isfish(reward))
		return
	var/damage = 0
	var/obj/item/fish/fishe = reward
	switch(fishe.w_class)
		if(ITEMSIZE_LARGE)
			damage = 10
		if(ITEMSIZE_HUGE)
			damage = 14
		if(ITEMSIZE_GIGANTIC)
			damage = 18
	if(!damage && fishe.weight >= 2000)
		damage = 5
	damage = round(damage * fishe.weight * 0.0005)
	if(damage)
		var/body_zone = pick(BP_R_HAND, BP_L_HAND)
		user.apply_damage(damage, BRUTE, body_zone, user.run_armor_check(body_zone, MELEE))
		playsound(src,'sound/items/weapons/bite.ogg', damage * 2, TRUE)
