
#define NITROGEN_RETARDATION_FACTOR 0.15	//Higher == N2 slows reaction more
#define THERMAL_RELEASE_MODIFIER 10000		//Higher == more heat released during reaction
#define PHORON_RELEASE_MODIFIER 1500		//Higher == less phoron released by reaction
#define OXYGEN_RELEASE_MODIFIER 15000		//Higher == less oxygen released at high temperature/power
#define REACTION_POWER_MODIFIER 1.1			//Higher == more overall power

/*
	How to tweak the SM

	POWER_FACTOR		directly controls how much power the SM puts out at a given level of excitation (power var). Making this lower means you have to work the SM harder to get the same amount of power.
	CRITICAL_TEMPERATURE	The temperature at which the SM starts taking damage.

	CHARGING_FACTOR		Controls how much emitter shots excite the SM.
	DAMAGE_RATE_LIMIT	Controls the maximum rate at which the SM will take damage due to high temperatures.
*/

//Controls how much power is produced by each collector in range - this is the main parameter for tweaking SM balance, as it basically controls how the power variable relates to the rest of the game.
#define POWER_FACTOR 1.0
#define DECAY_FACTOR 700			//Affects how fast the supermatter power decays
#define CRITICAL_TEMPERATURE 5000	//K
#define CHARGING_FACTOR 0.05
#define DAMAGE_RATE_LIMIT 3			//damage rate cap at power = 300, scales linearly with power


// Base variants are applied to everyone on the same Z level
// Range variants are applied on per-range basis: numbers here are on point blank, it scales with the map size (assumes square shaped Z levels)
#define DETONATION_RADS 40
#define DETONATION_MOB_CONCUSSION 4			// Value that will be used for Weaken() for mobs.

// Base amount of ticks for which a specific type of machine will be offline for. +- 20% added by RNG.
// This does pretty much the same thing as an electrical storm, it just affects the whole Z level instantly.
#define DETONATION_APC_OVERLOAD_PROB 10		// prob() of overloading an APC's lights.
#define DETONATION_SHUTDOWN_APC 120			// Regular APC.
#define DETONATION_SHUTDOWN_CRITAPC 10		// Critical APC. AI core and such. Considerably shorter as we don't want to kill the AI with a single blast. Still a nuisance.
#define DETONATION_SHUTDOWN_SMES 60			// SMES
#define DETONATION_SHUTDOWN_RNG_FACTOR 20	// RNG factor. Above shutdown times can be +- X%, where this setting is the percent. Do not set to 100 or more.
#define DETONATION_SOLAR_BREAK_CHANCE 60	// prob() of breaking solar arrays (this is per-panel, and only affects the Z level SM is on)

// If power level is between these two, explosion strength will be scaled accordingly between min_explosion_power and max_explosion_power
#define DETONATION_EXPLODE_MIN_POWER 200	// If power level is this or lower, minimal detonation strength will be used
#define DETONATION_EXPLODE_MAX_POWER 2000	// If power level is this or higher maximal detonation strength will be used

#define WARNING_DELAY 20			//seconds between warnings.

/obj/machinery/power/supermatter
	name = "Supermatter"
	desc = "A strangely translucent and iridescent crystal. <font color='red'>You get headaches just from looking at it.</font>"
	icon = 'icons/obj/engine.dmi'
	icon_state = "darkmatter"
	density = 1
	anchored = 0
	light_range = 4

	var/gasefficency = 0.25

	var/base_icon_state = "darkmatter"

	var/damage = 0
	var/damage_archived = 0
	var/safe_alert = "Crystaline hyperstructure returning to safe operating levels."
	var/safe_warned = 0
	var/public_alert = 0 //Stick to Engineering frequency except for big warnings when integrity bad
	var/warning_point = 100
	var/warning_alert = "Danger! Crystal hyperstructure instability!"
	var/emergency_point = 500
	var/emergency_alert = "CRYSTAL DELAMINATION IMMINENT."
	var/explosion_point = 1000

	light_color = "#8A8A00"
	var/warning_color = "#B8B800"
	var/emergency_color = "#D9D900"

	var/grav_pulling = 0
	var/pull_radius = 14
	// Time in ticks between delamination ('exploding') and exploding (as in the actual boom)
	var/pull_time = 100
	var/min_explosion_power = 8
	var/max_explosion_power = 16

	var/emergency_issued = 0

	// Time in 1/10th of seconds since the last sent warning
	var/lastwarning = 0

	// This stops spawning redundand explosions. Also incidentally makes supermatter unexplodable if set to 1.
	var/exploded = 0

	var/power = 0
	var/oxygen = 0

	//Temporary values so that we can optimize this
	//How much the bullets damage should be multiplied by when it is added to the internal variables
	var/config_bullet_energy = 2
	//How much of the power is left after processing is finished?
