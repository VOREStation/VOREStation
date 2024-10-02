//////////////////////////////Construct Spells/////////////////////////

/proc/findNullRod(var/atom/target)
	if(istype(target,/obj/item/nullrod))
		return 1
	else if(target.contents)
		for(var/atom/A in target.contents)
			if(findNullRod(A))
				return 1
	return 0

/spell/aoe_turf/conjure/construct
	name = "Artificer"
	desc = "This spell conjures a construct which may be controlled by Shades"

	school = "conjuration"
	charge_max = 600
	spell_flags = 0
	invocation = "none"
	invocation_type = SpI_NONE
	range = 0

	summon_type = list(/obj/structure/constructshell)

	hud_state = "artificer"

/spell/aoe_turf/conjure/construct/lesser
	charge_max = 1800
	summon_type = list(/obj/structure/constructshell/cult)
	hud_state = "const_shell"
	override_base = "const"

/spell/aoe_turf/conjure/floor
	name = "Floor Construction"
	desc = "This spell constructs a cult floor"

	charge_max = 20
	spell_flags = Z2NOCAST | CONSTRUCT_CHECK
	invocation = "none"
	invocation_type = SpI_NONE
	range = 0
	summon_type = list(/turf/simulated/floor/cult)

	hud_state = "const_floor"

/spell/aoe_turf/conjure/floor/conjure_animation(var/atom/movable/overlay/animation, var/turf/target)
	animation.icon_state = "cultfloor"
	flick("cultfloor",animation)
	spawn(10)
		qdel(animation)

/spell/aoe_turf/conjure/wall
	name = "Lesser Construction"
	desc = "This spell constructs a cult wall"

	charge_max = 100
	spell_flags = Z2NOCAST | CONSTRUCT_CHECK
	invocation = "none"
	invocation_type = SpI_NONE
	range = 0
	summon_type = list(/turf/simulated/wall/cult)

	hud_state = "const_wall"

/spell/aoe_turf/conjure/wall/conjure_animation(var/atom/movable/overlay/animation, var/turf/target)
	animation.icon_state = "cultwall"
	flick("cultwall",animation)
	spawn(10)
		qdel(animation)

/spell/aoe_turf/conjure/wall/reinforced
	name = "Greater Construction"
	desc = "This spell constructs a reinforced metal wall"

	charge_max = 300
	spell_flags = Z2NOCAST
	invocation = "none"
	invocation_type = SpI_NONE
	range = 0
	cast_delay = 50

	summon_type = list(/turf/simulated/wall/r_wall)

/spell/aoe_turf/conjure/soulstone
	name = "Summon Soulstone"
	desc = "This spell reaches into Nar-Sie's realm, summoning one of the legendary fragments across time and space"

	charge_max = 3000
	spell_flags = 0
	invocation = "none"
	invocation_type = SpI_NONE
	range = 0

	summon_type = list(/obj/item/soulstone)

	hud_state = "const_stone"
	override_base = "const"

/spell/aoe_turf/conjure/pylon
	name = "Red Pylon"
	desc = "This spell conjures a fragile crystal from Nar-Sie's realm. Makes for a convenient light source."

	charge_max = 200
	spell_flags = CONSTRUCT_CHECK
	invocation = "none"
	invocation_type = SpI_NONE
	range = 0

	summon_type = list(/obj/structure/cult/pylon)

	hud_state = "const_pylon"

/spell/aoe_turf/conjure/pylon/cast(list/targets)
	..()
	var/turf/spawn_place = pick(targets)
	for(var/obj/structure/cult/pylon/P in spawn_place.contents)
		if(P.isbroken)
			P.repair(usr)
		continue
	return

/spell/aoe_turf/conjure/door
	name = "Stone Door"
	desc = "This spell conjures a massive stone door."

	charge_max = 100
	spell_flags = CONSTRUCT_CHECK
	invocation = "none"
	invocation_type = SpI_NONE
	range = 0

	summon_type = list(/obj/structure/simple_door/cult)

	hud_state = "const_door"

