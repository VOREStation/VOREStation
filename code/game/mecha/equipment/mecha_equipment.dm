//DO NOT ADD MECHA PARTS TO THE GAME WITH THE DEFAULT "SPRITE ME" SPRITE!
//I'm annoyed I even have to tell you this! SPRITE FIRST, then commit.
#define EQUIP_HULL		"hull"
#define EQUIP_WEAPON	"weapon"
#define EQUIP_UTILITY	"utility"
#define EQUIP_SPECIAL	"core"
//VOREStation Addition begin: MICROMECHS
#define EQUIP_MICRO_UTILITY	"micro_utility"
#define EQUIP_MICRO_WEAPON	"micro_weapon"
//VOREStation Addition end: MICROMECHS

/obj/item/mecha_parts/mecha_equipment
	name = "mecha equipment"
	icon = 'icons/mecha/mecha_equipment.dmi'
	icon_state = "mecha_equip"
	force = 5
	origin_tech = list(TECH_MATERIAL = 2)
	description_info = "Some equipment may gain new abilities or advantages if equipped to certain types of Exosuits."
	var/equip_cooldown = 0
	var/equip_ready = TRUE
	var/energy_drain = 0
	var/obj/mecha/chassis = null
	var/range = MELEE //bitflags
	/// Bitflag. Used by exosuit fabricator to assign sub-categories based on which exosuits can equip this.
	var/mech_flags = NONE
	var/salvageable = TRUE
	var/required_type = /obj/mecha //may be either a type or a list of allowed types
	var/equip_type = null //mechaequip2
	var/allow_duplicate = FALSE
	var/ready_sound = 'sound/mecha/mech_reload_default.ogg' //Sound to play once the fire delay passed.
	var/enable_special = FALSE	// Will the tool do its special?

	var/step_delay = 0	// Does the component slow/speed up the suit?

/obj/item/mecha_parts/mecha_equipment/proc/do_after_cooldown(target=1)
	sleep(equip_cooldown)
	set_ready_state(TRUE)
	if(ready_sound) //Kind of like the kinetic accelerator.
		playsound(src, ready_sound, 50, 1, -1)
	if(target && chassis)
		return 1
	return 0

/obj/item/mecha_parts/mecha_equipment/examine(mob/user)
	. = ..()
	. += "<span class='notice'>[src] will fill [equip_type?"a [equip_type]":"any"] slot.</span>"

/obj/item/mecha_parts/mecha_equipment/proc/add_equip_overlay(obj/mecha/M as obj)
	return

/obj/item/mecha_parts/mecha_equipment/proc/update_chassis_page()
	if(chassis)
		send_byjax(chassis.occupant,"exosuit.browser","eq_list",chassis.get_equipment_list())
		send_byjax(chassis.occupant,"exosuit.browser","equipment_menu",chassis.get_equipment_menu(),"dropdowns")
		return 1
	return

/obj/item/mecha_parts/mecha_equipment/proc/update_equip_info()
	if(chassis)
		send_byjax(chassis.occupant,"exosuit.browser","\ref[src]",get_equip_info())
		return 1
	return

