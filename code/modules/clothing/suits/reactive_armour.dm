/obj/item/clothing/suit/armor/reactive_armor_shell
	name = "reactive armor shell"
	desc = "An experimental suit of armor, awaiting installation of an anomaly core."
	icon_state = "reactiveoff"
	w_class = ITEMSIZE_COST_LARGE

/obj/item/clothing/suit/armor/reactive_armor_shell/attackby(obj/item/I, mob/user)
	. = ..()
	var/static/list/anomaly_armour_types = list(
		/obj/effect/anomaly/grav = /obj/item/clothing/suit/armor/reactive/repulse,
		/obj/effect/anomaly/flux = /obj/item/clothing/suit/armor/reactive/tesla,
		/obj/effect/anomaly/bluespace = /obj/item/clothing/suit/armor/reactive/teleport,
		//obj/effect/anomaly/bioscrambler = /obj/item/clothing/suit/armor/reactive/bioscrambling,
		/obj/effect/anomaly/hallucination = /obj/item/clothing/suit/armor/reactive/hallucinating,
		/obj/effect/anomaly/dimensional = /obj/item/clothing/suit/armor/reactive/barricade,
		/obj/effect/anomaly/pyro = /obj/item/clothing/suit/armor/reactive/fire
	)

	if(istype(I, /obj/item/assembly/signaler/anomaly))
		var/obj/item/assembly/signaler/anomaly/anomaly = I
		var/armour_path = is_path_in_list(anomaly.anomaly_type, anomaly_armour_types, TRUE)
		if(!armour_path)
			armour_path = /obj/item/clothing/suit/armor/reactive/stealth
		to_chat(user, span_notice("You insert [anomaly] into the chest plate, and the armour gently hums to life."))
		new armour_path(get_turf(src))
		qdel(src)
		qdel(anomaly)
		return TRUE

/obj/item/clothing/suit/armor/reactive
	name = "reactive armor"
	desc = "Doesn't seem to do much for some reason."
	icon_state = "reactiveoff"
	blood_overlay_type = "armor"
	armor = list(melee = 40, bullet = 35, laser = 35, energy = 10, bomb = 10, bio = 0, rad = 0)
	var/hit_reaction_chance = 50
	///Whether the armor will try to react to hits (is it on)
	var/active = FALSE
	///This will be true for 30 seconds after an EMP, it makes the reaction effect dangerous to the user.
	var/bad_effect = FALSE
	///Message sent when the armor is emp'd. It is not the message for when the emp effect goes off.
	var/emp_message = span_warning("The reactive armor has been emp'd! Damn, now it's REALLY gonna not do much!")
	///Message sent when the armor is still on cooldown, but activates.
	var/cooldown_message = span_danger("The reactive armor fails to do much, as it is recharging! From what? Only the reactive armor knows.")
	///Duration of the cooldown specific to reactive armor for when it can activate again.
	var/reactivearmor_cooldown_duration = 10 SECONDS
	///The cooldown itself of the reactive armor for when it can activate again.
	var/reactivearmor_cooldown = 0

/obj/item/clothing/suit/armor/reactive/update_icon()
	. = ..()
	icon_state = "reactive[active ? null : "off"]"

/obj/item/clothing/suit/armor/reactive/attack_self(mob/user)
	active = !active
	to_chat(user, span_notice("[src] is now [active ? "active" : "inactive"]."))
	update_icon()
	add_fingerprint(user)

/obj/item/clothing/suit/armor/reactive/handle_shield(mob/user, damage, atom/damage_source, mob/attacker, def_zone, attack_text)
	if(!active || !prob(hit_reaction_chance))
		return FALSE
	if(world.time < reactivearmor_cooldown)
		cooldown_activation(user)
		return FALSE
	if(bad_effect)
		return emp_activation(user, damage_source, attack_text, damage)
	else
		return reactive_activation(user, damage_source, attack_text, damage)

/obj/item/clothing/suit/armor/reactive/proc/cooldown_activation(var/mob/living/carbon/human/owner)
	owner.visible_message(cooldown_message)