/spell/aoe_turf/conjure/grille
	name = "Arcane Grille"
	desc = "This spell conjures an airtight grille."

	charge_max = 100
	spell_flags = CONSTRUCT_CHECK
	invocation = "none"
	invocation_type = SpI_NONE
	range = 0

	summon_type = list(/obj/structure/grille/cult)

	hud_state = "const_grille"

/spell/aoe_turf/conjure/forcewall/lesser
	name = "Shield"
	desc = "Allows you to pull up a shield to protect yourself and allies from incoming threats"

	charge_max = 300
	spell_flags = 0
	invocation = "none"
	invocation_type = SpI_NONE
	range = 0
	summon_type = list(/obj/effect/forcefield/cult)
	duration = 200

	hud_state = "const_juggwall"

//Code for the Juggernaut construct's forcefield, that seemed like a good place to put it.
/obj/effect/forcefield/cult
	desc = "That eerie looking obstacle seems to have been pulled from another dimension through sheer force"
	name = "Juggerwall"
	icon = 'icons/effects/effects.dmi'
	icon_state = "m_shield_cult"
	light_color = "#B40000"
	light_range = 2
	invisibility = 0

/obj/effect/forcefield/cult/cultify()
	return

/spell/aoe_turf/knock/harvester
	name = "Force Doors"
	desc = "Mortal portals are no match for your occult might."

	spell_flags = CONSTRUCT_CHECK

	charge_max = 100
	invocation = ""
	invocation_type = "silent"
	range = 4

	hud_state = "const_knock"

/spell/aoe_turf/knock/harvester/cast(list/targets)
/*	for(var/turf/T in targets) //Disintigrating doors is bad, okay.
		for(var/obj/machinery/door/door in T.contents)
			spawn door.cultify()
	return */
	for(var/turf/T in targets)
		for(var/obj/machinery/door/door in T.contents)
			spawn(1)
				if(istype(door,/obj/machinery/door/airlock))
					var/obj/machinery/door/airlock/AL = door
					AL.locked = 0 //The spirits of the damned care not for your locks.
					AL.welded = 0 //Or your welding tools.
				else if(istype(door, /obj/machinery/door/firedoor))
					var/obj/machinery/door/firedoor/FD = door
					FD.blocked = 0
				door.open(1)
	return

/*
 *
 * Self-targeting spells. Modifiers, auras, instants, etc.
 *
 */

/spell/targeted/ethereal_jaunt/shift
	name = "Phase Shift"
	desc = "This spell allows you to pass through walls"

	charge_max = 200
	spell_flags = Z2NOCAST | INCLUDEUSER | CONSTRUCT_CHECK
	invocation_type = SpI_NONE
	range = -1
	duration = 50 //in deciseconds

	hud_state = "const_shift"

/spell/targeted/ethereal_jaunt/shift/jaunt_disappear(var/atom/movable/overlay/animation, var/mob/living/target)
	animation.icon_state = "phase_shift"
	animation.dir = target.dir
	flick("phase_shift",animation)

/spell/targeted/ethereal_jaunt/shift/jaunt_reappear(var/atom/movable/overlay/animation, var/mob/living/target)
	animation.icon_state = "phase_shift2"
	animation.dir = target.dir
	flick("phase_shift2",animation)

/spell/targeted/ethereal_jaunt/shift/jaunt_steam(var/mobloc)
	return

/*
 * Harvest has been disabled due to the lack of Nar'Sie. Here for posterity / future rework.
 */

