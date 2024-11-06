/*		Portable Turrets:
		Constructed from metal, a gun of choice, and a prox sensor.
		This code is slightly more documented than normal, as requested by XSI on IRC.
*/

/datum/category_item/catalogue/technology/turret
	name = "Turrets"
	desc = "This imtimidating machine is essentially an automated gun. It is able to \
	scan its immediate environment, and if it determines that a threat is nearby, it will \
	open up, aim the barrel of the weapon at the threat, and engage it until the threat \
	goes away, it dies (if using a lethal gun), or the turret is destroyed. This has made them \
	well suited for long term defense for a static position, as electricity costs much \
	less than hiring a person to stand around. Despite this, the lack of a sapient entity's \
	judgement has sometimes lead to tragedy when turrets are poorly configured.\
	<br><br>\
	Early models generally had simple designs, and would shoot at anything that moved, with only \
	the option to disable it remotely for maintenance or to let someone pass. More modern iterations \
	of turrets have instead replaced those simple systems with intricate optical sensors and \
	image recognition software that allow the turret to distinguish between several kinds of \
	entities, and to only engage whatever their owners configured them to fight against.\
	Some models also have the ability to switch between a lethal and non-lethal mode.\
	<br><br>\
	Today's cutting edge in static defense development has shifted away from improving the \
	software of the turret, and instead towards the hardware. The newest solutions for \
	automated protection includes new hardware capabilities such as thicker armor, more \
	advanced integrated weapons, and some may even have been built with EM hardening in \
	mind."
	value = CATALOGUER_REWARD_MEDIUM


#define TURRET_PRIORITY_TARGET 2
#define TURRET_SECONDARY_TARGET 1
#define TURRET_NOT_TARGET 0

/obj/machinery/porta_turret
	name = "turret"
	catalogue_data = list(/datum/category_item/catalogue/technology/turret)
	icon = 'icons/obj/turrets.dmi'
	icon_state = "turret_cover_normal"
	anchored = TRUE

	density = FALSE
	use_power = TRUE				//this turret uses and requires power
	idle_power_usage = 50		//when inactive, this turret takes up constant 50 Equipment power
	active_power_usage = 300	//when active, this turret takes up constant 300 Equipment power
	power_channel = EQUIP	//drains power from the EQUIPMENT channel
	req_one_access = list(access_security, access_heads)
	blocks_emissive = EMISSIVE_BLOCK_UNIQUE

	var/raised = FALSE			//if the turret cover is "open" and the turret is raised
	var/raising= FALSE			//if the turret is currently opening or closing its cover
	var/health = 80				//the turret's health
	var/maxhealth = 80			//turrets maximal health.
	var/auto_repair = FALSE		//if 1 the turret slowly repairs itself.
	var/locked = TRUE			//if the turret's behaviour control access is locked
	var/controllock = FALSE		//if the turret responds to control panels

	var/installation = /obj/item/gun/energy/gun		//the type of weapon installed
	var/gun_charge = 0				//the charge of the gun inserted
	var/projectile = null			//holder for bullettype
	var/lethal_projectile = null	//holder for the shot when emagged
	var/reqpower = 500				//holder for power needed
	var/turret_type = "normal"
	var/icon_color = "blue"
	var/lethal_icon_color = "blue"

	var/last_fired = FALSE			//TRUE: if the turret is cooling down from a shot, FALSE: turret is ready to fire
	var/shot_delay = 1.5 SECONDS	//1.5 seconds between each shot

	var/targetting_is_configurable = TRUE // if false, you cannot change who this turret attacks via its UI
	var/check_arrest = TRUE		//checks if the perp is set to arrest
	var/check_records = TRUE	//checks if a security record exists at all
	var/check_weapons = FALSE	//checks if it can shoot people that have a weapon they aren't authorized to have
	var/check_access = TRUE		//if this is active, the turret shoots everything that does not meet the access requirements
	var/check_anomalies = TRUE	//checks if it can shoot at unidentified lifeforms (ie xenos)
	var/check_synth	 = FALSE 	//if active, will shoot at anything not an AI or cyborg
	var/check_all = FALSE		//If active, will fire on anything, including synthetics.
	var/ailock = FALSE 			// AI cannot use this
	var/check_down = FALSE		//If active, will shoot to kill when lethals are also on
	var/faction = null			//if set, will not fire at people in the same faction for any reason.

	var/attacked = FALSE		//if set to TRUE, the turret gets pissed off and shoots at people nearby (unless they have sec access!)

	var/enabled = TRUE			//determines if the turret is on
	var/lethal = FALSE			//whether in lethal or stun mode
	var/lethal_is_configurable = TRUE // if false, its lethal setting cannot be changed
	var/disabled = FALSE

	var/shot_sound 				//what sound should play when the turret fires
	var/lethal_shot_sound		//what sound should play when the emagged turret fires

	var/datum/effect/effect/system/spark_spread/spark_system	//the spark system, used for generating... sparks?

	var/wrenching = FALSE
	var/last_target			//last target fired at, prevents turrets from erratically firing at all valid targets in range
	var/timeout = 10		// When a turret pops up, then finds nothing to shoot at, this number decrements until 0, when it pops down.
	var/can_salvage = TRUE	// If false, salvaging doesn't give you anything.

