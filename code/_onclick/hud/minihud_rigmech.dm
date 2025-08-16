// Specific types
/datum/mini_hud/rig
	var/obj/item/rig/owner_rig
	var/obj/screen/rig/power/power
	var/obj/screen/rig/health/health
	var/obj/screen/rig/air/air
	var/obj/screen/rig/airtoggle/airtoggle

	needs_processing = TRUE

/datum/mini_hud/rig/New(var/datum/hud/other, var/obj/item/rig/owner)
	owner_rig = owner
	power = new ()
	health = new ()
	air = new ()
	airtoggle = new ()

	screenobjs = list(power, health, air, airtoggle)
	screenobjs += new /obj/screen/rig/deco1
	screenobjs += new /obj/screen/rig/deco2
	screenobjs += new /obj/screen/rig/deco1_f
	screenobjs += new /obj/screen/rig/deco2_f

	for(var/obj/screen/S as anything in screenobjs)
		S.master = owner_rig
	..()

/datum/mini_hud/rig/Destroy()
	if(owner_rig)
		//owner_rig.minihud = null
		owner_rig = null
	return ..()

/datum/mini_hud/rig/process()
	if(!owner_rig)
		qdel(src)
		return

	var/obj/item/cell/rigcell = owner_rig.cell
	var/obj/item/tank/rigtank = owner_rig.air_supply

	var/charge_percentage = rigcell ? rigcell.charge / rigcell.maxcharge : 0
	var/air_percentage = rigtank ? CLAMP(rigtank.air_contents.total_moles / 17.4693, 0, 1) : 0
	var/air_on = owner_rig.wearer?.internal ? 1 : 0

	power.icon_state = "pwr[round(charge_percentage / 0.2, 1)]"
	air.icon_state = "air[round(air_percentage / 0.2, 1)]"
	health.icon_state = owner_rig.malfunctioning ? "health1" : "health5"
	airtoggle.icon_state = "airon[air_on]"

/datum/mini_hud/mech
	var/obj/mecha/owner_mech
	var/obj/screen/mech/power/power
	var/obj/screen/mech/health/health
	var/obj/screen/mech/air/air
	var/obj/screen/mech/airtoggle/airtoggle

	needs_processing = TRUE

/datum/mini_hud/mech/New(var/datum/hud/other, var/obj/mecha/owner)
	owner_mech = owner
	power = new ()
	health = new ()
	air = new ()
	airtoggle = new ()

	screenobjs = list(power, health, air, airtoggle)
	screenobjs += new /obj/screen/mech/deco1
	screenobjs += new /obj/screen/mech/deco2
	screenobjs += new /obj/screen/mech/deco1_f
	screenobjs += new /obj/screen/mech/deco2_f

	for(var/obj/screen/S as anything in screenobjs)
		S.master = owner_mech
	..()

/datum/mini_hud/mech/Destroy()
	if(owner_mech)
		owner_mech.minihud = null
		owner_mech = null
	return ..()

/datum/mini_hud/mech/process()
	if(!owner_mech)
		qdel(src)
		return

	var/obj/item/cell/mechcell = owner_mech.cell
	var/obj/machinery/portable_atmospherics/canister/mechtank = owner_mech.internal_tank

	var/charge_percentage = mechcell ? mechcell.charge / mechcell.maxcharge : 0
	var/air_percentage = mechtank ? CLAMP(mechtank.air_contents.total_moles / 1863.47, 0, 1) : 0
	var/health_percentage = owner_mech.health / owner_mech.maxhealth
	var/air_on = owner_mech.use_internal_tank

	power.icon_state = "pwr[round(charge_percentage / 0.2, 1)]"
	air.icon_state = "air[round(air_percentage / 0.2, 1)]"
	health.icon_state = "health[round(health_percentage / 0.2, 1)]"
	airtoggle.icon_state = "airon[air_on]"

// Screen objects
/obj/screen/rig
	icon = 'icons/mob/screen_rigmech.dmi'

/obj/screen/rig/deco1
	name = "RIG Status"
	icon_state = "frame1_1"
	screen_loc = ui_rig_deco1

/obj/screen/rig/deco2
	name = "RIG Status"
	icon_state = "frame1_2"
	screen_loc = ui_rig_deco2

/obj/screen/rig/deco1_f
	name = "RIG Status"
	icon_state = "frame1_1_far"
	screen_loc = ui_rig_deco1_f

/obj/screen/rig/deco2_f
	name = "RIG Status"
	icon_state = "frame1_2_far"
	screen_loc = ui_rig_deco2_f

/obj/screen/rig/power
	name = "Charge Level"
	icon_state = "pwr5"
	screen_loc = ui_rig_pwr

/obj/screen/rig/health
	name = "Integrity Level"
	icon_state = "health5"
	screen_loc = ui_rig_health

/obj/screen/rig/air
	name = "Air Storage"
	icon_state = "air5"
	screen_loc = ui_rig_air

/obj/screen/rig/airtoggle
	name = "Toggle Air"
	icon_state = "airoff"
	screen_loc = ui_rig_airtoggle

/obj/screen/rig/airtoggle/Click()
	var/mob/living/carbon/human/user = usr
	if(!istype(user) || user.stat || user.incapacitated())
		return
	var/obj/item/rig/owner_rig = master
	if(user != owner_rig.wearer)
		return
	user.toggle_internals()

/obj/screen/mech
	icon = 'icons/mob/screen_rigmech.dmi'

/obj/screen/mech/deco1
	name = "Mech Status"
	icon_state = "frame1_1"
	screen_loc = ui_mech_deco1

/obj/screen/mech/deco2
	name = "Mech Status"
	icon_state = "frame1_2"
	screen_loc = ui_mech_deco2

/obj/screen/mech/deco1_f
	name = "Mech Status"
	icon_state = "frame1_1_far"
	screen_loc = ui_mech_deco1_f

/obj/screen/mech/deco2_f
	name = "Mech Status"
	icon_state = "frame1_2_far"
	screen_loc = ui_mech_deco2_f

/obj/screen/mech/power
	name = "Charge Level"
	icon_state = "pwr5"
	screen_loc = ui_mech_pwr

/obj/screen/mech/health
	name = "Integrity Level"
	icon_state = "health5"
	screen_loc = ui_mech_health

/obj/screen/mech/air
	name = "Air Storage"
	icon_state = "air5"
	screen_loc = ui_mech_air

/obj/screen/mech/airtoggle
	name = "Toggle Air"
	icon_state = "airoff"
	screen_loc = ui_mech_airtoggle

/obj/screen/mech/airtoggle/Click()
	var/mob/living/carbon/human/user = usr
	if(!istype(user) || user.stat || user.incapacitated())
		return
	var/obj/mecha/owner_mech = master
	if(user != owner_mech.occupant)
		return
	owner_mech.toggle_internal_tank()

/*
/mob/observer/dead/create_mob_hud(datum/hud/HUD, apply_to_client = TRUE)
	..()

	var/list/adding = list()
	HUD.adding = adding

	var/obj/screen/using
	using = new /obj/screen/ghost/jumptomob()
	using.screen_loc = ui_ghost_jumptomob
	using.hud = src
	adding += using

	using = new /obj/screen/ghost/orbit()
	using.screen_loc = ui_ghost_orbit
	using.hud = src
	adding += using

	using = new /obj/screen/ghost/reenter_corpse()
	using.screen_loc = ui_ghost_reenter_corpse
	using.hud = src
	adding += using
*/