/*
/spell/targeted/harvest
	name = "Harvest"
	desc = "Back to where I come from, and you're coming with me."

	school = "transmutation"
	charge_max = 200
	spell_flags = Z2NOCAST | CONSTRUCT_CHECK | INCLUDEUSER
	invocation = ""
	invocation_type = SpI_NONE
	range = 0
	max_targets = 0

	overlay = 1
	overlay_icon = 'icons/effects/effects.dmi'
	overlay_icon_state = "rune_teleport"
	overlay_lifespan = 0

	hud_state = "const_harvest"

/spell/targeted/harvest/cast(list/targets, mob/user)//because harvest is already a proc
	..()

	var/destination = null
	for(var/obj/singularity/narsie/large/N in narsie_list)
		destination = N.loc
		break
	if(destination)
		var/prey = 0
		for(var/mob/living/M in targets)
			if(!findNullRod(M))
				M.forceMove(destination)
				if(M != user)
					prey = 1
		to_chat(user, span_sinister("You warp back to Nar-Sie[prey ? " along with your prey":""]."))
	else
		to_chat(user, span_danger("...something's wrong!")) //There shouldn't be an instance of Harvesters when Nar-Sie isn't in the world.
*/

/spell/targeted/fortify
	name = "Fortify Shell"
	desc = "Emit a field of energy around your shell to reduce incoming damage incredibly, while decreasing your mobility."

	range = -1
	school = "evocation"
	charge_type = Sp_RECHARGE
	invocation_type = SpI_NONE

	spell_flags = CONSTRUCT_CHECK | INCLUDEUSER

	hud_state = "const_fortify"
	smoke_amt = 0

	charge_max = 600

/spell/targeted/fortify/cast(list/targets, mob/living/user)
	if(findNullRod(user) || user.has_modifier_of_type(/datum/modifier/fortify))
		charge_counter = 400
		return
	user.add_modifier(/datum/modifier/fortify, 1 MINUTES)

/spell/targeted/occult_repair_aura
	name = "Repair Aura"
	desc = "Emit a field of energy around your shell to repair nearby constructs at range."

	range = -1
	school = "evocation"
	charge_type = Sp_RECHARGE
	invocation_type = SpI_NONE

	spell_flags = CONSTRUCT_CHECK | INCLUDEUSER

	hud_state = "const_repairaura"
	smoke_amt = 0

	charge_max = 600

/spell/targeted/occult_repair_aura/cast(list/targets, mob/living/user)
	if(findNullRod(user) || user.has_modifier_of_type(/datum/modifier/repair_aura))
		charge_counter = 300
		return
	user.add_modifier(/datum/modifier/repair_aura, 30 SECONDS)

/spell/targeted/ambush_mode
	name = "Toggle Ambush"
	desc = "Phase yourself mostly out of this reality, minimizing your combat ability, but allowing for employance of ambush tactics."

	range = -1
	school = "evocation"
	charge_type = Sp_RECHARGE
	invocation_type = SpI_NONE

	spell_flags = CONSTRUCT_CHECK | INCLUDEUSER

	hud_state = "const_ambush"
	smoke_amt = 0

	charge_max = 100

/spell/targeted/ambush_mode/cast(list/targets, mob/living/user)
	if(findNullRod(user))
		charge_counter = 50
		return
	if(user.has_modifier_of_type(/datum/modifier/ambush))
		user.remove_modifiers_of_type(/datum/modifier/ambush)
		return
	user.add_modifier(/datum/modifier/ambush, 0)

/*
 *
 * These are the spells that place spell-objects into the construct's hands akin to technomancers.
 *
 */

/spell/targeted/construct_advanced
	name = "Base Construct Spell"
	desc = "If you see this, please tell a developer!"

	range = -1
	school = "evocation"
	charge_type = Sp_RECHARGE
	invocation_type = SpI_NONE

	spell_flags = CONSTRUCT_CHECK | INCLUDEUSER

	hud_state = "const_rune"
	smoke_amt = 0

	charge_max = 10

	var/obj/item/spell/construct/spell_obj = null //This is the var that determines what Technomancer-style spell is put into their hands.

/spell/targeted/construct_advanced/cast(list/targets, mob/living/user)
	if(!findNullRod(user))
		user.place_spell_in_hand(spell_obj)