/obj/item/mecha_parts/mecha_equipment/proc/destroy()//missiles detonating, teleporter creating singularity?
	if(chassis)
		if(equip_type)
			if(equip_type == EQUIP_HULL)
				chassis.hull_equipment -= src
				listclearnulls(chassis.hull_equipment)
			if(equip_type == EQUIP_WEAPON)
				chassis.weapon_equipment -= src
				listclearnulls(chassis.weapon_equipment)
			if(equip_type == EQUIP_UTILITY)
				chassis.utility_equipment -= src
				listclearnulls(chassis.utility_equipment)
			if(equip_type == EQUIP_SPECIAL)
				chassis.special_equipment -= src
				listclearnulls(chassis.special_equipment)
			//VOREStation Addition begin: MICROMECHS
			if(equip_type == EQUIP_MICRO_UTILITY)
				chassis.micro_utility_equipment -= src
				listclearnulls(chassis.micro_utility_equipment)
			if(equip_type == EQUIP_MICRO_WEAPON)
				chassis.micro_weapon_equipment -= src
				listclearnulls(chassis.micro_weapon_equipment)
			//VOREStation Addition end: MICROMECHS
		chassis.universal_equipment -= src
		chassis.equipment -= src
		listclearnulls(chassis.equipment)
		if(chassis.selected == src)
			chassis.selected = null
		src.update_chassis_page()
		chassis.occupant_message(span_red("The [src] is destroyed!"))
		chassis.log_append_to_last("[src] is destroyed.",1)
		if(istype(src, /obj/item/mecha_parts/mecha_equipment/weapon))//Gun
			switch(chassis.mech_faction)
				if(MECH_FACTION_NT)
					src.chassis.occupant << sound('sound/mecha/weapdestrnano.ogg',volume=70)
				if(MECH_FACTION_SYNDI)
					src.chassis.occupant  << sound('sound/mecha/weapdestrsyndi.ogg',volume=60)
				else
					src.chassis.occupant  << sound('sound/mecha/weapdestr.ogg',volume=50)
		else //Not a gun
			switch(chassis.mech_faction)
				if(MECH_FACTION_NT)
					src.chassis.occupant  << sound('sound/mecha/critdestrnano.ogg',volume=70)
				if(MECH_FACTION_SYNDI)
					src.chassis.occupant  << sound('sound/mecha/critdestrsyndi.ogg',volume=70)
				else
					src.chassis.occupant  << sound('sound/mecha/critdestr.ogg',volume=50)
	spawn
		qdel(src)
	return

/obj/item/mecha_parts/mecha_equipment/proc/critfail()
	if(chassis)
		log_message("Critical failure",1)
	return

/obj/item/mecha_parts/mecha_equipment/proc/get_equip_info()
	if(!chassis) return
	return "<span style=\"color:[equip_ready?"#0f0":"#f00"];\">*</span>&nbsp;[chassis.selected==src?"<b>":"<a href='?src=\ref[chassis];select_equip=\ref[src]'>"][src.name][chassis.selected==src?"</b>":"</a>"]"

/obj/item/mecha_parts/mecha_equipment/proc/is_ranged()//add a distance restricted equipment. Why not?
	return range&RANGED

/obj/item/mecha_parts/mecha_equipment/proc/is_melee()
	return range&MELEE

/obj/item/mecha_parts/mecha_equipment/proc/enable_special_checks(atom/target)
	if(ispath(required_type))
		return istype(target, required_type)

	for (var/path in required_type)
		if (istype(target, path))
			return 1

	return 0

/obj/item/mecha_parts/mecha_equipment/proc/action_checks(atom/target)
	if(!target)
		return 0
	if(!chassis)
		return 0
	if(!equip_ready)
		return 0
	if(energy_drain && !chassis.has_charge(energy_drain))
		return 0
	return 1

/obj/item/mecha_parts/mecha_equipment/proc/action(atom/target)
	return

/obj/item/mecha_parts/mecha_equipment/proc/can_attach(obj/mecha/M as obj)
	//if(M.equipment.len >= M.max_equip)
	//	return 0
	if(!allow_duplicate)
		for(var/obj/item/mecha_parts/mecha_equipment/ME in M.equipment) //Exact duplicate components aren't allowed.
			if(ME.type == src.type)
				return 0
	if(equip_type == EQUIP_HULL && M.hull_equipment.len < M.max_hull_equip)
		return 1
	if(equip_type == EQUIP_WEAPON && M.weapon_equipment.len < M.max_weapon_equip)
		return 1
	if(equip_type == EQUIP_UTILITY && M.utility_equipment.len < M.max_utility_equip)
		return 1
	if(equip_type == EQUIP_SPECIAL && M.special_equipment.len < M.max_special_equip)
		return 1
	//VOREStation Addition begin: MICROMECHS
	if(equip_type == EQUIP_MICRO_UTILITY && M.micro_utility_equipment.len < M.max_micro_utility_equip)
		return 1
	if(equip_type == EQUIP_MICRO_WEAPON && M.micro_weapon_equipment.len < M.max_micro_weapon_equip)
		return 1
	//VOREStation Addition end: MICROMECHS
	if(equip_type != EQUIP_SPECIAL && M.universal_equipment.len < M.max_universal_equip) //The exosuit needs to be military grade to actually have a universal slot capable of accepting a true weapon.
		if(equip_type == EQUIP_WEAPON && !istype(M, /obj/mecha/combat))
			return 0
		return 1
	/*if (ispath(required_type))
		return istype(M, required_type)

	for (var/path in required_type)
		if (istype(M, path))
			return 1
	*/
	return 0

