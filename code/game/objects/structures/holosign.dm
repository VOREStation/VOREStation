/obj/structure/holosign
	name = "holo sign"
	icon = 'icons/effects/effects.dmi'
	anchored = TRUE
	var/obj/item/holosign_creator/projector
	var/health = 10
	explosion_resistance = 1

/obj/structure/holosign/Initialize(mapload, source_projector)
	. = ..()
	if(source_projector)
		projector = source_projector
		projector.signs += src
/*	if(overlays) // Fucking god damnit why do we have to have an entire different subsystem for this shit from other codebases.
		overlays.add_overlay(src, icon, icon_state, ABOVE_MOB_LAYER, plane, dir, alpha, RESET_ALPHA) //you see mobs under it, but you hit them like they are above it
		alpha = 0
*/

/obj/structure/holosign/Destroy()
	if(projector)
		projector.signs -= src
		projector = null
	return ..()

/obj/structure/holosign/attack_hand(mob/user, list/params)
	. = ..()
	if(.)
		return
	user.setClickCooldown(user.get_attack_speed())
	user.do_attack_animation(src)
	take_damage(5)
	playsound(loc, 'sound/weapons/egloves.ogg', 80, 1)

/obj/structure/holosign/attackby(obj/item/W as obj, mob/user as mob)
	user.setClickCooldown(user.get_attack_speed(W))
	user.do_attack_animation(src)
	playsound(loc, 'sound/weapons/egloves.ogg', 80, 1)
	take_damage(W.force)

/obj/structure/holosign/take_damage(var/damage)
	health -= damage
	spawn(1) healthcheck()
	return 1

/obj/structure/holosign/proc/healthcheck()
	if(health <= 0)
		qdel(src)

/obj/structure/holosign/wetsign
	name = "wet floor sign"
	desc = "The words flicker as if they mean nothing."
	icon_state = "holosign"

/obj/structure/holosign/barrier/combifan
	name = "holo combifan"
	desc = "A holographic barrier resembling a blue-accented tiny fan. Though it does not prevent solid objects from passing through, gas and temperature changes are kept out."
	icon_state = "holo_firelock"
	anchored = TRUE
	density = FALSE
	layer = ABOVE_TURF_LAYER
	can_atmos_pass = ATMOS_PASS_NO
	alpha = 150

/obj/structure/holosign/barrier/combifan/Destroy()
	update_nearby_tiles()
	return ..()

/obj/structure/holosign/barrier/combifan/Initialize(mapload)
	.=..()
	update_nearby_tiles()

/obj/structure/holosign/barrier/medical
	name = "\improper Vey-Med holobarrier"
	desc = "A holobarrier that uses biometrics to detect viruses. Denies passing to personnel with easily-detected, malicious viruses. Good for quarantines."
	icon_state = "holo_medical"
	alpha = 125
	var/buzzed = 0

/obj/structure/holosign/barrier/medical/CanPass(atom/movable/mover, border_dir)
	. = ..()
	if(mover.has_buckled_mobs())
		for(var/mob/living/L as anything in buckled_mobs)
			if(ishuman(L))
				if(CheckHuman(L))
					return FALSE
	if(ishuman(mover))
		return CheckHuman(mover)
	return TRUE

/obj/structure/holosign/barrier/medical/Bumped(atom/movable/AM)
	. = ..()
	if(ishuman(AM) && !CheckHuman(AM))
		if(buzzed < world.time)
			playsound(get_turf(src), 'sound/machines/buzz-sigh.ogg', 50, 1)
			buzzed = (world.time + 60)

		icon_state = "holo_medical-deny"
		addtimer(VARSET_CALLBACK(src, icon_state, "holo_medical"), 10 SECONDS, TIMER_DELETE_ME)

/obj/structure/holosign/barrier/medical/proc/CheckHuman(mob/living/carbon/human/H)
	if(istype(H.get_species(), SPECIES_XENOCHIMERA))
		return FALSE
	if(H.GetViruses())
		for(var/datum/disease/D in H.GetViruses())
			if(D.severity == NONTHREAT)
				continue
			return FALSE
	return TRUE