//        var/config_power_reduction_per_tick = 0.5
	//How much hallucination should it produce per unit of power?
	var/config_hallucination_power = 0.1

	var/debug = 0

	var/datum/looping_sound/supermatter/soundloop

/obj/machinery/power/supermatter/New()
	..()
	uid = gl_uid++

/obj/machinery/power/supermatter/Initialize()
	soundloop = new(list(src), TRUE)
	return ..()

/obj/machinery/power/supermatter/Destroy()
	STOP_PROCESSING(SSobj, src)
	QDEL_NULL(soundloop)
	return ..()

/obj/machinery/power/supermatter/proc/get_status()
	var/turf/T = get_turf(src)
	if(!T)
		return SUPERMATTER_ERROR
	var/datum/gas_mixture/air = T.return_air()
	if(!air)
		return SUPERMATTER_ERROR

	if(grav_pulling || exploded)
		return SUPERMATTER_DELAMINATING

	if(get_integrity() < 25)
		return SUPERMATTER_EMERGENCY

	if(get_integrity() < 50)
		return SUPERMATTER_DANGER

	if((get_integrity() < 100) || (air.temperature > CRITICAL_TEMPERATURE))
		return SUPERMATTER_WARNING

	if(air.temperature > (CRITICAL_TEMPERATURE * 0.8))
		return SUPERMATTER_NOTIFY

	if(power > 5)
		return SUPERMATTER_NORMAL
	return SUPERMATTER_INACTIVE


/obj/machinery/power/supermatter/proc/get_epr()
	var/turf/T = get_turf(src)
	if(!istype(T))
		return
	var/datum/gas_mixture/air = T.return_air()
	if(!air)
		return 0
	return round((air.total_moles / air.group_multiplier) / 23.1, 0.01)