/obj/item/mecha_parts/mecha_equipment/proc/attach(obj/mecha/M as obj)
	//M.equipment += src
	var/has_equipped = 0
	if(equip_type == EQUIP_HULL && M.hull_equipment.len < M.max_hull_equip && !has_equipped)
		M.hull_equipment += src
		has_equipped = 1
	if(equip_type == EQUIP_WEAPON && M.weapon_equipment.len < M.max_weapon_equip && !has_equipped)
		M.weapon_equipment += src
		has_equipped = 1
	if(equip_type == EQUIP_UTILITY && M.utility_equipment.len < M.max_utility_equip && !has_equipped)
		M.utility_equipment += src
		has_equipped = 1
	if(equip_type == EQUIP_SPECIAL && M.special_equipment.len < M.max_special_equip && !has_equipped)
		M.special_equipment += src
		has_equipped = 1
	//VOREStation Addition begin: MICROMECHS
	if(equip_type == EQUIP_MICRO_UTILITY && M.micro_utility_equipment.len < M.max_micro_utility_equip && !has_equipped)
		M.micro_utility_equipment += src
		has_equipped = 1
	if(equip_type == EQUIP_MICRO_WEAPON && M.micro_weapon_equipment.len < M.max_micro_weapon_equip && !has_equipped)
		M.micro_weapon_equipment += src
		has_equipped = 1
	//VOREStation Addition end: MICROMECHS
	if(equip_type != EQUIP_SPECIAL && M.universal_equipment.len < M.max_universal_equip && !has_equipped)
		M.universal_equipment += src
	M.equipment += src
	chassis = M
	src.loc = M

	if(enable_special_checks(M))
		enable_special = TRUE

	M.log_message("[src] initialized.")
	if(!M.selected)
		M.selected = src
	src.update_chassis_page()
	return

/obj/item/mecha_parts/mecha_equipment/Destroy()
	detach()
	return ..()

/obj/item/mecha_parts/mecha_equipment/proc/detach(atom/moveto=null)
	if(!chassis)
		return
	moveto = moveto || get_turf(chassis)
	forceMove(moveto)
	chassis.equipment -= src
	chassis.universal_equipment -= src
	if(equip_type)
		switch(equip_type)
			if(EQUIP_HULL)
				chassis.hull_equipment -= src
			if(EQUIP_WEAPON)
				chassis.weapon_equipment -= src
			if(EQUIP_UTILITY)
				chassis.utility_equipment -= src
			if(EQUIP_SPECIAL)
				chassis.special_equipment -= src
			//VOREStation Addition begin: MICROMECHS
			if(EQUIP_MICRO_UTILITY)
				chassis.micro_utility_equipment -= src
			if(EQUIP_MICRO_WEAPON)
				chassis.micro_weapon_equipment -= src
			//VOREStation Addition end: MICROMECHS
	if(chassis.selected == src)
		chassis.selected = null
	update_chassis_page()
	chassis.log_message("[src] removed from equipment.")
	chassis = null
	set_ready_state(TRUE)
	enable_special = FALSE
	return

/obj/item/mecha_parts/mecha_equipment/Topic(href,href_list)
	if(href_list["detach"])
		src.detach()
	return

/obj/item/mecha_parts/mecha_equipment/proc/set_ready_state(state)
	equip_ready = state
	if(chassis)
		send_byjax(chassis.occupant,"exosuit.browser","\ref[src]",src.get_equip_info())
	return

/obj/item/mecha_parts/mecha_equipment/proc/occupant_message(message)
	if(chassis)
		chassis.occupant_message("\icon[src][bicon(src)] [message]")
	return

/obj/item/mecha_parts/mecha_equipment/proc/log_message(message)
	if(chassis)
		chassis.log_message("<i>[src]:</i> [message]")
	return

/obj/item/mecha_parts/mecha_equipment/proc/MoveAction() //Allows mech equipment to do an action upon the mech moving
	return

/obj/item/mecha_parts/mecha_equipment/proc/get_step_delay() // Equipment returns its slowdown or speedboost.
	return step_delay