/obj/machinery/porta_turret/crescent
	req_one_access = list(access_cent_specops)
	enabled = FALSE
	ailock = TRUE
	check_synth = FALSE
	check_access = TRUE
	check_arrest = TRUE
	check_records = TRUE
	check_weapons = TRUE
	check_anomalies = TRUE
	check_all = FALSE
	check_down = TRUE

/obj/machinery/porta_turret/can_catalogue(mob/user) // Dead turrets can't be scanned.
	if(stat & BROKEN)
		to_chat(user, span_warning("\The [src] was destroyed, so it cannot be scanned."))
		return FALSE
	return ..()

/obj/machinery/porta_turret/stationary
	ailock = TRUE
	lethal = TRUE
	installation = /obj/item/gun/energy/laser

/obj/machinery/porta_turret/stationary/syndie // Generic turrets for POIs that need to not shoot their buddies.
	req_one_access = list(access_syndicate)
	enabled = TRUE
	check_all = TRUE
	faction = FACTION_SYNDICATE // Make sure this equals the faction that the mobs in the POI have or they will fight each other.

/obj/machinery/porta_turret/ai_defense
	name = "defense turret"
	desc = "This variant appears to be much more durable."
	req_one_access = list(access_synth) // Just in case.
	installation = /obj/item/gun/energy/xray // For the armor pen.
	health = 250 // Since lasers do 40 each.
	maxhealth = 250

/datum/category_item/catalogue/anomalous/precursor_a/alien_turret
	name = "Precursor Alpha Object - Turrets"
	desc = "An autonomous defense turret created by unknown ancient aliens. It utilizes an \
	integrated laser projector to harm, firing a cyan beam at the target. The signal processing \
	of this mechanism appears to be radically different to conventional electronics used by modern \
	technology, which appears to be much less susceptible to external electromagnetic influences.\
	<br><br>\
	This makes the turret be very resistant to the effects of an EM pulse. It is unknown if whatever \
	species that built the turret had intended for it to have that quality, or if it was an incidental \
	quirk of how they designed their electronics."
	value = CATALOGUER_REWARD_MEDIUM

/obj/machinery/porta_turret/alien // The kind used on the UFO submap.
	name = "interior anti-boarding turret"
	desc = "A very tough looking turret made by alien hands."
	catalogue_data = list(/datum/category_item/catalogue/anomalous/precursor_a/alien_turret)
	icon_state = "turret_cover_alien"
	req_one_access = list(access_alien)
	installation = /obj/item/gun/energy/alien
	enabled = TRUE
	lethal = TRUE
	ailock = TRUE
	check_all = TRUE
	health = 250 // Similar to the AI turrets.
	maxhealth = 250
	turret_type = "alien"

/obj/machinery/porta_turret/alien/destroyed // Turrets that are already dead, to act as a warning of what the rest of the submap contains.
	name = "broken interior anti-boarding turret"
	desc = "A very tough looking turret made by alien hands. This one looks destroyed, thankfully."
	icon_state = "destroyed_target_prism_alien"
	stat = BROKEN
	can_salvage = FALSE // So you need to actually kill a turret to get the alien gun.

/obj/machinery/porta_turret/industrial
	name = "industrial turret"
	desc = "This variant appears to be much more rugged."
	req_one_access = list(access_heads)
	icon_state = "turret_cover_industrial"
	installation = /obj/item/gun/energy/phasegun
	health = 200
	maxhealth = 200
	turret_type = "industrial"

/obj/machinery/porta_turret/industrial/bullet_act(obj/item/projectile/Proj)
	var/damage = round(Proj.get_structure_damage() * 1.33)

	if(!damage)
		return

	if(enabled)
		if(!attacked && !emagged)
			attacked = TRUE
			spawn()
				sleep(60)
				attacked = FALSE

	take_damage(damage)

/obj/machinery/porta_turret/industrial/attack_generic(mob/living/L, damage)
	return ..(L, damage * 0.8)

/obj/machinery/porta_turret/industrial/teleport_defense
	name = "defense turret"
	desc = "This variant appears to be much more durable, with a rugged outer coating."
	req_one_access = list(access_heads)
	installation = /obj/item/gun/energy/gun/burst
	health = 250
	maxhealth = 250

/obj/machinery/porta_turret/poi	//These are always angry
	enabled = TRUE
	lethal = TRUE
	ailock = TRUE
	check_all = TRUE
	can_salvage = FALSE	// So you can't just twoshot a turret and get a fancy gun

/obj/machinery/porta_turret/lasertag
	name = "lasertag turret"
	turret_type = "normal"
	req_one_access = list()
	installation = /obj/item/gun/energy/lasertag/omni

	targetting_is_configurable = FALSE
	lethal_is_configurable = FALSE

	locked = FALSE
	enabled = FALSE
	anchored = FALSE
	//These two are used for lasertag
	check_synth	 = FALSE
	check_weapons = FALSE
	//These vars aren't used
	check_access = FALSE
	check_arrest = FALSE
	check_records = FALSE
	check_anomalies = FALSE
	check_all = FALSE
	check_down = FALSE