/obj/machinery/power/supermatter/proc/explode()

	set waitfor = 0

	message_admins("Supermatter exploded at ([x],[y],[z] - <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>JMP</a>)",0,1)
	log_game("SUPERMATTER([x],[y],[z]) Exploded. Power:[power], Oxygen:[oxygen], Damage:[damage], Integrity:[get_integrity()]")
	anchored = 1
	grav_pulling = 1
	exploded = 1
	sleep(pull_time)
	var/turf/TS = get_turf(src)		// The turf supermatter is on. SM being in a locker, exosuit, or other container shouldn't block it's effects that way.
	if(!istype(TS))
		return

	var/list/affected_z = GetConnectedZlevels(TS.z)

	// Effect 1: Radiation, weakening to all mobs on Z level
	for(var/z in affected_z)
		SSradiation.z_radiate(locate(1, 1, z), DETONATION_RADS, 1)

	for(var/mob/living/mob in living_mob_list)
		var/turf/TM = get_turf(mob)
		if(!TM)
			continue
		if(!(TM.z in affected_z))
			continue

		mob.Weaken(DETONATION_MOB_CONCUSSION)
		to_chat(mob, "<span class='danger'>An invisible force slams you against the ground!</span>")

	// Effect 2: Z-level wide electrical pulse
	for(var/obj/machinery/power/apc/A in GLOB.apcs)
		if(!(A.z in affected_z))
			continue

		// Overloads lights
		if(prob(DETONATION_APC_OVERLOAD_PROB))
			A.overload_lighting()
		// Causes the APCs to go into system failure mode.
		var/random_change = rand(100 - DETONATION_SHUTDOWN_RNG_FACTOR, 100 + DETONATION_SHUTDOWN_RNG_FACTOR) / 100
		if(A.is_critical)
			A.energy_fail(round(DETONATION_SHUTDOWN_CRITAPC * random_change))
		else
			A.energy_fail(round(DETONATION_SHUTDOWN_APC * random_change))

	// Effect 3: Break solar arrays
	for(var/obj/machinery/power/solar/S in machines)
		if(!(S.z in affected_z))
			continue
		if(prob(DETONATION_SOLAR_BREAK_CHANCE))
			S.health = -1
			S.broken()

	// Effect 4: Medium scale explosion
	spawn(0)
		var/explosion_power = min_explosion_power
		if(power > 0)
			// 0-100% where 0% is at DETONATION_EXPLODE_MIN_POWER or lower and 100% is at DETONATION_EXPLODE_MAX_POWER or higher
			var/strength_percentage = between(0, (power - DETONATION_EXPLODE_MIN_POWER) / ((DETONATION_EXPLODE_MAX_POWER - DETONATION_EXPLODE_MIN_POWER) / 100), 100)
			explosion_power = between(min_explosion_power, (((max_explosion_power - min_explosion_power) * (strength_percentage / 100)) + min_explosion_power), max_explosion_power)

		explosion(TS, explosion_power/2, explosion_power, max_explosion_power, explosion_power * 4, 1)
		qdel(src)
		// Allow the explosion to finish
		spawn(5)
			new /obj/item/broken_sm(TS)

//Changes color and luminosity of the light to these values if they were not already set
/obj/machinery/power/supermatter/proc/shift_light(var/lum, var/clr)
	if(lum != light_range || clr != light_color)
		set_light(lum, l_color = clr)

/obj/machinery/power/supermatter/proc/get_integrity()
	var/integrity = damage / explosion_point
	integrity = round(100 - integrity * 100)
	integrity = integrity < 0 ? 0 : integrity
	return integrity


/obj/machinery/power/supermatter/proc/announce_warning()
	var/integrity = get_integrity()
	var/alert_msg = " Integrity at [integrity]%"
	var/message_sound = 'sound/ambience/matteralarm.ogg'

	if(damage > emergency_point)
		alert_msg = emergency_alert + alert_msg
		lastwarning = world.timeofday - WARNING_DELAY * 4
	else if(damage >= damage_archived) // The damage is still going up
		safe_warned = 0
		alert_msg = warning_alert + alert_msg
		lastwarning = world.timeofday
	else if(!safe_warned)
		safe_warned = 1 // We are safe, warn only once
		alert_msg = safe_alert
		lastwarning = world.timeofday
	else
		alert_msg = null
	if(alert_msg)
		global_announcer.autosay(alert_msg, "Supermatter Monitor", "Engineering")
		log_game("SUPERMATTER([x],[y],[z]) Emergency engineering announcement. Power:[power], Oxygen:[oxygen], Damage:[damage], Integrity:[get_integrity()]")
		//Public alerts
		if((damage > emergency_point) && !public_alert)
			global_announcer.autosay("WARNING: SUPERMATTER CRYSTAL DELAMINATION IMMINENT!", "Supermatter Monitor")
			for(var/mob/M in player_list) // Rykka adds SM Delam alarm
				if(!istype(M,/mob/new_player) && !isdeaf(M)) // Rykka adds SM Delam alarm
					M << message_sound // Rykka adds SM Delam alarm
			admin_chat_message(message = "SUPERMATTER DELAMINATING!", color = "#FF2222") //VOREStation Add
			public_alert = 1
			log_game("SUPERMATTER([x],[y],[z]) Emergency PUBLIC announcement. Power:[power], Oxygen:[oxygen], Damage:[damage], Integrity:[get_integrity()]")
		else if(safe_warned && public_alert)
			global_announcer.autosay(alert_msg, "Supermatter Monitor")
			public_alert = 0