/spell/targeted/construct_advanced/inversion_beam
	name = "Inversion Beam"
	desc = "Fire a searing beam of darkness at your foes."

	hud_state = "const_beam"
	spell_obj = /obj/item/spell/construct/projectile/inverted_beam

/spell/targeted/construct_advanced/mend_acolyte
	name = "Mend Acolyte"
	desc = "Mend a target acolyte or construct over time."

	charge_max = 100

	hud_state = "const_mend"
	spell_obj = /obj/item/spell/construct/mend_occult

/spell/targeted/construct_advanced/agonizing_sphere
	name = "Sphere of Agony"
	desc = "Rend a portal into a plane of naught but pain at the target location."

	charge_max = 100

	hud_state = "const_harvest"
	spell_obj = /obj/item/spell/construct/spawner/agonizing_sphere

/spell/targeted/construct_advanced/slam
	name = "Slam"
	desc = "Empower your FIST."

	charge_max = 300

	hud_state = "const_fist"
	spell_obj = /obj/item/spell/construct/slam

/*
 *
 * These are the spell objects that go into the construct's hands.
 *
 */

/*
 * Base advanced construct spell types.
 */

/obj/item/spell/construct //Energy costs are in units of blood, in the event a cultist gets one of these.
	name = "unholy energy"
	desc = "Your hands appear to be screaming. This is a debug text, you should probably tell a developer!"
	icon = 'icons/obj/spells.dmi'
	icon_state = "generic"
	item_icons = list(
		slot_l_hand_str = 'icons/mob/items/lefthand_spells.dmi',
		slot_r_hand_str = 'icons/mob/items/righthand_spells.dmi',
		)
	throwforce = 0
	force = 0
	show_examine = FALSE
	owner = null
	core = null
	cast_methods = null			// Controls how the spell is casted.
	aspect = ASPECT_UNHOLY		// Used for combining spells. Pretty much any cult spell is unholy.
	toggled = 0					// Mainly used for overlays.
	cooldown = 0 				// If set, will add a cooldown overlay and adjust click delay.  Must be a multiple of 5 for overlays.
	cast_sound = null			// Sound file played when this is used.
	var/last_castcheck = null	// The last time this spell was cast.

/obj/item/spell/construct/New()
	//..() //This kills the spell, because super on this calls the default spell's New, which checks for a core. Can't have that.
	if(isliving(loc))
		owner = loc
	if(!owner)
		qdel(src)
	update_icon()

/obj/item/spell/construct/adjust_instability(var/amount) //The only drawback to the boons of the geometer is the use of a mortal's blood as fuel. Constructs have already paid that price long ago.
	return

/obj/item/spell/construct/run_checks()
	if(owner)
		if((iscultist(owner) || istype(owner, /mob/living/simple_mob/construct)) && (world.time >= (last_castcheck + cooldown))) //Are they a cultist or a construct, and has the cooldown time passed?
			last_castcheck = world.time
			return 1
	return 0

/obj/item/spell/construct/pay_energy(var/amount)
	if(owner)
		if(istype(owner, /mob/living/simple_mob/construct))
			return 1
		if(iscultist(owner) && pay_blood(amount))
			return 1
	return 0

/obj/item/spell/construct/proc/pay_blood(var/amount) //If, for some reason, this is put into the hands of a cultist, by a talisnam or whatever.
	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		if(!H.should_have_organ(O_HEART))
			return 1
		if(H.remove_blood(amount))
			return 1
	return 0