/obj/machinery/porta_turret/lasertag/red
	turret_type = "red"
	installation = /obj/item/gun/energy/lasertag/red
	check_weapons = TRUE // Used to target blue players

/obj/machinery/porta_turret/lasertag/blue
	turret_type = "blue"
	installation = /obj/item/gun/energy/lasertag/blue
	check_synth = TRUE // Used to target red players

/obj/machinery/porta_turret/lasertag/assess_living(var/mob/living/L)
	if(!ishuman(L))
		return TURRET_NOT_TARGET

	if(L.invisibility >= INVISIBILITY_LEVEL_ONE) // Cannot see him. see_invisible is a mob-var
		return TURRET_NOT_TARGET

	if(get_dist(src, L) > 7)	//if it's too far away, why bother?
		return TURRET_NOT_TARGET

	if(L.lying)		//Don't need to stun-lock the players
		return TURRET_NOT_TARGET

	if(ishuman(L))
		var/mob/living/carbon/human/M = L
		if(istype(M.wear_suit, /obj/item/clothing/suit/redtag) && check_synth) // Checks if they are a red player
			return TURRET_PRIORITY_TARGET

		if(istype(M.wear_suit, /obj/item/clothing/suit/bluetag) && check_weapons) // Checks if they are a blue player
			return TURRET_PRIORITY_TARGET

/obj/machinery/porta_turret/lasertag/tgui_data(mob/user)
	var/list/data = list(
		"locked" = isLocked(user), // does the current user have access?
		"on" = enabled, // is turret turned on?
		"lethal" = lethal,
		"lethal_is_configurable" = lethal_is_configurable
	)
	return data

/obj/machinery/porta_turret/Initialize()
	//Sets up a spark system
	spark_system = new /datum/effect/effect/system/spark_spread
	spark_system.set_up(5, 0, src)
	spark_system.attach(src)

	setup()

	// If turrets ever switch overlays, this will need to be cached and reapplied each time overlays_cut() is called.
	var/image/turret_opened_overlay = image(icon, "open_[turret_type]")
	turret_opened_overlay.layer = layer-0.1
	add_overlay(turret_opened_overlay)
	return ..()

/obj/machinery/porta_turret/Destroy()
	qdel(spark_system)
	spark_system = null
	return ..()

/obj/machinery/porta_turret/update_icon()
	if(stat & BROKEN) // Turret is dead.
		icon_state = "destroyed_target_prism_[turret_type]"

	else if(raised || raising)
		// Turret is open.
		if(powered() && enabled)
			// Trying to shoot someone.
			if(lethal)
				icon_state = "[lethal_icon_color]_target_prism_[turret_type]"
			else
				icon_state = "[icon_color]_target_prism_[turret_type]"

		else
			// Disabled.
			icon_state = "grey_target_prism_[turret_type]"

	else
		// Its closed.
		icon_state = "turret_cover_[turret_type]"


/obj/machinery/porta_turret/proc/setup()
	var/obj/item/gun/energy/E = installation	//All energy-based weapons are applicable
	var/obj/item/projectile/P = initial(E.projectile_type)
	//var/obj/item/ammo_casing/shottype = E.projectile_type

	projectile = P
	lethal_projectile = projectile
	shot_sound = initial(P.fire_sound)
	lethal_shot_sound = shot_sound

	if(istype(P, /obj/item/projectile/energy))
		icon_color = "orange"

	else if(istype(P, /obj/item/projectile/beam/stun))
		icon_color = "blue"

	else if(istype(P, /obj/item/projectile/beam/lasertag))
		icon_color = "blue"

	else if(istype(P, /obj/item/projectile/beam))
		icon_color = "red"

	else
		icon_color = "blue"

	lethal_icon_color = icon_color

	weapon_setup(installation)

/obj/machinery/porta_turret/proc/weapon_setup(var/guntype)
	switch(guntype)
		if(/obj/item/gun/energy/gun/burst)
			lethal_icon_color = "red"
			lethal_projectile = /obj/item/projectile/beam/burstlaser
			lethal_shot_sound = 'sound/weapons/Laser.ogg'
			shot_delay = 1 SECOND

		if(/obj/item/gun/energy/phasegun)
			icon_color = "orange"
			lethal_icon_color = "orange"
			lethal_projectile = /obj/item/projectile/energy/phase/heavy
			shot_delay = 1 SECOND

		if(/obj/item/gun/energy/gun)
			lethal_icon_color = "red"
			lethal_projectile = /obj/item/projectile/beam	//If it has, going to kill mode
			lethal_shot_sound = 'sound/weapons/Laser.ogg'

		if(/obj/item/gun/energy/gun/nuclear)
			lethal_icon_color = "red"
			lethal_projectile = /obj/item/projectile/beam	//If it has, going to kill mode
			lethal_shot_sound = 'sound/weapons/Laser.ogg'

		if(/obj/item/gun/energy/xray)
			lethal_icon_color = "green"
			lethal_projectile = /obj/item/projectile/beam/xray
			projectile = /obj/item/projectile/beam/stun // Otherwise we fire xrays on both modes.
			lethal_shot_sound = 'sound/weapons/eluger.ogg'
			shot_sound = 'sound/weapons/Taser.ogg'