/obj/machinery/power/supermatter/process()

	var/turf/L = loc

	if(isnull(L))		// We have a null turf...something is wrong, stop processing this entity.
		return PROCESS_KILL

	if(!istype(L)) 	//We are in a crate or somewhere that isn't turf, if we return to turf resume processing but for now.
		return  //Yeah just stop.

	if(damage > explosion_point)
		if(!exploded)
			if(!istype(L, /turf/space))
				announce_warning()
			explode()
	else if(damage > warning_point) // while the core is still damaged and it's still worth noting its status
		shift_light(5, warning_color)
		if(damage > emergency_point)
			shift_light(7, emergency_color)
		if(!istype(L, /turf/space) && (world.timeofday - lastwarning) >= WARNING_DELAY * 10)
			announce_warning()
	else
		shift_light(4,initial(light_color))
	if(grav_pulling)
		supermatter_pull(src)

	if(power)
		// Volume will be 1 at no power, ~12.5 at ENERGY_NITROGEN, and 20+ at ENERGY_PHORON.
		// Capped to 20 volume since higher volumes get annoying and it sounds worse.
		soundloop.volume = min(round(power/10)+1, 20)

	//Ok, get the air from the turf
	var/datum/gas_mixture/removed = null
	var/datum/gas_mixture/env = null

	//ensure that damage doesn't increase too quickly due to super high temperatures resulting from no coolant, for example. We dont want the SM exploding before anyone can react.
	//We want the cap to scale linearly with power (and explosion_point). Let's aim for a cap of 5 at power = 300 (based on testing, equals roughly 5% per SM alert announcement).
	var/damage_inc_limit = (power/300)*(explosion_point/1000)*DAMAGE_RATE_LIMIT

	if(!istype(L, /turf/space))
		env = L.return_air()
		removed = env.remove(gasefficency * env.total_moles)	//Remove gas from surrounding area

	if(!env || !removed || !removed.total_moles)
		damage += max((power - 15*POWER_FACTOR)/10, 0)
	else if (grav_pulling) //If supermatter is detonating, remove all air from the zone
		env.remove(env.total_moles)
	else
		damage_archived = damage

		damage = max( damage + min( ( (removed.temperature - CRITICAL_TEMPERATURE) / 150 ), damage_inc_limit ) , 0 )
		//Ok, 100% oxygen atmosphere = best reaction
		//Maxes out at 100% oxygen pressure
		oxygen = max(min((removed.gas["oxygen"] - (removed.gas["nitrogen"] * NITROGEN_RETARDATION_FACTOR)) / removed.total_moles, 1), 0)

		//calculate power gain for oxygen reaction
		var/temp_factor
		var/equilibrium_power
		if (oxygen > 0.8)
			//If chain reacting at oxygen == 1, we want the power at 800 K to stabilize at a power level of 400
			equilibrium_power = 400
			icon_state = "[base_icon_state]_glow"
		else
			//If chain reacting at oxygen == 1, we want the power at 800 K to stabilize at a power level of 250
			equilibrium_power = 250
			icon_state = base_icon_state

		temp_factor = ( (equilibrium_power/DECAY_FACTOR)**3 )/800
		power = max( (removed.temperature * temp_factor) * oxygen + power, 0)

		//We've generated power, now let's transfer it to the collectors for storing/usage
		//transfer_energy()

		var/device_energy = power * REACTION_POWER_MODIFIER

		//Release reaction gasses
		var/heat_capacity = removed.heat_capacity()
		removed.adjust_multi("phoron", max(device_energy / PHORON_RELEASE_MODIFIER, 0), \
		                     "oxygen", max((device_energy + removed.temperature - T0C) / OXYGEN_RELEASE_MODIFIER, 0))

		var/thermal_power = THERMAL_RELEASE_MODIFIER * device_energy
		if (debug)
			var/heat_capacity_new = removed.heat_capacity()
			visible_message("[src]: Releasing [round(thermal_power)] W.")
			visible_message("[src]: Releasing additional [round((heat_capacity_new - heat_capacity)*removed.temperature)] W with exhaust gasses.")

		removed.add_thermal_energy(thermal_power)
		removed.temperature = between(0, removed.temperature, 10000)

		env.merge(removed)

	for(var/mob/living/carbon/human/l in view(src, min(7, round(sqrt(power/6))))) // If they can see it without mesons on.  Bad on them.
		if(!istype(l.glasses, /obj/item/clothing/glasses/meson)) // VOREStation Edit - Only mesons can protect you!
			l.hallucination = max(0, min(200, l.hallucination + power * config_hallucination_power * sqrt( 1 / max(1,get_dist(l, src)) ) ) )

	SSradiation.radiate(src, max(power * 1.5, 50) ) //Better close those shutters!

	power -= (power/DECAY_FACTOR)**3		//energy losses due to radiation

	return 1