/obj/item/spell/construct/afterattack(atom/target, mob/user, proximity_flag, click_parameters) //Not overriding it caused runtimes, because cooldown checked for core.
	if(!run_checks())
		return
	if(!proximity_flag)
		if(cast_methods & CAST_RANGED)
			on_ranged_cast(target, user)
	else
		if(istype(target, /obj/item/spell))
			var/obj/item/spell/spell = target
			if(spell.cast_methods & CAST_COMBINE)
				spell.on_combine_cast(src, user)
				return
		if(cast_methods & CAST_MELEE)
			on_melee_cast(target, user)
		else if(cast_methods & CAST_RANGED) //Try to use a ranged method if a melee one doesn't exist.
			on_ranged_cast(target, user)
	if(cooldown)
		var/effective_cooldown = round(cooldown, 5)
		user.setClickCooldown(effective_cooldown)
		flick("cooldown_[effective_cooldown]",src)

/obj/item/spell/construct/projectile //This makes me angry, but we need the template, and we can't use it because special check overrides on the base.
	name = "construct projectile template"
	icon_state = "generic"
	desc = "This is a generic template that shoots projectiles.  If you can read this, the game broke!"
	cast_methods = CAST_RANGED
	var/obj/item/projectile/spell_projectile = null
	var/pre_shot_delay = 0
	var/fire_sound = null
	var/energy_cost_per_shot = 5

/obj/item/spell/construct/projectile/on_ranged_cast(atom/hit_atom, mob/living/user)
	if(set_up(hit_atom, user))
		var/obj/item/projectile/new_projectile = make_projectile(spell_projectile, user)
		new_projectile.old_style_target(hit_atom)
		new_projectile.fire()
		log_and_message_admins("has casted [src] at \the [hit_atom].")
		if(fire_sound)
			playsound(src, fire_sound, 75, 1)
		return 1
	return 0

/obj/item/spell/construct/projectile/proc/make_projectile(obj/item/projectile/projectile_type, mob/living/user)
	var/obj/item/projectile/P = new projectile_type(get_turf(user))
	return P

/obj/item/spell/construct/projectile/proc/set_up(atom/hit_atom, mob/living/user)
	if(spell_projectile)
		if(pay_energy(energy_cost_per_shot))
			if(pre_shot_delay)
				var/image/target_image = image(icon = 'icons/obj/spells.dmi', loc = get_turf(hit_atom), icon_state = "target")
				user << target_image
				user.Stun(pre_shot_delay / 10)
				sleep(pre_shot_delay)
				qdel(target_image)
				if(owner)
					return TRUE
				return FALSE // We got dropped before the firing occured.
			return TRUE // No delay, no need to check.
	return FALSE

/obj/item/spell/construct/spawner
	name = "spawner template"
	desc = "If you see me, someone messed up."
	icon_state = "darkness"
	cast_methods = CAST_RANGED
	var/obj/effect/spawner_type = null

/obj/item/spell/construct/spawner/on_ranged_cast(atom/hit_atom, mob/user)
	var/turf/T = get_turf(hit_atom)
	if(T)
		new spawner_type(T)
		to_chat(user, span_cult("You shift \the [src] onto \the [T]."))
		log_and_message_admins("has casted [src] at [T.x],[T.y],[T.z].")
		qdel(src)

//Harvester Laser.

/obj/item/spell/construct/projectile/inverted_beam
	name = "inversion beam"
	icon_state = "generic"
	desc = "Your manipulators fire searing beams of inverted light."
	cast_methods = CAST_RANGED
	spell_projectile = /obj/item/projectile/beam/inversion
	pre_shot_delay = 0
	cooldown = 5
	fire_sound = 'sound/weapons/spiderlunge.ogg'

/obj/item/projectile/beam/inversion
	name = "inversion beam"
	icon_state = "invert"
	fire_sound = 'sound/weapons/spiderlunge.ogg'
	damage = 15
	damage_type = BURN
	check_armour = "laser"
	armor_penetration = 60
	light_range = 2
	light_power = -2
	light_color = "#FFFFFF"

	muzzle_type = /obj/effect/projectile/muzzle/inversion
	tracer_type = /obj/effect/projectile/tracer/inversion
	impact_type = /obj/effect/projectile/impact/inversion

//Harvester Pain Orb