/obj/machinery/porta_turret/proc/isLocked(mob/user)
	if(locked && !issilicon(user))
		to_chat(user, span_notice("Controls locked."))
		return 1
	if(HasController())
		return TRUE
	if(isrobot(user) || isAI(user))
		if(ailock)
			to_chat(user, span_notice("There seems to be a firewall preventing you from accessing this device."))
			return TRUE
		else
			return FALSE
	if(isobserver(user))
		var/mob/observer/dead/D = user
		if(D.can_admin_interact())
			return FALSE
		else
			return TRUE
	if(locked)
		return TRUE
	return FALSE

/obj/machinery/porta_turret/attack_ai(mob/user)
	tgui_interact(user)

/obj/machinery/porta_turret/attack_ghost(mob/user)
	tgui_interact(user)

/obj/machinery/porta_turret/attack_hand(mob/user)
	tgui_interact(user)

/obj/machinery/porta_turret/proc/HasController()
	var/area/A = get_area(src)
	return A && A.turret_controls.len > 0

/obj/machinery/porta_turret/tgui_interact(mob/user, datum/tgui/ui = null)
	if(HasController())
		to_chat(user, span_notice("[src] can only be controlled using the assigned turret controller."))
		return
	if(!anchored)
		to_chat(user, span_notice("[src] has to be secured first!"))
		return
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "PortableTurret", name, ui_x = 500, ui_y = 400)
		ui.open()

/obj/machinery/porta_turret/tgui_data(mob/user)
	var/list/data = list(
		"locked" = isLocked(user), // does the current user have access?
		"on" = enabled,
		"targetting_is_configurable" = targetting_is_configurable, // If false, targetting settings don't show up
		"lethal" = lethal,
		"lethal_is_configurable" = lethal_is_configurable,
		"check_weapons" = check_weapons,
		"neutralize_noaccess" = check_access,
		"neutralize_norecord" = check_records,
		"neutralize_criminals" = check_arrest,
		"neutralize_all" = check_all,
		"neutralize_nonsynth" = check_synth,
		"neutralize_unidentified" = check_anomalies,
		"neutralize_down" = check_down,
	)
	return data

/obj/machinery/porta_turret/tgui_act(action, list/params, datum/tgui/ui, datum/tgui_state/state)
	if(..())
		return TRUE
	if(isLocked(usr))
		return TRUE
	. = TRUE

	switch(action)
		if("power")
			enabled = !enabled
		if("lethal")
			if(lethal_is_configurable)
				lethal = !lethal
	if(targetting_is_configurable)
		switch(action)
			if("authweapon")
				check_weapons = !check_weapons
			if("authaccess")
				check_access = !check_access
			if("authnorecord")
				check_records = !check_records
			if("autharrest")
				check_arrest = !check_arrest
			if("authxeno")
				check_anomalies = !check_anomalies
			if("authsynth")
				check_synth = !check_synth
			if("authall")
				check_all = !check_all
			if("authdown")
				check_down = !check_down

/obj/machinery/porta_turret/power_change()
	if(powered())
		stat &= ~NOPOWER
		update_icon()
	else
		spawn(rand(0, 15))
			stat |= NOPOWER
			update_icon()


/obj/machinery/porta_turret/attackby(obj/item/I, mob/user)
	if(stat & BROKEN)
		if(I.has_tool_quality(TOOL_CROWBAR))
			//If the turret is destroyed, you can remove it with a crowbar to
			//try and salvage its components
			to_chat(user, span_notice("You begin prying the metal coverings off."))
			if(do_after(user, 20))
				if(can_salvage && prob(70))
					to_chat(user, span_notice("You remove the turret and salvage some components."))
					if(installation)
						var/obj/item/gun/energy/Gun = new installation(loc)
						Gun.power_supply.charge = gun_charge
						Gun.update_icon()
					if(prob(50))
						new /obj/item/stack/material/steel(loc, rand(1,4))
					if(prob(50))
						new /obj/item/assembly/prox_sensor(loc)
				else
					to_chat(user, span_notice("You remove the turret but did not manage to salvage anything."))
				qdel(src) // qdel

	else if(I.has_tool_quality(TOOL_WRENCH))
		if(enabled || raised)
			to_chat(user, span_warning("You cannot unsecure an active turret!"))
			return
		if(wrenching)
			to_chat(user, span_warning("Someone is already [anchored ? "un" : ""]securing the turret!"))
			return
		if(!anchored && isinspace())
			to_chat(user, span_warning("Cannot secure turrets in space!"))
			return

		user.visible_message(\
				span_warning("[user] begins [anchored ? "un" : ""]securing the turret."), \
				span_notice("You begin [anchored ? "un" : ""]securing the turret.") \
			)

		wrenching = TRUE
		if(do_after(user, 50 * I.toolspeed))
			//This code handles moving the turret around. After all, it's a portable turret!
			if(!anchored)
				playsound(src, I.usesound, 100, 1)
				anchored = TRUE
				update_icon()
				to_chat(user, span_notice("You secure the exterior bolts on the turret."))
			else if(anchored)
				playsound(src, I.usesound, 100, 1)
				anchored = FALSE
				to_chat(user, span_notice("You unsecure the exterior bolts on the turret."))
				update_icon()
		wrenching = FALSE

	else if(istype(I, /obj/item/card/id)||istype(I, /obj/item/pda))
		//Behavior lock/unlock mangement
		if(allowed(user))
			locked = !locked
			to_chat(user, span_notice("Controls are now [locked ? "locked" : "unlocked"]."))
			updateUsrDialog()
		else
			to_chat(user, span_notice("Access denied."))

	else
		//if the turret was attacked with the intention of harming it:
		user.setClickCooldown(user.get_attack_speed(I))
		take_damage(I.force * 0.5)
		if(I.force * 0.5 > 1) //if the force of impact dealt at least 1 damage, the turret gets pissed off
			if(!attacked && !emagged)
				attacked = 1
				spawn()
					sleep(60)
					attacked = 0
		..()