/obj/machinery/power/supermatter/bullet_act(var/obj/item/projectile/Proj)
	var/turf/L = loc
	if(!istype(L))		// We don't run process() when we are in space
		return 0	// This stops people from being able to really power up the supermatter
				// Then bring it inside to explode instantly upon landing on a valid turf.

	var/added_energy
	var/added_damage
	var/proj_damage = Proj.get_structure_damage()
	if(istype(Proj, /obj/item/projectile/beam))
		added_energy = proj_damage * config_bullet_energy	* CHARGING_FACTOR / POWER_FACTOR
		power += added_energy
	else
		added_damage = proj_damage * config_bullet_energy
		damage += added_damage
	if(added_energy || added_damage)
		log_game("SUPERMATTER([x],[y],[z]) Hit by \"[Proj.name]\". +[added_energy] Energy, +[added_damage] Damage.")
	return 0

/obj/machinery/power/supermatter/attack_robot(mob/user as mob)
	if(Adjacent(user))
		return attack_hand(user)
	else
		ui_interact(user)
	return

/obj/machinery/power/supermatter/attack_ai(mob/user as mob)
	ui_interact(user)

/obj/machinery/power/supermatter/attack_hand(mob/user as mob)
	var/datum/gender/TU = gender_datums[user.get_visible_gender()]
	user.visible_message("<span class=\"warning\">\The [user] reaches out and touches \the [src], inducing a resonance... [TU.his] body starts to glow and bursts into flames before flashing into ash.</span>",\
		"<span class=\"danger\">You reach out and touch \the [src]. Everything starts burning and all you can hear is ringing. Your last thought is \"That was not a wise decision.\"</span>",\
		"<span class=\"warning\">You hear an uneartly ringing, then what sounds like a shrilling kettle as you are washed with a wave of heat.</span>")

	Consume(user)

// This is purely informational UI that may be accessed by AIs or robots
/obj/machinery/power/supermatter/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1)
	var/data[0]

	data["integrity_percentage"] = round(get_integrity())
	var/datum/gas_mixture/env = null
	if(!istype(src.loc, /turf/space))
		env = src.loc.return_air()

	if(!env)
		data["ambient_temp"] = 0
		data["ambient_pressure"] = 0
	else
		data["ambient_temp"] = round(env.temperature)
		data["ambient_pressure"] = round(env.return_pressure())
	data["detonating"] = grav_pulling

	ui = SSnanoui.try_update_ui(user, src, ui_key, ui, data, force_open)
	if (!ui)
		ui = new(user, src, ui_key, "supermatter_crystal.tmpl", "Supermatter Crystal", 500, 300)
		ui.set_initial_data(data)
		ui.open()
		ui.set_auto_update(1)


/obj/machinery/power/supermatter/attackby(obj/item/weapon/W as obj, mob/living/user as mob)
	user.visible_message("<span class=\"warning\">\The [user] touches \a [W] to \the [src] as a silence fills the room...</span>",\
		"<span class=\"danger\">You touch \the [W] to \the [src] when everything suddenly goes silent.\"</span>\n<span class=\"notice\">\The [W] flashes into dust as you flinch away from \the [src].</span>",\
		"<span class=\"warning\">Everything suddenly goes silent.</span>")

	user.drop_from_inventory(W)
	Consume(W)

	user.apply_effect(150, IRRADIATE)