/obj/item/clothing/suit/armor/reactive/proc/reactive_activation(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", damage = 0)
	owner.visible_message(span_danger("The reactive armor doesn't do much! No surprises here."))
	return TRUE

/obj/item/clothing/suit/armor/reactive/proc/emp_activation(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", damage = 0)
	owner.visible_message(span_danger("The reactive armor doesn't do much, despite being emp'd! Besides giving off a special message, of course."))
	return TRUE

/obj/item/clothing/suit/armor/reactive/emp_act(severity, recursive)
	. = ..()
	if(bad_effect || !active)
		return
	visible_message(emp_message)
	bad_effect = TRUE
	addtimer(VARSET_CALLBACK(src, bad_effect, FALSE), 30 SECONDS)

/obj/item/clothing/suit/armor/reactive/teleport
	name = "reactive teleport armor"
	desc = "Someone separated our Research Director from his own head!"
	emp_message = span_warning("The reactive armor's teleportation calculations begin spewing errors!")
	cooldown_message = span_danger("The reactive teleport system is still recharging! It fails to activate!")
	reactivearmor_cooldown_duration = 10 SECONDS
	var/tele_range = 6

/obj/item/clothing/suit/armor/reactive/teleport/reactive_activation(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0)
	owner.visible_message(span_danger("The reactive teleport system flings [owner] clear of [attack_text]!"))
	playsound(get_turf(owner), 'sound/effects/phasein.ogg', 100, TRUE)
	do_teleport(owner, get_turf(owner), tele_range, no_effects = TRUE, channel = TELEPORT_CHANNEL_BLUESPACE)
	reactivearmor_cooldown = world.time + reactivearmor_cooldown_duration
	return TRUE

/obj/item/clothing/suit/armor/reactive/teleport/emp_activation(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", final_block_chance = 0, damage = 0)
	owner.visible_message(span_danger("The reactive teleport system flings itself clear of [attack_text], leaving someone behind in the process!"))
	owner.drop_from_inventory(src, get_turf(src))
	playsound(get_turf(owner),'sound/machines/buzz-sigh.ogg', 50, TRUE)
	playsound(get_turf(owner), 'sound/effects/phasein.ogg', 100, TRUE)
	do_teleport(src, get_turf(owner), tele_range, no_effects = TRUE, channel = TELEPORT_CHANNEL_BLUESPACE)
	reactivearmor_cooldown = world.time + reactivearmor_cooldown_duration
	return FALSE


/obj/item/clothing/suit/armor/reactive/repulse
	name = "reactive repulse armor"
	desc = "An experimental suit of armor that violently throws back attackers."
	cooldown_message = span_danger("The repulse generator is still recharging! It fails to generate a strong enough wave!")
	emp_message = span_warning("The repulse generator is reset to default settings...")

/obj/item/clothing/suit/armor/reactive/repulse/reactive_activation(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", damage = 0)
	playsound(get_turf(owner),'sound/effects/repulse.ogg', 100, TRUE)
	owner.visible_message(span_danger("[src] blocks [attack_text], converting the attack into a wave of force!"))
	var/turf/owner_turf = get_turf(owner)
	var/list/thrown_items = list()
	for(var/atom/movable/repulsed in range(owner_turf, 5))
		if(repulsed == owner || repulsed.anchored || thrown_items[repulsed])
			continue
		var/throwtarget = get_edge_target_turf(owner_turf, get_dir(owner_turf, get_step_away(repulsed, owner_turf)))
		repulsed.throw_at(throwtarget, 10, 1)
		thrown_items[repulsed] = repulsed

	reactivearmor_cooldown = world.time + reactivearmor_cooldown_duration
	return TRUE

/obj/item/clothing/suit/armor/reactive/repulse/emp_activation(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", damage = 0)
	playsound(get_turf(owner),'sound/effects/repulse.ogg', 100, TRUE)
	owner.visible_message(span_danger("[src] does not block [attack_text], and instead generates an attracting force!"))
	var/turf/owner_turf = get_turf(owner)
	var/list/thrown_items = list()
	for(var/atom/movable/repulsed in range(owner_turf, 5))
		if(repulsed == owner || repulsed.anchored || thrown_items[repulsed])
			continue
		repulsed.throw_at(owner, 10, 1)
		thrown_items[repulsed] = repulsed

	reactivearmor_cooldown = world.time + reactivearmor_cooldown_duration
	return FALSE


// Tesla

/obj/item/clothing/suit/armor/reactive/tesla
	name = "reactive tesla armor"
	desc = "An experimental suit of armor with sensitive detectors hooked up to a huge capacitor grid, with emitters strutting out of it. Zap."
	siemens_coefficient = -1
	cooldown_message = span_danger("The tesla capacitors on the reactive tesla armor are still recharging! The armor merely emits some sparks.")
	emp_message = span_warning("The tesla capacitors beep ominously for a moment.")
	clothing_traits = list(TRAIT_TESLA_SHOCKIMMUNE)
	/// How strong are the zaps we give off?
	var/zap_power = 2.5e4
	/// How far to the zaps we give off go?
	var/zap_range = 20

/obj/item/clothing/suit/armor/reactive/tesla/cooldown_activation(mob/living/carbon/human/owner)
	var/datum/effect/effect/system/spark_spread/sparks = new /datum/effect/effect/system/spark_spread()
	sparks.set_up(1, 1, src)
	sparks.start()
	..()

/obj/item/clothing/suit/armor/reactive/tesla/reactive_activation(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", damage = 0)
	owner.visible_message(span_danger("[src] blocks [attack_text], sending out arcs of lightning!"))
	tesla_zap(owner, zap_range, zap_power)
	reactivearmor_cooldown = world.time + reactivearmor_cooldown_duration
	return TRUE

/obj/item/clothing/suit/armor/reactive/tesla/emp_activation(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", damage = 0)
	owner.visible_message(span_danger("[src] blocks [attack_text], but pulls a massive charge of energy into [owner] from the surrounding environment!"))
	REMOVE_CLOTHING_TRAIT(owner, TRAIT_TESLA_SHOCKIMMUNE)
	electrocute_mob(owner, get_area(src), src, 1)
	ADD_CLOTHING_TRAIT(owner, TRAIT_TESLA_SHOCKIMMUNE)
	reactivearmor_cooldown = world.time + reactivearmor_cooldown_duration
	return TRUE

// Sure we could, but- Not really THAT useful. Give them the stealth one.
/obj/item/clothing/suit/armor/reactive/bioscrambling

// Hallucinating

/obj/item/clothing/suit/armor/reactive/hallucinating
	name = "reactive hallucinating armor"
	desc = "An experimental suit of armor with sensitive detectors hooked up to the mind of the wearer, sending mind pulses that causes hallucinations around you."
	cooldown_message = span_danger("The connection is currently out of sync... Recalibrating.")
	emp_message = span_warning("You feel the backsurge of a mind pulse.")
	clothing_traits = list(TRAIT_MADNESS_IMMUNE)

/obj/item/clothing/suit/armor/reactive/hallucinating/cooldown_activation(mob/living/carbon/human/owner)
	var/datum/effect/effect/system/spark_spread/sparks = new /datum/effect/effect/system/spark_spread()
	sparks.set_up(1, 1, src)
	sparks.start()
	..()

/obj/item/clothing/suit/armor/reactive/hallucinating/reactive_activation(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", damage = 0)
	owner.visible_message(span_danger("[src] blocks [attack_text], sending out mental pulses!"))
	for(var/mob/living/carbon/human/hallucinator in viewers(5, get_turf(src)))
		if(hallucinator == owner)
			continue
		hallucinator.hallucination += 50
		if(prob(10))
			to_chat(hallucinator, span_danger("Your nose bleeds!"))
			hallucinator.drip(1)
	reactivearmor_cooldown = world.time + reactivearmor_cooldown_duration
	return TRUE

/obj/item/clothing/suit/armor/reactive/hallucinating/emp_activation(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", damage = 0)
	owner.visible_message(span_danger("[src] blocks [attack_text], but pulls a massive charge of mental energy into [owner] from the surrounding environment!"))
	owner.hallucination += 75
	to_chat(owner, span_danger("Your nose bleeds!"))
	owner.drip(1)
	reactivearmor_cooldown = world.time + reactivearmor_cooldown_duration
	return TRUE

// When the wearer gets hit, this armor will push people nearby and spawn some blocking objects.
/obj/item/clothing/suit/armor/reactive/barricade
	name = "reactive barricade armor"
	desc = "An experimental suit of armor that generates barriers from another world when it detects its bearer is in danger."
	emp_message = span_warning("The reactive armor's dimensional coordinates are scrambled!")
	cooldown_message = span_danger("The reactive barrier system is still recharging! It fails to activate!")
	reactivearmor_cooldown_duration = 10 SECONDS

/obj/item/clothing/suit/armor/reactive/barricade/reactive_activation(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", damage = 0)
	playsound(get_turf(owner),'sound/effects/repulse.ogg', 100, TRUE)
	owner.visible_message(span_danger("The reactive armor interposes matter from another world between [src] and [attack_text]!"))
	for (var/atom/movable/target in repulse_targets(owner))
		repulse(target, owner)

	var/datum/armour_dimensional_theme/theme = new()
	theme.apply_random(get_turf(owner), dangerous = FALSE)
	qdel(theme)

	reactivearmor_cooldown = world.time + reactivearmor_cooldown_duration
	return TRUE

/obj/item/clothing/suit/armor/reactive/barricade/proc/repulse_targets(atom/source)
	var/list/push_targets = list()
	for (var/atom/movable/nearby_movable in view(1, source))
		if(nearby_movable == source)
			continue
		if(nearby_movable.anchored)
			continue
		push_targets += nearby_movable
	return push_targets

/obj/item/clothing/suit/armor/reactive/barricade/proc/repulse(atom/movable/victim, atom/source)
	var/dist_from_caster = get_dist(victim, source)

	if(dist_from_caster == 0)
		return

	if (isliving(victim))
		to_chat(victim, span_userdanger("You're thrown back by a wave of pressure!"))
	var/turf/throwtarget = get_edge_target_turf(source, get_dir(source, get_step_away(victim, source, 1)))
	victim.throw_at(throwtarget, 1, 1)

/obj/item/clothing/suit/armor/reactive/barricade/emp_activation(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", damage = 0)
	owner.visible_message(span_danger("The reactive armor shunts matter from an unstable dimension!"))
	var/datum/armour_dimensional_theme/theme = new()
	theme.apply_random(get_turf(owner), dangerous = TRUE)
	qdel(theme)
	reactivearmor_cooldown = world.time + reactivearmor_cooldown_duration
	return FALSE

// FIRE
/obj/item/clothing/suit/armor/reactive/fire
	name = "reactive incendiary armor"
	desc = "An experimental suit of armor with a reactive sensor array rigged to a flame emitter. For the stylish pyromaniac."
	cooldown_message = span_danger("The reactive incendiary armor activates, but fails to send out flames as it is still recharging its flame jets!")
	emp_message = span_warning("The reactive incendiary armor's targeting system begins rebooting...")

/obj/item/clothing/suit/armor/reactive/fire/reactive_activation(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", damage = 0)
	owner.visible_message(span_danger("[src] blocks [attack_text], sending out jets of flame!"))
	playsound(get_turf(owner), 'sound/magic/Fireball.ogg', 100, TRUE)
	for(var/mob/living/carbon_victim in range(6, get_turf(src)))
		if(carbon_victim != owner)
			carbon_victim.adjust_fire_stacks(8)
			carbon_victim.ignite_mob()
	owner.set_wet_stacks(20)
	reactivearmor_cooldown = world.time + reactivearmor_cooldown_duration
	return TRUE

/obj/item/clothing/suit/armor/reactive/fire/emp_activation(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", damage = 0)
	owner.visible_message(span_danger("[src] just makes [attack_text] worse by spewing molten death on [owner]!"))
	playsound(get_turf(owner), 'sound/magic/Fireball.ogg', 100, TRUE)
	owner.adjust_fire_stacks(12)
	owner.ignite_mob()
	reactivearmor_cooldown = world.time + reactivearmor_cooldown_duration
	return FALSE

/obj/item/clothing/suit/armor/reactive/stealth
	name = "reactive stealth armor"
	desc = "An experimental suit of armor that renders the wearer invisible on detection of imminent harm, and creates a decoy that runs away from the owner. You can't fight what you can't see."
	cooldown_message = span_danger("The reactive stealth system activates, but is not charged enough to fully cloak!")
	emp_message = span_warning("The reactive stealth armor's threat assessment system crashes...")
	///when triggering while on cooldown will only flicker the alpha slightly. this is how much it removes.
	var/cooldown_alpha_removal = 50
	///cooldown alpha flicker- how long it takes to return to the original alpha
	var/cooldown_animation_time = 3 SECONDS
	///how long they will be fully stealthed
	var/stealth_time = 4 SECONDS
	///how long it will animate back the alpha to the original
	var/animation_time = 2 SECONDS
	var/in_stealth = FALSE

/obj/item/clothing/suit/armor/reactive/stealth/cooldown_activation(mob/living/carbon/human/owner)
	if(in_stealth)
		return
	owner.alpha = max(0, owner.alpha - cooldown_alpha_removal)
	animate(owner, alpha = initial(owner.alpha), time = cooldown_animation_time)
	..()

/obj/item/clothing/suit/armor/reactive/stealth/reactive_activation(mob/living/carbon/human/owner, atom/movable/hitby, attack_text, final_block_chance, damage)
	var/mob/living/simple_mob/illusion/decoy = new(owner.loc)
	decoy.copy_appearance(owner)
	decoy.copy_overlays(owner, TRUE)
	var/datum/ai_holder/AI = decoy.ai_holder
	var/turf/rand_turf = pick(get_turf(orange(5, 10)))
	AI.give_destination(rand_turf)
	owner.alpha = 0
	in_stealth = TRUE
	owner.visible_message(span_danger("[owner] is hit by [attack_text] in the chest!"))
	addtimer(CALLBACK(src, PROC_REF(end_stealth), owner), stealth_time)
	decoy.say("*sidestep")
	addtimer(CALLBACK(src, PROC_REF(destroy_illusion), decoy), stealth_time)
	QDEL_IN(decoy, stealth_time)
	reactivearmor_cooldown = world.time + reactivearmor_cooldown_duration
	return TRUE

/obj/item/clothing/suit/armor/reactive/stealth/proc/end_stealth(mob/living/carbon/human/owner)
	in_stealth = FALSE
	animate(owner, alpha = initial(owner.alpha), time = animation_time)

/obj/item/clothing/suit/armor/reactive/stealth/proc/destroy_illusion(mob/illusion)
	var/datum/effect/effect/system/spark_spread/sparks = new /datum/effect/effect/system/spark_spread()
	sparks.set_up(3, 3, illusion)
	sparks.start()
	QDEL_IN(illusion, animation_time)

/obj/item/clothing/suit/armor/reactive/stealth/emp_activation(mob/living/carbon/human/owner, atom/movable/hitby, attack_text = "the attack", damage = 0)
	if(!isliving(hitby))
		return FALSE
	var/mob/living/attacker = hitby
	owner.visible_message(span_danger("[src] activates, cloaking the wrong person!"))
	attacker.alpha = 0
	addtimer(VARSET_CALLBACK(attacker, alpha, initial(attacker.alpha)), 4 SECONDS)
	reactivearmor_cooldown = world.time + reactivearmor_cooldown_duration
	return FALSE