/obj/machinery/porta_turret/attack_generic(mob/living/L, damage)
	if(isanimal(L))
		var/mob/living/simple_mob/S = L
		if(damage >= STRUCTURE_MIN_DAMAGE_THRESHOLD)
			var/incoming_damage = round(damage - (damage / 5)) //Turrets are slightly armored, assumedly.
			visible_message(span_danger("\The [S] [pick(S.attacktext)] \the [src]!"))
			take_damage(incoming_damage)
			S.do_attack_animation(src)
			return 1
		visible_message(span_infoplain(span_bold("\The [L]") + " bonks \the [src]'s casing!"))
	return ..()

/obj/machinery/porta_turret/emag_act(var/remaining_charges, var/mob/user)
	if(!emagged)
		//Emagging the turret makes it go bonkers and stun everyone. It also makes
		//the turret shoot much, much faster.
		to_chat(user, span_warning("You short out [src]'s threat assessment circuits."))
		visible_message(span_info("[src] hums oddly..."))
		emagged = TRUE
		controllock = TRUE
		enabled = FALSE //turns off the turret temporarily
		sleep(60) //6 seconds for the traitor to gtfo of the area before the turret decides to ruin his shit
		enabled = TRUE //turns it back on. The cover popUp() popDown() are automatically called in process(), no need to define it here
		return 1

/obj/machinery/porta_turret/take_damage(var/force)
	if(!raised && !raising)
		force = force / 8
		if(force < 5)
			return

	health -= force
	if(force > 5 && prob(45))
		spark_system.start()
	if(health <= 0)
		die()	//the death process :(

/obj/machinery/porta_turret/bullet_act(obj/item/projectile/Proj)
	var/damage = Proj.get_structure_damage()

	if(!damage)
		return

	if(enabled)
		if(!attacked && !emagged)
			attacked = 1
			spawn()
				sleep(60)
				attacked = FALSE

	..()

	take_damage(damage)

/obj/machinery/porta_turret/emp_act(severity)
	if(enabled)
		//if the turret is on, the EMP no matter how severe disables the turret for a while
		//and scrambles its settings, with a slight chance of having an emag effect
		check_arrest = prob(50)
		check_records = prob(50)
		check_weapons = prob(50)
		check_access = prob(20)	// check_access is a pretty big deal, so it's least likely to get turned on
		check_anomalies = prob(50)
		if(prob(5))
			emagged = TRUE

		enabled=0
		spawn(rand(60,600))
			if(!enabled)
				enabled = TRUE

	..()

/obj/machinery/porta_turret/ai_defense/emp_act(severity)
	if(prob(33)) // One in three chance to resist an EMP.  This is significant if an AoE EMP is involved against multiple turrets.
		return
	..()

/obj/machinery/porta_turret/alien/emp_act(severity) // This is overrided to give an EMP resistance as well as avoid scambling the turret settings.
	if(prob(75)) // Superior alien technology, I guess.
		return
	enabled = FALSE
	spawn(rand(1 MINUTE, 2 MINUTES))
		if(!enabled)
			enabled = TRUE

/obj/machinery/porta_turret/ex_act(severity)
	switch (severity)
		if(1)
			qdel(src)
		if(2)
			if(prob(25))
				qdel(src)
			else
				take_damage(initial(health) * 8) //should instakill most turrets
		if(3)
			take_damage(initial(health) * 8 / 3) //Level 4 is too weak to bother turrets

/obj/machinery/porta_turret/proc/die()	//called when the turret dies, ie, health <= 0
	health = 0
	stat |= BROKEN	//enables the BROKEN bit
	spark_system.start()	//creates some sparks because they look cool
	update_icon()

/obj/machinery/porta_turret/process()
	//the main machinery process

	if(stat & (NOPOWER|BROKEN))
		//if the turret has no power or is broken, make the turret pop down if it hasn't already
		popDown()
		return

	if(!enabled)
		//if the turret is off, make it pop down
		popDown()
		return

	var/list/targets = list()			//list of primary targets
	var/list/secondarytargets = list()	//targets that are least important

	var/list/seenturfs = list()
	for(var/turf/T in oview(world.view, src))
		seenturfs += T

	for(var/mob/M as anything in living_mob_list)
		if(M.z != z || !(get_turf(M) in seenturfs)) // Skip
			continue
		switch(assess_living(M))
			if(TURRET_PRIORITY_TARGET)
				targets += M
			if(TURRET_SECONDARY_TARGET)
				secondarytargets += M

	for(var/obj/mecha/M as anything in mechas_list)
		if(M.z != z || !(get_turf(M) in seenturfs)) // Skip
			continue
		switch(assess_mecha(M))
			if(TURRET_PRIORITY_TARGET)
				targets += M
			if(TURRET_SECONDARY_TARGET)
				secondarytargets += M

	if(!tryToShootAt(targets) && !tryToShootAt(secondarytargets) && --timeout <= 0)
		popDown() // no valid targets, close the cover

	if(auto_repair && (health < maxhealth))
		use_power(20000)
		health = min(health+1, maxhealth) // 1HP for 20kJ