/obj/machinery/power/supermatter/Bumped(atom/AM as mob|obj)
	if(istype(AM, /obj/effect))
		return
	if(istype(AM, /mob/living))
		var/mob/living/M = AM
		var/datum/gender/T = gender_datums[M.get_visible_gender()]
		AM.visible_message("<span class=\"warning\">\The [AM] slams into \the [src] inducing a resonance... [T.his] body starts to glow and catch flame before flashing into ash.</span>",\
		"<span class=\"danger\">You slam into \the [src] as your ears are filled with unearthly ringing. Your last thought is \"Oh, fuck.\"</span>",\
		"<span class=\"warning\">You hear an uneartly ringing, then what sounds like a shrilling kettle as you are washed with a wave of heat.</span>")
	else if(!grav_pulling) //To prevent spam, detonating supermatter does not indicate non-mobs being destroyed
		AM.visible_message("<span class=\"warning\">\The [AM] smacks into \the [src] and rapidly flashes to ash.</span>",\
		"<span class=\"warning\">You hear a loud crack as you are washed with a wave of heat.</span>")

	Consume(AM)


/obj/machinery/power/supermatter/proc/Consume(var/mob/living/user)
	if(istype(user))
		user.dust()
		power += 200
	else
		qdel(user)

	power += 200

		//Some poor sod got eaten, go ahead and irradiate people nearby.
	for(var/mob/living/l in range(10))
		if(l in view())
			l.show_message("<span class=\"warning\">As \the [src] slowly stops resonating, you find your skin covered in new radiation burns.</span>", 1,\
				"<span class=\"warning\">The unearthly ringing subsides and you notice you have new radiation burns.</span>", 2)
		else
			l.show_message("<span class=\"warning\">You hear an uneartly ringing and notice your skin is covered in fresh radiation burns.</span>", 2)
	var/rads = 500
	SSradiation.radiate(src, rads)

/proc/supermatter_pull(var/atom/target, var/pull_range = 255, var/pull_power = STAGE_FIVE)
	for(var/atom/A in range(pull_range, target))
		A.singularity_pull(target, pull_power)

/obj/machinery/power/supermatter/GotoAirflowDest(n) //Supermatter not pushed around by airflow
	return

/obj/machinery/power/supermatter/RepelAirflowDest(n)
	return

/obj/machinery/power/supermatter/shard //Small subtype, less efficient and more sensitive, but less boom.
	name = "Supermatter Shard"
	desc = "A strangely translucent and iridescent crystal that looks like it used to be part of a larger structure. <font color='red'>You get headaches just from looking at it.</font>"
	icon_state = "darkmatter_shard"
	base_icon_state = "darkmatter_shard"

	warning_point = 50
	emergency_point = 400
	explosion_point = 600

	gasefficency = 0.125

	pull_radius = 5
	pull_time = 45
	min_explosion_power = 3
	max_explosion_power = 6

/obj/machinery/power/supermatter/shard/announce_warning() //Shards don't get announcements
	return

/obj/item/broken_sm
	name = "shattered supermatter plinth"
	desc = "The shattered remains of a supermatter shard plinth. It doesn't look safe to be around."
	icon = 'icons/obj/engine.dmi'
	icon_state = "darkmatter_broken"

/obj/item/broken_sm/New()
	message_admins("Broken SM shard created at ([x],[y],[z] - <A HREF='?_src_=holder;adminplayerobservecoodjump=1;X=[x];Y=[y];Z=[z]'>JMP</a>)",0,1)
	START_PROCESSING(SSobj, src)
	return ..()

/obj/item/broken_sm/process()
	SSradiation.radiate(src, 50)

/obj/item/broken_sm/Destroy()
	STOP_PROCESSING(SSobj, src)
	return ..()