/obj/item/spell/construct/spawner/agonizing_sphere
	name = "sphere of agony"
	desc = "Call forth a portal to a dimension of naught but pain at your target."

	spawner_type = /obj/effect/temporary_effect/pulse/agonizing_sphere

/obj/item/spell/construct/spawner/agonizing_sphere/on_ranged_cast(atom/hit_atom, mob/user)
	if(within_range(hit_atom) && pay_energy(10))
		..()

/obj/item/spell/construct/spawner/agonizing_sphere/on_throw_cast(atom/hit_atom, mob/user)
	pay_energy(5)
	if(isliving(hit_atom))
		var/mob/living/L = hit_atom
		L.add_modifier(/datum/modifier/agonize, 10 SECONDS)

/obj/effect/temporary_effect/pulse/agonizing_sphere
	name = "agonizing sphere"
	desc = "A portal to some hellish place. Its screams wrack your body with pain.."
	icon_state = "red_static_sphere"
	time_to_die = null
	light_range = 4
	light_power = 5
	light_color = "#FF0000"
	light_on = TRUE
	pulses_remaining = 10
	pulse_delay = 1 SECOND

/obj/effect/temporary_effect/pulse/agonizing_sphere/on_pulse()
	for(var/mob/living/L in view(4,src))
		if(!iscultist(L) && !istype(L, /mob/living/simple_mob/construct))
			L.add_modifier(/datum/modifier/agonize, 2 SECONDS)
			if(L.isSynthetic())
				to_chat(L, span_cult("Your chassis warps as the [src] pulses!"))
				L.adjustFireLoss(4)

//Artificer Heal

/obj/item/spell/construct/mend_occult
	name = "mend acolyte"
	desc = "Mend the wounds of a cultist, or construct, over time."
	icon_state = "mend_wounds"
	cast_methods = CAST_MELEE
	aspect = ASPECT_UNHOLY
	light_color = "#FF5C5C"
	light_power = -2
	light_on = TRUE

/obj/item/spell/construct/mend_occult/on_melee_cast(atom/hit_atom, mob/living/user, def_zone)
	if(isliving(hit_atom))
		var/mob/living/L = hit_atom
		L.add_modifier(/datum/modifier/mend_occult, 150)
	qdel(src)

//Juggernaut Slam
/obj/item/spell/construct/slam
	name = "slam"
	desc = "Empower your FIST, to send an opponent flying."
	icon_state = "toggled_old"
	cast_methods = CAST_MELEE
	aspect = ASPECT_UNHOLY
	light_color = "#FF5C5C"
	light_power = -2
	light_on = TRUE
	cooldown = 15

/obj/item/spell/construct/slam/on_melee_cast(atom/hit_atom, mob/living/user, def_zone)
	var/attack_message = "slams"
	if(istype(user, /mob/living/simple_mob))
		var/mob/living/simple_mob/S = user
		attack_message = pick(S.attacktext)
	if(isliving(hit_atom))
		var/mob/living/L = hit_atom
		L.visible_message(span_danger("\The [user] [attack_message] \the [L], sending them flying!"))
		playsound(src, "punch", 50, 1)
		L.Weaken(2)
		L.adjustBruteLoss(rand(30, 50))
		var/throwdir = get_dir(src, L)
		L.throw_at(get_edge_target_turf(L, throwdir), 3, 1, src)
	if(istype(hit_atom, /turf/simulated/wall))
		var/turf/simulated/wall/W = hit_atom
		user.visible_message(span_warning("\The [user] rears its fist, preparing to hit \the [W]!"))
		var/windup = cooldown
		if(W.reinf_material)
			windup = cooldown * 2
		if(do_after(user, windup))
			W.visible_message(span_danger("\The [user] [attack_message] \the [W], obliterating it!"))
			W.dismantle_wall(1)
		else
			user.visible_message("<b>\The [user]</b> lowers its fist.")
			return
	qdel(src)