/obj/machinery/porta_turret/proc/assess_living(var/mob/living/L)
	if(!istype(L))
		return TURRET_NOT_TARGET

	if(L.invisibility >= INVISIBILITY_LEVEL_ONE) // Cannot see him. see_invisible is a mob-var
		return TURRET_NOT_TARGET

	if(faction && L.faction == faction)
		return TURRET_NOT_TARGET

	if(!emagged && issilicon(L) && check_all == FALSE)	// Don't target silica, unless told to neutralize everything.
		return TURRET_NOT_TARGET

	if(L.stat == DEAD && !emagged)		//if the perp is dead, no need to bother really
		return TURRET_NOT_TARGET	//move onto next potential victim!

	if(get_dist(src, L) > 7)	//if it's too far away, why bother?
		return TURRET_NOT_TARGET

	if(emagged)		// If emagged not even the dead get a rest
		return L.stat ? TURRET_SECONDARY_TARGET : TURRET_PRIORITY_TARGET

	if(lethal && locate(/mob/living/silicon/ai) in get_turf(L))		//don't accidentally kill the AI!
		return TURRET_NOT_TARGET

	if(check_synth || check_all)	//If it's set to attack all non-silicons or everything, target them!
		if(L.lying)
			return check_down ? TURRET_SECONDARY_TARGET : TURRET_NOT_TARGET
		return TURRET_PRIORITY_TARGET

	if(iscuffed(L)) // If the target is handcuffed, leave it alone
		return TURRET_NOT_TARGET

	if(isanimal(L)) // Animals are not so dangerous
		return check_anomalies ? TURRET_SECONDARY_TARGET : TURRET_NOT_TARGET

	if(isxenomorph(L) || isalien(L)) // Xenos are dangerous
		return check_anomalies ? TURRET_PRIORITY_TARGET	: TURRET_NOT_TARGET

	if(ishuman(L))	//if the target is a human, analyze threat level
		if(assess_perp(L) < 4)
			return TURRET_NOT_TARGET	//if threat level < 4, keep going

	if(L.lying)		//if the perp is lying down, it's still a target but a less-important target
		return check_down ? TURRET_SECONDARY_TARGET : TURRET_NOT_TARGET

	return TURRET_PRIORITY_TARGET	//if the perp has passed all previous tests, congrats, it is now a "shoot-me!" nominee

/obj/machinery/porta_turret/proc/assess_mecha(var/obj/mecha/M)
	if(!istype(M))
		return TURRET_NOT_TARGET

	if(!M.occupant)
		return check_all ? TURRET_SECONDARY_TARGET : TURRET_NOT_TARGET

	return assess_living(M.occupant)

/obj/machinery/porta_turret/proc/assess_perp(var/mob/living/carbon/human/H)
	if(!H || !istype(H))
		return 0

	if(emagged)
		return 10

	return H.assess_perp(src, check_access, check_weapons, check_records, check_arrest)

/obj/machinery/porta_turret/proc/tryToShootAt(var/list/mob/living/targets)
	if(targets.len && last_target && (last_target in targets) && target(last_target))
		return 1

	while(targets.len > 0)
		var/mob/living/M = pick(targets)
		targets -= M
		if(target(M))
			return 1


/obj/machinery/porta_turret/proc/popUp()	//pops the turret up
	set waitfor = FALSE
	if(disabled)
		return
	if(raising || raised)
		return
	if(stat & BROKEN)
		return
	set_raised_raising(raised, 1)
	update_icon()

	var/atom/flick_holder = new /atom/movable/porta_turret_cover(loc)
	flick_holder.layer = layer + 0.1
	flick("popup_[turret_type]", flick_holder)
	playsound(src, 'sound/machines/turrets/turret_deploy.ogg', 100, 1)
	sleep(10)
	qdel(flick_holder)

	set_raised_raising(1, 0)
	update_icon()
	timeout = 10

/obj/machinery/porta_turret/proc/popDown()	//pops the turret down
	set waitfor = FALSE
	last_target = null
	if(disabled)
		return
	if(raising || !raised)
		return
	if(stat & BROKEN)
		return
	set_raised_raising(raised, 1)
	update_icon()

	var/atom/flick_holder = new /atom/movable/porta_turret_cover(loc)
	flick_holder.layer = layer + 0.1
	flick("popdown_[turret_type]", flick_holder)
	playsound(src, 'sound/machines/turrets/turret_retract.ogg', 100, 1)
	sleep(10)
	qdel(flick_holder)

	set_raised_raising(0, 0)
	update_icon()
	timeout = 10

/obj/machinery/porta_turret/proc/set_raised_raising(var/incoming_raised, var/incoming_raising)
	raised = incoming_raised
	raising = incoming_raising
	density = raised || raising

/obj/machinery/porta_turret/proc/target(var/mob/living/target)
	if(disabled)
		return FALSE
	if(target)
		if(target in check_trajectory(target, src))	//Finally, check if we can actually hit the target
			last_target = target
			popUp()				//pop the turret up if it's not already up.
			set_dir(get_dir(src, target))	//even if you can't shoot, follow the target
			playsound(src, 'sound/machines/turrets/turret_rotate.ogg', 100, 1) // Play rotating sound
			spawn()
				shootAt(target)
			return TRUE
	return FALSE

/obj/machinery/porta_turret/proc/shootAt(var/mob/living/target)
	//any emagged turrets will shoot extremely fast! This not only is deadly, but drains a lot power!
	if(!(emagged || attacked))		//if it hasn't been emagged or attacked, it has to obey a cooldown rate
		if(last_fired || !raised)	//prevents rapid-fire shooting, unless it's been emagged
			return
		last_fired = TRUE
		spawn()
			sleep(shot_delay)
			last_fired = FALSE

	if(!isturf(get_turf(src)) || !isturf(get_turf(target)))
		return

	if(!raised) //the turret has to be raised in order to fire - makes sense, right?
		return

	update_icon()
	var/obj/item/projectile/A
	if(emagged || lethal)
		A = new lethal_projectile(loc)
		playsound(src, lethal_shot_sound, 75, 1)
	else
		A = new projectile(loc)
		playsound(src, shot_sound, 75, 1)

	var/power_mult = 1
	if(emagged)
		power_mult = 4 // Lethal beams + higher rate of fire
	else if(lethal)
		power_mult = 2 // Lethal beams
	use_power(reqpower * power_mult)

	//Turrets aim for the center of mass by default.
	//If the target is grabbing someone then the turret smartly aims for extremities
	var/def_zone
	var/obj/item/grab/G = locate() in target
	if(G && G.state >= GRAB_NECK) //works because mobs are currently not allowed to upgrade to NECK if they are grabbing two people.
		def_zone = pick(BP_HEAD, BP_L_HAND, BP_R_HAND, BP_L_FOOT, BP_R_FOOT, BP_L_ARM, BP_R_ARM, BP_L_LEG, BP_R_LEG)
	else
		def_zone = pick(BP_TORSO, BP_GROIN)

	//Shooting Code:
	A.firer = src
	A.old_style_target(target)
	A.launch_projectile_from_turf(target, def_zone, src)

	// Reset the time needed to go back down, since we just tried to shoot at someone.
	timeout = 10

/datum/turret_checks
	var/enabled
	var/lethal
	var/check_synth
	var/check_access
	var/check_records
	var/check_arrest
	var/check_weapons
	var/check_anomalies
	var/check_all
	var/ailock

/obj/machinery/porta_turret/proc/setState(var/datum/turret_checks/TC)
	if(controllock)
		return
	enabled = TC.enabled
	lethal = TC.lethal

	check_synth = TC.check_synth
	check_access = TC.check_access
	check_records = TC.check_records
	check_arrest = TC.check_arrest
	check_weapons = TC.check_weapons
	check_anomalies = TC.check_anomalies
	check_all = TC.check_all
	ailock = TC.ailock

	power_change()

/*
		Portable turret constructions
		Known as "turret frame"s
*/

/obj/machinery/porta_turret_construct
	name = "turret frame"
	icon = 'icons/obj/turrets.dmi'
	icon_state = "turret_frame"
	density=TRUE
	var/target_type = /obj/machinery/porta_turret	// The type we intend to build
	var/build_step = 0			//the current step in the building process
	var/finish_name="turret"	//the name applied to the product turret
	var/installation = null		//the gun type installed
	var/gun_charge = 0			//the gun charge of the gun type installed

/obj/machinery/porta_turret_construct/attackby(obj/item/I, mob/user)
	//this is a bit unwieldy but self-explanatory
	switch(build_step)
		if(0)	//first step
			if(I.has_tool_quality(TOOL_WRENCH) && !anchored)
				playsound(src, I.usesound, 100, 1)
				to_chat(user, span_notice("You secure the external bolts."))
				anchored = TRUE
				build_step = 1
				return

			else if(I.has_tool_quality(TOOL_CROWBAR) && !anchored)
				playsound(src, I.usesound, 75, 1)
				to_chat(user, span_notice("You dismantle the turret construction."))
				new /obj/item/stack/material/steel(loc, 5)
				qdel(src)
				return

		if(1)
			if(istype(I, /obj/item/stack/material) && I.get_material_name() == MAT_STEEL)
				var/obj/item/stack/M = I
				if(M.use(2))
					to_chat(user, span_notice("You add some metal armor to the interior frame."))
					build_step = 2
					icon_state = "turret_frame2"
				else
					to_chat(user, span_warning("You need two sheets of metal to continue construction."))
				return

			else if(I.has_tool_quality(TOOL_WRENCH))
				playsound(src, I.usesound, 75, 1)
				to_chat(user, span_notice("You unfasten the external bolts."))
				anchored = FALSE
				build_step = 0
				return

		if(2)
			if(I.has_tool_quality(TOOL_WRENCH))
				playsound(src, I.usesound, 100, 1)
				to_chat(user, span_notice("You bolt the metal armor into place."))
				build_step = 3
				return

			else if(I.has_tool_quality(TOOL_WELDER))
				var/obj/item/weldingtool/WT = I.get_welder()
				if(!WT.isOn())
					return
				if(WT.get_fuel() < 5) //uses up 5 fuel.
					to_chat(user, span_notice("You need more fuel to complete this task."))
					return

				playsound(src, I.usesound, 50, 1)
				if(do_after(user, 20 * I.toolspeed))
					if(!src || !WT.remove_fuel(5, user)) return
					build_step = 1
					to_chat(user, "You remove the turret's interior metal armor.")
					new /obj/item/stack/material/steel(loc, 2)
					return

		if(3)
			if(istype(I, /obj/item/gun/energy)) //the gun installation part

				if(isrobot(user))
					return
				var/obj/item/gun/energy/E = I //typecasts the item to an energy gun
				if(!user.unEquip(I))
					to_chat(user, span_notice("\The [I] is stuck to your hand, you cannot put it in \the [src]"))
					return
				installation = I.type //installation becomes I.type
				gun_charge = E.power_supply.charge //the gun's charge is stored in gun_charge
				to_chat(user, span_notice("You add [I] to the turret."))
				target_type = /obj/machinery/porta_turret

				build_step = 4
				qdel(I) //delete the gun :(
				return

			else if(I.has_tool_quality(TOOL_WRENCH))
				playsound(src, I.usesound, 100, 1)
				to_chat(user, span_notice("You remove the turret's metal armor bolts."))
				build_step = 2
				return

		if(4)
			if(isprox(I))
				build_step = 5
				if(!user.unEquip(I))
					to_chat(user, span_notice("\The [I] is stuck to your hand, you cannot put it in \the [src]"))
					return
				to_chat(user, span_notice("You add the prox sensor to the turret."))
				qdel(I)
				return

			//attack_hand() removes the gun

		if(5)
			if(I.has_tool_quality(TOOL_SCREWDRIVER))
				playsound(src, I.usesound, 100, 1)
				build_step = 6
				to_chat(user, span_notice("You close the internal access hatch."))
				return

			//attack_hand() removes the prox sensor

		if(6)
			if(istype(I, /obj/item/stack/material) && I.get_material_name() == MAT_STEEL)
				var/obj/item/stack/M = I
				if(M.use(2))
					to_chat(user, span_notice("You add some metal armor to the exterior frame."))
					build_step = 7
				else
					to_chat(user, span_warning("You need two sheets of metal to continue construction."))
				return

			else if(I.has_tool_quality(TOOL_SCREWDRIVER))
				playsound(src, I.usesound, 100, 1)
				build_step = 5
				to_chat(user, span_notice("You open the internal access hatch."))
				return

		if(7)
			if(I.has_tool_quality(TOOL_WELDER))
				var/obj/item/weldingtool/WT = I.get_welder()
				if(!WT.isOn()) return
				if(WT.get_fuel() < 5)
					to_chat(user, span_notice("You need more fuel to complete this task."))

				playsound(src, WT.usesound, 50, 1)
				if(do_after(user, 30 * WT.toolspeed))
					if(!src || !WT.remove_fuel(5, user))
						return
					build_step = 8
					to_chat(user, span_notice("You weld the turret's armor down."))

					//The final step: create a full turret
					var/obj/machinery/porta_turret/Turret = new target_type(loc)
					Turret.name = finish_name
					Turret.installation = installation
					Turret.gun_charge = gun_charge
					Turret.enabled = 0
					Turret.setup()

					qdel(src) // qdel

			else if(I.has_tool_quality(TOOL_CROWBAR))
				playsound(src, I.usesound, 75, 1)
				to_chat(user, span_notice("You pry off the turret's exterior armor."))
				new /obj/item/stack/material/steel(loc, 2)
				build_step = 6
				return

	if(istype(I, /obj/item/pen))	//you can rename turrets like bots!
		var/t = sanitizeSafe(tgui_input_text(user, "Enter new turret name", name, finish_name, MAX_NAME_LEN), MAX_NAME_LEN)
		if(!t)
			return
		if(!in_range(src, usr) && loc != usr)
			return

		finish_name = t
		return

	..()

/obj/machinery/porta_turret_construct/attack_hand(mob/user)
	switch(build_step)
		if(4)
			if(!installation)
				return
			build_step = 3

			var/obj/item/gun/energy/Gun = new installation(loc)
			Gun.power_supply.charge = gun_charge
			Gun.update_icon()
			installation = null
			gun_charge = 0
			to_chat(user, span_notice("You remove [Gun] from the turret frame."))

		if(5)
			to_chat(user, span_notice("You remove the prox sensor from the turret frame."))
			new /obj/item/assembly/prox_sensor(loc)
			build_step = 4

/obj/machinery/porta_turret_construct/attack_ai()
	return

/atom/movable/porta_turret_cover
	icon = 'icons/obj/turrets.dmi'

#undef TURRET_PRIORITY_TARGET
#undef TURRET_SECONDARY_TARGET
#undef TURRET_NOT_TARGET
